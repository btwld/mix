import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../core/breakpoint.dart';
import '../core/providers/widget_state_provider.dart';
import '../core/providers/widget_state_style_override.dart';
import '../core/spec.dart';
import '../core/style.dart';
import '../theme/tokens/token_refs.dart';
import '../theme/tokens/value_tokens.dart';

/// Base class for all variant types.
@immutable
sealed class Variant {
  const Variant();

  /// Factory method to create a named variant
  static NamedVariant named(String name) => .new(name);

  /// Human-readable label used for diagnostics.
  ///
  /// This label is not guaranteed to be unique across variant kinds.
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

  @override
  final String key;
  const ContextVariant(this.key, this.shouldApply);

  static WidgetStateVariant widgetState(WidgetState state) {
    return WidgetStateVariant(state);
  }

  static OrientationVariant orientation(Orientation orientation) {
    return OrientationVariant(orientation);
  }

  static ContextVariant not(ContextVariant variant) {
    return NotVariant(variant);
  }

  static ContextVariant breakpoint(Breakpoint breakpoint) {
    return BreakpointVariant(breakpoint);
  }

  static ContextVariant brightness(Brightness brightness) {
    return BrightnessVariant(brightness);
  }

  static ContextVariant size(String name, bool Function(Size) condition) {
    return ContextVariant(
      'media_query_size_$name',
      (context) => condition(MediaQuery.sizeOf(context)),
    );
  }

  // Directionality
  static DirectionalityVariant directionality(TextDirection direction) {
    return DirectionalityVariant(direction);
  }

  // Platform
  static PlatformVariant platform(TargetPlatform platform) {
    return PlatformVariant(platform);
  }

  // Web
  static WebVariant web() {
    return WebVariant();
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
}

/// Context variant that applies for a media-query orientation.
final class OrientationVariant extends ContextVariant {
  final Orientation orientation;

  OrientationVariant(this.orientation)
    : super(
        'media_query_orientation_${orientation.name}',
        (context) => MediaQuery.orientationOf(context) == orientation,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrientationVariant && other.orientation == orientation;

  @override
  int get hashCode => orientation.hashCode;
}

/// Context variant that applies for a platform brightness.
final class BrightnessVariant extends ContextVariant {
  final Brightness brightness;

  BrightnessVariant(this.brightness)
    : super(
        'media_query_platform_brightness_${brightness.name}',
        (context) => MediaQuery.platformBrightnessOf(context) == brightness,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BrightnessVariant && other.brightness == brightness;

  @override
  int get hashCode => brightness.hashCode;
}

/// Context variant that applies for a concrete or token-backed breakpoint.
final class BreakpointVariant extends ContextVariant {
  final Breakpoint breakpoint;

  BreakpointVariant(this.breakpoint)
    : super(_breakpointKey(breakpoint), (context) {
        if (breakpoint case final BreakpointRef ref) {
          return ref.token.resolve(context).matches(MediaQuery.sizeOf(context));
        }

        return breakpoint.matches(MediaQuery.sizeOf(context));
      });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BreakpointVariant && other.breakpoint == breakpoint;

  @override
  int get hashCode => breakpoint.hashCode;
}

/// Context variant that applies when another context variant does not.
final class NotVariant extends ContextVariant {
  final ContextVariant inner;

  NotVariant(this.inner)
    : super('not_${inner.key}', (context) => !inner.when(context));

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is NotVariant && other.inner == inner;

  @override
  int get hashCode => inner.hashCode;
}

/// Context variant that applies for inherited text direction.
final class DirectionalityVariant extends ContextVariant {
  final TextDirection direction;

  DirectionalityVariant(this.direction)
    : super(
        'directionality_${direction.name}',
        (context) => Directionality.of(context) == direction,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DirectionalityVariant && other.direction == direction;

  @override
  int get hashCode => direction.hashCode;
}

/// Context variant that applies for the current default target platform.
final class PlatformVariant extends ContextVariant {
  final TargetPlatform platform;

  PlatformVariant(this.platform)
    : super(
        'platform_${platform.name}',
        (_) => defaultTargetPlatform == platform,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlatformVariant && other.platform == platform;

  @override
  int get hashCode => platform.hashCode;
}

/// Context variant that applies when running on the web.
final class WebVariant extends ContextVariant {
  WebVariant() : super('web', (_) => kIsWeb);

  @override
  bool operator ==(Object other) => other is WebVariant;

  @override
  int get hashCode => key.hashCode;
}

final class WidgetStateVariant extends ContextVariant {
  final WidgetState state;

  WidgetStateVariant(this.state)
    : super('widget_state_${state.name}', (context) {
        final override = WidgetStateStyleOverride.maybeOf(context);
        if (override != null) return override.states.contains(state);

        return WidgetStateProvider.hasStateOf(context, state);
      });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WidgetStateVariant && other.state == state;

  @override
  int get hashCode => state.hashCode;
}

String _breakpointKey(Breakpoint breakpoint) {
  if (breakpoint case final BreakpointRef ref) {
    return 'breakpoint_${ref.token.name}';
  }

  return 'breakpoint_${breakpoint.minWidth ?? '0.0'}_${breakpoint.maxWidth ?? 'infinity'}';
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

// Helper functions for cleaner variant checking
bool hasVariant(List<NamedVariant> activeVariants, NamedVariant variant) =>
    activeVariants.contains(variant);

bool hasAnyVariant(
  List<NamedVariant> activeVariants,
  List<NamedVariant> variants,
) => variants.any((variant) => activeVariants.contains(variant));

bool hasAllVariants(
  List<NamedVariant> activeVariants,
  List<NamedVariant> variants,
) => variants.every((variant) => activeVariants.contains(variant));

/// Interface for design system components that adapt their styling
/// based on active variants and user modifications.
abstract class StyleVariation<S extends Spec<S>> {
  /// The named variant this StyleVariation handles
  NamedVariant get variantType;

  /// Combines user modifications with variant styling and contextual adaptations.
  Style<S> styleBuilder(
    covariant Style<S> style,
    Set<NamedVariant> activeVariants,
    BuildContext context,
  );
}

/// Mixin for enums that act as [NamedVariant]s.
///
/// Apply this mixin to an enum to use its values as named variants:
/// ```dart
/// enum ButtonVariant with EnumVariant { primary, secondary, outlined }
/// ```
mixin EnumVariant on Enum implements NamedVariant {
  @override
  String get key => _EnumName(this).name;

  @override
  String get name => _EnumName(this).name;
}

extension type const _EnumName(Enum _value) implements Enum {
  String get name => _value.name;
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
