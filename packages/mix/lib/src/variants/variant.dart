import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../core/breakpoint.dart';
import '../core/providers/widget_state_provider.dart';
import '../core/style.dart';

/// Base class for all variant types.
///
/// Conditionally applies styling based on manual application
/// or automatic context conditions.
@immutable
sealed class Variant {
  const Variant();

  String get key;
}

/// Manual variants applied only when explicitly requested.
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

  static ContextVariant not(ContextVariant variant) {
    return ContextVariant(
      'not_${variant.key}',
      (context) => !variant.when(context),
    );
  }

  static ContextVariant breakpoint(Breakpoint breakpoint) {
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
    return ContextVariant.breakpoint(Breakpoint.mobile);
  }

  static ContextVariant tablet() {
    return ContextVariant.breakpoint(Breakpoint.tablet);
  }

  static ContextVariant desktop() {
    return ContextVariant.breakpoint(Breakpoint.desktop);
  }

  /// Checks if this variant should be active for the given context.
  bool when(BuildContext context) {
    return shouldApply(context);
  }
}

final class WidgetStateVariant extends ContextVariant {
  final WidgetState state;

  WidgetStateVariant(this.state)
    : super('widget_state_${state.name}', (context) {
        return WidgetStateProvider.hasStateOf(context, state);
      });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WidgetStateVariant && other.state == state;

  @override
  int get hashCode => state.hashCode;
}

/// Variant that dynamically builds a Style based on build context.
@immutable
class ContextVariantBuilder<S extends Style<Object?>> extends Variant {
  /// Function that builds a Style from the given BuildContext.
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

  /// Builds a Style from the given BuildContext.
  S build(BuildContext context) => fn(context);
}

// Common named variants
const primary = NamedVariant('primary');
const secondary = NamedVariant('secondary');
const outlined = NamedVariant('outlined');
