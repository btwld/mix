/// Centralized [TypeChecker] constants for Mix generators.
///
/// Declaring checkers in one place keeps URL literals consistent across
/// generators and makes it cheap to audit which Mix types the codegen
/// pipeline depends on. Prefer using these over inline
/// `TypeChecker.fromUrl(...)` declarations.
library;

import 'package:source_gen/source_gen.dart';

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

/// `Prop<T>` from `package:mix`.
const propChecker = TypeChecker.fromUrl('package:mix/src/core/prop.dart#Prop');
