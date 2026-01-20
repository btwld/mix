"use client";

import React, { useEffect, useRef, useState, useCallback } from "react";
// Types are defined in flutter-types.ts - imported for re-export
import "./flutter-types";
import { getFlutterBuildConfig } from "./flutter/config";
import { FLUTTER_TIMEOUTS } from "./flutter/timeouts";
import { loadFlutterLoaderScript } from "./flutter/loader";
import { acquireInitializationLock } from "./flutter/initialization-lock";
import { validateAndNormalizeSrc, validateIframeSrc } from "./flutter/validate-src";
import { useFlutterErrorCapture } from "./flutter/hooks/useFlutterErrorCapture";

interface FlutterEmbedProps {
  /**
   * Base URL where Flutter web build is hosted.
   * Must be a relative path (e.g., "/demos") or match allowed domains.
   * Cross-origin URLs require useIframe mode.
   */
  src: string;
  /** Height of the embed container */
  height?: number;
  /** Width of the embed (defaults to 100%) */
  width?: string | number;
  /** Demo title displayed above the embed */
  title?: string;
  /** Whether to show a border around the embed */
  bordered?: boolean;
  /** Background color of the container */
  background?: string;
  /** Use iframe mode instead of element embedding (simpler, more reliable) */
  useIframe?: boolean;
  /** Loading placeholder content */
  loadingContent?: React.ReactNode;
}

/**
 * FlutterEmbed - Embeds a Flutter web application using Element Embedding
 *
 * This uses Flutter's official element embedding feature (v3.10+) to render
 * Flutter content directly into a DOM element, allowing for:
 * - Multiple Flutter instances on the same page
 * - CSS styling and transformations
 * - Better integration with the host page
 *
 * @see https://docs.flutter.dev/platform-integration/web/embedding-flutter-web
 *
 * @example Basic usage
 * ```tsx
 * <FlutterEmbed
 *   src="/demos"
 *   title="Simple Box Demo"
 *   height={400}
 * />
 * ```
 *
 * @example With iframe fallback (more reliable for cross-origin)
 * ```tsx
 * <FlutterEmbed
 *   src="https://mix-demos.web.app"
 *   useIframe
 *   height={500}
 * />
 * ```
 */
