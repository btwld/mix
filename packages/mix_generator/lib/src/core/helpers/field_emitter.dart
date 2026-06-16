/// Small helpers for repeated field-line emission in generated mixins.
library;

/// Emits common field loops while keeping each builder's field formatting local.
class FieldEmitter<T> {
  final List<T> fields;

  const FieldEmitter(this.fields);

  /// Emits abstract getters for [fields].
  String abstractGetters({
    required String Function(T field) typeCode,
    required String Function(T field) getterName,
  }) {
    if (fields.isEmpty) return '';

    final buffer = StringBuffer();
    for (final field in fields) {
      buffer.writeln('  ${typeCode(field)} get ${getterName(field)};');
    }
    buffer.writeln();

    return buffer.toString();
  }

  /// Emits each field through [lineFor].
  void linesInto(StringBuffer buffer, String Function(T field) lineFor) {
    for (final field in fields) {
      buffer.writeln(lineFor(field));
    }
  }

  /// Emits diagnostic property additions.
  String debugFillProperties({
    required bool callSuper,
    required String Function(T field) propertyCode,
  }) {
    final buffer = StringBuffer();

    buffer.writeln('  @override');
    buffer.writeln(
      '  void debugFillProperties(DiagnosticPropertiesBuilder properties) {',
    );

    if (callSuper) {
      buffer.writeln('    super.debugFillProperties(properties);');
    }

    if (fields.length == 1) {
      buffer.writeln('    properties.add(${propertyCode(fields.single)});');
    } else if (fields.isNotEmpty) {
      buffer.writeln('    properties');

      for (var i = 0; i < fields.length; i++) {
        final separator = i == fields.length - 1 ? ';' : '';
        buffer.writeln('      ..add(${propertyCode(fields[i])})$separator');
      }
    }

    buffer.writeln('  }');

    return buffer.toString();
  }

  /// Emits multiline `props` containing [fields] followed by [trailingProps].
  String multilineProps({
    required String Function(T field) propCode,
    List<String> trailingProps = const [],
  }) {
    final buffer = StringBuffer();

    buffer.writeln('  @override');
    buffer.write('  List<Object?> get props => [');
    buffer.writeln();

    for (final field in fields) {
      buffer.writeln('    ${propCode(field)},');
    }
    for (final prop in trailingProps) {
      buffer.writeln('    $prop,');
    }

    buffer.writeln('  ];');

    return buffer.toString();
  }
}
