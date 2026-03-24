"use client";

import React, { useEffect, useRef, useState, useCallback } from "react";
import type { FlutterMultiViewApp, FlutterEngineInitializer } from "./flutter-types";
import { FLUTTER_TIMEOUTS, withTimeout } from "./flutter/timeouts";

// Re-export for consumers
export type { FlutterMultiViewApp };

type LoadingState = "idle" | "loading-engine" | "adding-view" | "ready" | "error";

interface FlutterMultiViewProps {
  /** Preview ID to render (e.g., 'overview/introduction.0', 'guides/styling.0') */
  previewId: string;
  /** Base path where Flutter previews are hosted (default: /previews) */
  basePath?: string;
  /** Height of the preview container */
  height?: number;
  /** Whether to show a border around the preview */
  bordered?: boolean;
  /** Additional CSS classes */
  className?: string;
  /** Callback when preview is ready */
  onReady?: () => void;
  /** Callback on error */
  onError?: (error: Error) => void;
  /** Whether to lazy load (only load when in viewport) */
  lazyLoad?: boolean;
}

// =============================================================================
// Singleton Engine Lifecycle
// =============================================================================
//
// This module manages a singleton Flutter engine shared across all views.
// The lifecycle is:
//
// 1. IDLE: No engine loaded (initial state, all variables null/false)
// 2. LOADING: Engine being initialized (first component mount triggers this)
// 3. READY: Engine ready, views can be added (engineReady = true)
//
// State is stored at module level to survive component remounts.
// This is intentional - recreating the engine is expensive (~2-3s).
//
// IMPORTANT: The engine is NEVER destroyed during normal operation.
// Only a full page reload resets the engine state.
// This prevents WebGL context loss and CanvasKit reinitialization.
//
// Why module-level state instead of React context?
// - Context would cause re-initialization on every provider remount
// - The Flutter engine is truly global to the page (one WebGL context)
// - This matches Flutter's own singleton pattern for web embedding
// =============================================================================

/** Promise resolving to initialized Flutter app (singleton, survives remounts) */
let enginePromise: Promise<FlutterMultiViewApp> | null = null;

/** Whether engine initialization completed successfully */
let engineReady = false;

/** Promise for loading flutter_bootstrap.js script (singleton) */
let flutterScriptPromise: Promise<void> | null = null;

/**
 * Load the Flutter bootstrap script.
 */
async function ensureFlutterScript(basePath: string): Promise<void> {
  if (flutterScriptPromise) return flutterScriptPromise;

  flutterScriptPromise = new Promise((resolve, reject) => {
    // Check if already loaded
    if (window._flutter) {
      resolve();
      return;
    }

    const script = document.createElement("script");
    // Uses flutter_bootstrap.js (patched by the build script).
    // Patch removes auto-load to allow multi-view configuration before init.
    script.src = `${basePath}/flutter_bootstrap.js`;
    script.async = true;

    script.onload = () => {
      // Wait for _flutter to be available (with timeout)
      let attempts = 0;
      const maxAttempts = 100; // 5 seconds max (100 * 50ms)

      const checkFlutter = () => {
        if (window._flutter) {
          resolve();
        } else if (attempts >= maxAttempts) {
          flutterScriptPromise = null;
          reject(new Error("Flutter script loaded but _flutter not available"));
        } else {
          attempts++;
          setTimeout(checkFlutter, 50);
        }
      };
      checkFlutter();
    };

    script.onerror = () => {
      flutterScriptPromise = null;
      reject(new Error("Failed to load Flutter script"));
    };

    document.head.appendChild(script);
  });

  return flutterScriptPromise;
}

/**
 * Initialize the Flutter multi-view engine (singleton).
 */
async function ensureFlutterEngine(basePath: string): Promise<FlutterMultiViewApp> {
  if (engineReady && window.flutterApp) {
    return window.flutterApp;
  }

  if (!enginePromise) {
    const initPromise = (async () => {
      await ensureFlutterScript(basePath);

      // Set multi-view mode flag
      window.FLUTTER_MULTI_VIEW_MODE = true;

      // Use the convenience function if available, otherwise initialize directly
      if (window.initFlutterMultiView) {
        const app = await window.initFlutterMultiView();
        engineReady = true;
        return app;
      }

      // Fallback: Initialize directly
      return new Promise<FlutterMultiViewApp>((resolve, reject) => {
        if (!window._flutter) {
          reject(new Error("Flutter not loaded"));
          return;
        }

        // Load with entrypointBaseUrl config for proper path resolution when embedding
        window._flutter.loader.load({
          config: {
            entrypointBaseUrl: basePath + "/",
          },
          onEntrypointLoaded: async (engineInitializer: FlutterEngineInitializer) => {
            try {
              window.__FLUTTER_MULTI_VIEW_ENABLED__ = true;

              const engine = await engineInitializer.initializeEngine({
                multiViewEnabled: true,
                assetBase: basePath + "/",
              });

              const app = await engine.runApp() as unknown as FlutterMultiViewApp;
              window.flutterApp = app;
              engineReady = true;
              resolve(app);
            } catch (err) {
              enginePromise = null;
              reject(err);
            }
          },
        });
      });
    })();

    enginePromise = initPromise.catch((err) => {
      enginePromise = null;
      throw err;
    });
  }

  return withTimeout(
    enginePromise!,
    FLUTTER_TIMEOUTS.ENGINE_INIT,
    "Flutter engine initialization"
  ).catch((err) => {
    if (err?.name === "TimeoutError") {
      enginePromise = null;
    }
    throw err;
  });
}

