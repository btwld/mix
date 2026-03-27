import { codeToHtml } from "shiki";

import { FeatureShowcaseClient } from "./FeatureShowcase";

const CODE_SNIPPETS: Record<string, string> = {
  "homepage/styling": `final boxStyle = BoxStyler()
    .width(260)
    .paddingAll(20)
    .borderRounded(16)
    .linearGradient(
      colors: [Colors.indigo.shade600,
               Colors.purple.shade400],
      begin: .topLeft,
      end: .bottomRight,
    )
    .shadowOnly(
      color: Colors.indigo.withValues(alpha: 0.28),
      offset: Offset(0, 18),
      blurRadius: 30,
    );`,

  "homepage/variants": `final cardStyle = BoxStyler()
    .width(260)
    .paddingAll(20)
    .borderRounded(18)
    .color(Colors.indigo.shade400)
    .borderAll(
      color: Colors.white.withValues(alpha: 0.10),
      width: 1,
    )
    .animate(.easeInOut(220.ms))
    .onHovered(
      BoxStyler()
          .color(Colors.indigo.shade500)
          .scale(1.02)
          .borderAll(
            color: Colors.white.withValues(alpha: 0.18),
            width: 1,
          ),
    );`,

  "homepage/animation": `final heartFrameStyle = BoxStyler()
    .paddingAll(20)
    .color(Colors.red.shade50)
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
    );`,
};

export async function FeatureShowcase() {
  const codeSnippets: Record<string, string> = {};

  await Promise.all(
    Object.entries(CODE_SNIPPETS).map(async ([id, code]) => {
      codeSnippets[id] = await codeToHtml(code.trim(), {
        lang: "dart",
        theme: "tokyo-night",
        structure: "inline",
      });
    })
  );

  return <FeatureShowcaseClient codeSnippets={codeSnippets} />;
}
