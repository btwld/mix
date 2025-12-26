import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../core/breakpoint.dart';
import '../core/providers/widget_state_provider.dart';
import '../core/spec.dart';
import '../core/style.dart';
import '../theme/tokens/token_refs.dart';
import '../theme/tokens/value_tokens.dart';

/// Base class for all variant types.
@immutable
sealed class Variant {
  const Variant();

  /// Factory method to create a named variant
  static NamedVariant named(String name) => NamedVariant(name);

  String get key;
}

/// Manual variants applied when explicitly requested.
@immutable
class NamedVariant extends Variant {
  final String name;

  const NamedVariant(this.name);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is NamedVariant && other.name == name;

  @override
  String toString() => 'NamedVariant($name)';

  @override
  String get key => name;

  @override
  int get hashCode => name.hashCode;
}

/// Variants that automatically apply based on context conditions.
@immutable
class ContextVariant extends Variant {
  final bool Function(BuildContext) shouldApply;

  /// Optional widget state tracking. When non-null, this variant is treated
  /// as a widget state variant with higher priority during style resolution.
  final WidgetState? trackedState;

  @override
  final String key;

  const ContextVariant(this.key, this.shouldApply, {this.trackedState});

  /// Creates a widget state variant that applies when the widget is in the given state.
  static ContextVariant widgetState(WidgetState state) {
    return ContextVariant(
      'widget_state_${state.name}',
      (context) => WidgetStateProvider.hasStateOf(context, state),
      trackedState: state,
    );
  }

  static ContextVariant orientation(Orientation orientation) {
    return ContextVariant(
      'media_query_orientation_${orientation.name}',
      (context) => MediaQuery.orientationOf(context) == orientation,
    );
  }

  static ContextVariant not(ContextVariant variant) {
    return ContextVariant(
      'not_${variant.key}',
      (context) => !variant.when(context),
    );
  }

  static ContextVariant breakpoint(Breakpoint breakpoint) {
    if (breakpoint case final BreakpointRef ref) {
      return ContextVariant('breakpoint_${ref.token.name}', (context) {
        return ref.token.resolve(context).matches(MediaQuery.sizeOf(context));
      });
    }

    return ContextVariant(
      'breakpoint_${breakpoint.minWidth ?? '0.0'}_${breakpoint.maxWidth ?? 'infinity'}',
      (context) => breakpoint.matches(MediaQuery.sizeOf(context)),
    );
  }

  static ContextVariant brightness(Brightness brightness) {
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
  static ContextVariant directionality(TextDirection direction) {
    return ContextVariant(
      'directionality_${direction.name}',
      (context) => Directionality.of(context) == direction,
    );
  }

  // Platform
  static ContextVariant platform(TargetPlatform platform) {
    return ContextVariant(
      'platform_${platform.name}',
      (context) => defaultTargetPlatform == platform,
    );
  }

  // Web
  static ContextVariant web() {
    return ContextVariant('web', (_) => kIsWeb);
  }

  // Responsive breakpoints
  static ContextVariant mobile() {
    return ContextVariant.breakpoint(BreakpointToken.mobile());
  }

  static ContextVariant tablet() {
    return ContextVariant.breakpoint(BreakpointToken.tablet());
  }

  static ContextVariant desktop() {
    return ContextVariant.breakpoint(BreakpointToken.desktop());
  }

  /// Check if this variant should be active for the given context
  bool when(BuildContext context) {
    return shouldApply(context);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContextVariant && other.key == key;

  @override
  int get hashCode => key.hashCode;
}

/// Variant that dynamically builds a Style based on build context.
@immutable
class ContextVariantBuilder<S extends Style<Object?>> extends Variant {
  /// Function that builds a Style from context
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

  /// Build a Style from context
  S build(BuildContext context) => fn(context);
}

// Common named variants
const primary = NamedVariant('primary');
const secondary = NamedVariant('secondary');
const outlined = NamedVariant('outlined');
const solid = NamedVariant('solid');
const danger = NamedVariant('danger');

// Size variants
const small = NamedVariant('small');
const large = NamedVariant('large');
