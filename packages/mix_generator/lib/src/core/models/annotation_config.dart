/// Configuration models for annotation flags.
///
/// Holds the methods and components flags extracted from annotations.
library;

import 'package:mix_annotations/mix_annotations.dart';

/// Configuration extracted from a [MixableSpec] annotation.
class MixableSpecAnnotationConfig {
  /// Bitmask of method flags from [GeneratedSpecMethods].
  final int methods;

  /// Bitmask of component flags (utility, attribute, etc.) from
  /// [GeneratedSpecComponents].
  final int components;

  const MixableSpecAnnotationConfig({
    this.methods = GeneratedSpecMethods.all,
    this.components = GeneratedSpecComponents.all,
  });

  /// Whether the generator emits a `copyWith` method.
  bool get generateCopyWith => (methods & GeneratedSpecMethods.copyWith) != 0;

  /// Whether the generator emits a concrete `props` getter on the mixin.
  ///
  /// When false (set via `GeneratedSpecMethods.skipEquals`), the user supplies
  /// `props` on the class. The surrounding `==`, `hashCode`, `getDiff`, and
  /// `stringify` bodies always emit and reference whichever `props` is exposed.
  bool get generateProps => (methods & GeneratedSpecMethods.equals) != 0;

  /// Whether the generator emits a `lerp` method.
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

  @override
  String toString() => 'MixableStylerAnnotationConfig(methods: $methods)';
}

/// Configuration extracted from @Mixable annotation.
class MixableAnnotationConfig {
  /// Flags indicating which methods to generate in the Mix mixin.
  final int methods;

  /// The name of the target type to resolve to.
  final String? resolveToType;

  const MixableAnnotationConfig({
    this.methods = GeneratedMixMethods.all,
    this.resolveToType,
  });

  /// Whether to generate merge() method.
  bool get generateMerge => (methods & GeneratedMixMethods.merge) != 0;

  /// Whether to generate resolve() method.
  bool get generateResolve => (methods & GeneratedMixMethods.resolve) != 0;

  /// Whether to generate props getter.
  bool get generateProps => (methods & GeneratedMixMethods.props) != 0;

  /// Whether to generate debugFillProperties() method.
  bool get generateDebugFillProperties =>
      (methods & GeneratedMixMethods.debugFillProperties) != 0;

  @override
  String toString() {
    final typeStr = resolveToType ?? 'null';

    return 'MixableAnnotationConfig(methods: $methods, resolveToType: $typeStr)';
  }
}
