import 'package:flutter/material.dart';

import '../core/widget_state/widget_state_controller.dart';
import '../internal/compare_mixin.dart';
import '../internal/deep_collection_equality.dart';

/// Sealed base class for all variant types in the Mix framework.
///
/// Variants are used to conditionally apply styling based on either:
/// - Manual application (NamedVariant)
/// - Automatic context conditions (ContextVariant)
@immutable
sealed class Variant with EqualityMixin {
  const Variant();

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
final class NamedVariant extends Variant {
  final String name;

  const NamedVariant(this.name);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is NamedVariant && other.name == name;

  @override
  int get hashCode => name.hashCode;

  @override
  List<Object?> get props => [name];
}

/// Base for variants that automatically apply based on context conditions.
/// These variants check their conditions during widget build.
@immutable
abstract base class ContextVariant extends Variant {
  const ContextVariant();

  /// Check if this variant should be active for the given context
  bool when(BuildContext context);
}

/// Interactive state variants (HIGH PRIORITY).
/// These override environmental variants when both are active.
///
/// Examples: hover, press, focus, disabled
@immutable
final class WidgetStateVariant extends ContextVariant {
  final WidgetState state;

  const WidgetStateVariant(this.state);

  @override
  bool when(BuildContext context) {
    return MixWidgetStateModel.hasStateOf(context, state);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WidgetStateVariant && other.state == state;

  @override
  int get hashCode => state.hashCode;

  @override
  List<Object?> get props => [state];
}

/// Environmental variants (NORMAL PRIORITY).
/// Environmental conditions that can be overridden by interactive states.
///
/// Uses MediaQuery for all context-based conditions with factory constructors
/// that match the MediaQuery API 1:1 for consistency and discoverability.
@immutable
final class MediaQueryVariant extends ContextVariant {
  final bool Function(BuildContext) _condition;
  final String _name;

  const MediaQueryVariant._(this._condition, this._name);

  /// Size-based conditions using MediaQuery.sizeOf(context)
  factory MediaQueryVariant.size(bool Function(Size) condition, String name) {
    return MediaQueryVariant._(
      (context) => condition(MediaQuery.sizeOf(context)),
      name,
    );
  }

  /// Orientation using MediaQuery.orientationOf(context)
  factory MediaQueryVariant.orientation(Orientation orientation) {
    return MediaQueryVariant._(
      (context) => MediaQuery.orientationOf(context) == orientation,
      'orientation_${orientation.name}',
    );
  }

  /// Platform brightness using MediaQuery.platformBrightnessOf(context)
  factory MediaQueryVariant.platformBrightness(Brightness brightness) {
    return MediaQueryVariant._(
      (context) => MediaQuery.platformBrightnessOf(context) == brightness,
      'brightness_${brightness.name}',
    );
  }

  /// Device pixel ratio using MediaQuery.devicePixelRatioOf(context)
  factory MediaQueryVariant.devicePixelRatio(
    bool Function(double) condition,
    String name,
  ) {
    return MediaQueryVariant._(
      (context) => condition(MediaQuery.devicePixelRatioOf(context)),
      name,
    );
  }

  /// Text scaler using MediaQuery.textScalerOf(context)
  factory MediaQueryVariant.textScaler(
    bool Function(TextScaler) condition,
    String name,
  ) {
    return MediaQueryVariant._(
      (context) => condition(MediaQuery.textScalerOf(context)),
      name,
    );
  }

  /// Padding using MediaQuery.paddingOf(context)
  factory MediaQueryVariant.padding(
    bool Function(EdgeInsets) condition,
    String name,
  ) {
    return MediaQueryVariant._(
      (context) => condition(MediaQuery.paddingOf(context)),
      name,
    );
  }

  /// View insets using MediaQuery.viewInsetsOf(context)
  factory MediaQueryVariant.viewInsets(
    bool Function(EdgeInsets) condition,
    String name,
  ) {
    return MediaQueryVariant._(
      (context) => condition(MediaQuery.viewInsetsOf(context)),
      name,
    );
  }

  /// Accessibility - always use 24 hour format
  factory MediaQueryVariant.alwaysUse24HourFormat(bool value) {
    return MediaQueryVariant._(
      (context) => MediaQuery.alwaysUse24HourFormatOf(context) == value,
      'always_use_24_hour_format_$value',
    );
  }

