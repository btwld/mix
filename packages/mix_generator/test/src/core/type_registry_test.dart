// import 'package:mix_generator/src/core/type_registry.dart';
// import 'package:mix_generator/src/core/utils/dart_type_utils.dart';
// import 'package:test/test.dart';

// import '../helpers/test_helpers.dart';

void main() {}

// void main() {
//   group('TypeRegistry', () {
//     test('handles Spec classes correctly', () async {
//       // Define test code with a Spec class
//       const testCode = '''
//         class TestSpec extends Spec<TestSpec> {
//           final String name;
          
//           const TestSpec({required this.name});
//         }
//       ''';

//       // Resolve the library with our test code
//       final library = await resolveMixTestLibrary(testCode);

//       // Get the TypeRegistry instance
//       final registry = TypeRegistry.instance;

//       // Get the class element and its type
//       final classElement = library.getClass('TestSpec')!;
//       final dartType = classElement.thisType;

//       // Verify the utility is created correctly
//       final utility = registry.getUtilityForType(dartType);
//       expect(utility, isNotNull);
//       expect(utility, equals('TestSpecUtility'));

//       // Verify the representation is created correctly
//       final representation = registry.getResolvableForType(dartType);
//       expect(representation, isNotNull);
//       expect(representation, equals('TestSpecAttribute'));
//     });

//     test('handles Mixable classes correctly', () async {
//       // Define test code with a Mixable class
//       const testCode = '''
//         class ValueType {}
        
//         class TestDto extends Mixable<ValueType> {
//           final String name;
          
//           const TestDto({required this.name});
//         }
//       ''';

//       // Resolve the library with our test code
//       final library = await resolveMixTestLibrary(testCode);

//       // Get the TypeRegistry instance
//       final registry = TypeRegistry.instance;

//       // Pre-register TestDto in the registry for the test
//       registry.registerDiscoveredTypes({'TestDto': 'TestDto'});

//       // Get the class elements and their types
//       final dtoElement = library.getClass('TestDto')!;
//       final dtoDartType = dtoElement.thisType;

//       // Verify the representation for the DTO type
//       final dtoRepresentation = registry.getResolvableForType(dtoDartType);
//       expect(dtoRepresentation, isNotNull);
//       expect(dtoRepresentation, equals('TestDto'));

//       // Verify the DTO type is correctly identified
//       expect(TypeUtils.isResolvable(dtoDartType), isTrue);

//       // Verify utility is available (could be different depending on implementation)
//       final dtoUtility = registry.getUtilityForType(dtoDartType);
//       expect(dtoUtility, isNotNull);
//     });

//     test('removes Dto suffix when getting utility type for DTO classes',
//         () async {
//       // Define test code with a Dto class that has a Dto suffix
//       const testCode = '''
//         class Color {}
        
//         class ColorDto extends Dto<Color> {
//           final int value;
          
//           const ColorDto({required this.value});
//         }
//       ''';

//       // Resolve the library with our test code
//       final library = await resolveMixTestLibrary(testCode);

//       // First, register the ColorDto as a known type in the registry
//       final registry = TypeRegistry.instance;
//       registry.registerDiscoveredTypes({'ColorDto': 'Color'});

//       // Get the class element and its type
//       final dtoElement = library.getClass('ColorDto')!;
//       final dtoDartType = dtoElement.thisType;

//       // Verify the utility for the DTO type has the Dto suffix removed
//       final dtoUtility = registry.getUtilityForType(dtoDartType);
//       expect(dtoUtility, isNotNull);
//       expect(dtoUtility, equals('ColorUtility'));
//     });

//     test('ignoredUtilities contains expected values', () {
//       // Verify that the ignoredUtilities list contains the expected values
//       expect(ignoredUtilities, contains('SpacingSideUtility'));
//       expect(ignoredUtilities, contains('FontFamilyUtility'));
//       expect(ignoredUtilities, contains('GapUtility'));
//       expect(ignoredUtilities, contains('FontSizeUtility'));
//       expect(ignoredUtilities, contains('StrokeAlignUtility'));
//       expect(ignoredUtilities.length, equals(5));
//     });

//     test('getRepresentationForType returns correct representation type',
//         () async {
//       // Define test code with a Spec class
//       const testCode = '''
//         class TestSpec extends Spec<TestSpec> {
//           final String name;
          
//           const TestSpec({required this.name});
//         }
//       ''';

//       // Resolve the library with our test code
//       final library = await resolveMixTestLibrary(testCode);

//       // Get the TypeRegistry instance
//       final registry = TypeRegistry.instance;

//       // Get the class element and its type
//       final classElement = library.getClass('TestSpec')!;
//       final dartType = classElement.thisType;

