// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_height_behavior_mix.dart';

// **************************************************************************
// MixableGenerator
// **************************************************************************

mixin _$TextHeightBehaviorMixMixin on Mix<TextHeightBehavior>, Diagnosticable {
  Prop<bool>? get $applyHeightToFirstAscent;
  Prop<bool>? get $applyHeightToLastDescent;
  Prop<TextLeadingDistribution>? get $leadingDistribution;

  /// Merges with another [TextHeightBehaviorMix].
  @override
  TextHeightBehaviorMix merge(TextHeightBehaviorMix? other) {
    return TextHeightBehaviorMix.create(
      applyHeightToFirstAscent: MixOps.merge(
        $applyHeightToFirstAscent,
        other?.$applyHeightToFirstAscent,
      ),
      applyHeightToLastDescent: MixOps.merge(
        $applyHeightToLastDescent,
        other?.$applyHeightToLastDescent,
      ),
      leadingDistribution: MixOps.merge(
        $leadingDistribution,
        other?.$leadingDistribution,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        DiagnosticsProperty(
          'applyHeightToFirstAscent',
          $applyHeightToFirstAscent,
        ),
      )
      ..add(
        DiagnosticsProperty(
          'applyHeightToLastDescent',
          $applyHeightToLastDescent,
        ),
      )
      ..add(DiagnosticsProperty('leadingDistribution', $leadingDistribution));
  }

  @override
  List<Object?> get props => [
    $applyHeightToFirstAscent,
    $applyHeightToLastDescent,
    $leadingDistribution,
  ];
}
