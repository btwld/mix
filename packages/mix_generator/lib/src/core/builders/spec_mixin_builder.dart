import '../models/annotation_config.dart';
import '../models/field_model.dart';
import '../helpers/field_emitter.dart';
import '../resolvers/diagnostic_resolver.dart';
import '../resolvers/lerp_resolver.dart';

/// Builds the `_$XSpec` mixin for a Spec class.
class SpecMixinBuilder {
  final String specName;
  final List<FieldModel> fields;
  final MixableSpecAnnotationConfig config;

  const SpecMixinBuilder({
    required this.specName,
    required this.fields,
    required this.config,
  });

  FieldEmitter<FieldModel> _fieldEmitter() => .new(fields);

  String _buildAbstractGetters() {
    return _fieldEmitter().abstractGetters(
      typeCode: (field) => field.effectiveSpecType,
      getterName: (field) => field.name,
    );
  }

  String _buildCopyWith() {
    final buffer = StringBuffer();

    buffer.writeln('  @override');
    buffer.writeln('  $specName copyWith({');

    for (final field in fields) {
      final type = field.effectiveSpecType;
      final optionalType = type.endsWith('?') ? type : '$type?';
      buffer.writeln('    $optionalType ${field.name},');
    }

    buffer.writeln('  }) {');
    buffer.writeln('    return $specName(');

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

    _fieldEmitter().linesInto(buffer, (field) {
      final lerpCode = generateLerpCode(field);

      return '      ${field.name}: $lerpCode,';
    });

    buffer.writeln('    );');
    buffer.writeln('  }');

    return buffer.toString();
  }

  /// Emits `debugFillProperties` without a `super` call — `implements`
  /// Diagnosticable means there's no parent to delegate to.
  String _buildDebugFillProperties() {
    return _fieldEmitter().debugFillProperties(
      callSuper: false,
      propertyCode: generateSpecDiagnosticCode,
    );
  }

  String _buildProps() {
    final buffer = StringBuffer();

    // `@override`: `Equatable` (mixed into `Spec<T>`) declares `props` abstractly.
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

  String _buildTypeGetter() {
    final buffer = StringBuffer();
    buffer.writeln('  @override');
    buffer.writeln('  Type get type => $specName;');

    return buffer.toString();
  }

  /// Emits `==`, `hashCode`, `stringify`, and `getDiff` overrides that
  /// delegate to `propsEquals`, `propsHash`, and `propsDiff`.
  String _buildEquatableSurface() {
    final buffer = StringBuffer();

    buffer.writeln('  @override');
    buffer.writeln('  bool operator ==(Object other) {');
    buffer.writeln('    return identical(this, other) ||');
    buffer.writeln('        other is $specName &&');
    buffer.writeln('            runtimeType == other.runtimeType &&');
    buffer.writeln('            propsEquals(props, other.props);');
    buffer.writeln('  }');
    buffer.writeln();
    buffer.writeln('  @override');
    buffer.writeln('  int get hashCode => propsHash(runtimeType, props);');
    buffer.writeln();
    buffer.writeln('  @override');
    buffer.writeln('  bool get stringify => true;');
    buffer.writeln();
    buffer.writeln('  @override');
    buffer.writeln('  Map<String, String> getDiff(Equatable other) {');
    buffer.writeln('    if (this == other) return const {};');
    buffer.writeln();
    buffer.writeln('    return propsDiff(props, other.props);');
    buffer.writeln('  }');

    return buffer.toString();
  }

  /// Emits Diagnosticable's concrete bodies — the mixin `implements`
  /// Diagnosticable rather than extending it, so no inheritance covers them.
  String _buildDiagnosticableSurface() {
    final buffer = StringBuffer();

    buffer.writeln('  @override');
    buffer.writeln("  String toStringShort() => '\$runtimeType';");
    buffer.writeln();
    buffer.writeln('  @override');
    buffer.writeln(
      '  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) =>',
    );
    buffer.writeln(
      '      toDiagnosticsNode(style: DiagnosticsTreeStyle.singleLine)',
    );
    buffer.writeln('          .toString(minLevel: minLevel);');
    buffer.writeln();
    buffer.writeln('  @override');
    buffer.writeln(
      '  DiagnosticsNode toDiagnosticsNode({String? name, DiagnosticsTreeStyle? style}) =>',
    );
    buffer.writeln(
      '      DiagnosticableNode<Diagnosticable>(name: name, value: this, style: style);',
    );

    return buffer.toString();
  }

  /// Emits a deprecated typedef from the pre-2.0 mixin name to the
  /// current rich mixin. The new mixin has no `on` constraint, so the
  /// legacy host shape resolves cleanly through the alias.
  ///
  /// `\$` escapes are required: the emitted message lives inside a Dart
  /// string literal in the `.g.dart` file, so a bare `$` would re-trigger
  /// interpolation and fail to resolve (`BoxSpecMethods` is not a symbol).
  String _buildLegacyTypedef() {
    final buffer = StringBuffer();
    buffer.writeln(
      "@Deprecated('Rename to `_\\\$$specName` and migrate the class "
      "declaration to `class $specName with _\\\$$specName`. The "
      "`_\\\$${specName}Methods` alias will be removed in mix_generator 3.0.')",
    );
    // Suppress `unused_element`: callers on the new host shape never
    // reference the alias, so the hint would fire on every spec.
    buffer.writeln(
      'typedef $_legacyMixinName = $mixinName; // ignore: unused_element',
    );

    return buffer.toString();
  }

  /// Pre-2.0 generator name, kept as a deprecated alias so legacy
  /// `class X extends Spec<X> with Diagnosticable, _$XSpecMethods`
  /// declarations keep compiling against the 2.0+ generator.
  String get _legacyMixinName => '_\$${specName}Methods';

  /// The generated mixin name, e.g. `_$BoxSpec`.
  String get mixinName => '_\$$specName';

  /// Builds the full `mixin _$<SpecName> implements Spec<T>, Diagnosticable`
  /// so a `class X with _$X` declaration is a complete Spec.
  String build() {
    final buffer = StringBuffer();

    buffer.writeln(
      'mixin $mixinName implements Spec<$specName>, Diagnosticable {',
    );

    buffer.writeln(_buildAbstractGetters());
    buffer.writeln(_buildTypeGetter());

    if (config.generateCopyWith) {
      buffer.writeln(_buildCopyWith());
    }

    if (config.generateLerp) {
      buffer.writeln(_buildLerp());
    }

    // `props` is opt-out (`skipEquals`); the equality surface always emits.
    if (config.generateProps) {
      buffer.writeln(_buildProps());
    }
    buffer.writeln(_buildEquatableSurface());

    buffer.writeln(_buildDiagnosticableSurface());
    buffer.writeln(_buildDebugFillProperties());

    buffer.writeln('}');
    buffer.writeln();
    buffer.write(_buildLegacyTypedef());

    return buffer.toString();
  }
}
