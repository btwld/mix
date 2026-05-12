import 'package:mix_annotations/mix_annotations.dart';

/// Configuration extracted from a [MixableSpec] annotation.
class MixableSpecAnnotationConfig {
  final int methods;
  final int components;

  const MixableSpecAnnotationConfig({
    this.methods = GeneratedSpecMethods.all,
    this.components = GeneratedSpecComponents.all,
  });

  bool get generateCopyWith => (methods & GeneratedSpecMethods.copyWith) != 0;

  /// Whether to emit a `props` getter. When false (via `skipEquals`), the
  /// user supplies `props`; the equality surface still emits and uses it.
  bool get generateProps => (methods & GeneratedSpecMethods.equals) != 0;

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
