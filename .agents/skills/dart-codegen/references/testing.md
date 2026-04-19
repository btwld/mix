# Testing Generators

## Dependencies
```yaml
dev_dependencies:
  build_test: ^2.2.0
  test: ^1.25.0
```

## Basic testBuilder
```dart
import 'package:build_test/build_test.dart';
import 'package:test/test.dart';
import 'package:my_gen/builder.dart';

void main() {
  test('generates for @MyAnnotation', () async {
    await testBuilder(
      myGen(BuilderOptions.empty),
      {
        'my_pkg|lib/model.dart': '''
          import 'package:my_annotation/my_annotation.dart';
          @MyAnnotation()
          class User { final String name; User(this.name); }
        ''',
        // Stub the annotation package so the analyzer can resolve it:
        'my_annotation|lib/my_annotation.dart': '''
          class MyAnnotation { const MyAnnotation(); }
        ''',
      },
      outputs: {
        'my_pkg|lib/model.my_gen.g.part': contains('class _\$UserImpl'),
      },
    );
  });
}
```

## Using real package sources
When your generator depends on real annotation packages:
```dart
final readerWriter = TestReaderWriter(rootPackage: 'my_pkg');
await readerWriter.testing.loadIsolateSources();  // loads real pub cache
await testBuilder(myGen(BuilderOptions.empty), sources, readerWriter: readerWriter);
```

## Error-path tests

Errors thrown by generators (like `InvalidGenerationSource`) are **caught by source_gen and reported as severe log entries**, not re-thrown. So `throwsA(isA<InvalidGenerationSource>())` will NOT match. Capture the log stream instead:

```dart
test('rejects annotation on function', () async {
  final logs = <LogRecord>[];
  await testBuilder(
    myGen(BuilderOptions.empty),
    {
      'my_pkg|lib/bad.dart': '''
        import 'package:my_annotation/my_annotation.dart';
        @MyAnnotation() void foo() {}
      ''',
    },
    onLog: logs.add,
  );
  expect(
    logs.where((r) => r.level == Level.SEVERE).map((r) => r.message).join(),
    contains('only applies to classes'),
  );
});
```

Import: `import 'package:logging/logging.dart';` for `LogRecord` and `Level`.

`throwsA` only works when the builder factory itself throws synchronously — e.g., validation of `BuilderOptions.config`:

```dart
expect(
  () => myGen(BuilderOptions({'bad_option': 42})),
  throwsA(isA<ArgumentError>()),
);
```

## Resolver-only tests (no builder)
For testing element-inspection helpers directly:
```dart
final resolver = await resolveSource(
  '''
  library test;
  class Foo { final int x = 0; }
  ''',
  (r) async => r,
);
final lib = await resolver.findLibraryByName('test');
```

## Golden files
The `generator_test` package compares output to `.golden` files:
```dart
import 'package:generator_test/generator_test.dart';

void main() {
  test('golden', () async {
    final src = SourceGenerator.fromBuilder(
      myGen(BuilderOptions.empty),
      inputs: ['test/fixtures/input.dart'],
      goldens: ['test/fixtures/input.golden'],
    );
    await src.test();
  });
}
```

## What to cover
At minimum:
1. **Happy path** — common annotation → correct output.
2. **Missing required field** — annotation missing a required param.
3. **Wrong element kind** — annotation on something unsupported.
4. **Generics** — class with type parameters if relevant.
5. **Cross-file** — input imports another library whose types must resolve.
6. **Nullable / non-nullable** — if type analysis matters.

## Running the full pipeline
In the example package:
```
dart run build_runner test
dart run build_runner build --delete-conflicting-outputs
```
The `test` command exposes generated files to the test runner.
