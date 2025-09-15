import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../core/breakpoint.dart';
import '../core/mix_element.dart';
import '../core/providers/widget_state_provider.dart';
import '../core/spec.dart';
import '../core/style.dart';
import '../core/style_spec.dart';

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
abstract interface class Variant<S extends Spec<S>> {
  /// Gets the key for this variant style
  String get variantKey;

  /// The key used to identify compatible types for merging
  Object get mergeKey => variantKey;

  /// Merges this variant with another variant of the same type
  Variant<S> merge(covariant Variant<S>? other);
}


/// Variant style for trigger-based variants (automatic activation)
@immutable
final class TriggerVariant<S extends Spec<S>> extends Mixable<StyleSpec<S>>
    implements Variant<S> {
  final ContextTrigger trigger;
  final Style<S> _style;

  const TriggerVariant(this.trigger, Style<S> style) : _style = style;

  Style<S> get style => _style;

  bool isActive(BuildContext context) {
    return trigger.matches(context);
  }

  @override
  TriggerVariant<S> merge(covariant TriggerVariant<S>? other) {
    if (other == null) {
      return this;
    }

    if (variantKey != other.variantKey) {
      throw ArgumentError(
        'Cannot merge TriggerVariant with different keys. '
        'Attempted to merge key "$variantKey" with "${other.variantKey}".',
      );
    }

    return TriggerVariant(trigger, _style.merge(other._style));
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TriggerVariant<S> &&
          other.trigger == trigger &&
          other._style == _style;

  @override
  String get variantKey => trigger.key;

  @override
  int get hashCode => Object.hash(trigger, _style);
}

/// Variant style for dynamic style building (always active)
@immutable
final class VariantBuilder<S extends Spec<S>> extends Mixable<StyleSpec<S>>
    implements Variant<S> {
  final Style<S> Function(BuildContext) builder;

  const VariantBuilder(this.builder);

  Style<S> resolve(BuildContext context) => builder(context);

  @override
  VariantBuilder<S> merge(covariant VariantBuilder<S>? other) {
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
    return VariantBuilder(
      (context) => builder(context).merge(other.builder(context)),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VariantBuilder<S> && other.builder == builder;

  @override
  String get variantKey => builder.hashCode.toString();

  @override
  int get hashCode => builder.hashCode;
}

/// Interface for design system components that adapt their styling
/// based on active variants and user modifications.
abstract interface class StyleVariant<S extends Spec<S>> implements Variant<S> {
  /// The named variant this StyleVariation handles
  String get variant;

  /// Combines user modifications with variant styling and contextual adaptations.
  Style<S> buildStyle(covariant Style<S> style, Set<String> activeVariants);
  @override
  String get variantKey => variant;
}
