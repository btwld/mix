"use client";

import { motion } from "framer-motion";
import Link from "next/link";
import React, { useEffect, useState } from "react";

import { FlutterMultiView } from "./FlutterMultiView";

const CODE_SNIPPETS: Record<string, string> = {
  "homepage/styling": `final Box = BoxStyler()
    .width(120)
    .height(120)
    .borderRounded(16)
    .color(Colors.deepPurple);

// Use it
Box();`,

  "homepage/variants": `final Card = BoxStyler()
    .width(120)
    .height(120)
    .borderRounded(16)
    .color(Colors.cyan)
    .alignment(.center)
    .animate(.easeInOut(220.ms))
    .onHovered(
      .color(Colors.cyanAccent)
      .scale(1.2),
    );

// Use it
Card(child: Text('Hover'));`,

  "homepage/animation": `final heartFrameStyle = BoxStyler()
    .paddingAll(20)
    .color(Colors.red)
    .shapeCircle()
    .keyframeAnimation(
      trigger: _trigger,
      timeline: [
        KeyframeTrack('scale', [
          .easeOutSine(0.84, 90.ms),
          .ease(1.16, 180.ms),
          .elasticOut(1.0, 500.ms),
        ], initial: 1.0),
        KeyframeTrack<double>('y', [
          .ease(-26.0, 140.ms),
          .decelerate(0.0, 280.ms),
        ], initial: 0.0),
      ],
      styleBuilder: (values, style) => style
          .scale(values.get('scale'))
          .translate(0, values.get('y')),
    );

// _trigger is a ValueNotifier<bool>

// Use it
Box(style: heartFrameStyle, child: heartIcon);`,

  "homepage/buttons": `final Button = BoxStyler()
    .paddingX(24)
    .paddingY(12)
    .borderRounded(10)
    .alignment(.center)
    .animate(.easeInOut(180.ms))
    .onPressed(.scale(0.95))
    .wrap(.defaultText(
      TextStyler().fontSize(14).fontWeight(.w600),
    ));

final Solid = Button
    .color(Colors.deepPurple)
    .wrap(.defaultText(.color(Colors.white)));

final Outlined = Button
    .borderAll(color: Colors.deepPurple, width: 1.5)
    .wrap(.defaultText(.color(Colors.deepPurple)));

// Use it
Solid(child: Text('Solid'));
Outlined(child: Text('Outlined'));`,

  "homepage/directives": `final Title = TextStyler()
    .fontSize(20)
    .fontWeight(.w700)
    .color(Colors.white)
    .uppercase();

final Subtitle = TextStyler()
    .fontSize(14)
    .color(Colors.white70)
    .capitalize();

// Use it
Title('hello world');                    // HELLO WORLD
Subtitle('style transforms built in');   // Style Transforms Built In`,
};

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

function useShikiHighlight(snippets: Record<string, string>) {
  const [highlighted, setHighlighted] = useState<Record<string, string>>({});

  useEffect(() => {
    let cancelled = false;
    async function highlight() {
      const { codeToHtml } = await import("shiki");
      const results: Record<string, string> = {};
      await Promise.all(
        Object.entries(snippets).map(async ([id, code]) => {
          results[id] = await codeToHtml(code.trim(), {
            lang: "dart",
            theme: "tokyo-night",
            structure: "inline",
          });
        })
      );
      if (!cancelled) setHighlighted(results);
    }
    highlight();
    return () => { cancelled = true; };
  }, [snippets]);

  return highlighted;
}

export function FeatureShowcase() {
  const codeSnippets = useShikiHighlight(CODE_SNIPPETS);

  return (
    <div className="not-prose my-20">
      <div className="space-y-32">
        {FEATURES.map((feature, index) => (
          <motion.div
            key={feature.previewId}
            initial={{ opacity: 0, y: 40 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true, margin: "-80px" }}
            transition={{ duration: 0.7, ease: [0.25, 0.4, 0.25, 1] }}
          >
            <FeatureBlock
              feature={feature}
              reversed={index % 2 !== 0}
              codeHtml={codeSnippets[feature.previewId] ?? ""}
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
  codeHtml,
}: {
  feature: Feature;
  reversed: boolean;
  codeHtml: string;
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
          className="mt-6 inline-flex items-center gap-1.5 text-sm font-medium text-zinc-500 transition-colors hover:text-violet-400"
        >
          Learn more
          <span aria-hidden className="text-xs transition-transform group-hover:translate-x-0.5">→</span>
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
            <pre
              className="m-0 overflow-x-auto px-5 py-4 text-[12.5px] leading-[1.9] font-mono"
              style={{ background: "transparent" }}
            >
              {codeHtml ? (
                <code dangerouslySetInnerHTML={{ __html: codeHtml }} />
              ) : (
                <code className="text-zinc-600">
                  {CODE_SNIPPETS[feature.previewId]}
                </code>
              )}
            </pre>
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
