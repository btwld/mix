import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../variants/context_variant.dart';
import '../../variants/context_variant_util/on_brightness_util.dart';
import '../../variants/variant_attribute.dart';
import '../../variants/widget_state_variant.dart';
import '../attributes_map.dart';
import '../spec.dart';
import '../variant.dart';
import 'style_mix.dart';

extension StyleMixExt<T extends SpecAttribute, V> on SpecUtility<T, V> {
  /// Adds a variant with associated style.
  ///
  /// This method allows you to define conditional styling based on a specific variant.
  /// When the variant is applied, the associated style will be merged with the base styles.

  void variant(Variant variant, SpecUtility<T, V> style) {
    variants = variants.merge(
      AttributeMap([VariantAttribute(variant, Style(style))]),
    );
  }

  SpecUtilityContextVariantUtility<T, V> get on =>
      SpecUtilityContextVariantUtility._((map) {
        variants = variants.merge(map);
      });
}

class _AlwaysTrueContextVariant extends ContextVariant {
  const _AlwaysTrueContextVariant();

  @override
  bool when(BuildContext context) => true;
}

class SpecUtilityContextVariantUtility<T extends SpecAttribute, V> {
  final void Function(AttributeMap<VariantAttribute>) _addContextVariant;

  const SpecUtilityContextVariantUtility._(this._addContextVariant);

  /// Adds a context variant with a style builder function.
  ///
  /// This method creates a conditional style that is built dynamically when the variant
  /// condition is met. The styleBuilder function is called to generate the style at runtime.
  void _on(ContextVariant variant, SpecUtility<T, V> Function() styleBuilder) {
    final map =
        AttributeMap([VariantAttribute(variant, Style(styleBuilder()))]);
    _addContextVariant(map);
  }

  /// Adds a context-dependent style that adapts based on BuildContext.
  ///
  /// This method creates a style that can access the current BuildContext to make
  /// dynamic styling decisions. The styleBuilder function receives the context and
  /// returns a style based on the current widget tree state.
  void context(
    SpecUtility<T, V> Function(BuildContext context) styleBuilder,
  ) {
    final attribute = ContextVariantBuilder(
      (context) => Style(styleBuilder(context)),
      const _AlwaysTrueContextVariant(),
    );
    _addContextVariant(AttributeMap([attribute]));
  }

  /// Applies styles when the widget is hovered.
  ///
  /// This method adds hover state styling. The provided style will be applied
  /// when the user hovers over the widget, typically for interactive feedback.
  void hover(covariant SpecUtility<T, V> style) {
    _on(const OnHoverVariant(), () => style);
  }

  /// Applies styles when the widget is disabled.
  ///
  /// This method adds disabled state styling. The provided style will be applied
  /// when the widget is in a disabled state, often for visual indication that
  /// the widget is not interactive.
  void disabled(SpecUtility<T, V> style) {
    _on(const OnDisabledVariant(), () => style);
  }

  /// Applies styles when the widget is focused.
  ///
  /// This method adds focus state styling. The provided style will be applied
  /// when the widget receives focus, commonly used for accessibility and
  /// keyboard navigation feedback.
  void focus(SpecUtility<T, V> style) {
    _on(const OnFocusedVariant(), () => style);
  }

  /// Applies styles when the widget is selected.
  ///
  /// This method adds selected state styling. The provided style will be applied
  /// when the widget is in a selected state, typically used for items in lists
  /// or selection-based interfaces.
  void selected(SpecUtility<T, V> style) {
    _on(const OnSelectedVariant(), () => style);
  }

  /// Applies styles when the widget is being dragged.
  ///
  /// This method adds drag state styling. The provided style will be applied
  /// when the widget is being dragged, often used for drag-and-drop interfaces
  /// to provide visual feedback during the drag operation.
  void dragged(SpecUtility<T, V> style) {
    _on(const OnDraggedVariant(), () => style);
  }

  /// Applies styles when the widget is in an error state.
  ///
  /// This method adds error state styling. The provided style will be applied
  /// when the widget encounters an error condition, commonly used for form
  /// validation feedback or error indication.
  void error(SpecUtility<T, V> style) {
    _on(const OnErrorVariant(), () => style);
  }

  /// Applies styles when the widget is pressed.
  ///
  /// This method adds pressed state styling. The provided style will be applied
  /// when the widget is being pressed or activated, typically used for button
  /// press feedback and interactive elements.
  void pressed(SpecUtility<T, V> style) {
    _on(const OnPressVariant(), () => style);
  }

  void dark(SpecUtility<T, V> style) {
    _on(const OnBrightnessVariant(Brightness.dark), () => style);
  }

  void light(SpecUtility<T, V> style) {
    _on(const OnBrightnessVariant(Brightness.light), () => style);
  }
}
