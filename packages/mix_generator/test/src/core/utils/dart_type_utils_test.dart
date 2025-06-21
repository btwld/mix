// // test/src/core/utils/dart_type_utils_test.dart
// import 'package:analyzer/dart/element/type.dart';
// import 'package:mix_generator/src/core/utils/dart_type_utils.dart';
// import 'package:mix_generator/src/core/utils/extensions.dart';
// import 'package:test/test.dart';

// import '../../../src/helpers/test_helpers.dart';

void main() {}

// void main() {
//   //----------------------------------------------------------------------------
//   // CORE TYPE UTILITIES TESTS
//   //----------------------------------------------------------------------------
//   group('Core Type Utilities', () {
//     test('resolveTypeToClass handles interface types', () async {
//       final library = await resolveSimpleTestLibrary('''
//         class TestClass {}
//         class TestUser {
//           TestClass field;
//           TestUser(this.field);
//         }
//       ''');

//       // Verify classes were resolved correctly
//       final userClass = library.getClass('TestUser');
//       expect(userClass, isNotNull,
//           reason: 'TestUser class not found in resolved library');

//       final fieldElement = userClass!.fields.firstWhere(
//         (f) => f.name == 'field',
//         orElse: () => throw Exception('field not found in TestUser class'),
//       );

//       final fieldType = fieldElement.type;
//       final resolvedClass = TypeUtils.resolveTypeToClass(fieldType);

//       expect(resolvedClass, isNotNull);
//       expect(resolvedClass!.name, equals('TestClass'));
//     });

//     test('resolveTypeToClass handles type parameters with bounds', () async {
//       final library = await resolveSimpleTestLibrary('''
//         class Base {}
//         class TestClass<T extends Base> {
//           T field;
//           TestClass(this.field);
//         }
//       ''');

//       final testClass = library.getClass('TestClass');
//       expect(testClass, isNotNull,
//           reason: 'TestClass class not found in resolved library');

//       final fieldElement = testClass!.fields.firstWhere(
//         (f) => f.name == 'field',
//         orElse: () => throw Exception('field not found in TestClass class'),
//       );

//       final fieldType = fieldElement.type;
//       final resolvedClass = TypeUtils.resolveTypeToClass(fieldType);

//       expect(resolvedClass, isNotNull);
//       expect(resolvedClass!.name, equals('Base'));
//     });

//     test('findSupertype correctly identifies supertype', () async {
//       final library = await resolveSimpleTestLibrary('''
//         class Parent {}
//         class Child extends Parent {}
//       ''');

//       final childClass = library.getClass('Child');
//       expect(childClass, isNotNull,
//           reason: 'Child class not found in resolved library');

//       final supertype = TypeUtils.findSupertype(childClass!, 'Parent');
//       expect(supertype, isNotNull);
//       expect(supertype!.element.name, equals('Parent'));

//       final nonSupertype = TypeUtils.findSupertype(childClass, 'NonExistent');
//       expect(nonSupertype, isNull);
//     });

//     test('getGenericFromSupertype extracts generic type correctly', () async {
//       final library = await resolveSimpleTestLibrary('''
//         class Generic<T> {}
//         class User {}
//         class UserGeneric extends Generic<User> {}
//       ''');

//       final userGenericClass = library.getClass('UserGeneric');
//       expect(userGenericClass, isNotNull,
//           reason: 'UserGeneric class not found in resolved library');

//       final genericType =
//           TypeUtils.getGenericFromSupertype(userGenericClass!, 'Generic');
//       expect(genericType, isNotNull);
//       expect(genericType!.getDisplayString(withNullability: false),
//           equals('User'));
//     });

//     test('resolveGenericType resolves type parameters to bounds', () async {
//       final library = await resolveSimpleTestLibrary('''
//         class Base {}
//         class Child extends Base {}
//         class Container<T extends Base> {
//           T value;
//           Container(this.value);
//         }
//       ''');

//       final containerClass = library.getClass('Container');
//       expect(containerClass, isNotNull,
//           reason: 'Container class not found in resolved library');

//       final valueField = containerClass!.fields.firstWhere(
//         (f) => f.name == 'value',
//         orElse: () =>
//             throw Exception('value field not found in Container class'),
//       );

//       final typeParam = valueField.type as TypeParameterType;
//       final resolvedType = TypeUtils.resolveGenericType(typeParam);

//       expect(resolvedType, isNotNull);
//       expect(resolvedType!.getDisplayString(withNullability: false),
//           equals('Base'));
//     });
//   });

