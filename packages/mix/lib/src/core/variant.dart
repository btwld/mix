import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../core/widget_state/widget_state_controller.dart';
import '../internal/deep_collection_equality.dart';
import 'deprecated.dart';
import 'factory/style_mix.dart';

/// Priority levels for variant application
enum VariantPriority {
  normal(0),
  high(1);

  const VariantPriority(this.value);
  final int value;
}

/// Sealed base class for all variant types in the Mix framework.
///
/// Variants are used to conditionally apply styling based on either:
/// - Manual application (NamedVariant)
/// - Automatic context conditions (ContextVariant)
@immutable
sealed class Variant {
  const Variant();

  String get key;

  /// Operator for creating AND multi-variants
  MultiVariant operator &(covariant Variant variant) =>
      MultiVariant.and([this, variant]);

  /// Operator for creating OR multi-variants
  MultiVariant operator |(covariant Variant variant) =>
      MultiVariant.or([this, variant]);
}

/// Manual variants that are only applied when explicitly requested.
/// These variants don't automatically apply based on context.
///
/// Examples: primary, outlined, large
@immutable
class NamedVariant extends Variant {
  final String name;

  const NamedVariant(this.name);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is NamedVariant && other.name == name;

  @override
  String get key => name;

  @override
  int get hashCode => name.hashCode;
}

/// Base for variants that automatically apply based on context conditions.
/// These variants check their conditions during widget build.
@immutable
class ContextVariant extends Variant {
  final bool Function(BuildContext) shouldApply;

  @override
  final String key;
  const ContextVariant(this.key, this.shouldApply);

  static WidgetStateVariant widgetState(WidgetState state) {
    return WidgetStateVariant(state);
  }

  static ContextVariant orientation(Orientation orientation) {
    return ContextVariant(
      'media_query_orientation_${orientation.name}',
      (context) => MediaQuery.orientationOf(context) == orientation,
    );
  }

  static ContextVariant platformBrightness(Brightness brightness) {
    return ContextVariant(
      'media_query_platform_brightness_${brightness.name}',
      (context) => MediaQuery.platformBrightnessOf(context) == brightness,
    );
  }

  static ContextVariant size(String name, bool Function(Size) condition) {
    return ContextVariant(
      'media_query_size_$name',
      (context) => condition(MediaQuery.sizeOf(context)),
    );
  }

  // Directionality
  static ContextVariant direction(TextDirection direction) {
    return ContextVariant(
      'directionality_${direction.name}',
      (context) => Directionality.of(context) == direction,
    );
  }

  // Platform
  static ContextVariant platform(TargetPlatform platform) {
    return ContextVariant(
      'platform_${platform.name}',
      (context) => Theme.of(context).platform == platform,
    );
  }

  // Web
  static ContextVariant web() {
    return ContextVariant('web', (context) => kIsWeb);
  }

  /// Check if this variant should be active for the given context
  bool when(BuildContext context) {
    return shouldApply(context);
  }
}

class WidgetStateVariant extends ContextVariant {
  final WidgetState state;

  WidgetStateVariant(this.state)
    : super(
        'widget_state_${state.name}',
        (context) => MixWidgetStateModel.hasStateOf(context, state),
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WidgetStateVariant && other.state == state;

  @override
  int get hashCode => state.hashCode;
}

/// Variant that dynamically builds a Style based on build context.
/// This variant type allows for complex styling that depends on runtime context.
@immutable
class ContextVariantBuilder<S extends StyleElement<Object?>> extends Variant {
  /// Function that builds a Style based on the given BuildContext
  final S Function(BuildContext) fn;

  const ContextVariantBuilder(this.fn);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContextVariantBuilder && other.fn == fn;

  @override
  int get hashCode => fn.hashCode;

  @override
  String get key => fn.hashCode.toString();

  /// Build a Style from the given BuildContext
  S build(BuildContext context) => fn(context);
}

/// Operator for combining variants with AND/OR/NOT logic
enum MultiVariantOperator { and, or, not }

/// Variant that combines multiple variants with AND/OR logic.
/// Supports complex conditional styling based on multiple conditions.
@immutable
final class MultiVariant extends ContextVariant {
  final List<Variant> variants;
  final MultiVariantOperator operatorType;

  MultiVariant._(this.variants, {required this.operatorType})
    : super('', (context) => false);

