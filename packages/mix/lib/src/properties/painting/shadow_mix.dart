import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../core/helpers.dart';
import '../../core/mix_element.dart';
import '../../core/prop.dart';

/// Base class for shadow styling.
///
/// Shared properties for [ShadowMix] and [BoxShadowMix].
sealed class BaseShadowMix<T extends Shadow> extends Mix<T> {
  // Properties use MixableProperty for cleaner merging
  final Prop<Color>? $color;
  final Prop<Offset>? $offset;
  final Prop<double>? $blurRadius;

  const BaseShadowMix({
    Prop<double>? blurRadius,
    Prop<Color>? color,
    Prop<Offset>? offset,
  }) : $blurRadius = blurRadius,
       $color = color,
       $offset = offset;
}

/// Mix representation of [Shadow].
///
/// Supports shadow styling with tokens.
class ShadowMix extends BaseShadowMix<Shadow>
    with DefaultValue<Shadow>, Diagnosticable {
  ShadowMix({double? blurRadius, Color? color, Offset? offset})
    : this.create(
        blurRadius: Prop.maybe(blurRadius),
        color: Prop.maybe(color),
        offset: Prop.maybe(offset),
      );

  const ShadowMix.create({super.blurRadius, super.color, super.offset});

  /// Creates a [ShadowMix] from an existing [Shadow].
  ShadowMix.value(Shadow shadow)
    : this(
        blurRadius: shadow.blurRadius,
        color: shadow.color,
        offset: shadow.offset,
      );

  /// Creates with color.
  factory ShadowMix.color(Color value) {
    return ShadowMix(color: value);
  }

  /// Creates with offset.
  factory ShadowMix.offset(Offset value) {
    return ShadowMix(offset: value);
  }

  /// Creates with blur radius.
  factory ShadowMix.blurRadius(double value) {
    return ShadowMix(blurRadius: value);
  }

  /// Creates from nullable [Shadow].
  static ShadowMix? maybeValue(Shadow? shadow) {
    return shadow != null ? ShadowMix.value(shadow) : null;
  }

  /// Copy with color.
  ShadowMix color(Color value) {
    return merge(ShadowMix.color(value));
  }

  /// Copy with offset.
  ShadowMix offset(Offset value) {
    return merge(ShadowMix.offset(value));
  }

  /// Copy with blur radius.
  ShadowMix blurRadius(double value) {
    return merge(ShadowMix.blurRadius(value));
  }

  /// Resolves to [Shadow].
  @override
  Shadow resolve(BuildContext context) {
    return Shadow(
      color: MixOps.resolve(context, $color) ?? defaultValue.color,
      offset: MixOps.resolve(context, $offset) ?? defaultValue.offset,
      blurRadius:
          MixOps.resolve(context, $blurRadius) ?? defaultValue.blurRadius,
    );
  }

  /// Merges with another shadow.
  @override
  ShadowMix merge(ShadowMix? other) {
    return ShadowMix.create(
      blurRadius: MixOps.merge($blurRadius, other?.$blurRadius),
      color: MixOps.merge($color, other?.$color),
      offset: MixOps.merge($offset, other?.$offset),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('blurRadius', $blurRadius))
      ..add(DiagnosticsProperty('color', $color))
      ..add(DiagnosticsProperty('offset', $offset));
  }

  @override
  List<Object?> get props => [$blurRadius, $color, $offset];

  @override
  Shadow get defaultValue => const Shadow();
}