//   //----------------------------------------------------------------------------
//   // DART TYPE EXTENSIONS TESTS
//   //----------------------------------------------------------------------------
//   group('DartType Extensions', () {
//     test('type property checks work correctly', () async {
//       final library = await resolveSimpleTestLibrary('''
//         import 'dart:async';
        
//         class TestClass {
//           String? nullableString;
//           String nonNullableString;
//           List<int> intList;
//           Map<String, bool> stringBoolMap;
//           Set<double> doubleSet;
//           Future<String> futureString;
//           Stream<int> intStream;
          
//           TestClass(this.nonNullableString, this.intList, this.stringBoolMap, 
//                    this.doubleSet, this.futureString, this.intStream);
//         }
//       ''');

//       final testClass = library.getClass('TestClass');
//       expect(testClass, isNotNull,
//           reason: 'TestClass not found in resolved library');

//       final nullableField = testClass!.fields.firstWhere(
//         (f) => f.name == 'nullableString',
//         orElse: () =>
//             throw Exception('nullableString field not found in TestClass'),
//       );

//       final stringField = testClass.fields.firstWhere(
//         (f) => f.name == 'nonNullableString',
//         orElse: () =>
//             throw Exception('nonNullableString field not found in TestClass'),
//       );

//       final listField = testClass.fields.firstWhere(
//         (f) => f.name == 'intList',
//         orElse: () => throw Exception('intList field not found in TestClass'),
//       );

//       final mapField = testClass.fields.firstWhere(
//         (f) => f.name == 'stringBoolMap',
//         orElse: () =>
//             throw Exception('stringBoolMap field not found in TestClass'),
//       );

//       final setField = testClass.fields.firstWhere(
//         (f) => f.name == 'doubleSet',
//         orElse: () => throw Exception('doubleSet field not found in TestClass'),
//       );

//       final futureField = testClass.fields.firstWhere(
//         (f) => f.name == 'futureString',
//         orElse: () =>
//             throw Exception('futureString field not found in TestClass'),
//       );

//       final streamField = testClass.fields.firstWhere(
//         (f) => f.name == 'intStream',
//         orElse: () => throw Exception('intStream field not found in TestClass'),
//       );

//       expect(nullableField.type.isNullable, isTrue);
//       expect(stringField.type.isNullable, isFalse);

//       expect(listField.type.isList, isTrue);
//       expect(listField.type.isMap, isFalse);
//       expect(listField.type.isSet, isFalse);

//       expect(mapField.type.isList, isFalse);
//       expect(mapField.type.isMap, isTrue);
//       expect(mapField.type.isSet, isFalse);

//       expect(setField.type.isList, isFalse);
//       expect(setField.type.isMap, isFalse);
//       expect(setField.type.isSet, isTrue);

//       expect(futureField.type.isFuture, isTrue);
//       expect(futureField.type.isStream, isFalse);

//       expect(streamField.type.isFuture, isFalse);
//       expect(streamField.type.isStream, isTrue);
//     });

//     test('getTypeArguments extracts type arguments correctly', () async {
//       final library = await resolveSimpleTestLibrary('''
//         class TestClass {
//           List<String> stringList = [];
//           Map<int, bool> intBoolMap = {};
//           Set<double> doubleSet = {};
//         }
//       ''');

//       final testClass = library.getClass('TestClass');
//       expect(testClass, isNotNull,
//           reason: 'TestClass not found in resolved library');

//       final listField = testClass!.fields.firstWhere(
//         (f) => f.name == 'stringList',
//       );
//       final mapField = testClass.fields.firstWhere(
//         (f) => f.name == 'intBoolMap',
//       );
//       final setField = testClass.fields.firstWhere(
//         (f) => f.name == 'doubleSet',
//       );

//       // Test list type arguments
//       final listTypeArgs = listField.type.typeArguments;
//       expect(listTypeArgs.length, equals(1));
//       expect(listTypeArgs[0].getDisplayString(withNullability: false),
//           equals('String'));

//       // Test map type arguments
//       final mapTypeArgs = mapField.type.typeArguments;
//       expect(mapTypeArgs.length, equals(2));
//       expect(mapTypeArgs[0].getDisplayString(withNullability: false),
//           equals('int'));
//       expect(mapTypeArgs[1].getDisplayString(withNullability: false),
//           equals('bool'));