  factory MultiVariant(
    Iterable<Variant> variants, {
    required MultiVariantOperator type,
  }) {
    final multiVariants = <MultiVariant>[];
    final otherVariants = <Variant>[];

    for (var variant in variants) {
      if (variant is MultiVariant) {
        if (variant.operatorType == type) {
          otherVariants.addAll(variant.variants);
        } else {
          multiVariants.add(variant);
        }
      } else {
        otherVariants.add(variant);
      }
    }

    final combinedVariants = [...multiVariants, ...otherVariants];

    return MultiVariant._(combinedVariants.toList(), operatorType: type);
  }

  factory MultiVariant.and(Iterable<Variant> variants) {
    return MultiVariant(variants, type: MultiVariantOperator.and);
  }

  factory MultiVariant.or(Iterable<Variant> variants) {
    return MultiVariant(variants, type: MultiVariantOperator.or);
  }

  factory MultiVariant.not(Variant variant) {
    return MultiVariant._([variant], operatorType: MultiVariantOperator.not);
  }

  List<Object?> get props => [variants, operatorType];

  @override
  bool when(BuildContext context) {
    final conditions = variants.map((variant) {
      if (variant is ContextVariant) {
        return variant.when(context);
      }

      // NamedVariants never match context conditions
      return false;
    }).toList();

    switch (operatorType) {
      case MultiVariantOperator.or:
        return conditions.contains(true);
      case MultiVariantOperator.and:
        return conditions.every((e) => e);
      case MultiVariantOperator.not:
        return !conditions.first;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MultiVariant &&
          other.operatorType == operatorType &&
          const DeepCollectionEquality().equals(other.variants, variants);

  @override
  String get key => 'MultiVariant(${variants.map((v) => v.key).join(', ')})';

  @override
  int get hashCode =>
      Object.hash(operatorType, const DeepCollectionEquality().hash(variants));
}

// Predefined widget state variants
final hover = ContextVariant.widgetState(WidgetState.hovered);
final press = ContextVariant.widgetState(WidgetState.pressed);
final focus = ContextVariant.widgetState(WidgetState.focused);
final disabled = ContextVariant.widgetState(WidgetState.disabled);
final selected = ContextVariant.widgetState(WidgetState.selected);
final dragged = ContextVariant.widgetState(WidgetState.dragged);
final error = ContextVariant.widgetState(WidgetState.error);

// Predefined MediaQuery variants
// Brightness variants
final dark = ContextVariant.platformBrightness(Brightness.dark);
final light = ContextVariant.platformBrightness(Brightness.light);

// Orientation variants
final portrait = ContextVariant.orientation(Orientation.portrait);
final landscape = ContextVariant.orientation(Orientation.landscape);

// Size-based responsive variants
final mobile = ContextVariant.size('mobile', (size) => size.width <= 767);
final tablet = ContextVariant.size(
  'tablet',
  (size) => size.width > 767 && size.width <= 1279,
);
final desktop = ContextVariant.size('desktop', (size) => size.width > 1279);

// Directionality variants
final ltr = ContextVariant.direction(TextDirection.ltr);
final rtl = ContextVariant.direction(TextDirection.rtl);

// Platform variants
final ios = ContextVariant.platform(TargetPlatform.iOS);
final android = ContextVariant.platform(TargetPlatform.android);
final macos = ContextVariant.platform(TargetPlatform.macOS);
final windows = ContextVariant.platform(TargetPlatform.windows);
final linux = ContextVariant.platform(TargetPlatform.linux);
final fuchsia = ContextVariant.platform(TargetPlatform.fuchsia);
final web = ContextVariant.web();

// Breakpoint variants (using common responsive breakpoints)
final xsmall = ContextVariant.size('xsmall', (size) => size.width <= 480);
final small = ContextVariant.size('small', (size) => size.width <= 768);
final medium = ContextVariant.size('medium', (size) => size.width <= 1024);
final large = ContextVariant.size('large', (size) => size.width <= 1280);
final xlarge = ContextVariant.size('xlarge', (size) => size.width > 1280);

// Predefined breakpoint helper function
ContextVariant breakpointVariant(Breakpoint breakpoint) {
  return ContextVariant.size(
    'breakpoint_${breakpoint.minWidth}_${breakpoint.maxWidth}',
    (size) => breakpoint.matches(size),
  );
}

// Utility variants using NOT logic
final enabled = not(disabled);
final unselected = not(selected);

// Common named variants
const primary = NamedVariant('primary');
const secondary = NamedVariant('secondary');
const outlined = NamedVariant('outlined');

// NOT operator for creating inverse variants
MultiVariant not(Variant variant) => MultiVariant.not(variant);
