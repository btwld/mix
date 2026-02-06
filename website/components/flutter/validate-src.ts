/**
 * URL validation utilities for Flutter embedding.
 *
 * Provides security-focused validation for src paths to prevent script injection
 * and ensure only trusted domains are used for element embedding.
 */

/** Allowed external domains for Flutter demos in element embedding mode */
export const ALLOWED_DOMAINS = [
  "localhost",
  "127.0.0.1",
  "mix-demos.web.app",
  "mix.flutterando.com.br",
];

/**
 * Validates and normalizes the src path for element embedding mode.
 *
 * - Relative paths are allowed
 * - Absolute URLs must match allowed domains
 * - Returns null if validation fails
 *
 * @param src - The source path to validate
 * @returns Normalized src or null if invalid
 */
export function validateAndNormalizeSrc(src: string): string | null {
  // Handle empty strings and normalize slashes
  if (!src || typeof src !== "string") {
    console.error("FlutterEmbed: src prop is required and must be a non-empty string");
    return null;
  }

  let normalized = src.trim();

  if (!normalized) {
    console.error("FlutterEmbed: src prop resolved to empty string after normalization");
    return null;
  }

  // Check if it's a relative path (starts with / but not //)
  if (normalized.startsWith("/") && !normalized.startsWith("//")) {
    // Only normalize slashes for relative paths (safe, no protocol to mangle)
    normalized = normalized.replace(/\/+/g, "/"); // Dedupe slashes
    normalized = normalized.replace(/\/$/, ""); // Remove trailing slash
    return normalized;
  }

  // Check if it's a protocol-relative URL or absolute URL
  try {
    const url = new URL(normalized, window.location.origin);

    // Check against allowed domains
    const hostname = url.hostname.toLowerCase();
    const isAllowed = ALLOWED_DOMAINS.some(
      (domain) => hostname === domain || hostname.endsWith(`.${domain}`)
    );

    if (!isAllowed) {
      console.error(
        `FlutterEmbed: Domain "${hostname}" is not in the allowed list. ` +
          `Use useIframe={true} for external domains or add to ALLOWED_DOMAINS.`
      );
      return null;
    }

    return url.href.replace(/\/$/, ""); // Return normalized absolute URL
  } catch {
    // If URL parsing fails, treat as relative path
    return normalized;
  }
}

/**
 * Validates src for iframe mode.
 *
 * Allows any https URL but blocks dangerous schemes.
 * More permissive than element embedding since iframes are isolated.
 *
 * @param src - The source path to validate
 * @returns Normalized src or null if invalid
 */
export function validateIframeSrc(src: string): string | null {
  if (!src || typeof src !== "string") {
    console.error("FlutterEmbed: src prop is required for iframe mode");
    return null;
  }

  const trimmed = src.trim();
  if (!trimmed) {
    console.error("FlutterEmbed: src prop resolved to empty string");
    return null;
  }

  // Block dangerous schemes
  const lowerSrc = trimmed.toLowerCase();
  const blockedSchemes = ["javascript:", "data:", "blob:", "vbscript:"];
  for (const scheme of blockedSchemes) {
    if (lowerSrc.startsWith(scheme)) {
      console.error(`FlutterEmbed: Blocked scheme "${scheme}" in iframe src`);
      return null;
    }
  }

  // For absolute URLs, verify protocol
  try {
    const url = new URL(trimmed, window.location.origin);
    if (!["http:", "https:"].includes(url.protocol)) {
      console.error(`FlutterEmbed: Only http/https allowed, got "${url.protocol}"`);
      return null;
    }
    return url.href.replace(/\/$/, "");
  } catch {
    // Relative path - allow
    return trimmed;
  }
}
