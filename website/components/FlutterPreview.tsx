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
  /** Initial mode shown */
  defaultMode?: PreviewMode;
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
  defaultMode = "preview",
  height = 360,
  codeMaxHeight = 420,
  basePath = "/previews",
  sourceBasePath = "/previews/sources",
  bordered = true,
  fallbackToFullFile = true,
}: FlutterPreviewProps) {
  const [manifestState, setManifestState] = useState<ManifestState>("loading");
  const [entry, setEntry] = useState<PreviewManifestEntry | null>(null);
  const [manifestError, setManifestError] = useState<string | null>(null);
  const showPreview = defaultMode === "preview" || defaultMode === "both";
  const showCode = defaultMode === "code" || defaultMode === "both";

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

export default FlutterPreview;
