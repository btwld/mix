"use client";

import React, { useState } from "react";
import { DartPadEmbed } from "./DartPadEmbed";
import { FlutterEmbed } from "./FlutterEmbed";

type DemoMode = "preview" | "code" | "both";

interface DemoProps {
  /** Demo title */
  title?: string;
  /** Description of what the demo shows */
  description?: string;

  // DartPad mode props
  /** GitHub Gist ID for DartPad */
  gistId?: string;
  /** Inline code for DartPad */
  code?: string;

  // Flutter Embed mode props
  /** URL to hosted Flutter web build */
  flutterSrc?: string;
  /** Use iframe for Flutter (recommended - element embedding has WebGL conflicts with multiple instances) */
  useIframe?: boolean;

  // Shared props
  /** Height of the demo area */
  height?: number;
  /** Initial view mode */
  defaultMode?: DemoMode;
  /** Whether to show mode toggle tabs */
  showTabs?: boolean;
  /** Theme for DartPad */
  theme?: "dark" | "light";
}

/**
 * Demo - Unified component for embedding interactive Flutter demos
 *
 * Automatically chooses between DartPad and FlutterEmbed based on props:
 * - If `gistId` or `code` is provided → Uses DartPad
 * - If `flutterSrc` is provided → Uses Flutter Element Embedding
 *
 * @example DartPad with Gist
 * ```tsx
 * <Demo
 *   title="Box Styling"
 *   gistId="abc123def456"
 *   description="Basic box with color and rounded corners"
 * />
 * ```
 *
 * @example DartPad with inline code
 * ```tsx
 * <Demo
 *   title="Hover Effect"
 *   code={`
 *     import 'package:mix/mix.dart';
 *     // ...
 *   `}
 * />
 * ```
 *
 * @example Flutter Element Embed
 * ```tsx
 * <Demo
 *   title="Animation Demo"
 *   flutterSrc="/demos/animation"
 *   description="Complex animation that requires full Flutter"
 * />
 * ```
 */
export function Demo({
  title,
  description,
  gistId,
  code,
  flutterSrc,
  useIframe = true, // Default to iframe for reliability with multiple Flutter instances
  height = 450,
  defaultMode = "preview",
  showTabs = true,
  theme = "dark",
}: DemoProps) {
  const [mode, setMode] = useState<DemoMode>(defaultMode);

  const isDartPad = Boolean(gistId || code);
  const isFlutterEmbed = Boolean(flutterSrc);

  // Q6 fix: Warn if multiple content sources are provided
  if (isDartPad && isFlutterEmbed) {
    console.warn(
      "Demo: Both DartPad props (gistId/code) and flutterSrc were provided. " +
        "Only one content source should be specified. Using DartPad."
    );
  }

  // If neither is specified, show an error state
  if (!isDartPad && !isFlutterEmbed) {
    return (
      <div className="my-6 rounded-lg border border-red-500/30 bg-red-500/10 p-4 text-red-400">
        <strong>Demo Error:</strong> Either <code>gistId</code>,{" "}
        <code>code</code>, or <code>flutterSrc</code> must be provided.
      </div>
    );
  }

  const TabButton = ({
    active,
    onClick,
    children,
    "data-testid": dataTestId,
  }: {
    active: boolean;
    onClick: () => void;
    children: React.ReactNode;
    "data-testid"?: string;
  }) => (
    <button
      onClick={onClick}
      data-testid={dataTestId}
      className={`px-3 py-1.5 text-xs font-medium rounded transition-colors ${
        active
          ? "bg-purple-600 text-white"
          : "bg-white/5 text-zinc-400 hover:bg-white/10 hover:text-zinc-300"
      }`}
    >
      {children}
    </button>
  );

  return (
    <div
      className="my-8 not-prose"
      data-testid="demo"
      data-demo-type={isDartPad ? "dartpad" : "flutter"}
    >
      {/* Header */}
      <div className="mb-3 flex items-center justify-between">
        <div>
          {title && (
            <h4 className="text-base font-semibold text-white">{title}</h4>
          )}
          {description && (
            <p className="mt-1 text-sm text-zinc-400">{description}</p>
          )}
        </div>

        {/* Mode tabs - only show for DartPad since it has code view */}
        {showTabs && isDartPad && (
          <div className="flex gap-1">
            <TabButton
              active={mode === "preview"}
              onClick={() => setMode("preview")}
              data-testid="demo-tab-preview"
            >
              Preview
            </TabButton>
            <TabButton
              active={mode === "code"}
              onClick={() => setMode("code")}
              data-testid="demo-tab-code"
            >
              Code
            </TabButton>
            <TabButton
              active={mode === "both"}
              onClick={() => setMode("both")}
              data-testid="demo-tab-both"
            >
              Both
            </TabButton>
          </div>
        )}
      </div>

      {/* Demo content */}
      <div
        className="overflow-hidden rounded-lg border border-white/10 bg-[#1a1a2e]"
        style={{
          height: mode === "both" ? height * 1.2 : height,
        }}
      >
        {isDartPad ? (
          <DartPadEmbed
            gistId={gistId}
            code={code}
            theme={theme}
            height={height}
            split={mode === "code" ? 100 : mode === "preview" ? 0 : 50}
            run={mode !== "code"}
          />
        ) : (
          <FlutterEmbed
            src={flutterSrc!}
            height={height}
            useIframe={useIframe}
            bordered={false}
          />
        )}
      </div>

      {/* Footer with type indicator */}
      <div className="mt-2 flex items-center gap-2 text-xs text-zinc-500">
        <span
          data-testid="demo-badge"
          className={`inline-flex items-center gap-1 rounded px-2 py-0.5 ${
            isDartPad
              ? "bg-blue-500/10 text-blue-400"
              : "bg-purple-500/10 text-purple-400"
          }`}
        >
          {isDartPad ? "DartPad" : "Flutter Web"}
        </span>
        {isDartPad && theme === "dark" && (
          <span className="text-zinc-600">Editable - try modifying the code!</span>
        )}
      </div>
    </div>
  );
}

export default Demo;
