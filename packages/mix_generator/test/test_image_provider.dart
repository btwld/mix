// ignore_for_file: avoid_print

import 'package:analyzer/dart/element/type.dart';
import 'package:mix_generator/src/core/type_registry.dart';
import 'package:mix_generator/src/core/utils/extensions.dart';
import 'package:test/test.dart';

import 'src/helpers/test_helpers.dart';

void main() {
  group('TypeRegistry Utilities Tests', () {
    test('check ImageProvider type string representation', () async {
      // Define test code that uses ImageProvider
      const testCode = '''
        class ImageProvider<T> {}
        
        class TestClass {
          final ImageProvider imageProvider;
          
          const TestClass({required this.imageProvider});
        }
      ''';

      // Resolve the library with our test code
      final library = await resolveMixTestLibrary(testCode);

      // Get the TypeRegistry instance
      final registry = TypeRegistry.instance;

      // Get the class element and the field type
      final classElement = library.getClass('TestClass')!;
      final imageProviderField = classElement.fields.firstWhere(
        (field) => field.name == 'imageProvider',
      );
      final imageProviderType = imageProviderField.type;

      // Get the type string and check what it looks like
      final typeString = imageProviderType.getTypeAsString();
      print('ImageProvider type string: $typeString');

      // Try to find a utility for this type
      final utility = registry.getUtilityForType(imageProviderType);
      print('Utility found: $utility');

      // Check the exact type representation
      print(
          'Display string: ${imageProviderType.getDisplayString(withNullability: false)}');
      print('Is interface type: ${imageProviderType is InterfaceType}');
      if (imageProviderType is InterfaceType) {
        print(
            'Type arguments: ${imageProviderType.typeArguments.map((t) => t.getDisplayString(withNullability: false)).join(', ')}');
      }

      // Check if it's in the utilities map
      var foundInUtilities = false;
      for (final entry in utilities.entries) {
        if (entry.value.contains('ImageProvider')) {
          print('Found in utilities: ${entry.key} -> ${entry.value}');
          foundInUtilities = true;
        }
      }
      if (!foundInUtilities) {
        print('Not found in utilities map');
      }
    });

    test('fallback to GenericUtility for unknown types', () async {
      // Define test code with an unknown type
      const testCode = '''
        class UnknownType {}
        
        class TestClass {
          final UnknownType unknownField;
          
          const TestClass({required this.unknownField});
        }
      ''';

      // Resolve the library with our test code
      final library = await resolveMixTestLibrary(testCode);

      // Get the TypeRegistry instance
      final registry = TypeRegistry.instance;

      // Get the class element and the field type
      final classElement = library.getClass('TestClass')!;
      final unknownField = classElement.fields.firstWhere(
        (field) => field.name == 'unknownField',
      );
      final unknownType = unknownField.type;

      // Try to find a utility for this unknown type
      final utility = registry.getUtilityForType(unknownType);

      // Verify we get a GenericUtility with the correct type parameter
      expect(utility, startsWith('GenericUtility<T, '));
      expect(utility, contains('UnknownType'));
      print('Fallback utility for unknown type: $utility');
    });
  });
}
