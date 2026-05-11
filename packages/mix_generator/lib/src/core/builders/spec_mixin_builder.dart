/// Spec mixin builder for generating the `_$XSpec` mixin.
///
/// The mixin is self-contained: user code writes `class BoxSpec with
/// _$BoxSpec { ... }` — one keyword. `implements Spec<$specName>,
/// Diagnosticable` brings in the full `Equatable` + `Diagnosticable`
/// contracts (since `Spec<T> with Equatable` on the base class). Because
/// `implements` doesn't carry over concrete bodies, the generator inlines
/// them — `==`, `hashCode`, `stringify`, `getDiff`, `toStringShort`,
/// `toString({minLevel})`, `toDiagnosticsNode`, `debugFillProperties` —
/// using `propsEquals` / `propsHash` / `propsDiff` helpers from
/// `mix/src/core/equatable.dart` for the deep-collection logic.
///
/// This matches dart_mappable's pattern: one generated mixin per type,
/// no user-visible Equatable/Diagnosticable ceremony.
library;

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

  /// Emits `debugFillProperties` without a `super` call — the mixin
  /// `implements Diagnosticable` rather than extending it, so there is no
  /// parent `debugFillProperties` to delegate to.
  String _buildDebugFillProperties() {
    return _fieldEmitter().debugFillProperties(
      callSuper: false,
      propertyCode: generateSpecDiagnosticCode,
    );
  }

  String _buildProps() {
    final buffer = StringBuffer();

    // `@override` — `Spec<T> with Equatable` declares `props` abstractly,
    // so this concrete body overrides the inherited contract.
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

  /// Inlines the full `Equatable` surface: `==`, `hashCode`, `stringify`,
  /// and `getDiff`. The base `Spec<T>` mixes in `Equatable`, so
  /// `implements Spec<$specName>` pulls the interface contract in.
  /// Concrete bodies are emitted here because `implements` doesn't carry
  /// over `Equatable`'s concrete bodies. `propsEquals` / `propsHash` /
  /// `propsDiff` live in `mix/src/core/equatable.dart`.
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

  /// Emits the Diagnosticable-compatible surface required by the generated
  /// mixin without requiring the applying class to extend Diagnosticable.
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

  /// The mixin name — matches dart_mappable's `{ClassName}Mappable`
  /// convention in spirit: `_$BoxSpec`, one generated identifier per spec.
  String get mixinName => '_\$$specName';

  /// Builds the complete mixin code.
  ///
  /// User-facing shape: `final class BoxSpec with _$BoxSpec { ... }`.
  /// The generated mixin is self-contained — it implements `Spec<X>` and
  /// `Diagnosticable`, inlines `==`/`hashCode`/`toString`, and declares
  /// abstract field getters that the user class satisfies via
  /// `@override final` fields.
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

    // `props`, `==`, and `hashCode` travel together under the same flag
    // (`GeneratedSpecMethods.equals`). Emit all three or none.
    if (config.generateEquals) {
      buffer.writeln(_buildProps());
      buffer.writeln(_buildEquatableSurface());
    }

    buffer.writeln(_buildDiagnosticableSurface());
    buffer.writeln(_buildDebugFillProperties());

    buffer.writeln('}');

    return buffer.toString();
  }
}
