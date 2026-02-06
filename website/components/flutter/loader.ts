/**
 * Singleton Flutter loader script manager.
 *
 * Coordinates loading of flutter.js across all FlutterEmbed instances
 * to prevent duplicate script tags and race conditions.
 */

type LoaderState = "idle" | "loading" | "ready" | "error";

// Module-level state for coordinating script loading across all instances
let flutterLoaderState: LoaderState = "idle";
let flutterLoaderPromise: Promise<void> | null = null;

/**
 * Loads the Flutter loader script exactly once, coordinating across all
 * FlutterEmbed instances to prevent duplicate script tags.
 */
export async function loadFlutterLoaderScript(basePath: string): Promise<void> {
  // If already loaded, return immediately
  if (flutterLoaderState === "ready" && window._flutter?.loader) {
    return;
  }

  // If previously errored, reset state AND remove stale script to allow retry
  if (flutterLoaderState === "error") {
    flutterLoaderState = "idle";
    flutterLoaderPromise = null;
    // Remove stale script element so retry can insert fresh one
    const staleScript = document.getElementById("flutter-loader-script");
    if (staleScript) {
      staleScript.remove();
    }
  }

  // If currently loading, wait for the existing promise
  if (flutterLoaderState === "loading" && flutterLoaderPromise) {
    return flutterLoaderPromise;
  }

  // Start loading
  flutterLoaderState = "loading";

  flutterLoaderPromise = new Promise<void>((resolve, reject) => {
    const scriptId = "flutter-loader-script";
    const existingScript = document.getElementById(scriptId);

    if (existingScript) {
      // Script tag exists, wait for Flutter to be available
      waitForFlutterLoader()
        .then(() => {
          flutterLoaderState = "ready";
          resolve();
        })
        .catch((error) => {
          flutterLoaderState = "error";
          flutterLoaderPromise = null; // Clear so retry creates fresh promise
          reject(error);
        });
      return;
    }

    const script = document.createElement("script");
    script.id = scriptId;
    // Uses flutter.js (loader only) - does NOT auto-initialize.
    // Safe for iframe mode where each iframe has isolated context.
    script.src = `${basePath}/flutter.js`;
    script.async = true;

    script.onload = () => {
      waitForFlutterLoader()
        .then(() => {
          flutterLoaderState = "ready";
          resolve();
        })
        .catch((error) => {
          flutterLoaderState = "error";
          flutterLoaderPromise = null;
          reject(error);
        });
    };

    script.onerror = () => {
      flutterLoaderState = "error";
      reject(new Error("Failed to load flutter.js"));
    };

    document.head.appendChild(script);
  });

  return flutterLoaderPromise;
}

async function waitForFlutterLoader(retries = 20): Promise<void> {
  if (window._flutter?.loader) return;
  if (retries <= 0) throw new Error("Flutter loader not available after timeout");
  await new Promise((r) => setTimeout(r, 100));
  return waitForFlutterLoader(retries - 1);
}

/**
 * Reset loader state. For testing only.
 */
export function __resetLoaderState_TESTING_ONLY(): void {
  flutterLoaderState = "idle";
  flutterLoaderPromise = null;
}
