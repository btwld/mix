import 'package:flutter/widgets.dart';

import '../../../modifiers/internal/render_widget_modifier.dart';
import '../../factory/mix_data.dart';
import '../../factory/mix_provider.dart';
import '../../factory/style_mix.dart';
import '../../modifier.dart';

class MixBuilder extends StatelessWidget {
  const MixBuilder({
    super.key,
    this.inherit = false,
    required this.style,
    this.orderOfModifiers = const [],
    required this.builder,
  });

  final bool inherit;
  final Style style;
  final List<Type> orderOfModifiers;
  final Widget Function(BuildContext) builder;

  Widget _applyModifiers(MixData mix, Widget child) {
    // Get the list of WidgetModifierAttribute from the mix
    final modifiers = mix
        .whereType<WidgetModifierSpecAttribute>()
        .map((e) => e.resolve(mix))
        .toList();

    // If the mix is animated, use RenderAnimatedModifiers, otherwise use RenderModifiers
    return mix.isAnimated
        ? RenderAnimatedModifiers(
            modifiers: modifiers,
            duration: mix.animation!.duration,
            mix: mix,
            orderOfModifiers: orderOfModifiers,
            curve: mix.animation!.curve,
            child: child,
          )
        : RenderModifiers(
            modifiers: modifiers,
            mix: mix,
            orderOfModifiers: orderOfModifiers,
            child: child,
          );
  }

  @override
  Widget build(BuildContext context) {
    final inheritedMix = inherit ? Mix.maybeOfInherited(context) : null;
    // Get the mix from the style
    final mix = style.of(context);
    // Merge the inherited mix with the current mix, or use the current mix if no inherited mix
    final mergedMix = inheritedMix?.merge(mix) ?? mix;

    // Return a Mix widget with the merged mix and the child widget with modifiers applied
    return Mix(
      data: mergedMix,
      child: _applyModifiers(mergedMix, Builder(builder: builder)),
    );
  }
}
