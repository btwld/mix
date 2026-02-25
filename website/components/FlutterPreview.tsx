"use client";

import React, { useEffect, useState } from "react";

import { FlutterMultiView } from "./FlutterMultiView";
import { FlutterSnippet } from "./FlutterSnippet";
import {
  type PreviewManifestEntry,
  findPreviewManifestEntry,
} from "./flutter/preview-manifest";

type PreviewMode = "preview" | "code" | "both";
type ManifestState = "loading" | "ready" | "error";

interface FlutterPreviewProps {
  /** Preview ID registered in PreviewRegistry */
  previewId: string;
  /** Header title */
  title?: string;
  /** Optional subtitle/description */
  description?: string;
  /** Initial mode shown */
  defaultMode?: PreviewMode;
  /** Show mode tabs */
  showTabs?: boolean;
  /** Flutter preview height */
  height?: number;
  /** Maximum code block height */
  codeMaxHeight?: number;
  /** Preview bundle base path */
  basePath?: string;
  /** Source bundle base path */
  sourceBasePath?: string;
  /** Show border around preview */
  bordered?: boolean;
  /** Fallback to full file when region does not exist */
  fallbackToFullFile?: boolean;
}

export function FlutterPreview({
  previewId,
  title,
  description,
  defaultMode = "preview",
  showTabs = false,
  height = 360,
  codeMaxHeight = 420,
  basePath = "/previews",
  sourceBasePath = "/previews/sources",
  bordered = true,
  fallbackToFullFile = true,
}: FlutterPreviewProps) {
  const [mode, setMode] = useState<PreviewMode>(defaultMode);
  const [manifestState, setManifestState] = useState<ManifestState>("loading");
  const [entry, setEntry] = useState<PreviewManifestEntry | null>(null);
  const [manifestError, setManifestError] = useState<string | null>(null);
  const showPreview = mode === "preview" || mode === "both";
  const showCode = mode === "code" || mode === "both";
  const resolvedTitle = title ?? entry?.title;
  const resolvedDescription = description ?? entry?.description;

  useEffect(() => {
    let isMounted = true;

    const loadEntry = async () => {
      setManifestState("loading");
      setManifestError(null);
      setEntry(null);

      try {
        const manifestEntry = await findPreviewManifestEntry(previewId, basePath);
        if (!isMounted) return;

        if (!manifestEntry) {
          throw new Error(`Unknown previewId: ${previewId}`);
        }

        setEntry(manifestEntry);
        setManifestState("ready");
      } catch (error) {
        if (!isMounted) return;
        setManifestState("error");
        setManifestError(error instanceof Error ? error.message : "Unknown manifest error");
      }
    };

    loadEntry();

    return () => {
      isMounted = false;
    };
  }, [basePath, previewId]);

  return (
    <div
      className="my-8 not-prose"
      data-testid="flutter-preview"
      data-preview-id={previewId}
    >
      {(resolvedTitle || resolvedDescription || showTabs) && (
        <div className="mb-3 flex items-start justify-between gap-4">
          <div>
            {resolvedTitle && (
              <h4 className="text-base font-semibold text-white">{resolvedTitle}</h4>
            )}
            {resolvedDescription && (
              <p className="mt-1 text-sm text-zinc-400">{resolvedDescription}</p>
            )}
          </div>

          {showTabs && (
            <div className="flex gap-1">
              <ModeButton
                active={mode === "preview"}
                onClick={() => setMode("preview")}
                label="Preview"
              />
              <ModeButton
                active={mode === "code"}
                onClick={() => setMode("code")}
                label="Code"
              />
              <ModeButton
                active={mode === "both"}
                onClick={() => setMode("both")}
                label="Both"
              />
            </div>
          )}
        </div>
      )}

      {manifestState === "loading" && (
        <div className="rounded-lg border border-white/10 bg-[#1a1a2e] px-4 py-3 text-sm text-zinc-400">
          Resolving preview metadata...
        </div>
      )}

      {manifestState === "error" && (
        <div className="rounded-lg border border-red-500/30 bg-red-500/10 px-4 py-3 text-sm text-red-400">
          {manifestError ?? "Failed to resolve preview metadata."}
        </div>
      )}

      {manifestState === "ready" && entry && (
        <>
          {showPreview && entry.renderable !== false && (
            <FlutterMultiView
              key={`preview-${previewId}`}
              previewId={previewId}
              basePath={basePath}
              height={height}
              bordered={bordered}
              lazyLoad={false}
              className={showCode ? "mb-3" : ""}
            />
          )}

          {showPreview && entry.renderable === false && (
            <div className="mb-3 rounded-lg border border-amber-500/30 bg-amber-500/10 px-4 py-3 text-sm text-amber-300">
              This preview is snippet-only and cannot be rendered interactively.
            </div>
          )}

          {showCode && (
            <FlutterSnippet
              sourcePath={entry.sourcePath}
              region={entry.snippetRegion ?? undefined}
              basePath={sourceBasePath}
              maxHeight={codeMaxHeight}
              fallbackToFullFile={fallbackToFullFile}
            />
          )}
        </>
      )}
    </div>
  );
}

function ModeButton({
  active,
  onClick,
  label,
}: {
  active: boolean;
  onClick: () => void;
  label: string;
}) {
  return (
    <button
      onClick={onClick}
      className={`rounded px-3 py-1.5 text-xs font-medium transition-colors ${
        active
          ? "bg-purple-600 text-white"
          : "bg-white/5 text-zinc-400 hover:bg-white/10 hover:text-zinc-300"
      }`}
    >
      {label}
    </button>
  );
}

export default FlutterPreview;
