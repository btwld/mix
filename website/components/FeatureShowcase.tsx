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
  /** Grid column span on large screens (out of 2). Default 1. */
  colSpan?: 1 | 2;
  /** Layout direction inside the card */
  layout?: "stacked" | "side-by-side";
}

const FEATURES: Feature[] = [
  {
    title: "Intuitive Styling",
    subtitle:
      "Define size, color, and shape in a single fluent chain. Each method returns a new style — readable, composable, and type-safe.",
    learnMoreHref: "/documentation/guides/styling",
    learnMoreLabel: "See the styling guide",
    previewId: "homepage/styling",
    colSpan: 2,
    layout: "side-by-side",
  },
  {
    title: "Context-Reactive Variants",
    subtitle:
      "Declare hover behavior inline — color, scale, and shadow all react to state without conditional logic.",
    learnMoreHref: "/documentation/guides/dynamic-styling",
    learnMoreLabel: "Explore variants",
    previewId: "homepage/variants",
    layout: "stacked",
  },
  {
    title: "Powerful Animations",
    subtitle:
      "Define keyframe timelines with multiple property tracks directly inside styles. No external animation controllers needed.",
    learnMoreHref: "/documentation/guides/animations",
    learnMoreLabel: "Animation docs",
    previewId: "homepage/animation",
    layout: "stacked",
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
    colSpan: 2,
    layout: "side-by-side",
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
    colSpan: 2,
    layout: "side-by-side",
  },
];

interface ManifestRawEntry {
  previewId: string;
  sourcePath: string;
  snippetRegion?: string | null;
  title?: string | null;
  description?: string | null;
  category?: string | null;
  renderable: boolean;
}

function normalizeManifestEntry(entry: ManifestRawEntry): PreviewManifestEntry {
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
  (previewsManifest.entries as ManifestRawEntry[]).map((entry) => [
    entry.previewId,
    normalizeManifestEntry(entry),
  ])
);

const cardStagger = {
  hidden: {},
  visible: {
    transition: {
      staggerChildren: 0.08,
    },
  },
};

const cardReveal = {
  hidden: { opacity: 0, y: 24 },
  visible: {
    opacity: 1,
    y: 0,
    transition: {
      duration: 0.6,
      ease: [0.25, 0.4, 0.25, 1] as const,
    },
  },
};

export function FeatureShowcase() {
  return (
    <div className="not-prose">
      {/* Outer grid wrapper */}
      <div
        className="overflow-visible rounded-3xl ring-1 ring-white/[0.08] p-2"
        style={{ background: "var(--mix-surface)" }}
      >
        <motion.div
          className="grid grid-cols-1 gap-2 lg:grid-cols-2"
          initial="hidden"
          whileInView="visible"
          viewport={{ once: true, margin: "-60px" }}
          variants={cardStagger}
        >
          {FEATURES.map((feature) => (
            <motion.div
              key={feature.previewId}
              className={feature.colSpan === 2 ? "lg:col-span-2" : ""}
              variants={cardReveal}
            >
              <FeatureCard
                feature={feature}
                snippetEntry={SNIPPET_ENTRIES[feature.previewId]}
              />
            </motion.div>
          ))}
        </motion.div>
      </div>
    </div>
  );
}

function FeatureCard({
  feature,
  snippetEntry,
}: {
  feature: Feature;
  snippetEntry?: PreviewManifestEntry;
}) {
  const isSideBySide = feature.layout === "side-by-side";

  return (
    <div
      className="group relative flex h-full flex-col rounded-2xl ring-1 ring-inset ring-white/[0.08]"
      style={{ background: "var(--mix-surface-bright)" }}
    >
      {/* Card content */}
      <div className={
        isSideBySide
          ? "flex flex-col gap-0 lg:flex-row lg:items-stretch"
          : "flex flex-col"
      }>
        {/* Text + Code section */}
        <div className={
          isSideBySide
            ? "flex min-w-0 flex-1 flex-col"
            : "flex flex-col"
        }>
          {/* Text header */}
          <div className="px-6 pt-6 pb-4">
            <h3 className="text-base font-semibold tracking-[-0.01em] text-white">
              {feature.title}
            </h3>
            <p className="mt-2 text-sm leading-relaxed text-[var(--mix-text-muted)]">
              {feature.subtitle}
            </p>
            <Link
              href={feature.learnMoreHref}
              className="group/link mt-3 inline-flex items-center gap-1.5 text-xs font-medium text-[var(--mix-text-muted)] transition-colors hover:text-[var(--mix-accent)]"
            >
              {feature.learnMoreLabel}
              <span aria-hidden className="transition-transform group-hover/link:translate-x-0.5">
                →
              </span>
            </Link>
          </div>

          {/* Code snippet */}
          <div className="min-w-0 flex-1 px-2 pb-2">
            <div
              className="h-full min-w-0 overflow-hidden rounded-xl border border-[var(--mix-border-card)]"
              style={{ background: "var(--mix-bg)" }}
            >
              {/* Code */}
              <div className="relative">
                {snippetEntry ? (
                  <FlutterSnippet
                    sourcePath={snippetEntry.sourcePath}
                    region={snippetEntry.snippetRegion ?? undefined}
                    showMeta={false}
                    maxHeight={isSideBySide ? 280 : 220}
                    surfaceClassName="overflow-hidden"
                    codeClassName="overflow-x-auto px-4 py-3 font-mono text-[13px] leading-[1.7]"
                    loadingClassName="px-4 py-6 text-[var(--mix-text-muted)]"
                    errorClassName="px-4 py-3"
                  />
                ) : (
                  <div className="px-4 py-6 text-sm text-[var(--mix-text-muted)]">
                    Example source unavailable.
                  </div>
                )}
                {/* Bottom fade */}
                <div
                  className="pointer-events-none absolute bottom-0 left-0 right-0 h-6"
                  style={{
                    background: "linear-gradient(to top, var(--mix-bg), transparent)",
                  }}
                />
              </div>
            </div>
          </div>
        </div>

        {/* Flutter preview */}
        <div
          className={
            isSideBySide
              ? "flex shrink-0 items-center justify-center border-t border-[var(--mix-border-card)] p-6 lg:border-t-0 lg:border-l"
              : "flex items-center justify-center border-t border-[var(--mix-border-card)] p-6"
          }
          style={{
            minWidth: isSideBySide ? Math.max(feature.previewWidth ?? 280, 280) : undefined,
          }}
        >
          <div
            className="flex items-center justify-center overflow-visible"
            style={{
              width: feature.previewWidth ?? 240,
              height: feature.previewHeight ?? 200,
            }}
          >
            <FlutterMultiView
              previewId={feature.previewId}
              height={feature.previewHeight ?? 200}
              bordered={false}
              transparent
              lazyLoad
            />
          </div>
        </div>
      </div>
    </div>
  );
}

export default FeatureShowcase;
