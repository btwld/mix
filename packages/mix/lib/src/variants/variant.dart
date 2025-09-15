import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../core/breakpoint.dart';
import '../core/mix_element.dart';
import '../core/providers/widget_state_provider.dart';
import '../core/spec.dart';
import '../core/style.dart';

@Deprecated('Use ContextTrigger instead')
typedef ContextVariant = ContextTrigger;

/// Triggers that determine when styles should be applied based on context conditions.
@immutable
class ContextTrigger {
  final bool Function(BuildContext) shouldApply;
  final String key;

  const ContextTrigger(this.key, this.shouldApply);

  static WidgetStateTrigger widgetState(WidgetState state) {
    return WidgetStateTrigger(state);
  }

  static ContextTrigger orientation(Orientation orientation) {
    return ContextTrigger(
      'media_query_orientation_${orientation.name}',
      (context) => MediaQuery.orientationOf(context) == orientation,
    );
  }

  static ContextTrigger not(ContextTrigger trigger) {
    return ContextTrigger(
      'not_${trigger.key}',
      (context) => !trigger.matches(context),
    );
  }

  static ContextTrigger breakpoint(Breakpoint breakpoint) {
    return ContextTrigger(
      'breakpoint_${breakpoint.minWidth ?? '0.0'}_${breakpoint.maxWidth ?? 'infinity'}',
      (context) => breakpoint.matches(MediaQuery.sizeOf(context)),
    );
  }

  static ContextTrigger brightness(Brightness brightness) {
    return ContextTrigger(
      'media_query_platform_brightness_${brightness.name}',
      (context) => MediaQuery.platformBrightnessOf(context) == brightness,
    );
  }

  static ContextTrigger size(String name, bool Function(Size) condition) {
    return ContextTrigger(
      'media_query_size_$name',
      (context) => condition(MediaQuery.sizeOf(context)),
    );
  }

  // Directionality
  static ContextTrigger directionality(TextDirection direction) {
    return ContextTrigger(
      'directionality_${direction.name}',
      (context) => Directionality.of(context) == direction,
    );
  }

  // Platform
  static ContextTrigger platform(TargetPlatform platform) {
    return ContextTrigger(
      'platform_${platform.name}',
      (context) => defaultTargetPlatform == platform,
    );
  }

  // Web
  static ContextTrigger web() {
    return ContextTrigger('web', (_) => kIsWeb);
  }

  // Responsive breakpoints
  static ContextTrigger mobile() {
    return ContextTrigger.breakpoint(Breakpoint.mobile);
  }

  static ContextTrigger tablet() {
    return ContextTrigger.breakpoint(Breakpoint.tablet);
  }

  static ContextTrigger desktop() {
    return ContextTrigger.breakpoint(Breakpoint.desktop);
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
      other is ContextTrigger &&
          other.key == key &&
          other.shouldApply == shouldApply;

  @override
  int get hashCode => Object.hash(key, shouldApply);
}

final class WidgetStateTrigger extends ContextTrigger {
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
final class EventVariantStyle<S extends Spec<S>> extends VariantStyle<S> {
  final ContextTrigger trigger;
  final Style<S> _style;

  const EventVariantStyle(this.trigger, Style<S> style) : _style = style;

  Style<S> get style => _style;

  bool isActive(BuildContext context) => trigger.matches(context);

  @override
  EventVariantStyle<S> merge(covariant EventVariantStyle<S>? other) {
    if (other == null) {
      return this;
    }

    if (variantKey != other.variantKey) {
      throw ArgumentError(
        'Cannot merge EventVariantStyle with different keys. '
        'Attempted to merge key "$variantKey" with "${other.variantKey}".',
      );
    }

    return EventVariantStyle(trigger, _style.merge(other._style));
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventVariantStyle<S> &&
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

/// Interface for design system components that adapt their styling
/// based on active variants and user modifications.
mixin StyleVariantMixin<T extends Style<S>, S extends Spec<S>> on Style<S>
    implements VariantStyle<S> {
  /// The named variant this StyleVariation handles
  @override
  String get variantKey;

  T merge(T? other) {
    if (other == null) return this as T;

    return other.withVariants([this]) as T;
  }

  @override
  String get mergeKey => variantKey;

  /// Adapts this style based on active variants.
  T buildStyle(Set<String> activeVariants);
}
