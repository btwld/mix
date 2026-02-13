import 'package:flutter/material.dart';
import 'package:mix_tailwinds/mix_tailwinds.dart';

/// Diagnostic preview for parser-driven gradient direction parity checks.
///
/// Gradients are intentionally applied via Tailwind class strings so strategy
/// changes in `TwConfig.gradientStrategy` affect this fixture.
class GradientDebugPreview extends StatelessWidget {
  const GradientDebugPreview({super.key, required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(width: width, child: const _GradientDebugCard()),
      ),
    );
  }
}

class _GradientDebugCard extends StatelessWidget {
  const _GradientDebugCard();

  @override
  Widget build(BuildContext context) {
    return Div(
      classNames:
          'w-full rounded-2xl border border-slate-400 bg-white p-4 shadow-md',
      children: const [
        Div(
          classNames: 'flex flex-col gap-3',
          children: [
            _GradientTile(
              gradientClassNames:
                  'bg-gradient-to-r from-black via-white to-black',
            ),
            _GradientTile(
              gradientClassNames:
                  'bg-gradient-to-br from-black via-white to-black',
            ),
            _GradientTile(
              gradientClassNames: 'bg-gradient-to-r from-white to-black',
            ),
            _GradientTile(
              gradientClassNames: 'bg-gradient-to-br from-white to-black',
            ),
          ],
        ),
      ],
    );
  }
}

class _GradientTile extends StatelessWidget {
  const _GradientTile({required this.gradientClassNames});

  final String gradientClassNames;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Div(
        classNames: 'h-full rounded-xl border border-slate-500',
        child: Div(
          classNames:
              'h-full w-full rounded-lg border border-black/50 $gradientClassNames',
        ),
      ),
    );
  }
}
