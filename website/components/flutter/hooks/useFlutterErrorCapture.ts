"use client";

import { useEffect, useState, useCallback } from "react";

/**
 * Hook to capture global errors during Flutter initialization.
 *
 * Captures Flutter and CanvasKit related errors from window error/rejection events.
 * This helps diagnose initialization failures by surfacing errors that would
 * otherwise only appear in the browser console.
 *
 * @param enabled - Whether to capture errors (typically true only during loading)
 * @returns Object with captured errors array and clear function
 *
 * @example
 * ```tsx
 * const { errors, clearErrors } = useFlutterErrorCapture(status === "loading");
 *
 * // Show warnings if errors detected
 * {errors.length > 0 && <Warning count={errors.length} />}
 * ```
 */
export function useFlutterErrorCapture(enabled: boolean) {
  const [errors, setErrors] = useState<string[]>([]);

  const clearErrors = useCallback(() => {
    setErrors([]);
  }, []);

  useEffect(() => {
    if (!enabled) return;

    const errorHandler = (event: ErrorEvent) => {
      const msg = event.message || "";
      // Capture Flutter/canvaskit related errors
      if (isFlutterRelatedError(msg)) {
        setErrors((prev) => [...prev, msg]);
        console.warn("[FlutterEmbed] Captured error:", msg);
      }
    };

    const rejectionHandler = (event: PromiseRejectionEvent) => {
      const msg = event.reason?.message || String(event.reason);
      // Capture Flutter/canvaskit related rejections
      if (isFlutterRelatedError(msg)) {
        setErrors((prev) => [...prev, msg]);
        console.warn("[FlutterEmbed] Captured rejection:", msg);
      }
    };

    window.addEventListener("error", errorHandler);
    window.addEventListener("unhandledrejection", rejectionHandler);

    return () => {
      window.removeEventListener("error", errorHandler);
      window.removeEventListener("unhandledrejection", rejectionHandler);
    };
  }, [enabled]);

  return { errors, clearErrors };
}

/**
 * Check if an error message is related to Flutter/CanvasKit.
 */
function isFlutterRelatedError(msg: string): boolean {
  const lowerMsg = msg.toLowerCase();
  return (
    lowerMsg.includes("canvaskit") ||
    lowerMsg.includes("flutter") ||
    msg.includes("Failed to fetch") ||
    msg.includes("dynamically imported module")
  );
}
