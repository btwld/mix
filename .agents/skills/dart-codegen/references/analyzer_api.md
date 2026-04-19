# Analyzer API: Element, DartType, ConstantReader, TypeChecker

## Version note
source_gen 3.0+ uses the analyzer `element2` APIs. The old `enclosingElement` / `enclosingElement2` / `enclosingElement3` chain was consolidated. Pin analyzer versions carefully — minor releases break APIs.

## Walking the element tree
```dart
LibraryElement lib = await step.inputLibrary;
for (final c in lib.classes) {            // ClassElement
  for (final f in c.fields) { ... }        // FieldElement
  for (final m in c.methods) { ... }       // MethodElement
  for (final ctor in c.constructors) { ... }
}
lib.enums; lib.mixins; lib.extensions; lib.extensionTypes;
lib.topLevelFunctions; lib.topLevelVariables;
```

Key ClassElement getters: `fields`, `methods`, `constructors`, `interfaces` (InterfaceType list), `supertype`, `mixins`, `allSupertypes`, `typeParameters`, `isAbstract`, `isFinal`, `isSealed`.

Key FieldElement getters: `type` (DartType), `isFinal`, `isConst`, `isStatic`, `isLate`, `hasInitializer`, `computeConstantValue()`.

Key MethodElement getters: `parameters`, `returnType`, `typeParameters`, `isStatic`, `isAbstract`, `isOperator`.

## TypeChecker
Match types at build time.
```dart
const _myAnnotation = TypeChecker.fromUrl(
  'package:my_pkg/annotation.dart#MyAnnotation',
);
// dart:core type:
const _listChecker = TypeChecker.fromUrl('dart:core#List');

// Methods:
_myAnnotation.isExactly(element);             // exact class match
_myAnnotation.isAssignableFrom(element);      // includes subtypes
_myAnnotation.isExactlyType(dartType);
_myAnnotation.isAssignableFromType(dartType);
_myAnnotation.hasAnnotationOf(element);
_myAnnotation.firstAnnotationOf(element);     // → DartObject?
_myAnnotation.annotationsOf(element);         // → Iterable<DartObject>
```

**Do not use `TypeChecker.fromRuntime`** — removed in source_gen 4.0. Always `fromUrl`.

## ConstantReader (reading annotation values)
`GeneratorForAnnotation.generateForAnnotatedElement` gives you a `ConstantReader annotation`.

```dart
// Required field — throws if missing/wrong type:
final name = annotation.read('name').stringValue;

// Optional field — null if missing:
final timeout = annotation.peek('timeout')?.intValue ?? 30;

// Types supported:
reader.boolValue / .intValue / .doubleValue / .stringValue
reader.listValue / .setValue / .mapValue
reader.typeValue     // DartType for `Type` fields
reader.objectValue   // DartObject for anything else
reader.isNull / .isBool / .isInt / .isString / .isList / .isMap
reader.instanceOf(typeChecker);   // check the annotation's type
reader.revive();     // Revivable: source URI + accessor for recreating const
```

## GeneratorForAnnotation skeleton
```dart
class MyGenerator extends GeneratorForAnnotation<MyAnnotation> {
  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep step,
  ) {
    if (element is! ClassElement) {
      throw InvalidGenerationSource(
        '@MyAnnotation only applies to classes.',
        element: element,
      );
    }
    // ... build output with code_builder ...
    return DartFormatter(
      languageVersion: DartFormatter.latestLanguageVersion,
    ).format(output);
  }
}

Builder myGen(BuilderOptions o) =>
    SharedPartBuilder([MyGenerator()], 'my_gen');
```

Return `''` or `null` to skip without emitting. Throw `InvalidGenerationSource(msg, element: el, node: astNode)` for user-facing errors.

## DartType → code_builder Reference (the bridge)
You must carry the import URI or code_builder won't add the import.

```dart
Reference typeRef(DartType t) {
  if (t is InterfaceType) {
    final uri = t.element.library.source.uri.toString();
    final nullable = t.nullabilitySuffix == NullabilitySuffix.question;
    if (t.typeArguments.isEmpty) {
      return TypeReference((b) => b
        ..symbol = t.element.name
        ..url = uri
        ..isNullable = nullable);
    }
    return TypeReference((b) => b
      ..symbol = t.element.name
      ..url = uri
      ..isNullable = nullable
      ..types.addAll(t.typeArguments.map(typeRef)));
  }
  if (t is TypeParameterType) {
    return refer(t.element.name); // no url for T, U, etc.
  }
  if (t is FunctionType) {
    // NAME CONFLICT: `FunctionType` exists in BOTH analyzer AND code_builder.
    // Alias one import: `import 'package:code_builder/code_builder.dart' as cb;`
    // then use `cb.FunctionType(...)` below. Or import analyzer's as aliased.
    return cb.FunctionType((b) => b
      ..returnType = typeRef(t.returnType)
      ..requiredParameters.addAll(t.parameters
          .where((p) => p.isRequiredPositional)
          .map((p) => typeRef(p.type))));
  }
  if (t is DynamicType) return refer('dynamic');
  if (t.isDartCoreNull) return refer('Null');
  return refer(t.getDisplayString());
}
```

## Generics handling
`ClassElement.typeParameters` is `List<TypeParameterElement>`. Each has `name` (e.g. `'T'`) and `bound` (`DartType?`, e.g. `num` in `T extends num`). Use `InterfaceType.typeArguments` to get concrete types.

## Getting the AssetId for an element
```dart
final id = await step.resolver.assetIdForElement(element);
```
Useful when you need to know which file an imported type came from.
