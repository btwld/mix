import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/file_system/overlay_file_system.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:test/test.dart';

const _builders = [
  'PressableBoxBuilder',
  'PressableTextBuilder',
  'PressableIconBuilder',
  'PressableImageBuilder',
  'PressableChildrenBuilder',
];

void main() {
  final mixRoot =
      [
            Directory('${Directory.current.path}/../mix'),
            Directory('${Directory.current.path}/packages/mix'),
          ]
          .firstWhere((directory) => directory.existsSync())
          .resolveSymbolicLinksSync();
  final resources = OverlayResourceProvider(PhysicalResourceProvider.INSTANCE);
  final fixturePath = '$mixRoot/test/pressable_terminal_contract_fixture.dart';
  final lines = <String>["import 'package:mix/mix.dart';", 'void main() {'];
  final expectedErrors = <int, String>{};
  void negative(String source, String code) {
    lines.add(source);
    expectedErrors[lines.length] = code;
  }

  for (final styler in [
    'BoxStyler',
    'TextStyler',
    'IconStyler',
    'ImageStyler',
    'FlexBoxStyler',
    'StackBoxStyler',
    'WrapBoxStyler',
    'GridBoxStyler',
  ]) {
    final variable = styler[0].toLowerCase() + styler.substring(1);
    lines.add('final $variable = $styler().pressable();');
    negative('$variable.pressable();', 'undefined_method');
    negative('$variable.padding(null);', 'undefined_method');
    final positional = styler == 'TextStyler' ? "'Label', " : '';
    negative(
      '$variable(${positional}style: $styler());',
      'undefined_named_parameter',
    );
    lines.add('$variable($positional);');
    // Preserve ordinary styler calls. GridBoxStyler intentionally has no call().
    if (styler != 'GridBoxStyler') lines.add('$styler()($positional);');
  }
  for (final styler in ['FlexStyler', 'StackStyler', 'WrapStyler']) {
    negative('$styler().pressable();', 'undefined_method');
  }
  lines.add('GridBox(style: GridBoxStyler(), children: const []);');
  lines.add('}');
  resources.setOverlay(
    fixturePath,
    content: lines.join('\n'),
    modificationStamp: 1,
  );
  late AnalysisContextCollection collection;
  setUpAll(() {
    collection = AnalysisContextCollection(
      includedPaths: [mixRoot],
      resourceProvider: resources,
    );
  });
  tearDownAll(() async => collection.dispose());

  Future<ResolvedUnitResult> resolve(String path) async {
    final result = await collection
        .contextFor(path)
        .currentSession
        .getResolvedUnit(path);
    expect(result, isA<ResolvedUnitResult>());
    return result as ResolvedUnitResult;
  }

  test(
    'every builder preserves resolved Pressable types and defaults',
    () async {
      final pressable = await resolve(
        '$mixRoot/lib/src/specs/pressable/pressable_widget.dart',
      );
      final builders = await resolve(
        '$mixRoot/lib/src/specs/pressable/pressable_builders.dart',
      );
      final constructor = pressable.unit.declarations
          .whereType<ClassDeclaration>()
          .singleWhere((item) => item.name.lexeme == 'Pressable')
          .members
          .whereType<ConstructorDeclaration>()
          .single
          .declaredFragment!
          .element;
      final expected = {
        for (final parameter in constructor.formalParameters)
          if (parameter.name != 'child') parameter.name!: parameter,
      };
      for (final name in _builders) {
        final call =
            builders.unit.declarations
                    .whereType<ClassDeclaration>()
                    .singleWhere((item) => item.name.lexeme == name)
                    .members
                    .whereType<MethodDeclaration>()
                    .singleWhere((method) => method.name.lexeme == 'call')
                    .declaredFragment!
                    .element
                as MethodElement;
        final actual = {
          for (final parameter in call.formalParameters)
            parameter.name!: parameter,
        };
        for (final entry in expected.entries) {
          final parameter = actual[entry.key];
          expect(
            parameter,
            isNotNull,
            reason: '$name.call is missing ${entry.key}',
          );
          expect(
            parameter!.type,
            entry.value.type,
            reason: '$name.${entry.key} type',
          );
          expect(
            parameter.isNamed,
            entry.value.isNamed,
            reason: '$name.${entry.key} named',
          );
          expect(
            parameter.isRequired,
            entry.value.isRequired,
            reason: '$name.${entry.key} required',
          );
          expect(
            parameter.computeConstantValue(),
            entry.value.computeConstantValue(),
            reason: '$name.${entry.key} default',
          );
        }
      }
    },
  );

  test(
    'terminal builders reject styling, repeated conversion and overrides',
    () async {
      final result = await resolve(fixturePath);
      final actual = <int, String>{};
      for (final error in result.errors) {
        if (error.errorCode.errorSeverity.name != 'ERROR') continue;
        final line = result.lineInfo.getLocation(error.offset).lineNumber;
        expect(
          actual.containsKey(line),
          isFalse,
          reason: 'Unexpected extra diagnostic: $error',
        );
        actual[line] = error.errorCode.name.toLowerCase();
      }
      expect(
        actual,
        expectedErrors,
        reason:
            'Only the exact invalid calls should fail; ordinary styler and builder calls must compile.',
      );
    },
  );

  test(
    'checked-in generation applies each private hook and exports builders',
    () async {
      const hooks = <String, String>{
        'box': 'Box',
        'text': 'Text',
        'icon': 'Icon',
        'image': 'Image',
        'flexbox': 'FlexBox',
        'stackbox': 'StackBox',
        'wrapbox': 'WrapBox',
      };
      for (final entry in hooks.entries) {
        final path =
            '$mixRoot/lib/src/specs/${entry.key}/${entry.key}_spec.dart';
        final source = File(path).readAsStringSync();
        final hook = '_${entry.value}StylerPressableMixin';
        expect(source, contains('extraStylerMixins: [$hook]'));
        final generated = File(
          path.replaceFirst('.dart', '.g.dart'),
        ).readAsStringSync();
        expect(generated, contains('$hook<${entry.value}Styler>'));
      }
      expect(
        File('$mixRoot/lib/mix.dart').readAsStringSync(),
        contains("export 'src/specs/pressable/pressable_builders.dart'"),
      );
    },
  );
}