export function FlutterEmbed({
  src,
  height = 400,
  width = "100%",
  title,
  bordered = true,
  background = "#1a1a2e",
  useIframe = false,
  loadingContent,
}: FlutterEmbedProps) {
  const containerRef = useRef<HTMLDivElement>(null);
  const [status, setStatus] = useState<"loading" | "ready" | "error">("loading");
  const [errorMessage, setErrorMessage] = useState<string>("");
  const [loadingStage, setLoadingStage] = useState<string>("Initializing...");
  // Key to force iframe remount on retry
  const [iframeKey, setIframeKey] = useState(0);
  // Use extracted hook for error capture
  const { errors: capturedErrors, clearErrors } = useFlutterErrorCapture(status === "loading");
  const mountedRef = useRef(true);
  const loadingRef = useRef(false);
  const loadingTimeoutRef = useRef<NodeJS.Timeout | null>(null);
  const releaseLockRef = useRef<(() => void) | null>(null);
  const iframeRef = useRef<HTMLIFrameElement>(null);

  // Validate src prop - iframe mode still validates but allows more domains
  const validatedSrc = useIframe ? validateIframeSrc(src) : validateAndNormalizeSrc(src);

  const releaseInitializationLock = useCallback(() => {
    const release = releaseLockRef.current;
    if (release) {
      releaseLockRef.current = null;
      release();
    }
  }, []);

  const loadFlutterApp = useCallback(async () => {
    if (!containerRef.current || useIframe || loadingRef.current) return;
    if (!validatedSrc) {
      setErrorMessage("Invalid src path. Check console for details.");
      setStatus("error");
      return;
    }

    loadingRef.current = true;
    clearErrors();

    // Initial delay to let iframe Flutter instances stabilize first
    // Iframes load Flutter in isolated contexts that we can't coordinate with.
    // This delay ensures any iframe Flutter has finished loading CanvasKit before
    // element embedding starts, preventing WebGL resource conflicts.
    setLoadingStage("Waiting for resources...");
    await new Promise((resolve) => setTimeout(resolve, FLUTTER_TIMEOUTS.RESOURCE_STABILIZATION));

    // Check if component was unmounted during delay
    if (!mountedRef.current) {
      loadingRef.current = false;
      return;
    }

    // Acquire initialization lock to prevent WebGL conflicts from concurrent initializations
    // Multiple Flutter element embeds cannot initialize simultaneously - they compete for
    // CanvasKit/WebGL resources causing BindingErrors.
    const releaseLock = await acquireInitializationLock();
    releaseLockRef.current = releaseLock;

    try {
      // Check if component was unmounted while waiting for lock
      if (!mountedRef.current) {
        return; // finally block will release the lock
      }

      // Step 1: Load flutter.js using singleton loader (Q7 fix)
      // Using flutter.js (not flutter_bootstrap.js) to avoid the auto-call that
      // uses document.baseURI for path resolution
      setLoadingStage("Loading Flutter loader script...");
      await loadFlutterLoaderScript(validatedSrc);

      // Check if component was unmounted during async operation
      if (!mountedRef.current) return;

      // Step 2: Set buildConfig if not already set
      // This is required by the Flutter loader - normally set by flutter_bootstrap.js
      // Config is loaded from flutter-build-config.json (generated during build)
      if (!window._flutter!.buildConfig) {
        setLoadingStage("Loading build configuration...");
        const buildConfig = await getFlutterBuildConfig(validatedSrc);
        if (!mountedRef.current) return;
        window._flutter!.buildConfig = buildConfig;
      }

      setLoadingStage("Initializing Flutter engine...");

      // Step 3: Load Flutter with element embedding
      const hostElement = containerRef.current;
      if (!hostElement || !mountedRef.current) return;

      await window._flutter!.loader.load({
        config: {
          hostElement: hostElement,
          entrypointBaseUrl: `${validatedSrc}/`,
        },
        onEntrypointLoaded: async (engineInitializer) => {
          if (!mountedRef.current) return;

          setLoadingStage("Loading CanvasKit renderer...");
          const appRunner = await engineInitializer.initializeEngine({
            hostElement: hostElement,
            assetBase: `${validatedSrc}/`,
          });

          if (!mountedRef.current) return;

          setLoadingStage("Running Flutter app...");
          await appRunner.runApp();
          setLoadingStage("Ready");
          setStatus("ready");
        },
      });
    } catch (error) {
      if (!mountedRef.current) return;
      console.error("Flutter embed error:", error);
      const errorMsg = error instanceof Error ? error.message : "Unknown error";
      setErrorMessage(errorMsg);
      setStatus("error");
    } finally {
      loadingRef.current = false;
      releaseInitializationLock(); // Release the initialization lock for other embeds
    }
  }, [releaseInitializationLock, validatedSrc, useIframe]);

  // Q8 fix: Proper cleanup on unmount
  useEffect(() => {
    mountedRef.current = true;

    if (!useIframe) {
      loadFlutterApp();
    }
    // Note: For iframe mode, status is set to "ready" via onLoad handler

    // Cleanup function to prevent state updates after unmount
    return () => {
      mountedRef.current = false;
    };
  }, [loadFlutterApp, useIframe]);

  // Loading timeout - show error after 30 seconds if still loading
  useEffect(() => {
    if (status !== "loading") {
      // Clear any existing timeout when no longer loading
      if (loadingTimeoutRef.current) {
        clearTimeout(loadingTimeoutRef.current);
        loadingTimeoutRef.current = null;
      }
      return;
    }

    loadingTimeoutRef.current = setTimeout(() => {
      if (mountedRef.current && status === "loading") {
        loadingRef.current = false;
        releaseInitializationLock();
        const errorDetails = capturedErrors.length > 0
          ? `Captured errors: ${capturedErrors.join("; ")}`
          : "No errors captured - check browser console for details.";
        setErrorMessage(`Loading timed out at stage: "${loadingStage}". ${errorDetails}`);
        setStatus("error");
      }
    }, FLUTTER_TIMEOUTS.ENGINE_INIT);

    return () => {
      if (loadingTimeoutRef.current) {
        clearTimeout(loadingTimeoutRef.current);
        loadingTimeoutRef.current = null;
      }
    };
  }, [status, loadingStage, capturedErrors, releaseInitializationLock]);

  // iframe mode: handle load detection with fallback for cached iframes
  useEffect(() => {
    if (!useIframe) return;

    setLoadingStage("Loading iframe...");

    const iframe = iframeRef.current;
    if (!iframe) return;

    const handleLoad = () => {
      if (mountedRef.current) {
        setStatus("ready");
      }
    };

    // Fix for cached iframe: check if already loaded
    // This handles the race condition where browser loads iframe before React attaches onLoad
    try {
      if (iframe.contentDocument?.readyState === "complete") {
        handleLoad();
        return;
      }
    } catch {
      // Cross-origin iframe - can't check readyState, rely on event listener
    }

    // Add native listener for normal load path
    iframe.addEventListener("load", handleLoad);

    // 45 second timeout as final fallback
    const timeout = setTimeout(() => {
      if (mountedRef.current && status === "loading") {
        setErrorMessage(
          `Flutter iframe did not load within ${FLUTTER_TIMEOUTS.IFRAME_LOAD / 1000} seconds. ` +
          "Check that the demos are built and the server is running."
        );
        setStatus("error");
      }
    }, FLUTTER_TIMEOUTS.IFRAME_LOAD);

    return () => {
      iframe.removeEventListener("load", handleLoad);
      clearTimeout(timeout);
    };
  }, [useIframe, status]);

  const containerStyle: React.CSSProperties = {
    height,
    width,
    background,
    position: "relative",
    overflow: "hidden",
    borderRadius: "0.5rem",
    ...(bordered && {
      border: "1px solid rgba(255, 255, 255, 0.1)",
    }),
  };

  const LoadingOverlay = () => (
    <div
      className="absolute inset-0 flex items-center justify-center"
      style={{ background }}
    >
      {loadingContent || (
        <div className="flex flex-col items-center gap-3">
          <div className="h-8 w-8 animate-spin rounded-full border-2 border-purple-500 border-t-transparent" />
          <span className="text-sm text-zinc-400">{loadingStage}</span>
          {capturedErrors.length > 0 && (
            <div className="text-xs text-amber-400 max-w-xs text-center">
              ⚠️ {capturedErrors.length} warning(s) detected
            </div>
          )}
        </div>
      )}
    </div>
  );

  const ErrorDisplay = () => (
    <div
      className="absolute inset-0 flex items-center justify-center"
      style={{ background }}
    >
      <div className="flex flex-col items-center gap-3 text-center px-4 max-w-lg">
        <div className="text-red-400 text-lg">Failed to load demo</div>
        <div className="text-xs text-zinc-500">
          Last stage: <span className="text-zinc-400">{loadingStage}</span>
        </div>
        <div className="text-xs text-zinc-500 font-mono bg-zinc-800/50 p-3 rounded max-h-32 overflow-auto w-full">
          {errorMessage || "Unknown error - check browser console"}
        </div>
        {capturedErrors.length > 0 && (
          <details className="w-full text-left">
            <summary className="text-xs text-amber-400 cursor-pointer">
              {capturedErrors.length} captured error(s)
            </summary>
            <ul className="mt-2 text-xs text-zinc-500 font-mono bg-zinc-800/30 p-2 rounded max-h-24 overflow-auto">
              {capturedErrors.map((err, i) => (
                <li key={i} className="truncate">• {err}</li>
              ))}
            </ul>
          </details>
        )}
        <button
          onClick={() => {
            if (loadingRef.current) return; // Prevent rapid clicks (Q12)
            setStatus("loading");
            setErrorMessage("");
            setLoadingStage("Initializing...");
            clearErrors();
            if (useIframe) {
              // Force iframe remount by changing key
              setIframeKey((k) => k + 1);
            } else {
              loadFlutterApp();
            }
          }}
          disabled={loadingRef.current}
          data-testid="flutter-retry"
          className="mt-2 px-4 py-2 bg-purple-600 hover:bg-purple-500 disabled:bg-purple-800 disabled:cursor-not-allowed rounded text-sm text-white transition-colors"
        >
          Retry
        </button>
      </div>
    </div>
  );

  // Show error immediately if src validation failed
  if (!validatedSrc) {
    return (
      <div className="my-6 not-prose">
        {title && (
          <div className="mb-2 text-sm font-medium text-zinc-300">{title}</div>
        )}
        <div
          style={containerStyle}
          className="flex items-center justify-center"
        >
          <div className="text-red-400 text-center px-4">
            <div className="text-lg">Invalid demo source</div>
            <div className="text-sm text-zinc-500 mt-2">
              Check the <code>src</code> prop value
            </div>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div
      className="my-6 not-prose"
      data-testid="flutter-embed"
      data-status={status}
    >
      {title && (
        <div className="mb-2 text-sm font-medium text-zinc-300">{title}</div>
      )}

      <div style={containerStyle}>
        {useIframe ? (
          <iframe
            key={iframeKey}
            ref={iframeRef}
            src={`${validatedSrc}/index.html`}
            data-testid="flutter-iframe"
            className="h-full w-full"
            style={{ border: "none" }}
            title={title || "Flutter Demo"}
            loading="lazy"
            sandbox="allow-scripts allow-same-origin"
            referrerPolicy="no-referrer"
            onError={() => {
              setErrorMessage("Failed to load iframe");
              setStatus("error");
            }}
          />
        ) : (
          <div
            ref={containerRef}
            data-testid="flutter-element"
            className="h-full w-full"
            style={{ position: "relative" }}
          />
        )}

        {status === "loading" && <LoadingOverlay />}
        {status === "error" && <ErrorDisplay />}
      </div>

      <div className="mt-2 flex items-center gap-2 text-xs text-zinc-500">
        <span className="inline-flex items-center gap-1 rounded px-2 py-0.5 bg-purple-500/10 text-purple-400">
          {useIframe ? "Flutter (iframe)" : "Flutter Element Embedding"}
        </span>
        <span className="ml-auto text-zinc-600">
          {status === "ready" ? "Interactive" : status === "loading" ? "Loading..." : "Error"}
        </span>
      </div>
    </div>
  );
}

export default FlutterEmbed;
