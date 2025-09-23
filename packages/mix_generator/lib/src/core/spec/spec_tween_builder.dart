import '../metadata/spec_metadata.dart';
import '../utils/code_builder.dart';

/// Builds a tween class for a spec.
class SpecTweenBuilder implements CodeBuilder {
  final SpecMetadata metadata;

  const SpecTweenBuilder(this.metadata);

  /// Builds the lerp method for the tween
  String _buildLerpMethod(String className) {
    final constModifier = metadata.isConst ? 'const ' : '';

    return '''
@override
$className lerp(double t) {
  if (begin == null && end == null) {
    return $constModifier$className${metadata.constructorRef}();
  }
  
  if (begin == null) {
    return end!;
  }
  
  return begin!.lerp(end!, t);
}''';
  }

  @override
  String build() {
    final className = metadata.name;
    final tweenName = '${className}Tween';

    // Build the tween class
    final classBuilder = ClassBuilder(
      className: tweenName,
      documentation: '''
/// A tween that interpolates between two [$className] instances.
/// 
/// This class can be used in animations to smoothly transition between
/// different [$className] specifications.''',
      extendsClass: 'Tween<$className?>',
      constructorCode: '''$tweenName({
    super.begin, super.end,
  });''',
      methods: [_buildLerpMethod(className)],
    );

    return classBuilder.build();
  }
}
