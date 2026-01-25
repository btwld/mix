/// Configuration models for annotation flags.
///
/// Holds the methods and components flags extracted from annotations.
library;

import 'package:mix_annotations/mix_annotations.dart';

/// Configuration extracted from @MixableSpec annotation.
class MixableSpecAnnotationConfig {
  /// Flags indicating which methods to generate within the Spec class.
  final int methods;

  /// Flags indicating which components to generate (utility, attribute, etc.).
  final int components;

  const MixableSpecAnnotationConfig({
    this.methods = GeneratedSpecMethods.all,
    this.components = GeneratedSpecComponents.all,
  });

  /// Whether to generate copyWith method.
  bool get generateCopyWith => (methods & GeneratedSpecMethods.copyWith) != 0;

  /// Whether to generate equals (props getter).
  bool get generateEquals => (methods & GeneratedSpecMethods.equals) != 0;

  /// Whether to generate lerp method.
  bool get generateLerp => (methods & GeneratedSpecMethods.lerp) != 0;

  @override
  String toString() =>
      'MixableSpecAnnotationConfig(methods: $methods, components: $components)';
}

/// Configuration extracted from @MixableStyler annotation.
class MixableStylerAnnotationConfig {
  /// Flags indicating which methods to generate in the Styler mixin.
  final int methods;

  const MixableStylerAnnotationConfig({
    this.methods = GeneratedStylerMethods.all,
  });

  /// Whether to generate setter methods for fields.
  bool get generateSetters => (methods & GeneratedStylerMethods.setters) != 0;

  /// Whether to generate merge() method.
  bool get generateMerge => (methods & GeneratedStylerMethods.merge) != 0;

  /// Whether to generate resolve() method.
  bool get generateResolve => (methods & GeneratedStylerMethods.resolve) != 0;

  /// Whether to generate debugFillProperties() method.
  bool get generateDebugFillProperties =>
      (methods & GeneratedStylerMethods.debugFillProperties) != 0;

  /// Whether to generate props getter.
  bool get generateProps => (methods & GeneratedStylerMethods.props) != 0;

  /// Whether to generate call() method.
  bool get generateCall => (methods & GeneratedStylerMethods.call) != 0;

  @override
  String toString() => 'MixableStylerAnnotationConfig(methods: $methods)';
}
