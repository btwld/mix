// import 'package:mix_annotations/mix_annotations.dart';
// import 'package:mix_generator/src/core/metadata/field_metadata.dart';
// import 'package:mix_generator/src/core/metadata/spec_metadata.dart';
// import 'package:mix_generator/src/core/spec/spec_attribute_builder.dart';
// import 'package:test/test.dart';

// import '../../helpers/test_helpers.dart';

void main() {}

// void main() {
//   group('SpecAttributeBuilder', () {
//     test('builds basic attribute class correctly', () async {
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
//       final builder = SpecAttributeBuilder(metadata);
//       final generatedCode = builder.build();

//       // Verify the generated code contains expected elements
//       expect(generatedCode,
//           contains('class TestSpecAttribute extends SpecAttribute<TestSpec>'));
//       expect(generatedCode, contains('final String? name;'));
//       expect(generatedCode, contains('final int? age;'));
//       expect(generatedCode,
//           contains('const TestSpecAttribute({this.name, this.age'));
//       expect(generatedCode,
//           contains('@override\n  TestSpec resolve(BuildContext mix)'));
//       expect(generatedCode, contains('return TestSpec('));
//       expect(
//           generatedCode,
//           contains(
//               '@override\n    TestSpecAttribute merge(TestSpecAttribute? other)'));
//       expect(generatedCode, contains('@override\n  List<Object?> get props'));
//     });

//     test('builds widget modifier attribute class correctly', () async {
//       // Define test code for a widget modifier spec
//       const testCode = '''
//         class TestWidgetModifierSpec extends WidgetModifierSpec<TestWidgetModifierSpec> {
//           final Color? color;
//           final double? opacity;

//           const TestWidgetModifierSpec({this.color, this.opacity, super.animated});

//           @override
//           TestWidgetModifierSpec copyWith() {
//             return TestWidgetModifierSpec(
//               color: color,
//               opacity: opacity,
//               animated: animated,
//             );
//           }

//           @override
//           TestWidgetModifierSpec lerp(TestWidgetModifierSpec? other, double t) {
//             return TestWidgetModifierSpec(
//               color: Color.lerp(color, other?.color, t),
//               opacity: lerpDouble(opacity, other?.opacity, t),
//               animated: animated,
//             );
//           }

//           @override
//           Widget build(Widget child) {
//             return child;
//           }
//         }
//       ''';

//       // Resolve the library with our test code
//       final library = await resolveMixTestLibrary(testCode);

//       // Get the class element for our test spec
//       final classElement = library.getClass('TestWidgetModifierSpec')!;

//       // Extract fields from the class element
//       final parameters = ParameterMetadata.extractFromConstructor(classElement);

//       // Create spec metadata
//       final metadata = SpecMetadata(
//         element: classElement,
//         name: 'TestWidgetModifierSpec',
//         parameters: parameters,
//         isConst: true,
//         isDiagnosticable: false,
//         constructor: classElement.unnamedConstructor!,
//         isAbstract: false,
//         generatedMethods: GeneratedSpecMethods.all,
//         generatedComponents: GeneratedSpecComponents.all,
//         isWidgetModifier: true,
//       );

//       // Create the builder and generate the code
//       final builder = SpecAttributeBuilder(metadata);
//       final generatedCode = builder.build();

//       // Verify the generated code contains expected elements
//       expect(
//           generatedCode,
//           contains(
//               'class TestWidgetModifierSpecAttribute extends WidgetModifierSpecAttribute<TestWidgetModifierSpec>'));
//       // Note: The actual type might be InvalidType due to the test environment
//       expect(generatedCode, contains('final'));
//       expect(generatedCode, contains('opacity;'));
//       expect(
//           generatedCode, contains('const TestWidgetModifierSpecAttribute({'));
//       expect(generatedCode,
//           contains('@override\n  TestWidgetModifierSpec resolve(BuildContext mix)'));
//       expect(generatedCode, contains('return TestWidgetModifierSpec('));
//       expect(
//           generatedCode,
//           contains(
//               '@override\n    TestWidgetModifierSpecAttribute merge(TestWidgetModifierSpecAttribute? other)'));
//       expect(generatedCode, contains('@override\n  List<Object?> get props'));
//     });

//     test('handles diagnosticable specs correctly', () async {
//       // Define test code for a diagnosticable spec
//       const testCode = '''
//         class DiagnosticableSpec extends Spec with Diagnosticable {
//           final String label;

//           const DiagnosticableSpec({required this.label});
//         }
//       ''';

//       // Resolve the library with our test code
//       final library = await resolveMixTestLibrary(testCode);

//       // Get the class element for our test spec
//       final classElement = library.getClass('DiagnosticableSpec')!;

//       // Extract fields from the class element
//       final parameters = ParameterMetadata.extractFromConstructor(classElement);

//       // Create spec metadata
//       final metadata = SpecMetadata(
//         element: classElement,
//         name: 'DiagnosticableSpec',
//         parameters: parameters,
//         isConst: true,
//         isDiagnosticable: true,
//         constructor: classElement.unnamedConstructor!,
//         isAbstract: false,
//         generatedMethods: GeneratedSpecMethods.all,
//         generatedComponents: GeneratedSpecComponents.all,
//         isWidgetModifier: false,
//       );

//       // Create the builder and generate the code
//       final builder = SpecAttributeBuilder(metadata);
//       final generatedCode = builder.build();

//       // Verify the generated code contains expected elements
//       expect(
//           generatedCode,
//           contains(
//               'class DiagnosticableSpecAttribute extends SpecAttribute<DiagnosticableSpec> with Diagnosticable'));
//       expect(generatedCode, contains('final String? label;'));
//       expect(generatedCode, contains('final String? label;'));
//       expect(
//           generatedCode,
//           contains(
//               '@override\n  void debugFillProperties(DiagnosticPropertiesBuilder properties)'));
//       expect(generatedCode, contains('properties.add(DiagnosticsProperty'));
//     });
//   });
// }

// /// A dumm
