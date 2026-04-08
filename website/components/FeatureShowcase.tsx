"use client";

import { motion } from "framer-motion";
import Link from "next/link";

import previewsManifest from "../public/previews/previews-manifest.json";
import { FlutterSnippet } from "./FlutterSnippet";
import { FlutterMultiView } from "./FlutterMultiView";
import { type PreviewManifestEntry } from "./flutter/preview-manifest";

interface Feature {
  title: string;
  subtitle: string;
  learnMoreHref: string;
  learnMoreLabel: string;
  previewId: string;
  previewWidth?: number;
  previewHeight?: number;
}

const FEATURES: Feature[] = [
  {
    title: "Intuitive Styling",
    subtitle:
      "Define size, color, and shape in a single fluent chain. Each method returns a new style — readable, composable, and type-safe.",
    learnMoreHref: "/documentation/guides/styling",
    learnMoreLabel: "See the styling guide",
    previewId: "homepage/styling",
  },
  {
    title: "Context-Reactive Variants",
    subtitle:
      "Declare hover behavior inline — color, scale, and shadow all react to state without conditional logic.",
    learnMoreHref: "/documentation/guides/dynamic-styling",
    learnMoreLabel: "Explore variants",
    previewId: "homepage/variants",
  },
  {
    title: "Powerful Animations",
    subtitle:
      "Define keyframe timelines with multiple property tracks directly inside styles. No external animation controllers needed.",
    learnMoreHref: "/documentation/guides/animations",
    learnMoreLabel: "Animation docs",
    previewId: "homepage/animation",
  },
  {
    title: "Design System Buttons",
    subtitle:
      "Define a base button once, then compose variants by adding just what differs. Text styling flows through via inherited defaults.",
    learnMoreHref: "/documentation/tutorials/creating-a-widget",
    learnMoreLabel: "Build your own widget",
    previewId: "homepage/buttons",
    previewWidth: 320,
    previewHeight: 80,
  },
  {
    title: "Text Directives",
    subtitle:
      "Apply uppercase and capitalize transforms directly in the style. Directives stay attached through merges and composition.",
    learnMoreHref: "/documentation/guides/directives",
    learnMoreLabel: "Directives guide",
    previewId: "homepage/directives",
    previewWidth: 320,
    previewHeight: 100,
  },
];

function normalizeManifestEntry(entry: (typeof previewsManifest.entries)[number]): PreviewManifestEntry {
  return {
    previewId: entry.previewId,
    sourcePath: entry.sourcePath,
    snippetRegion: entry.snippetRegion ?? undefined,
    title: entry.title ?? undefined,
    description: entry.description ?? undefined,
    category: entry.category ?? undefined,
    renderable: entry.renderable,
  };
}

const SNIPPET_ENTRIES: Record<string, PreviewManifestEntry> = Object.fromEntries(
  previewsManifest.entries.map((entry) => [
    entry.previewId,
    normalizeManifestEntry(entry),
  ])
);

export function FeatureShowcase() {
  return (
    <div className="not-prose">
      <div className="flex flex-col gap-24">
        {FEATURES.map((feature) => (
          <motion.div
            key={feature.previewId}
            initial={{ opacity: 0, y: 40 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true, margin: "-80px" }}
            transition={{ duration: 0.6, ease: [0.25, 0.4, 0.25, 1] as const }}
          >
            <FeatureBlock
              feature={feature}
              snippetEntry={SNIPPET_ENTRIES[feature.previewId]}
            />
          </motion.div>
        ))}
      </div>
    </div>
  );
}

function FeatureBlock({
  feature,
  snippetEntry,
}: {
  feature: Feature;
  snippetEntry?: PreviewManifestEntry;
}) {
  return (
    <div className="space-y-5">
      {/* Text */}
      <div>
        <h3 className="text-xl font-semibold tracking-[-0.02em] text-white sm:text-2xl">
          {feature.title}
        </h3>
        <p className="mt-3 max-w-[520px] text-sm leading-relaxed text-[var(--mix-text-muted)]">
          {feature.subtitle}
        </p>
        <Link
          href={feature.learnMoreHref}
          className="group mt-3 inline-flex items-center gap-1.5 text-sm font-medium text-[var(--mix-text-muted)] transition-colors hover:text-[var(--mix-accent)]"
        >
          {feature.learnMoreLabel}
          <span
            aria-hidden
            className="text-xs transition-transform group-hover:translate-x-0.5"
          >
            →
          </span>
        </Link>
      </div>

      {/* Code (left) + Preview (right) */}
      <div className="grid grid-cols-1 items-center gap-4 lg:grid-cols-[1fr_auto]">
        {/* Code card */}
        <div
          className="code-card min-w-0 overflow-hidden rounded-xl relative"
          style={{
            border: "1px solid var(--mix-border-card)",
            backgroundColor: "var(--mix-surface)",
            boxShadow: "0 40px 80px rgba(0, 0, 0, 0.3)",
          }}
        >
          {/* Accent line at top */}
          <div
            className="absolute top-0 left-0 right-0 h-px"
            style={{
              background: "linear-gradient(90deg, transparent, var(--mix-accent), transparent)",
            }}
          />

          {/* File label */}
          <div className="border-b border-white/[0.05] px-5 py-2.5">
            <span className="text-[11px] tracking-[0.1em] text-[var(--mix-text-muted)] font-mono uppercase">
              example.dart
            </span>
          </div>

          {/* Code content */}
          <div className="relative">
            {snippetEntry ? (
              <FlutterSnippet
                sourcePath={snippetEntry.sourcePath}
                region={snippetEntry.snippetRegion ?? undefined}
                showMeta={false}
                maxHeight={320}
                surfaceClassName="overflow-hidden"
                codeClassName="overflow-x-auto px-5 py-4 font-mono text-[13px] leading-[1.6]"
                loadingClassName="px-5 py-8 text-[var(--mix-text-muted)]"
                errorClassName="px-5 py-4"
              />
            ) : (
              <div className="px-5 py-8 text-sm text-[var(--mix-text-muted)]">
                Example source unavailable.
              </div>
            )}
            {/* Bottom fade */}
            <div
              className="pointer-events-none absolute bottom-0 left-0 right-0 h-8"
              style={{
                background: "linear-gradient(to top, var(--mix-surface), transparent)",
              }}
            />
          </div>
        </div>

        {/* Flutter preview */}
        <div
          className="flex items-center justify-center overflow-visible"
          style={{
            width: feature.previewWidth ?? 280,
            height: feature.previewHeight ?? 220,
          }}
        >
          <FlutterMultiView
            previewId={feature.previewId}
            height={feature.previewHeight ?? 220}
            bordered={false}
            transparent
            lazyLoad
          />
        </div>
      </div>
    </div>
  );
}

export default FeatureShowcase;
