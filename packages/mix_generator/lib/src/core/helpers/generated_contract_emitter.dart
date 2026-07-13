/// Shared emitters for generated value and diagnostic contracts.
library;

/// Emits the Equatable-compatible value surface for [concreteType].
String buildEquatableSurface(String concreteType) {
  final buffer = StringBuffer();

  buffer.writeln('  @override');
  buffer.writeln('  bool operator ==(Object other) {');
  buffer.writeln('    return identical(this, other) ||');
  buffer.writeln('        other is $concreteType &&');
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

/// Emits Diagnosticable's concrete surface for generated implementing mixins.
String buildDiagnosticableSurface() {
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
