"use client";

import React, { useMemo, useState } from "react";

interface DartPadEmbedProps {
  /** GitHub Gist ID containing the Dart code */
  gistId?: string;
  /** Inline Dart code to embed (alternative to gistId) */
  code?: string;
  /** Theme: 'dark' for exercises, 'light' for demos */
  theme?: "dark" | "light";
  /** Height of the embed in pixels */
  height?: number;
  /** Whether to show the run button */
  run?: boolean;
  /** Split percentage between code and output (0-100) */
  split?: number;
  /** Whether to use Flutter mode (vs pure Dart) */
  flutter?: boolean;
  /** Title shown above the embed */
  title?: string;
}

/**
 * DartPadEmbed - Embeds an interactive DartPad in documentation
 *
 * Best practices from Dart team:
 * - Use light theme for demos (read-only examples)
 * - Use dark theme for exercises (user should modify)
 *
 * @example With Gist ID
 * ```tsx
 * <DartPadEmbed gistId="abc123" theme="dark" />
 * ```
 *
 * @example With inline code
 * ```tsx
 * <DartPadEmbed
 *   code={`
 *     import 'package:flutter/material.dart';
 *     import 'package:mix/mix.dart';
 *
 *     void main() => runApp(MyApp());
 *   `}
 *   flutter
 * />
 * ```
 */
export function DartPadEmbed({
  gistId,
  code,
  theme = "dark",
  height = 500,
  run = true,
  split = 50,
  flutter = true,
  title,
}: DartPadEmbedProps) {
  const [status, setStatus] = useState<"loading" | "ready" | "error">("loading");

  // Validate that at least one content source is provided
  const hasContent = Boolean(gistId || code);

  const iframeSrc = useMemo(() => {
    const baseUrl = flutter
      ? "https://dartpad.dev/embed-flutter.html"
      : "https://dartpad.dev/embed-dart.html";

    const params = new URLSearchParams();
    params.set("theme", theme);
    params.set("run", run.toString());
    params.set("split", split.toString());

    if (gistId) {
      params.set("id", gistId);
    }

    return `${baseUrl}?${params.toString()}`;
  }, [gistId, theme, run, split, flutter]);

  // For inline code, we need to use a different approach
  // DartPad supports postMessage API for setting code
  const iframeRef = React.useRef<HTMLIFrameElement>(null);

  React.useEffect(() => {
    if (code && iframeRef.current) {
      const iframe = iframeRef.current;

      const sendCode = () => {
        try {
          if (!iframe.contentWindow) {
            console.error("DartPadEmbed: iframe contentWindow not available");
            return;
          }
          iframe.contentWindow.postMessage(
            {
              sourceCode: code.trim(),
              type: "sourceCode",
            },
            "https://dartpad.dev"
          );
        } catch (error) {
          console.error("DartPadEmbed: Failed to post code to DartPad", error);
        }
      };

      // Fix load race: check if iframe already loaded (fast cache path)
      if (iframe.contentDocument?.readyState === "complete") {
        sendCode();
      }

      // Also listen for load event in case it hasn't loaded yet
      iframe.addEventListener("load", sendCode);
      return () => iframe.removeEventListener("load", sendCode);
    }
  }, [code]);

  // Show error if no content source provided
  if (!hasContent) {
    return (
      <div className="my-6 not-prose">
        {title && (
          <div className="mb-2 text-sm font-medium text-zinc-300">{title}</div>
        )}
        <div
          className="overflow-hidden rounded-lg border border-red-500/30 bg-red-500/10 flex items-center justify-center"
          style={{ height }}
        >
          <div className="text-red-400 text-center px-4">
            <div className="text-lg">Missing content source</div>
            <div className="text-sm text-zinc-500 mt-2">
              Provide either <code>gistId</code> or <code>code</code> prop
            </div>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div
      className="my-6 not-prose"
      data-testid="dartpad-embed"
      data-status={status}
    >
      {title && (
        <div className="mb-2 text-sm font-medium text-zinc-300">{title}</div>
      )}
      <div
        className="overflow-hidden rounded-lg border border-white/10"
        style={{ height }}
      >
        <iframe
          ref={iframeRef}
          src={iframeSrc}
          data-testid="dartpad-iframe"
          className="h-full w-full"
          style={{ border: "none" }}
          title={title || "DartPad Demo"}
          allow="clipboard-write"
          loading="lazy"
          onLoad={() => setStatus("ready")}
          onError={() => setStatus("error")}
        />
      </div>
      <div className="mt-2 flex items-center gap-2 text-xs text-zinc-500">
        <span>Powered by</span>
        <a
          href="https://dartpad.dev"
          target="_blank"
          rel="noopener noreferrer"
          className="text-purple-400 hover:text-purple-300"
        >
          DartPad
        </a>
        {theme === "dark" && (
          <span className="ml-auto text-zinc-600">
            Try editing the code above!
          </span>
        )}
      </div>
    </div>
  );
}

export default DartPadEmbed;
