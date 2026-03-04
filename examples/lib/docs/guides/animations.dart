/// Animations guide — gallery of all cases from the animations documentation.
///
/// Each case lives in its own file under docs/guides/animations/ and has a
/// Preview declared in [PreviewRegistry] for FlutterPreview in animations.mdx.
library;

import 'package:flutter/material.dart';

import 'animations/implicit_state_counter.dart' as implicit_counter;
import 'animations/implicit_variant_hover.dart' as implicit_hover;
import 'animations/keyframe_loop.dart' as keyframe_loop;
import 'animations/keyframe_switch.dart' as keyframe_switch;
import 'animations/phase_tap_compress.dart' as phase_tap;
import '../../helpers.dart';

void main() {
  runMixApp(const AnimationsGuideExample());
}

class AnimationsGuideExample extends StatelessWidget {
  const AnimationsGuideExample({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Section(
            title: 'Implicit',
            children: [
              _Card(
                title: 'Case 1: State-triggered',
                child: const implicit_counter.ImplicitStateCounterExample(),
              ),
              _Card(
                title: 'Case 2: Variant-triggered',
                child: const implicit_hover.ImplicitVariantHoverExample(),
              ),
            ],
          ),
          const SizedBox(width: 24),
          _Section(
            title: 'Phase',
            children: [
              _Card(
                title: 'Tap → compress → expand',
                child: const phase_tap.PhaseTapCompressExample(),
              ),
            ],
          ),
          const SizedBox(width: 24),
          _Section(
            title: 'Keyframe',
            children: [
              _Card(
                title: 'Case 1: Switch (scale + width)',
                child: const keyframe_switch.KeyframeSwitchExample(),
              ),
              _Card(
                title: 'Case 2: Loop (scale + color + opacity)',
                child: const keyframe_loop.KeyframeLoopExample(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}
