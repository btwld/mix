/// Centralized [TypeChecker] constants for Mix generators.
///
/// Declaring checkers in one place keeps URL literals consistent across
/// generators and makes it cheap to audit which Mix types the codegen
/// pipeline depends on. Prefer using these over inline
/// `TypeChecker.fromUrl(...)` declarations.
library;

import 'package:source_gen/source_gen.dart';

/// `MixWidget` annotation from `package:mix_annotations`.
const mixWidgetAnnotationChecker = TypeChecker.fromUrl(
  'package:mix_annotations/src/annotations.dart#MixWidget',
);

/// `MixableField` annotation from `package:mix_annotations`.
const mixableFieldAnnotationChecker = TypeChecker.fromUrl(
  'package:mix_annotations/src/annotations.dart#MixableField',
);

/// `Style<S>` abstract class from `package:mix`.
const styleChecker = TypeChecker.fromUrl(
  'package:mix/src/core/style.dart#Style',
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

/// Flutter's `Widget` base class.
const flutterWidgetChecker = TypeChecker.fromUrl(
  'package:flutter/src/widgets/framework.dart#Widget',
);

/// Flutter's `Key` base class.
const flutterKeyChecker = TypeChecker.fromUrl(
  'package:flutter/src/foundation/key.dart#Key',
);

/// Flutter's `BuildContext` interface.
const flutterBuildContextChecker = TypeChecker.fromUrl(
  'package:flutter/src/widgets/framework.dart#BuildContext',
);