/**
 * FlutterMultiView - React component for embedding Flutter previews using multi-view mode.
 *
 * Uses Flutter's multi-view API to render multiple independent previews on the same page
 * with a single shared Flutter engine, avoiding WebGL/CanvasKit conflicts.
 *
 * @example
 * ```tsx
 * <FlutterMultiView previewId="overview/introduction.0" height={400} />
 * ```
 */
export function FlutterMultiView({
  previewId,
  basePath = "/previews",
  height = 400,
  bordered = true,
  className = "",
  onReady,
  onError,
  lazyLoad = true,
}: FlutterMultiViewProps) {
  const containerRef = useRef<HTMLDivElement>(null);
  const viewIdRef = useRef<number | null>(null);
  const [state, setState] = useState<LoadingState>("idle");
  const [error, setError] = useState<string | null>(null);
  const hasLoadedRef = useRef(false);
  const isMountedRef = useRef(true);
  const addViewAttemptRef = useRef(0);

  const loadView = useCallback(async () => {
    const container = containerRef.current;
    if (!container || hasLoadedRef.current) return;

    hasLoadedRef.current = true;
    setState("loading-engine");

    try {
      const app = await ensureFlutterEngine(basePath);

      // Check if component unmounted during async operation
      if (!isMountedRef.current) {
        hasLoadedRef.current = false;
        return;
      }

      // Verify container is still valid
      if (!containerRef.current) {
        hasLoadedRef.current = false;
        return;
      }

      setState("adding-view");
      const myAttempt = ++addViewAttemptRef.current;

      // Add the view with timeout protection
      if (!previewId) {
        throw new Error("previewId is required");
      }

      const initialData: Record<string, string> = { previewId };

      const hostElement = containerRef.current;
      const addViewPromise = Promise.resolve(app.addView({
        hostElement,
        initialData,
      }));
      let addViewTimeoutId: ReturnType<typeof setTimeout> | null = null;
      const timeoutPromise = new Promise<number>((_, reject) => {
        addViewTimeoutId = setTimeout(() => {
          // Mark this attempt as canceled so late-resolving addView calls get cleaned up.
          addViewAttemptRef.current += 1;
          reject(new Error(
            `Adding view "${previewId}" timed out after ${FLUTTER_TIMEOUTS.ADD_VIEW / 1000}s`
          ));
        }, FLUTTER_TIMEOUTS.ADD_VIEW);
      });

      addViewPromise
        .then((pendingViewId) => {
          if (addViewAttemptRef.current === myAttempt) return;
          try {
            app.removeView(pendingViewId);
          } catch (err) {
            if (process.env.NODE_ENV === "development") {
              console.warn("[FlutterMultiView] Failed to remove timed-out view:", err);
            }
          }
        })
        .catch(() => {
          // Errors are handled by the race below.
        });

      const viewId = await Promise.race([addViewPromise, timeoutPromise]).finally(() => {
        if (addViewTimeoutId) {
          clearTimeout(addViewTimeoutId);
          addViewTimeoutId = null;
        }
      });

      // Check again after addView (handles unmount during addView)
      if (!isMountedRef.current) {
        // Clean up the view we just created
        try {
          app.removeView(viewId);
        } catch (err) {
          if (process.env.NODE_ENV === "development") {
            console.warn("[FlutterMultiView] Failed to remove view during unmount cleanup:", err);
          }
        }
        return;
      }

      viewIdRef.current = viewId;
      setState("ready");
      onReady?.();
    } catch (err) {
      // Don't update state if unmounted
      if (!isMountedRef.current) return;

      const error = err instanceof Error ? err : new Error(String(err));
      if (process.env.NODE_ENV === "development") {
        console.error("[FlutterMultiView] Failed to load view:", {
          previewId,
          error: error.message,
          stack: error.stack,
        });
      }

      setError(error.message);
      setState("error");
      hasLoadedRef.current = false;
      const contextError = new Error(
        `Preview "${previewId}" failed: ${error.message}`,
      );
      (contextError as Error & { cause?: unknown }).cause = error;
      onError?.(contextError);
    }
  }, [basePath, onReady, onError, previewId]);

  // Set up IntersectionObserver for lazy loading
  useEffect(() => {
    if (!containerRef.current) return;

    // Prevent re-initialization if inputs change after initial load.
    // (use React key prop to remount if dynamic changes are needed)
    if (hasLoadedRef.current) return;

    if (!lazyLoad) {
      loadView();
      return;
    }

    const observer = new IntersectionObserver(
      (entries) => {
        if (entries[0].isIntersecting && !hasLoadedRef.current) {
          loadView();
        }
      },
      { rootMargin: "100px" } // Start loading slightly before visible
    );

    observer.observe(containerRef.current);

    return () => {
      observer.disconnect();
    };
  }, [lazyLoad, loadView]);

  // Track mounted state and cleanup view on unmount
  useEffect(() => {
    isMountedRef.current = true;

    return () => {
      isMountedRef.current = false;

      if (viewIdRef.current !== null && window.flutterApp) {
        try {
          window.flutterApp.removeView(viewIdRef.current);
        } catch (err) {
          if (process.env.NODE_ENV === "development") {
            console.warn("[FlutterMultiView] Failed to remove view on unmount:", {
              viewId: viewIdRef.current,
              error: err instanceof Error ? err.message : String(err),
            });
          }
        }
        viewIdRef.current = null;
      }
    };
  }, []);

  const containerStyles: React.CSSProperties = {
    height,
    width: "100%",
    backgroundColor: "#1a1a2e",
    borderRadius: bordered ? "8px" : undefined,
    border: bordered ? "1px solid rgba(255, 255, 255, 0.1)" : undefined,
    overflow: "hidden",
    position: "relative",
  };

  return (
    <div className={className} style={containerStyles}>
      {/* Loading overlay */}
      {state !== "ready" && state !== "error" && (
        <div
          style={{
            position: "absolute",
            inset: 0,
            display: "flex",
            flexDirection: "column",
            alignItems: "center",
            justifyContent: "center",
            gap: "12px",
            zIndex: 10,
            backgroundColor: "#1a1a2e",
          }}
        >
          <div
            style={{
              width: "32px",
              height: "32px",
              border: "3px solid rgba(167, 139, 250, 0.3)",
              borderTopColor: "#a78bfa",
              borderRadius: "50%",
              animation: "spin 1s linear infinite",
            }}
          />
          <span style={{ color: "#a78bfa", fontSize: "12px" }}>
            {state === "loading-engine" && "Loading Flutter engine..."}
            {state === "adding-view" && "Initializing preview view..."}
            {state === "idle" && "Waiting..."}
          </span>
        </div>
      )}

      {/* Error state */}
      {state === "error" && (
        <div
          style={{
            position: "absolute",
            inset: 0,
            display: "flex",
            flexDirection: "column",
            alignItems: "center",
            justifyContent: "center",
            gap: "12px",
            backgroundColor: "#1a1a2e",
            color: "#ef4444",
            padding: "16px",
            textAlign: "center",
          }}
        >
          <span>⚠️ Failed to load preview</span>
          <span style={{ fontSize: "12px", opacity: 0.7 }}>{error}</span>
          <button
            onClick={() => {
              hasLoadedRef.current = false;
              setError(null);
              setState("idle");
              loadView();
            }}
            style={{
              marginTop: "8px",
              padding: "8px 16px",
              backgroundColor: "#a78bfa",
              color: "white",
              border: "none",
              borderRadius: "4px",
              cursor: "pointer",
              fontSize: "14px",
            }}
          >
            Retry
          </button>
        </div>
      )}

      {/* Flutter view container */}
      <div
        ref={containerRef}
        role="application"
        aria-label={`Flutter preview: ${previewId}`}
        aria-busy={state === "loading-engine" || state === "adding-view"}
        data-preview-id={previewId}
        data-state={state}
        style={{
          width: "100%",
          height: "100%",
          visibility: state === "ready" ? "visible" : "hidden",
        }}
      />

      <style>{`
        @keyframes spin {
          to { transform: rotate(360deg); }
        }
      `}</style>
    </div>
  );
}

/**
 * Reset engine state. ONLY for testing or explicit cleanup.
 *
 * WARNING: This invalidates all existing views. Only use in test teardown
 * or when deliberately resetting the entire Flutter state.
 */
export function __resetEngineState_TESTING_ONLY(): void {
  if (process.env.NODE_ENV !== "test" && process.env.NODE_ENV !== "development") {
    console.warn("__resetEngineState_TESTING_ONLY should only be used in tests");
  }
  enginePromise = null;
  engineReady = false;
  flutterScriptPromise = null;
}

export default FlutterMultiView;