//       // Test set type arguments
//       final setTypeArgs = setField.type.typeArguments;
//       expect(setTypeArgs.length, equals(1));
//       expect(setTypeArgs[0].getDisplayString(withNullability: false),
//           equals('double'));
//     });

//     test('handles nested generic types correctly', () async {
//       final library = await resolveSimpleTestLibrary('''
//         class TestClass {
//           List<Map<String, int>> nestedGeneric = [];
//           Future<List<String>> futureList = Future.value([]);
//         }
//       ''');

//       final testClass = library.getClass('TestClass');
//       expect(testClass, isNotNull);

//       final nestedField = testClass!.fields.firstWhere(
//         (f) => f.name == 'nestedGeneric',
//       );
//       final futureListField = testClass.fields.firstWhere(
//         (f) => f.name == 'futureList',
//       );

//       // Test nested generics
//       expect(nestedField.type.isList, isTrue);
//       final listTypeArg = nestedField.type.typeArguments[0];
//       expect(listTypeArg.isMap, isTrue);

//       final mapTypeArgs = listTypeArg.typeArguments;
//       expect(mapTypeArgs.length, equals(2));
//       expect(mapTypeArgs[0].getDisplayString(withNullability: false),
//           equals('String'));
//       expect(mapTypeArgs[1].getDisplayString(withNullability: false),
//           equals('int'));

//       // Test Future with List
//       expect(futureListField.type.isFuture, isTrue);
//       final futureTypeArg = futureListField.type.typeArguments[0];
//       expect(futureTypeArg.isList, isTrue);
//       expect(
//           futureTypeArg.typeArguments[0]
//               .getDisplayString(withNullability: false),
//           equals('String'));
//     });

//     test('handles complex type hierarchies correctly', () async {
//       final library = await resolveSimpleTestLibrary('''
//         abstract class Animal {}
//         class Dog extends Animal {}
//         class Cat extends Animal {}
        
//         class AnimalContainer<T extends Animal> {
//           T animal;
//           AnimalContainer(this.animal);
//         }
        
//         class DogContainer extends AnimalContainer<Dog> {
//           DogContainer(Dog dog) : super(dog);
//         }
//       ''');

//       final dogContainerClass = library.getClass('DogContainer');
//       expect(dogContainerClass, isNotNull);

//       final supertype =
//           TypeUtils.findSupertype(dogContainerClass!, 'AnimalContainer');
//       expect(supertype, isNotNull);

//       final typeArg = TypeUtils.getGenericFromSupertype(
//           dogContainerClass, 'AnimalContainer');
//       expect(typeArg, isNotNull);
//       expect(typeArg!.getDisplayString(withNullability: false), equals('Dog'));

//       // Verify the bound relationship
//       final animalClass = library.getClass('Animal');
//       final dogClass = library.getClass('Dog');

//       expect(dogClass!.supertype!.element, equals(animalClass));
//     });
//   });

//   //----------------------------------------------------------------------------
//   // MIX PACKAGE TYPE TESTS
//   //----------------------------------------------------------------------------
//   group('Mix Package Type Tests', () {
//     test('correctly identifies Dto types from mix_annotations package',
//         () async {
//       final library = await resolveMixTestLibrary('''
//         @Mixable()
//         class UserDto extends Dto<String> {
//           final String name;
//           final int age;
          
//           UserDto(this.name, this.age);
//         }
//       ''');

//       final userDtoClass = library.getClass('UserDto');
//       expect(userDtoClass, isNotNull, reason: 'UserDto class not found');

//       // Check for the Dto annotation
//       final annotations = userDtoClass!.metadata;
//       expect(annotations, isNotEmpty,
//           reason: 'No annotations found on UserDto');

//       final dtoAnnotation = annotations.first;
//       final dtoElement = dtoAnnotation.element;
//       expect(dtoElement, isNotNull, reason: 'Annotation element is null');

//       // Check that the annotation is from the mix_annotations package
//       final enclosingElement = dtoElement!.enclosingElement3!;
//       expect(enclosingElement.name, equals('Mixable'));

//       final source = enclosingElement.source!;
//       expect(source.uri.scheme, equals('package'));
//       expect(source.uri.path, equals('mix_annotations/mix_annotations.dart'));
//     });

//     test('correctly identifies Spec types from mix_annotations package',
//         () async {
//       final library = await resolveMixTestLibrary('''
//         class ColorSpec extends Spec<ColorSpec> {
//           final int red;
//           final int green;
//           final int blue;
          
//           ColorSpec(this.red, this.green, this.blue);
//         }
//       ''');

