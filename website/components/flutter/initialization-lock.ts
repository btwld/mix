/**
 * Initialization lock to prevent WebGL conflicts from concurrent Flutter initializations.
 *
 * Multiple Flutter element embeds cannot initialize simultaneously because they
 * compete for WebGL/CanvasKit resources, causing BindingErrors. This queue
 * ensures only one element embed initializes at a time.
 */

let initializationQueue: Array<() => void> = [];
let isInitializing = false;

/**
 * Waits for the queue to be empty before proceeding with initialization.
 * Returns a release function that must be called when initialization completes.
 *
 * @example
 * ```ts
 * const releaseLock = await acquireInitializationLock();
 * try {
 *   // ... initialize Flutter
 * } finally {
 *   releaseLock();
 * }
 * ```
 */
export async function acquireInitializationLock(): Promise<() => void> {
  return new Promise((resolve) => {
    const tryAcquire = () => {
      if (!isInitializing) {
        isInitializing = true;
        resolve(() => {
          isInitializing = false;
          // Signal next waiting embed
          const next = initializationQueue.shift();
          if (next) next();
        });
      } else {
        // Add ourselves to queue and wait
        initializationQueue.push(tryAcquire);
      }
    };
    tryAcquire();
  });
}

/**
 * Reset lock state. For testing only.
 */
export function __resetLockState_TESTING_ONLY(): void {
  initializationQueue = [];
  isInitializing = false;
}
