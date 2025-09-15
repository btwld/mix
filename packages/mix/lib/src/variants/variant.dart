import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../core/breakpoint.dart';
import '../core/mix_element.dart';
import '../core/providers/widget_state_provider.dart';
import '../core/spec.dart';
import '../core/style.dart';

/// Triggers that determine when styles should be applied based on context conditions.
@immutable
class ContextVariant {
  final bool Function(BuildContext) shouldApply;
  final String key;

  const ContextVariant(this.key, this.shouldApply);

  static WidgetStateTrigger widgetState(WidgetState state) {
    return WidgetStateTrigger(state);
  }

  static ContextVariant orientation(Orientation orientation) {
    return ContextVariant(
      'media_query_orientation_${orientation.name}',
      (context) => MediaQuery.orientationOf(context) == orientation,
    );
  }

  static ContextVariant not(ContextVariant trigger) {
    return ContextVariant(
      'not_${trigger.key}',
      (context) => !trigger.matches(context),
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

  /// Check if this trigger should activate for the given context
  bool matches(BuildContext context) {
    return shouldApply(context);
  }

  @override
  String toString() => 'ContextTrigger($key)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContextVariant &&
          other.key == key &&
          other.shouldApply == shouldApply;

  @override
  int get hashCode => Object.hash(key, shouldApply);
}

final class WidgetStateTrigger extends ContextVariant {
  final WidgetState state;

  WidgetStateTrigger(this.state)
    : super('widget_state_${state.name}', (context) {
        return WidgetStateProvider.hasStateOf(context, state);
      });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WidgetStateTrigger && other.state == state;

  @override
  int get hashCode => state.hashCode;
}

/// Base interface for variant-based styling
@immutable
sealed class VariantStyle<S extends Spec<S>> extends Mixable {
  const VariantStyle();

  /// Unique key identifying this variant
  String get variantKey;

  Object get mergeKey => variantKey;
}

/// Variant style for trigger-based variants (automatic activation)
@immutable
final class ContextVariantStyle<S extends Spec<S>> extends VariantStyle<S> {
  final ContextVariant trigger;
  final Style<S> _style;

  const ContextVariantStyle(this.trigger, Style<S> style) : _style = style;

  Style<S> get style => _style;

  bool isActive(BuildContext context) => trigger.matches(context);

  @override
  ContextVariantStyle<S> merge(covariant ContextVariantStyle<S>? other) {
    if (other == null) {
      return this;
    }

    if (variantKey != other.variantKey) {
      throw ArgumentError(
        'Cannot merge EventVariantStyle with different keys. '
        'Attempted to merge key "$variantKey" with "${other.variantKey}".',
      );
    }

    return ContextVariantStyle(trigger, _style.merge(other._style));
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContextVariantStyle<S> &&
          other.trigger == trigger &&
          other._style == _style;

  @override
  String get variantKey => trigger.key;

  @override
  int get hashCode => Object.hash(trigger, _style);
}

/// Variant style for dynamic style building (always active)
@immutable
final class VariantStyleBuilder<S extends Spec<S>> extends VariantStyle<S> {
  final Style<S> Function(BuildContext) builder;

  const VariantStyleBuilder(this.builder);

  Style<S> resolve(BuildContext context) => builder(context);

  @override
  VariantStyleBuilder<S> merge(covariant VariantStyleBuilder<S>? other) {
    if (other == null) {
      return this;
    }

    if (variantKey != other.variantKey) {
      throw ArgumentError(
        'Cannot merge VariantBuilder with different keys. '
        'Attempted to merge key "$variantKey" with "${other.variantKey}".',
      );
    }

    // Create new builder that merges the resolved styles
    return VariantStyleBuilder(
      (context) => builder(context).merge(other.builder(context)),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VariantStyleBuilder<S> && other.builder == builder;

  @override
  String get variantKey => builder.hashCode.toString();

  @override
  int get hashCode => builder.hashCode;
}