//       final colorSpecClass = library.getClass('ColorSpec');
//       expect(colorSpecClass, isNotNull, reason: 'ColorSpec class not found');

//       // Check inheritance
//       final specSupertype = TypeUtils.findSupertype(colorSpecClass!, 'Spec');
//       expect(specSupertype, isNotNull,
//           reason: 'Spec supertype not found for ColorSpec');

//       // Verify the supertype is from the mix_annotations package
//       final specElement = specSupertype!.element;
//       final source = specElement.source;
//       expect(source.uri.scheme, equals('package'));
//       expect(source.uri.path, equals('mix/mix.dart'));
//     });

//     test('correctly identifies types from mix package', () async {
//       final library = await resolveMixTestLibrary('''
//         class CustomWidgetModifier extends WidgetModifierSpec {
//           final String value;
          
//           CustomWidgetModifier(this.value);
//         }
//       ''');

//       final modifierClass = library.getClass('CustomWidgetModifier');
//       expect(modifierClass, isNotNull,
//           reason: 'CustomWidgetModifier class not found');

//       // Check inheritance
//       final widgetModifierSupertype =
//           TypeUtils.findSupertype(modifierClass!, 'WidgetModifierSpec');
//       expect(widgetModifierSupertype, isNotNull,
//           reason:
//               'WidgetModifierSpec supertype not found for CustomWidgetModifier');

//       // Verify the supertype is from the mix package
//       final widgetModifierElement = widgetModifierSupertype!.element;
//       final source = widgetModifierElement.source;
//       expect(source.uri.scheme, equals('package'));
//       expect(source.uri.path, equals('mix/mix.dart'));

//       // Check transitive inheritance to Spec from mix_annotations
//       final specSupertype = TypeUtils.findSupertype(modifierClass, 'Spec');
//       expect(specSupertype, isNotNull,
//           reason: 'Spec supertype not found for CustomWidgetModifier');
//     });

//     test('can work with complex type hierarchies across packages', () async {
//       final library = await resolveMixTestLibrary('''
//         // Base classes
//         abstract class Animal {}
//         class Dog extends Animal {}
        
//         // User classes with Mix types
//         @Dto<Dog>()
//         class DogDto {
//           final String name;
//           DogDto(this.name);
//         }
        
//         class AnimalSpec<T extends Animal> extends Spec {
//           final T animal;
//           AnimalSpec(this.animal);
//         }
        
//         class DogSpec extends AnimalSpec<Dog> {
//           DogSpec(Dog dog) : super(dog);
//         }
        
//         class DogModifier extends WidgetModifierSpec {
//           final DogSpec dogSpec;
          
//           DogModifier(this.dogSpec);
//         }
//       ''');

//       final dogDtoClass = library.getClass('DogDto');
//       expect(dogDtoClass, isNotNull, reason: 'DogDto class not found');

//       final dogSpecClass = library.getClass('DogSpec');
//       expect(dogSpecClass, isNotNull, reason: 'DogSpec class not found');

//       final dogModifierClass = library.getClass('DogModifier');
//       expect(dogModifierClass, isNotNull,
//           reason: 'DogModifier class not found');

//       // Check inheritance
//       final animalSpecSupertype =
//           TypeUtils.findSupertype(dogSpecClass!, 'AnimalSpec');
//       expect(animalSpecSupertype, isNotNull,
//           reason: 'AnimalSpec supertype not found for DogSpec');

//       final widgetModifierSupertype =
//           TypeUtils.findSupertype(dogModifierClass!, 'WidgetModifierSpec');
//       expect(widgetModifierSupertype, isNotNull,
//           reason: 'WidgetModifierSpec supertype not found for DogModifier');

//       // Check that WidgetModifierSpec is from mix package
//       final widgetModifierElement = widgetModifierSupertype!.element;
//       final widgetModifierSource = widgetModifierElement.source;
//       expect(widgetModifierSource.uri.scheme, equals('package'));
//       expect(widgetModifierSource.uri.path, equals('mix/mix.dart'));

//       // Check that Spec is from mix_annotations package
//       final specSupertype = TypeUtils.findSupertype(dogSpecClass, 'Spec');
//       expect(specSupertype, isNotNull,
//           reason: 'Spec supertype not found for DogSpec');

//       final specElement = specSupertype!.element;
//       final specSource = specElement.source;
//       expect(specSource.uri.scheme, equals('package'));
//       expect(specSource.uri.path, equals('mix/mix.dart'));
//     });
//   });
// }
