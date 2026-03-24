"use client";

import React, { useEffect, useMemo, useState } from "react";

type SnippetStatus = "loading" | "ready" | "error";

interface FlutterSnippetProps {
  /** Source file path under /previews/sources (for example: examples/lib/api/widgets/box/simple_box.dart) */
  sourcePath: string;
  /** Optional named region to extract from source comments (#docregion / #region) */
  region?: string;
  /** Optional title shown above the snippet */
  title?: string;
  /** Base path where sources are hosted */
  basePath?: string;
  /** Maximum code area height */
  maxHeight?: number;
  /** Fallback to full file when a region is missing */
  fallbackToFullFile?: boolean;
  /** Additional CSS classes */
  className?: string;
}

export function FlutterSnippet({
  sourcePath,
  region,
  title,
  basePath = "/previews/sources",
  maxHeight = 440,
  fallbackToFullFile = true,
  className = "",
}: FlutterSnippetProps) {
  const [status, setStatus] = useState<SnippetStatus>("loading");
  const [code, setCode] = useState<string>("");
  const [error, setError] = useState<string>("");
  const normalizedSourcePath = useMemo(
    () => normalizeSourcePath(sourcePath),
    [sourcePath]
  );

  useEffect(() => {
    let isMounted = true;
    const controller = new AbortController();

    const load = async () => {
      if (!normalizedSourcePath) {
        setStatus("error");
        setError("Invalid sourcePath. Use a relative path without '..'.");
        return;
      }

      setStatus("loading");
      setError("");

      try {
        const sourceUrl = `${basePath.replace(/\/$/, "")}/${normalizedSourcePath}`;
        const response = await fetch(sourceUrl, { signal: controller.signal });

        if (!response.ok) {
          throw new Error(`Failed to load source (${response.status})`);
        }

        const fullSource = await response.text();
        const extracted = region
          ? extractRegion(fullSource, region)
          : { code: fullSource, found: true };

        if (region && !extracted.found && !fallbackToFullFile) {
          throw new Error(`Region "${region}" not found in ${normalizedSourcePath}`);
        }

        const resolvedCode = extracted.found ? extracted.code : fullSource;

        if (!isMounted) return;
        setCode(trimEmptyBoundaryLines(resolvedCode));
        setStatus("ready");
      } catch (err) {
        if (!isMounted) return;
        if (err instanceof DOMException && err.name === "AbortError") return;
        setStatus("error");
        setError(err instanceof Error ? err.message : "Unknown error");
      }
    };

    load();

    return () => {
      isMounted = false;
      controller.abort();
    };
  }, [basePath, fallbackToFullFile, normalizedSourcePath, region]);

  return (
    <div className={`not-prose ${className}`}>
      {(title || region) && (
        <div className="mb-2 flex items-center justify-between text-xs text-zinc-500">
          <span className="text-zinc-300">{title || "Source"}</span>
          {region && (
            <span className="rounded bg-white/5 px-2 py-0.5 text-zinc-500">
              region: {region}
            </span>
          )}
        </div>
      )}

      <div className="overflow-hidden rounded-lg border border-white/10 bg-[#0f1320]">
        {status === "loading" && (
          <div className="flex items-center justify-center p-6 text-sm text-zinc-400">
            Loading source...
          </div>
        )}

        {status === "error" && (
          <div className="p-4 text-sm text-red-400">
            Failed to load snippet: {error}
          </div>
        )}

        {status === "ready" && (
          <pre
            className="m-0 overflow-auto p-4 text-xs leading-6 text-zinc-200"
            style={{ maxHeight }}
          >
            <code>{code}</code>
          </pre>
        )}
      </div>
    </div>
  );
}

function normalizeSourcePath(value: string): string | null {
  if (!value || typeof value !== "string") return null;

  const trimmed = value.trim().replace(/\\/g, "/").replace(/^\/+/, "");
  if (!trimmed || trimmed.includes("\0")) return null;

  const segments = trimmed.split("/").filter(Boolean);
  if (segments.length === 0) return null;
  if (segments.some((segment) => segment === "." || segment === "..")) return null;

  return segments.join("/");
}

function extractRegion(
  source: string,
  region: string
): { code: string; found: boolean } {
  const lines = source.split(/\r?\n/);
  const target = region.trim();
  const chunks: string[] = [];
  let currentChunk: string[] = [];
  let inRegion = false;
  let found = false;

  for (const line of lines) {
    const trimmed = line.trim();

    const startMatch = trimmed.match(/^\/\/\s*#(?:docregion|region)\b(.*)$/);
    if (startMatch) {
      const names = parseRegionNames(startMatch[1] || "");
      if (matchesRegion(names, target)) {
        if (inRegion && currentChunk.length > 0) {
          chunks.push(currentChunk.join("\n"));
          currentChunk = [];
        }
        inRegion = true;
        found = true;
      }
      continue;
    }

    const endMatch = trimmed.match(/^\/\/\s*#(?:enddocregion|endregion)\b(.*)$/);
    if (endMatch) {
      const names = parseRegionNames(endMatch[1] || "");
      if (inRegion && matchesRegion(names, target)) {
        inRegion = false;
        if (currentChunk.length > 0) {
          chunks.push(currentChunk.join("\n"));
          currentChunk = [];
        }
      }
      continue;
    }

    if (inRegion) {
      currentChunk.push(line);
    }
  }

  if (inRegion && currentChunk.length > 0) {
    chunks.push(currentChunk.join("\n"));
  }

  if (!found) {
    return { code: source, found: false };
  }

  return { code: dedent(chunks.join("\n\n")), found: true };
}

function parseRegionNames(raw: string): string[] {
  if (!raw.trim()) return [];
  return raw
    .split(",")
    .map((name) => name.trim())
    .filter(Boolean);
}

function matchesRegion(names: string[], target: string): boolean {
  if (!target) return names.length === 0;
  if (names.length === 0) return false;
  return names.includes(target);
}

function dedent(input: string): string {
  const lines = input.replace(/\r\n/g, "\n").split("\n");
  const nonEmpty = lines.filter((line) => line.trim().length > 0);
  if (nonEmpty.length === 0) return input;

  const minIndent = Math.min(
    ...nonEmpty.map((line) => {
      const match = line.match(/^\s*/);
      return match ? match[0].length : 0;
    })
  );

  if (minIndent <= 0) return input;
  return lines.map((line) => (line.trim() ? line.slice(minIndent) : "")).join("\n");
}

function trimEmptyBoundaryLines(input: string): string {
  const lines = input.split("\n");
  while (lines.length > 0 && lines[0].trim() === "") {
    lines.shift();
  }
  while (lines.length > 0 && lines[lines.length - 1].trim() === "") {
    lines.pop();
  }
  return lines.join("\n");
}

export default FlutterSnippet;
