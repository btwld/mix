import 'package:source_gen/source_gen.dart';

/// `MixableField` annotation from `package:mix_annotations`.
const mixableFieldAnnotationChecker = TypeChecker.fromUrl(
  'package:mix_annotations/src/annotations.dart#MixableField',
);

/// `MixableSpec` annotation from `package:mix_annotations`.
const mixableSpecAnnotationChecker = TypeChecker.fromUrl(
  'package:mix_annotations/src/annotations.dart#MixableSpec',
);

/// `Style<S>` abstract class from `package:mix`.
const styleChecker = TypeChecker.fromUrl(
  'package:mix/src/core/style.dart#Style',
);

/// `StyleWidget<S>` abstract class from `package:mix`.
const styleWidgetChecker = TypeChecker.fromUrl(
  'package:mix/src/core/style_widget.dart#StyleWidget',
);

/// `Mix<T>` abstract class from `package:mix`.
const mixChecker = TypeChecker.fromUrl(
  'package:mix/src/core/mix_element.dart#Mix',
);

/// `Mixable<T>` abstract class from `package:mix`.
const mixableChecker = TypeChecker.fromUrl(
  'package:mix/src/core/mix_element.dart#Mixable',
);

/// `DefaultValue<T>` mixin from `package:mix`.
const defaultValueChecker = TypeChecker.fromUrl(
  'package:mix/src/core/mix_element.dart#DefaultValue',
);

/// `Prop<T>` from `package:mix`.
const propChecker = TypeChecker.fromUrl('package:mix/src/core/prop.dart#Prop');

/// `WidgetModifier<T>` from `package:mix`.
const widgetModifierChecker = TypeChecker.fromUrl(
  'package:mix/src/core/widget_modifier.dart#WidgetModifier',
);

/// Flutter's `Widget` base class.
///
/// The URL is the canonical location in `package:flutter`; the `@MixWidget`
/// generator uses it to validate that a styler's `call()` returns a `Widget`
/// subtype.
const widgetChecker = TypeChecker.fromUrl(
  'package:flutter/src/widgets/framework.dart#Widget',
);

/// Flutter's `Key` class at its canonical `package:flutter/src/foundation`
/// location.
///
/// The `@MixWidget` generator uses it to recognize `Key? key` named parameters
/// on a styler's `call()` so they get forwarded via `super.key` instead of
/// surfacing as a generated constructor parameter.
const keyChecker = TypeChecker.fromUrl(
  'package:flutter/src/foundation/key.dart#Key',
);
