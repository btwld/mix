// import 'package:mix_annotations/mix_annotations.dart';
// import 'package:mix_generator/src/core/metadata/field_metadata.dart';
// import 'package:mix_generator/src/core/metadata/spec_metadata.dart';
// import 'package:mix_generator/src/core/spec/spec_tween_builder.dart';
// import 'package:test/test.dart';

// import '../../helpers/test_helpers.dart';

void main() {}

// void main() {
//   group('SpecTweenBuilder', () {
//     test('builds basic tween class correctly', () async {
//       // Define test code for a simple spec
//       const testCode = '''
//         class TestSpec extends Spec<TestSpec> {
//           final String name;
//           final int age;

//           const TestSpec({required this.name, required this.age});
//         }
//       ''';

//       // Resolve the library with our test code
//       final library = await resolveMixTestLibrary(testCode);

//       // Get the class element for our test spec
//       final classElement = library.getClass('TestSpec')!;

//       // Extract fields from the class element
//       final parameters = ParameterMetadata.extractFromConstructor(classElement);

//       // Create spec metadata
//       final metadata = SpecMetadata(
//         element: classElement,
//         name: 'TestSpec',
//         parameters: parameters,
//         isConst: true,
//         isDiagnosticable: false,
//         constructor: classElement.unnamedConstructor!,
//         isAbstract: false,
//         generatedMethods: GeneratedSpecMethods.all,
//         generatedComponents: GeneratedSpecComponents.all,
//         isWidgetModifier: false,
//       );

//       // Create the builder and generate the code
//       final builder = SpecTweenBuilder(metadata);
//       final generatedCode = builder.build();

//       // Define the expected code pattern
//       const expectedCode = '''
// /// A tween that interpolates between two [TestSpec] instances.
// ///
// /// This class can be used in animations to smoothly transition between
// /// different [TestSpec] specifications.
// class TestSpecTween extends Tween<TestSpec?> {
//   TestSpecTween({
//     super.begin, super.end,
//   });

//   @override
//   TestSpec lerp(double t) {
//     if (begin == null && end == null) {
//       return const TestSpec();
//     }

//     if (begin == null) {
//       return end!;
//     }

//     return begin!.lerp(end!, t);
//   }
// }''';

//       // Normalize whitespace for comparison
//       final normalizedGenerated = _normalizeWhitespace(generatedCode);
//       final normalizedExpected = _normalizeWhitespace(expectedCode);

//       expect(normalizedGenerated, normalizedExpected);
//     });

//     test('builds tween class for non-const spec correctly', () async {
//       // Define test code for a non-const spec
//       const testCode = '''
//         class NonConstSpec extends Spec<NonConstSpec> {
//           final String name;
//           final int age;

//           NonConstSpec({required this.name, required this.age});
//         }
//       ''';

//       // Resolve the library with our test code
//       final library = await resolveMixTestLibrary(testCode);

//       // Get the class element for our test spec
//       final classElement = library.getClass('NonConstSpec')!;

//       // Extract fields from the class element
//       final parameters = ParameterMetadata.extractFromConstructor(classElement);

//       // Create spec metadata with isConst = false
//       final metadata = SpecMetadata(
//         element: classElement,
//         name: 'NonConstSpec',
//         parameters: parameters,
//         isConst: false,
//         isDiagnosticable: false,
//         constructor: classElement.unnamedConstructor!,
//         isAbstract: false,
//         generatedMethods: GeneratedSpecMethods.all,
//         generatedComponents: GeneratedSpecComponents.all,
//         isWidgetModifier: false,
//       );

//       // Create the builder and generate the code
//       final builder = SpecTweenBuilder(metadata);
//       final generatedCode = builder.build();

//       // Define the expected code pattern
//       const expectedCode = '''
// /// A tween that interpolates between two [NonConstSpec] instances.
// ///
// /// This class can be used in animations to smoothly transition between
// /// different [NonConstSpec] specifications.
// class NonConstSpecTween extends Tween<NonConstSpec?> {
//   NonConstSpecTween({
//     super.begin, super.end,
//   });

//   @override
//   NonConstSpec lerp(double t) {
//     if (begin == null && end == null) {
//       return NonConstSpec();
//     }

//     if (begin == null) {
//       return end!;
//     }

//     return begin!.lerp(end!, t);
//   }
// }''';

//       // Normalize whitespace for comparison
//       final normalizedGenerated = _normalizeWhitespace(generatedCode);
//       final normalizedExpected = _normalizeWhitespace(expectedCode);

//       expect(normalizedGenerated, normalizedExpected);
//     });

//     test('builds tween class with constructor reference correctly', () async {
//       // Define test code for a spec with named constructor
//       const testCode = '''
//         class NamedConstructorSpec extends Spec<NamedConstructorSpec> {
//           final String name;

//           const NamedConstructorSpec.named({required this.name});

//           const NamedConstructorSpec({required this.name});
//         }
//       ''';

//       // Resolve the library with our test code
//       final library = await resolveMixTestLibrary(testCode);

//       // Get the class element for our test spec
//       final classElement = library.getClass('NamedConstructorSpec')!;

//       // Extract fields from the class element
//       final parameters = ParameterMetadata.extractFromConstructor(classElement);

//       // Create a custom spec metadata with a constructor reference
//       final metadata = _TestSpecMetadata(
//         element: classElement,
//         name: 'NamedConstructorSpec',
//         parameters: parameters,
//         isConst: true,
//         isDiagnosticable: false,
//         constructor: classElement.unnamedConstructor!,
//         isAbstract: false,
//         generatedMethods: GeneratedSpecMethods.all,
//         generatedComponents: GeneratedSpecComponents.all,
//         isWidgetModifier: false,
//         constructorRef: '.named',
//       );

//       // Create the builder and generate the code
//       final builder = SpecTweenBuilder(metadata);
//       final generatedCode = builder.build();

//       // Define the expected code pattern
//       const expectedCode = '''
// /// A tween that interpolates between two [NamedConstructorSpec] instances.
// ///
// /// This class can be used in animations to smoothly transition between
// /// different [NamedConstructorSpec] specifications.
// class NamedConstructorSpecTween extends Tween<NamedConstructorSpec?> {
//   NamedConstructorSpecTween({
//     super.begin, super.end,
//   });

//   @override
//   NamedConstructorSpec lerp(double t) {
//     if (begin == null && end == null) {
//       return const NamedConstructorSpec.named();
//     }

//     if (begin == null) {
//       return end!;
//     }

//     return begin!.lerp(end!, t);
//   }
// }''';

//       // Normalize whitespace for comparison
//       final normalizedGenerated = _normalizeWhitespace(generatedCode);
//       final normalizedExpected = _normalizeWhitespace(expectedCode);

//       expect(normalizedGenerated, normalizedExpected);
//     });
//   });
// }

// /// A test-specific subclass of SpecMetadata that allows setting a constructor reference
// class _TestSpecMetadata extends SpecMetadata {
//   @override
//   final String constructorRef;

//   _TestSpecMetadata({
//     required super.element,
//     required super.name,
//     required super.parameters,
//     required super.isConst,
//     required super.isDiagnosticable,
//     required super.constructor,
//     required super.isAbstract,
//     required super.generatedMethods,
//     required super.generatedComponents,
//     required super.isWidgetModifier,
//     required this.constructorRef,
//   });
// }

// /// Normalizes whitespace in a string to make comparison more reliable
// String _normalizeWhitespace(String input) {
//   // Replace all whitespace sequences with a single space
//   return input.replaceAll(RegExp(r'\s+'), ' ').trim();
// }
