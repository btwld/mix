import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../core/helpers.dart';
import '../core/widget_modifier.dart';
import '../core/prop.dart';
import '../core/style.dart';
import '../core/utility.dart';
import '../theme/tokens/mix_token.dart';

part 'flexible_modifier.g.dart';

/// Modifier that makes its child flexible within a flex layout.
///
/// Wraps the child in a [Flexible] widget with the specified flex and fit properties.
@MixableModifier()
final class FlexibleModifier extends WidgetModifier<FlexibleModifier>
    with Diagnosticable, _$FlexibleModifierMethods {
  @override
  final int? flex;
  @override
  final FlexFit? fit;
  const FlexibleModifier({this.flex, this.fit});

  @override
  Widget build(Widget child) {
    return Flexible(flex: flex ?? 1, fit: fit ?? .loose, child: child);
  }
}

/// Utility class for applying flexible modifications.
///
/// Provides convenient methods for creating FlexibleModifierMix instances.
final class FlexibleModifierUtility<T extends Style<Object?>>
    extends MixUtility<T, FlexibleModifierMix> {
  late final fit = MixUtility<T, FlexFit>(
    (prop) => utilityBuilder(FlexibleModifierMix(fit: prop)),
  );
  FlexibleModifierUtility(super.utilityBuilder);
  T flex(int v) => utilityBuilder(FlexibleModifierMix(flex: v));
  T tight({int? flex}) => utilityBuilder(
    FlexibleModifierMix.create(
      flex: Prop.maybe(flex),
      fit: Prop.value(FlexFit.tight),
    ),
  );

  T loose({int? flex}) => utilityBuilder(
    FlexibleModifierMix.create(
      flex: Prop.maybe(flex),
      fit: Prop.value(FlexFit.loose),
    ),
  );

  T expanded({int? flex}) => tight(flex: flex);

  T call({int? flex, FlexFit? fit}) {
    return utilityBuilder(FlexibleModifierMix(flex: flex, fit: fit));
  }

  T flexToken(MixToken<int> token) {
    return utilityBuilder(FlexibleModifierMix.create(flex: Prop.token(token)));
  }

  T fitToken(MixToken<FlexFit> token) {
    return utilityBuilder(FlexibleModifierMix.create(fit: Prop.token(token)));
  }
}
