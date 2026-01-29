/// Spec mixin builder for generating _$XSpecMethods mixin.
///
/// Generates copyWith(), lerp(), debugFillProperties(), and props.
library;

import '../models/annotation_config.dart';
import '../models/field_model.dart';
import '../resolvers/diagnostic_resolver.dart';
import '../resolvers/lerp_resolver.dart';

/// Builds the _$XSpecMethods mixin for a Spec class.
class SpecMixinBuilder {
  final String specName;
  final List<FieldModel> fields;
  final MixableSpecAnnotationConfig config;

  const SpecMixinBuilder({
    required this.specName,
    required this.fields,
    required this.config,
  });

  String _buildAbstractGetters() {
    if (fields.isEmpty) return '';

    final buffer = StringBuffer();
    for (final field in fields) {
      buffer.writeln('  ${field.effectiveSpecType} get ${field.name};');
    }
    buffer.writeln();

    return buffer.toString();
  }

  String _buildCopyWith() {
    final buffer = StringBuffer();

    buffer.writeln('  @override');
    buffer.writeln('  $specName copyWith({');

    // Parameters
    for (final field in fields) {
      buffer.writeln('    ${field.effectiveSpecType} ${field.name},');
    }

    buffer.writeln('  }) {');
    buffer.writeln('    return $specName(');

    // Field assignments
    for (final field in fields) {
      buffer.writeln(
        '      ${field.name}: ${field.name} ?? this.${field.name},',
      );
    }

    buffer.writeln('    );');
    buffer.writeln('  }');

    return buffer.toString();
  }

  String _buildLerp() {
    final buffer = StringBuffer();

    buffer.writeln('  @override');
    buffer.writeln('  $specName lerp($specName? other, double t) {');
    buffer.writeln('    return $specName(');

    // Field lerp assignments
    for (final field in fields) {
      final lerpCode = lerpResolver.generateLerpCode(field);
      buffer.writeln('      ${field.name}: $lerpCode,');
    }

    buffer.writeln('    );');
    buffer.writeln('  }');

    return buffer.toString();
  }

  String _buildDebugFillProperties() {
    final buffer = StringBuffer();

    buffer.writeln('  @override');
    buffer.writeln(
      '  void debugFillProperties(DiagnosticPropertiesBuilder properties) {',
    );
    buffer.writeln('    super.debugFillProperties(properties);');

    if (fields.isNotEmpty) {
      buffer.writeln('    properties');

      for (int i = 0; i < fields.length; i++) {
        final field = fields[i];
        final diagnosticCode = diagnosticResolver.generateSpecDiagnosticCode(
          field,
        );
        final separator = i == fields.length - 1 ? ';' : '';
        buffer.writeln('      ..add($diagnosticCode)$separator');
      }
    }

    buffer.writeln('  }');

    return buffer.toString();
  }

  String _buildProps() {
    final buffer = StringBuffer();

    buffer.writeln('  @override');
    buffer.write('  List<Object?> get props => [');

    if (fields.isEmpty) {
      buffer.writeln('];');
    } else {
      final fieldNames = fields.map((f) => f.name).join(', ');
      buffer.writeln('$fieldNames];');
    }

    return buffer.toString();
  }

  /// The mixin name.
  String get mixinName => '_\$${specName}Methods';

  /// Builds the complete mixin code.
  String build() {
    final buffer = StringBuffer();

    buffer.writeln('mixin $mixinName on Spec<$specName>, Diagnosticable {');

    // Generate abstract getters
    buffer.writeln(_buildAbstractGetters());

    // Generate copyWith (controlled by GeneratedSpecMethods.copyWith)
    if (config.generateCopyWith) {
      buffer.writeln(_buildCopyWith());
    }

    // Generate lerp (controlled by GeneratedSpecMethods.lerp)
    if (config.generateLerp) {
      buffer.writeln(_buildLerp());
    }

    // Generate debugFillProperties (always generated for diagnostics)
    buffer.writeln(_buildDebugFillProperties());

    // Generate props (controlled by GeneratedSpecMethods.equals)
    if (config.generateEquals) {
      buffer.writeln(_buildProps());
    }

    buffer.writeln('}');

    return buffer.toString();
  }
}