/// Mix representation of [BoxShadow].
///
/// Extends [ShadowMix] with spread radius support.
class BoxShadowMix extends BaseShadowMix<BoxShadow>
    with DefaultValue<BoxShadow>, Diagnosticable {
  final Prop<double>? $spreadRadius;

  BoxShadowMix({
    Color? color,
    Offset? offset,
    double? blurRadius,
    double? spreadRadius,
  }) : this.create(
         color: Prop.maybe(color),
         offset: Prop.maybe(offset),
         blurRadius: Prop.maybe(blurRadius),
         spreadRadius: Prop.maybe(spreadRadius),
       );

  const BoxShadowMix.create({
    super.color,
    super.offset,
    super.blurRadius,
    Prop<double>? spreadRadius,
  }) : $spreadRadius = spreadRadius;

  /// Creates a [BoxShadowMix] from an existing [BoxShadow].
  BoxShadowMix.value(BoxShadow boxShadow)
    : this(
        color: boxShadow.color,
        offset: boxShadow.offset,
        blurRadius: boxShadow.blurRadius,
        spreadRadius: boxShadow.spreadRadius,
      );

  /// Creates a box shadow with the specified color.
  factory BoxShadowMix.color(Color value) {
    return BoxShadowMix(color: value);
  }

  /// Creates a box shadow with the specified offset.
  factory BoxShadowMix.offset(Offset value) {
    return BoxShadowMix(offset: value);
  }

  /// Creates a box shadow with the specified blur radius.
  factory BoxShadowMix.blurRadius(double value) {
    return BoxShadowMix(blurRadius: value);
  }

  /// Creates a box shadow with the specified spread radius.
  factory BoxShadowMix.spreadRadius(double value) {
    return BoxShadowMix(spreadRadius: value);
  }

  /// Creates a [BoxShadowMix] from a nullable [BoxShadow].
  ///
  /// Returns null if the input is null.
  static BoxShadowMix? maybeValue(BoxShadow? boxShadow) {
    return boxShadow != null ? BoxShadowMix.value(boxShadow) : null;
  }

  /// Creates shadows from elevation level.
  static List<BoxShadowMix> fromElevation(ElevationShadow value) {
    return kElevationToShadow[value.elevation]!
        .map(BoxShadowMix.value)
        .toList();
  }

  /// Copy with color.
  BoxShadowMix color(Color value) {
    return merge(BoxShadowMix.color(value));
  }

  /// Copy with offset.
  BoxShadowMix offset({double? x, double? y}) {
    return merge(BoxShadowMix.offset(Offset(x ?? 0, y ?? 0)));
  }

  /// Copy with blur radius.
  BoxShadowMix blurRadius(double value) {
    return merge(BoxShadowMix.blurRadius(value));
  }

  /// Returns a copy with the specified spread radius.
  BoxShadowMix spreadRadius(double value) {
    return merge(BoxShadowMix.spreadRadius(value));
  }

  /// Resolves to [BoxShadow].
  @override
  BoxShadow resolve(BuildContext context) {
    return BoxShadow(
      color: MixOps.resolve(context, $color) ?? defaultValue.color,
      offset: MixOps.resolve(context, $offset) ?? defaultValue.offset,
      blurRadius:
          MixOps.resolve(context, $blurRadius) ?? defaultValue.blurRadius,
      spreadRadius:
          MixOps.resolve(context, $spreadRadius) ?? defaultValue.spreadRadius,
    );
  }

  /// Merges with another box shadow.
  @override
  BoxShadowMix merge(BoxShadowMix? other) {
    return BoxShadowMix.create(
      color: MixOps.merge($color, other?.$color),
      offset: MixOps.merge($offset, other?.$offset),
      blurRadius: MixOps.merge($blurRadius, other?.$blurRadius),
      spreadRadius: MixOps.merge($spreadRadius, other?.$spreadRadius),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('color', $color))
      ..add(DiagnosticsProperty('offset', $offset))
      ..add(DiagnosticsProperty('blurRadius', $blurRadius))
      ..add(DiagnosticsProperty('spreadRadius', $spreadRadius));
  }

  @override
  List<Object?> get props => [$color, $offset, $blurRadius, $spreadRadius];

  @override
  BoxShadow get defaultValue => const BoxShadow();
}

/// Material Design elevation levels.
///
/// Predefined values for shadow generation.
enum ElevationShadow {
  one(1),
  two(2),
  three(3),
  four(4),
  six(6),
  eight(8),
  nine(9),
  twelve(12),
  sixteen(16),
  twentyFour(24);

  /// The elevation value.
  final int elevation;

  const ElevationShadow(this.elevation);
}

/// Mix wrapper for a list of [ShadowMix] items resolving to `List<Shadow>`.
class ShadowListMix extends Mix<List<Shadow>> with Diagnosticable {
  final List<ShadowMix> items;

  const ShadowListMix(this.items);

  @override
  List<Shadow> resolve(BuildContext context) {
    return items.map((m) => m.resolve(context)).toList();
  }

  @override
  ShadowListMix merge(covariant ShadowListMix? other) {
    final merged = MixOps.mergeList(
      items,
      other?.items,
      strategy: ListMergeStrategy.replace,
    )!;

    return ShadowListMix(merged);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty('items', items));
  }

  @override
  List<Object?> get props => [items];
}

/// Mix wrapper for a list of [BoxShadowMix] items resolving to `List<BoxShadow>`.
class BoxShadowListMix extends Mix<List<BoxShadow>> with Diagnosticable {
  final List<BoxShadowMix> items;

  const BoxShadowListMix(this.items);

  @override
  List<BoxShadow> resolve(BuildContext context) {
    return items.map((m) => m.resolve(context)).toList();
  }

  @override
  BoxShadowListMix merge(covariant BoxShadowListMix? other) {
    final merged = MixOps.mergeList(
      items,
      other?.items,
      strategy: ListMergeStrategy.replace,
    )!;

    return BoxShadowListMix(merged);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty('items', items));
  }

  @override
  List<Object?> get props => [items];
}

extension BoxShadowListMixExt on List<BoxShadowMix> {
  BoxShadowListMix toMix() {
    return BoxShadowListMix(this);
  }
}