//       // Verify getRepresentationForType returns the correct type
//       final representationType = registry.getResolvableForType(dartType);
//       expect(representationType, isNotNull);
//       expect(representationType, equals('TestSpecAttribute'));
//     });

//     test('getUtilityForType returns correct utility type', () async {
//       // Define test code with a Spec class
//       const testCode = '''
//         class TestSpec extends Spec<TestSpec> {
//           final String name;
          
//           const TestSpec({required this.name});
//         }
//       ''';

//       // Resolve the library with our test code
//       final library = await resolveMixTestLibrary(testCode);

//       // Get the TypeRegistry instance
//       final registry = TypeRegistry.instance;

//       // Get the class element and its type
//       final classElement = library.getClass('TestSpec')!;
//       final dartType = classElement.thisType;

//       // Verify getUtilityForType returns the correct type
//       final utilityType = registry.getUtilityForType(dartType);
//       expect(utilityType, isNotNull);
//       expect(utilityType, equals('TestSpecUtility'));
//     });

//     test('getUtilityNameFromTypeName handles different input formats', () {
//       final registry = TypeRegistry.instance;

//       // Test with a simple type name
//       expect(
//           registry.getUtilityNameFromTypeName('Color'), equals('ColorUtility'));

//       // Test with a type name that already has Utility suffix
//       expect(registry.getUtilityNameFromTypeName('ColorUtility'),
//           equals('ColorUtility'));

//       // Test with a Dto suffix
//       expect(registry.getUtilityNameFromTypeName('ColorDto'),
//           equals('ColorUtility'));

//       // Test with an Attribute suffix
//       expect(registry.getUtilityNameFromTypeName('ColorAttribute'),
//           equals('ColorUtility'));

//       // Test with lowercase first letter
//       expect(
//           registry.getUtilityNameFromTypeName('color'), equals('ColorUtility'));
//     });

//     test('hasTryToMerge correctly identifies types with tryToMerge method',
//         () async {
//       // Define test code with a DTO class that has a static tryToMerge method

//       // Get the TypeRegistry instance
//       final registry = TypeRegistry.instance;

//       // Add TestDto to the tryToMerge set temporarily for the test
//       final originalTryToMerge = Set<String>.from(tryToMerge);
//       tryToMerge.add('TestDto');

//       try {
//         // Verify hasTryToMerge returns true for TestDto
//         expect(registry.hasTryToMerge('TestDto'), isTrue);

//         // Verify hasTryToMerge returns true for Test (without Dto suffix)
//         expect(registry.hasTryToMerge('Test'), isTrue);

//         // Verify hasTryToMerge returns false for an unrelated type
//         expect(registry.hasTryToMerge('UnrelatedType'), isFalse);
//       } finally {
//         // Restore the original tryToMerge set
//         tryToMerge.clear();
//         tryToMerge.addAll(originalTryToMerge);
//       }
//     });

//     test('handles hardcoded utility mappings', () {
//       // Test a few hardcoded mappings from the utilities map
//       for (final entry in utilities.entries.take(5)) {
//         final utilityName = entry.key;
//         final typeName = entry.value;

//         expect(utilityName.endsWith('Utility'), isTrue,
//             reason: 'Utility name should end with Utility');

//         // For this test, we can't easily create DartType instances,
//         // so we'll just verify the utilities map structure
//         expect(typeName, isNotNull);
//       }
//     });
//   });

//   group('TypeReference', () {
//     test('constructor handles generic types correctly', () {
//       // Test with a simple type name
//       const simpleRef = TypeReference('TestClass');
//       expect(simpleRef.name, equals('TestClass'));

//       // Test with a generic type name
//       const genericRef = TypeReference('List<String>');
//       expect(genericRef.name, equals('List<String>'));

//       // Test with a nested generic type name
//       const nestedGenericRef = TypeReference('Map<String, List<int>>');
//       expect(nestedGenericRef.name, equals('Map<String, List<int>>'));
//     });

//     test('fromType creates TypeReference from DartType', () async {
//       // Define test code with a generic type
//       const testCode = '''
//         class TestClass<T> {
//           List<T> items;
          
//           TestClass(this.items);
//         }
//       ''';

//       // Resolve the library with our test code
//       final library = await resolveSimpleTestLibrary(testCode);

//       // Get the class element
//       final classElement = library.getClass('TestClass')!;

//       // Get the field element and its type
//       final fieldElement = classElement.fields.first;
//       final fieldType = fieldElement.type;

//       // Create TypeReference from the field type
//       final typeRef = TypeReference.fromType(fieldType);

//       // Verify the TypeReference was created correctly
//       expect(typeRef.name, equals('List<T>'));
//       expect(typeRef.type, equals(fieldType));
//     });
//   });
// }

// // Mock defi
