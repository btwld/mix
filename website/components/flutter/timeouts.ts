/**
 * Centralized timeout constants for Flutter embedding.
 *
 * All timeouts are in milliseconds.
 */

export const FLUTTER_TIMEOUTS = {
  /** Delay for Flutter resources to stabilize after view creation */
  RESOURCE_STABILIZATION: 2000,

  /** Maximum time to wait for addView() to complete */
  ADD_VIEW: 15000,

  /** Maximum time to wait for Flutter engine/loader initialization */
  ENGINE_INIT: 30000,

  /** Maximum time to wait for iframe to load */
  IFRAME_LOAD: 45000,
} as const;

/**
 * Error thrown when an operation times out.
 */
export class TimeoutError extends Error {
  readonly operation: string;
  readonly timeoutMs: number;

  constructor(operation: string, timeoutMs: number) {
    super(`${operation} timed out after ${timeoutMs}ms`);
    this.name = "TimeoutError";
    this.operation = operation;
    this.timeoutMs = timeoutMs;
  }
}

/**
 * Promise.race-based timeout helper.
 *
 * Rejects with TimeoutError if operation doesn't complete within limit.
 *
 * @param promise - The promise to wrap with a timeout
 * @param timeoutMs - Timeout in milliseconds
 * @param operation - Description of the operation (for error message)
 */
export async function withTimeout<T>(
  promise: Promise<T>,
  timeoutMs: number,
  operation: string
): Promise<T> {
  let timeoutId: ReturnType<typeof setTimeout> | null = null;

  const timeoutPromise = new Promise<never>((_, reject) => {
    timeoutId = setTimeout(
      () => reject(new TimeoutError(operation, timeoutMs)),
      timeoutMs
    );
  });

  try {
    return await Promise.race([promise, timeoutPromise]);
  } finally {
    if (timeoutId !== null) {
      clearTimeout(timeoutId);
    }
  }
}