  /// Accessibility - accessible navigation
  factory MediaQueryVariant.accessibleNavigation(bool value) {
    return MediaQueryVariant._(
      (context) => MediaQuery.accessibleNavigationOf(context) == value,
      'accessible_navigation_$value',
    );
  }

  /// Accessibility - invert colors
  factory MediaQueryVariant.invertColors(bool value) {
    return MediaQueryVariant._(
      (context) => MediaQuery.invertColorsOf(context) == value,
      'invert_colors_$value',
    );
  }

  /// Accessibility - high contrast
  factory MediaQueryVariant.highContrast(bool value) {
    return MediaQueryVariant._(
      (context) => MediaQuery.highContrastOf(context) == value,
      'high_contrast_$value',
    );
  }

  /// Accessibility - disable animations
  factory MediaQueryVariant.disableAnimations(bool value) {
    return MediaQueryVariant._(
      (context) => MediaQuery.disableAnimationsOf(context) == value,
      'disable_animations_$value',
    );
  }

  /// Accessibility - bold text
  factory MediaQueryVariant.boldText(bool value) {
    return MediaQueryVariant._(
      (context) => MediaQuery.boldTextOf(context) == value,
      'bold_text_$value',
    );
  }

  /// Custom condition for any MediaQuery-based logic
  factory MediaQueryVariant.custom(
    bool Function(BuildContext) condition,
    String name,
  ) {
    return MediaQueryVariant._(condition, name);
  }

  @override
  bool when(BuildContext context) => _condition(context);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MediaQueryVariant && other._name == _name;

  @override
  int get hashCode => _name.hashCode;

  @override
  List<Object?> get props => [_name];
}

/// Operator for combining variants with AND/OR logic
enum MultiVariantOperator { and, or }

/// Variant that combines multiple variants with AND/OR logic.
/// Supports complex conditional styling based on multiple conditions.
@immutable
final class MultiVariant extends ContextVariant {
  final List<Variant> variants;
  final MultiVariantOperator operatorType;

  const MultiVariant._(this.variants, {required this.operatorType});

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

  @override
  bool when(BuildContext context) {
    final conditions = variants.map((variant) {
      if (variant is ContextVariant) {
        return variant.when(context);
      }

      // NamedVariants never match context conditions
      return false;
    }).toList();

    return operatorType == MultiVariantOperator.or
        ? conditions.contains(true)
        : conditions.every((e) => e);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MultiVariant &&
          other.operatorType == operatorType &&
          const DeepCollectionEquality().equals(other.variants, variants);

  @override
  int get hashCode =>
      Object.hash(operatorType, const DeepCollectionEquality().hash(variants));

  @override
  List<Object?> get props => [variants, operatorType];
}

// Predefined widget state variants
const hover = WidgetStateVariant(WidgetState.hovered);
const press = WidgetStateVariant(WidgetState.pressed);
const focus = WidgetStateVariant(WidgetState.focused);
const disabled = WidgetStateVariant(WidgetState.disabled);
const selected = WidgetStateVariant(WidgetState.selected);
const dragged = WidgetStateVariant(WidgetState.dragged);
const error = WidgetStateVariant(WidgetState.error);

// Predefined MediaQuery variants
// Brightness variants
final dark = MediaQueryVariant.platformBrightness(Brightness.dark);
final light = MediaQueryVariant.platformBrightness(Brightness.light);

// Orientation variants
final portrait = MediaQueryVariant.orientation(Orientation.portrait);
final landscape = MediaQueryVariant.orientation(Orientation.landscape);

// Size-based responsive variants
final mobile = MediaQueryVariant.size((size) => size.width <= 767, 'mobile');
final tablet = MediaQueryVariant.size(
  (size) => size.width > 767 && size.width <= 1279,
  'tablet',
);
final desktop = MediaQueryVariant.size((size) => size.width > 1279, 'desktop');

// Common accessibility variants
final highContrast = MediaQueryVariant.highContrast(true);
final boldText = MediaQueryVariant.boldText(true);
final disableAnimations = MediaQueryVariant.disableAnimations(true);

// Common named variants
const primary = NamedVariant('primary');
const secondary = NamedVariant('secondary');
const outlined = NamedVariant('outlined');
const large = NamedVariant('large');
const medium = NamedVariant('medium');
const small = NamedVariant('small');
