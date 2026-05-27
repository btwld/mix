library;

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

class SpecStylerClassBuilder {
  final ClassElement specElement;
  final String specName;
  final ConstantReader annotation;
  final BuildStep buildStep;

  const SpecStylerClassBuilder({
    required this.specElement,
    required this.specName,
    required this.annotation,
    required this.buildStep,
  });

  String get stylerName => specName.endsWith('Spec')
      ? '${specName.substring(0, specName.length - 4)}Styler'
      : '${specName}Styler';

  String build() {
    final buffer = StringBuffer();
    buffer.writeln(
      'class $stylerName extends MixStyler<$stylerName, $specName> {',
    );
    buffer.writeln('}');

    return buffer.toString();
  }
}
