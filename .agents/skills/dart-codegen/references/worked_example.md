# Worked Example: A Minimal Complete Generator

A full working scaffold for `@AutoToString` — generates `toString()` for annotated classes. Use this as a template when starting a new generator. Covers: two-package layout, build.yaml, SharedPartBuilder, GeneratorForAnnotation, code_builder output, one test.

## Directory layout
```
auto_to_string/
├── auto_to_string_annotation/
│   ├── lib/
│   │   └── auto_to_string_annotation.dart
│   └── pubspec.yaml
├── auto_to_string_generator/
│   ├── lib/
│   │   ├── builder.dart
│   │   └── src/
│   │       └── auto_to_string_generator.dart
│   ├── test/
│   │   └── generator_test.dart
│   ├── build.yaml
│   └── pubspec.yaml
└── example/
    ├── lib/
    │   └── user.dart
    └── pubspec.yaml
```

## auto_to_string_annotation/pubspec.yaml
```yaml
name: auto_to_string_annotation
version: 0.1.0
environment: { sdk: ^3.4.0 }
```

## auto_to_string_annotation/lib/auto_to_string_annotation.dart
```dart
class AutoToString {
  final bool includePrivate;
  const AutoToString({this.includePrivate = false});
}
```

## auto_to_string_generator/pubspec.yaml
```yaml
name: auto_to_string_generator
version: 0.1.0
environment: { sdk: ^3.4.0 }
dependencies:
  auto_to_string_annotation: ^0.1.0
  analyzer: '>=6.0.0 <9.0.0'
  build: ^2.4.0
  source_gen: ^2.0.0
  code_builder: ^4.10.0
  dart_style: ^3.0.0
dev_dependencies:
  build_runner: ^2.4.0
  build_test: ^2.2.0
  test: ^1.25.0
```

## auto_to_string_generator/build.yaml
```yaml
builders:
  auto_to_string:
    import: "package:auto_to_string_generator/builder.dart"
    builder_factories: ["autoToStringBuilder"]
    build_extensions: {".dart": [".auto_to_string.g.part"]}
    auto_apply: dependents
    build_to: cache
    applies_builders: ["source_gen|combining_builder"]
```

## auto_to_string_generator/lib/builder.dart
```dart
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'src/auto_to_string_generator.dart';

Builder autoToStringBuilder(BuilderOptions options) =>
    SharedPartBuilder([AutoToStringGenerator()], 'auto_to_string');
```

## auto_to_string_generator/lib/src/auto_to_string_generator.dart
```dart
import 'package:analyzer/dart/element/element.dart';
import 'package:auto_to_string_annotation/auto_to_string_annotation.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:source_gen/source_gen.dart';

class AutoToStringGenerator extends GeneratorForAnnotation<AutoToString> {
  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep step,
  ) {
    if (element is! ClassElement) {
      throw InvalidGenerationSource(
        '@AutoToString only applies to classes.',
        element: element,
      );
    }
    final includePrivate = annotation.read('includePrivate').boolValue;
    final fields = element.fields.where((f) {
      if (f.isStatic) return false;
      if (f.isSynthetic) return false;
      if (!includePrivate && f.name.startsWith('_')) return false;
      return true;
    }).toList();

    // Build: name: ${self.name}, age: ${self.age}
    final parts = fields
        .map((f) => '${f.name}: \${self.${f.name}}')
        .join(', ');
    final body = "return '${element.name}($parts)';";

    // Emit a top-level helper: String _$UserToString(User self) { ... }
    // The user writes: @override String toString() => _$UserToString(this);
    // (Extensions can't override Object.toString — instance methods always win.)
    final fn = Method((m) => m
      ..name = '_\$${element.name}ToString'
      ..returns = refer('String')
      ..requiredParameters.add(Parameter((p) => p
        ..name = 'self'
        ..type = refer(element.name)))
      ..body = Code(body));

    final source = fn.accept(DartEmitter.scoped(
      useNullSafetySyntax: true,
    )).toString();
    return DartFormatter(
      languageVersion: DartFormatter.latestLanguageVersion,
    ).format(source);
  }
}
```

## auto_to_string_generator/test/generator_test.dart
```dart
import 'package:auto_to_string_generator/builder.dart';
import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:logging/logging.dart';
import 'package:test/test.dart';

void main() {
  test('generates toString for public fields', () async {
    await testBuilder(
      autoToStringBuilder(BuilderOptions.empty),
      {
        'auto_to_string_annotation|lib/auto_to_string_annotation.dart': '''
          class AutoToString {
            final bool includePrivate;
            const AutoToString({this.includePrivate = false});
          }
        ''',
        'pkg|lib/user.dart': '''
          import 'package:auto_to_string_annotation/auto_to_string_annotation.dart';
          part 'user.g.dart';
          @AutoToString()
          class User {
            final String name;
            final int age;
            User(this.name, this.age);
          }
        ''',
      },
      outputs: {
        'pkg|lib/user.auto_to_string.g.part':
            allOf([contains('String _\$UserToString(User self)'),
                   contains("name: \${self.name}"),
                   contains("age: \${self.age}")]),
      },
    );
  });

  test('rejects annotation on function', () async {
    final logs = <LogRecord>[];
    await testBuilder(
      autoToStringBuilder(BuilderOptions.empty),
      {
        'auto_to_string_annotation|lib/auto_to_string_annotation.dart': '''
          class AutoToString {
            const AutoToString({bool includePrivate = false});
          }
        ''',
        'pkg|lib/bad.dart': '''
          import 'package:auto_to_string_annotation/auto_to_string_annotation.dart';
          @AutoToString() void foo() {}
        ''',
      },
      onLog: logs.add,
    );
    expect(
      logs.where((r) => r.level == Level.SEVERE).map((r) => r.message).join(),
      contains('only applies to classes'),
    );
  });
}
```

## example/pubspec.yaml
```yaml
name: example
environment: { sdk: ^3.4.0 }
dependencies:
  auto_to_string_annotation:
    path: ../auto_to_string_annotation
dev_dependencies:
  auto_to_string_generator:
    path: ../auto_to_string_generator
  build_runner: ^2.4.0
```

## example/lib/user.dart
```dart
import 'package:auto_to_string_annotation/auto_to_string_annotation.dart';
part 'user.g.dart';

@AutoToString()
class User {
  final String name;
  final int age;
  User(this.name, this.age);

  // User writes this glue — extensions can't override toString.
  @override
  String toString() => _$UserToString(this);
}

void main() {
  print(User('Alice', 30));  // User(name: Alice, age: 30)
}
```

## To run end-to-end
```
cd auto_to_string_generator && dart pub get && dart test
cd ../example && dart pub get
dart run build_runner build --delete-conflicting-outputs
dart run lib/user.dart
```

## Extending this template
- **Change `@AutoToString` to your annotation**: rename the annotation class, the `TypeChecker` URL, the `partId` in SharedPartBuilder, the `.auto_to_string.g.part` extension in build.yaml.
- **Switch to PartBuilder** (dedicated `.foo.dart` file): replace `SharedPartBuilder` with `PartBuilder`, drop `applies_builders`, change `build_extensions` to the custom extension, and in the user's source they write `part 'user.foo.dart';` instead of `part 'user.g.dart';`.
- **Switch to aggregation**: see `dependencies.md` — two-builder pattern with `.intermediate.json` in cache and a root-only aggregator.
