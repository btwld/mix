"use client";

import React, { useEffect, useRef, useState, useCallback } from "react";
import type { FlutterMultiViewApp, FlutterEngineInitializer } from "./flutter-types";

// Re-export for consumers
export type { FlutterMultiViewApp };

type LoadingState = "idle" | "loading-engine" | "adding-view" | "ready" | "error";

interface FlutterMultiViewProps {
  /** The demo ID to render (e.g., 'box-basic', 'variant-hover') */
  demoId: string;
  /** Height of the demo container */
  height?: number;
  /** Whether to show a border around the demo */
  bordered?: boolean;
  /** Additional CSS classes */
  className?: string;
  /** Callback when demo is ready */
  onReady?: () => void;
  /** Callback on error */
  onError?: (error: Error) => void;
  /** Whether to lazy load (only load when in viewport) */
  lazyLoad?: boolean;
}

// Shared state for the Flutter engine
let enginePromise: Promise<FlutterMultiViewApp> | null = null;
let engineReady = false;
let flutterScriptPromise: Promise<void> | null = null;

// Timeout for initialization (30 seconds)
const INIT_TIMEOUT_MS = 30000;

/**
 * Wrap a promise with a timeout.
 */
function withTimeout<T>(promise: Promise<T>, ms: number, errorMsg: string): Promise<T> {
  return Promise.race([
    promise,
    new Promise<T>((_, reject) =>
      setTimeout(() => reject(new Error(errorMsg)), ms)
    ),
  ]);
}

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

  if (enginePromise) {
    return enginePromise;
  }

  enginePromise = withTimeout(
    (async () => {
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
    })(),
    INIT_TIMEOUT_MS,
    `Flutter engine initialization timed out after ${INIT_TIMEOUT_MS / 1000}s`
  ).catch((err) => {
    // Reset state on failure so retry can work
    enginePromise = null;
    throw err;
  });

  return enginePromise;
}

/**
 * FlutterMultiView - React component for embedding Flutter demos using multi-view mode.
 *
 * Uses Flutter's multi-view API to render multiple independent demos on the same page
 * with a single shared Flutter engine, avoiding WebGL/CanvasKit conflicts.
 *
 * @example
 * ```tsx
 * <FlutterMultiView demoId="box-basic" height={400} />
 * <FlutterMultiView demoId="variant-hover" height={350} />
 * ```
 *
 * Available demo IDs (from DemoRegistry):
 * - Widgets: box-basic, box-gradient, hbox-chip, vbox-card, zbox-layers, icon-styled, text-styled, text-directives
 * - Variants: variant-hover, variant-pressed, variant-focused, variant-selected, variant-disabled, variant-dark-light, variant-selected-toggle, variant-responsive
 * - Gradients: gradient-linear, gradient-radial, gradient-sweep
 * - Tokens: tokens-theme
 * - Animations: anim-hover-scale, anim-auto-scale, anim-tap-phase, anim-switch, anim-spring
 */
export function FlutterMultiView({
  demoId,
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
  const isInViewRef = useRef(false);
  const hasLoadedRef = useRef(false);
  const isMountedRef = useRef(true);

  const basePath = "/demos";

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

      // Add the view
      const viewId = app.addView({
        hostElement: containerRef.current,
        initialData: { demoId },
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
          demoId,
          error: error.message,
          stack: error.stack,
        });
      }

      setError(error.message);
      setState("error");
      hasLoadedRef.current = false;
      const contextError = new Error(`Demo "${demoId}" failed: ${error.message}`);
      (contextError as Error & { cause?: unknown }).cause = error;
      onError?.(contextError);
    }
  }, [demoId, onReady, onError]);

  // Set up IntersectionObserver for lazy loading
  useEffect(() => {
    if (!containerRef.current) return;

    // Prevent re-initialization if demoId changes after initial load
    // (use React key prop to remount if demoId needs to change dynamically)
    if (hasLoadedRef.current) return;

    if (!lazyLoad) {
      loadView();
      return;
    }

    const observer = new IntersectionObserver(
      (entries) => {
        const entry = entries[0];
        isInViewRef.current = entry.isIntersecting;

        if (entry.isIntersecting && !hasLoadedRef.current) {
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
            {state === "adding-view" && "Initializing demo view..."}
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
          <span>⚠️ Failed to load demo</span>
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
        aria-label={`Flutter demo: ${demoId}`}
        aria-busy={state === "loading-engine" || state === "adding-view"}
        data-demo-id={demoId}
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

export default FlutterMultiView;
