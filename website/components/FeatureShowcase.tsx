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
    previewId: "homepage/styling",
  },
  {
    title: "Context-Reactive Variants",
    subtitle:
      "Declare hover behavior inline — color, scale, and shadow all react to state without conditional logic.",
    learnMoreHref: "/documentation/guides/dynamic-styling",
    previewId: "homepage/variants",
  },
  {
    title: "Powerful Animations",
    subtitle:
      "Define keyframe timelines with multiple property tracks directly inside styles. No external animation controllers needed.",
    learnMoreHref: "/documentation/guides/animations",
    previewId: "homepage/animation",
  },
  {
    title: "Design System Buttons",
    subtitle:
      "Define a base button once, then compose variants by adding just what differs. Text styling flows through via inherited defaults.",
    learnMoreHref: "/documentation/tutorials/creating-a-widget",
    previewId: "homepage/buttons",
    previewWidth: 320,
    previewHeight: 80,
  },
  {
    title: "Text Directives",
    subtitle:
      "Apply uppercase and capitalize transforms directly in the style. Directives stay attached through merges and composition.",
    learnMoreHref: "/documentation/guides/directives",
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
    <div className="not-prose my-20">
      <div className="space-y-32">
        {FEATURES.map((feature, index) => (
          <motion.div
            key={feature.previewId}
            initial={{ opacity: 0, y: 40 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true, margin: "-80px" }}
            transition={{ duration: 0.7, ease: [0.25, 0.4, 0.25, 1] as const }}
          >
            <FeatureBlock
              feature={feature}
              reversed={index % 2 !== 0}
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
  reversed,
  snippetEntry,
}: {
  feature: Feature;
  reversed: boolean;
  snippetEntry?: PreviewManifestEntry;
}) {
  return (
    <div
      className={`grid grid-cols-1 items-center gap-10 lg:grid-cols-[1fr_1.2fr] lg:gap-16 ${
        reversed ? "lg:[direction:rtl]" : ""
      }`}
    >
      {/* Text side */}
      <div className={reversed ? "[direction:ltr]" : ""}>
        <h3
          className="text-3xl font-bold tracking-[-0.04em] leading-[1.15] sm:text-[2.25rem]"
          style={{
            backgroundImage: "linear-gradient(146deg, #fff, #a78bfa)",
            WebkitBackgroundClip: "text",
            WebkitTextFillColor: "transparent",
            backgroundClip: "text",
          }}
        >
          {feature.title}
        </h3>
        <p className="mt-4 max-w-[380px] text-[15px] leading-7 text-zinc-400">
          {feature.subtitle}
        </p>
        <Link
          href={feature.learnMoreHref}
          className="group mt-6 inline-flex items-center gap-1.5 text-sm font-medium text-zinc-500 transition-colors hover:text-violet-400"
        >
          Learn more
          <span
            aria-hidden
            className="text-xs transition-transform group-hover:translate-x-0.5"
          >
            →
          </span>
        </Link>
      </div>

      {/* Code card + overlapping preview */}
      <div className={`relative pb-8 ${reversed ? "[direction:ltr]" : ""}`}>
        {/* Code card — full surface */}
        <div className="overflow-hidden rounded-xl border border-white/[0.07] bg-[#141417]">
          {/* Window chrome */}
          <div className="flex items-center gap-2 border-b border-white/[0.05] px-4 py-2.5">
            <div className="flex gap-1.5">
              <span className="h-[9px] w-[9px] rounded-full bg-white/[0.08]" />
              <span className="h-[9px] w-[9px] rounded-full bg-white/[0.08]" />
              <span className="h-[9px] w-[9px] rounded-full bg-white/[0.08]" />
            </div>
            <span className="ml-2 text-[11px] tracking-wide text-zinc-600 font-mono uppercase">
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
                maxHeight={230}
                surfaceClassName="overflow-hidden"
                codeClassName="overflow-x-auto px-5 py-4 font-mono text-[12.5px] leading-[1.9]"
                loadingClassName="px-5 py-8 text-zinc-500"
                errorClassName="px-5 py-4"
              />
            ) : (
              <div className="px-5 py-8 text-sm text-zinc-500">
                Example source unavailable.
              </div>
            )}
            {/* Subtle bottom fade */}
            <div
              className="pointer-events-none absolute bottom-0 left-0 right-0 h-8"
              style={{
                background: "linear-gradient(to top, #141417, transparent)",
              }}
            />
          </div>
        </div>

        {/* Overlapping Flutter preview */}
        <div
          className={`absolute -bottom-8 z-10 -right-6 lg:-right-10`}
          style={{
            width: feature.previewWidth ?? 280,
            height: feature.previewHeight ?? 220,
            filter: "drop-shadow(0 20px 40px rgba(0, 0, 0, 0.5))",
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
