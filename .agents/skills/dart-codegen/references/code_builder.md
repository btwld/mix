# code_builder Patterns

## Core specs
`Class`, `Method`, `Field`, `Constructor`, `Parameter`, `Mixin`, `Extension`, `ExtensionType`, `Enum`, `Library`, `Directive`, `TypeDef`, `Reference`, `TypeReference`, `FunctionType`, `RecordType`, `Code`.

Every spec uses a builder closure:
```dart
final c = Class((b) => b
  ..name = 'UserImpl'
  ..extend = refer('User', 'package:m/user.dart')
  ..implements.add(refer('Serializable'))
  ..fields.add(Field((f) => f
    ..name = 'id'
    ..modifier = FieldModifier.final$
    ..type = refer('String')))
  ..constructors.add(Constructor((c) => c
    ..constant = true
    ..requiredParameters.add(Parameter((p) => p
      ..name = 'id'
      ..toThis = true))))  // → this.id
  ..methods.add(Method((m) => m
    ..name = 'toJson'
    ..returns = TypeReference((b) => b
      ..symbol = 'Map'
      ..types.addAll([refer('String'), refer('dynamic')]))
    ..body = Code("return {'id': id};"))));
```

## Class modifiers (Dart 3)
```dart
Class((b) => b..modifier = ClassModifier.sealed);
// Values: sealed, base, interface, final$, mixin
```

## refer vs TypeReference
- `refer(symbol, [url])` — simplest, use for non-generic types.
- `TypeReference((b) => b..symbol = ...)` — needed for generics, nullability, or bounds.
- Every Reference **is** an Expression, so chaining works: `refer('Foo').newInstance([]).property('bar')`.

## Expression API
```dart
refer('print').call([literalString('hi')])          // print('hi')
refer('Foo', url).newInstance([], {'x': literalNum(1)})  // Foo(x: 1)
refer('Foo').constInstance([])                      // const Foo()
expr.property('name').assign(literalString('x'))    // obj.name = 'x'
expr.nullSafeProperty('foo')                        // obj?.foo
expr.asA(refer('int'))                              // obj as int
expr.isA(refer('int'))                              // obj is int
expr.equalTo(other) / .and(other) / .or(other)
expr.conditional(whenTrue, whenFalse)               // cond ? a : b
expr.returned / .awaited / .thrown / .spread / .nullChecked
expr.statement                                      // expr; (adds semicolon)
expr.code                                           // as Code
declareVar('x').assign(expr)  declareFinal('x')  declareConst('x')
```

Literals: `literalString`, `literalNum`, `literalBool`, `literalNull`, `literalList`, `literalConstList`, `literalMap`, `literalConstMap`, `literalRecord`.

## Code.scope for lazy imports
When writing raw Code that references types, use Code.scope so the emitter resolves and prefixes imports:
```dart
final body = Code.scope((allocate) =>
  'return ${allocate(refer('JsonEncoder', 'dart:convert'))}().convert(data);');
```

## Emitting — always use DartEmitter.scoped
```dart
final library = Library((b) => b
  ..comments.add('GENERATED — DO NOT EDIT')
  ..ignoreForFile.addAll(['unused_element', 'require_trailing_commas'])
  ..body.addAll([myClass, myExtension]));

final emitter = DartEmitter.scoped(
  orderDirectives: true,
  useNullSafetySyntax: true,
);
final raw = library.accept(emitter).toString();

final formatted = DartFormatter(
  languageVersion: DartFormatter.latestLanguageVersion,
).format(raw);
```

`DartEmitter.scoped()` uses `Allocator.simplePrefixing()` which auto-imports with unique prefixes (`_i1`, `_i2`). Never hand-write `import` directives when using scoped emitter — it does it.

## When NOT to use code_builder
If your output is mostly boilerplate with small interpolations (freezed, json_serializable do this), string templates are easier to read and faster to write. Still run through `DartFormatter` at the end. Code_builder shines when imports are complex or output structure is highly dynamic (auto_route, injectable).
