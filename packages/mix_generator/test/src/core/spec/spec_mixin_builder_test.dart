import 'package:mix_annotations/mix_annotations.dart';
import 'package:mix_generator/src/core/metadata/field_metadata.dart';
import 'package:mix_generator/src/core/metadata/spec_metadata.dart';
import 'package:mix_generator/src/core/spec/spec_mixin_builder.dart';
import 'package:test/test.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('SpecMixinBuilder', () {
    test('builds basic spec mixin correctly', () async {
      // Define test code for a simple spec
      const testCode = '''
        class TestSpec extends Spec {
          final String name;
          final int age;
          
          const TestSpec({required this.name, required this.age});
        }
      ''';

      // Resolve the library with our test code
      final library = await resolveMixTestLibrary(testCode);

      // Get the class element for our test spec
      final classElement = library.getClass('TestSpec')!;

      // Extract fields from the class element
      final parameters = ParameterMetadata.extractFromConstructor(classElement);

      // Create spec metadata
      final metadata = SpecMetadata(
        element: classElement,
        name: 'TestSpec',
        parameters: parameters,
        isConst: true,
        isDiagnosticable: false,
        constructor: classElement.unnamedConstructor!,
        isAbstract: false,
        generatedMethods: GeneratedSpecMethods.all,
        generatedComponents: GeneratedSpecComponents.all,
        isWidgetModifier: false,
      );

      // Create the builder and generate the code
      final builder = SpecMixinBuilder(metadata);
      final generatedCode = builder.build();

      // Define the expected code pattern
      const expectedCode = '''
/// A mixin that provides spec functionality for [TestSpec].
mixin _\$TestSpec on Spec<TestSpec> {
  static TestSpec from(MixData mix) {
  return mix.attributeOf<TestSpecAttribute>()?.resolve(mix) ?? const TestSpec();
}

  /// {@template test_spec_of}
/// Retrieves the [TestSpec] from the nearest [ComputedStyle] ancestor in the widget tree.
///
/// This method uses [ComputedStyle.specOf] for surgical rebuilds - only widgets
/// that call this method will rebuild when [TestSpec] changes, not when other specs change.
/// If no ancestor [ComputedStyle] is found, this method returns an empty [TestSpec].
///
/// Example:
///
/// ```dart
/// final testSpec = TestSpec.of(context);
/// ```
/// {@endtemplate}
static TestSpec of(BuildContext context) {
  return ComputedStyle.specOf<TestSpec>(context) ?? const TestSpec();
}

    /// Creates a copy of this [TestSpec] but with the given fields
  /// replaced with the new values.
  @override
  TestSpec copyWith({String? name, int? age,}) {
    return TestSpec(
      name: name ?? _\$this.name, age: age ?? _\$this.age,
    );
  }

  /// Linearly interpolates between this [TestSpec] and another [TestSpec] based on the given parameter [t].
///
/// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
/// When [t] is 0.0, the current [TestSpec] is returned. When [t] is 1.0, the [other] [TestSpec] is returned.
/// For values of [t] between 0.0 and 1.0, an interpolated [TestSpec] is returned.
///
/// If [other] is null, this method returns the current [TestSpec] instance.
///
/// The interpolation is performed on each property of the [TestSpec] using the appropriate
/// interpolation method:
/// For [name] and [age], the interpolation is performed using a step function.
/// If [t] is less than 0.5, the value from the current [TestSpec] is used. Otherwise, the value
/// from the [other] [TestSpec] is used.
///
/// This method is typically used in animations to smoothly transition between
/// different [TestSpec] configurations.
  @override
  TestSpec lerp(TestSpec? other, double t) {
    if (other == null) return _\$this;

    return TestSpec(name: t < 0.5 ? _\$this.name : other.name, age: t < 0.5 ? _\$this.age : other.age,);
  }


    /// The list of properties that constitute the state of this [TestSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [TestSpec] instances for equality.
  @override
  List<Object?> get props => [
_\$this.name,
_\$this.age,
    ];

  TestSpec get _\$this => this as TestSpec;
}''';

      // Normalize whitespace for comparison
      final normalizedGenerated = _normalizeWhitespace(generatedCode);
      final normalizedExpected = _normalizeWhitespace(expectedCode);

      expect(normalizedGenerated, normalizedExpected);
    });

    test('builds widget modifier spec mixin correctly', () async {
      // Define test code for a widget modifier spec
      const testCode = '''
        class TestWidgetModifierSpec extends WidgetModifierSpec<TestWidgetModifierSpec> {
          final Color? color;
          final double? opacity;
          
          const TestWidgetModifierSpec({this.color, this.opacity, super.animated});
          
          @override
          TestWidgetModifierSpec copyWith() {
            return TestWidgetModifierSpec(
              color: color,
              opacity: opacity,
              animated: animated,
            );
          }
          
          @override
          TestWidgetModifierSpec lerp(TestWidgetModifierSpec? other, double t) {
            return TestWidgetModifierSpec(
              color: Color.lerp(color, other?.color, t),
              opacity: lerpDouble(opacity, other?.opacity, t),
              animated: animated,
            );
          }
          
          @override
          Widget build(Widget child) {
            return child;
          }
        }
      ''';

      // Resolve the library with our test code
      final library = await resolveMixTestLibrary(testCode);

      // Get the class element for our test spec
      final classElement = library.getClass('TestWidgetModifierSpec')!;

      // Extract fields from the class element
      final parameters = ParameterMetadata.extractFromConstructor(classElement);

      // Create spec metadata
      final metadata = SpecMetadata(
        element: classElement,
        name: 'TestWidgetModifierSpec',
        parameters: parameters,
        isConst: true,
        isDiagnosticable: false,
        constructor: classElement.unnamedConstructor!,
        isAbstract: false,
        generatedMethods: GeneratedSpecMethods.all,
        generatedComponents: GeneratedSpecComponents.all,
        isWidgetModifier: true,
      );

      // Create the builder and generate the code
      final builder = SpecMixinBuilder(metadata);
      final generatedCode = builder.build();

      // Define the expected code pattern
      const expectedCode = '''
/// A mixin that provides spec functionality for [TestWidgetModifierSpec].
mixin _\$TestWidgetModifierSpec on WidgetModifierSpec<TestWidgetModifierSpec> {
    /// The list of properties that constitute the state of this [TestWidgetModifierSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [TestWidgetModifierSpec] instances for equality.
  @override
  List<Object?> get props => [
_\$this.color,
_\$this.opacity,
_\$this.animated,
    ];

  TestWidgetModifierSpec get _\$this => this as TestWidgetModifierSpec;
}''';

      // Normalize whitespace for comparison
      final normalizedGenerated = _normalizeWhitespace(generatedCode);
      final normalizedExpected = _normalizeWhitespace(expectedCode);

      expect(normalizedGenerated, normalizedExpected);
    });

    test('handles diagnosticable specs correctly', () async {
      // Define test code for a diagnosticable spec
      const testCode = '''
        class DiagnosticableSpec extends Spec with Diagnosticable {
          final String label;
          
          const DiagnosticableSpec({required this.label});
        }
      ''';

      // Resolve the library with our test code
      final library = await resolveMixTestLibrary(testCode);

      // Get the class element for our test spec
      final classElement = library.getClass('DiagnosticableSpec')!;

      // Extract fields from the class element
      final parameters = ParameterMetadata.extractFromConstructor(classElement);

      // Create spec metadata
      final metadata = SpecMetadata(
        element: classElement,
        name: 'DiagnosticableSpec',
        parameters: parameters,
        isConst: true,
        isDiagnosticable: true,
        constructor: classElement.unnamedConstructor!,
        isAbstract: false,
        generatedMethods: GeneratedSpecMethods.all,
        generatedComponents: GeneratedSpecComponents.all,
        isWidgetModifier: false,
      );

      // Create the builder and generate the code
      final builder = SpecMixinBuilder(metadata);
      final generatedCode = builder.build();

      // Define the expected code pattern
      const expectedCode = '''
/// A mixin that provides spec functionality for [DiagnosticableSpec].
mixin _\$DiagnosticableSpec on Spec<DiagnosticableSpec> {
  static DiagnosticableSpec from(MixData mix) {
  return mix.attributeOf<DiagnosticableSpecAttribute>()?.resolve(mix) ?? const DiagnosticableSpec();
}

  /// {@template diagnosticable_spec_of}
/// Retrieves the [DiagnosticableSpec] from the nearest [ComputedStyle] ancestor in the widget tree.
///
/// This method uses [ComputedStyle.specOf] for surgical rebuilds - only widgets
/// that call this method will rebuild when [DiagnosticableSpec] changes, not when other specs change.
/// If no ancestor [ComputedStyle] is found, this method returns an empty [DiagnosticableSpec].
///
/// Example:
///
/// ```dart
/// final diagnosticableSpec = DiagnosticableSpec.of(context);
/// ```
/// {@endtemplate}
static DiagnosticableSpec of(BuildContext context) {
  return ComputedStyle.specOf<DiagnosticableSpec>(context) ?? const DiagnosticableSpec();
}

    /// Creates a copy of this [DiagnosticableSpec] but with the given fields
  /// replaced with the new values.
  @override
  DiagnosticableSpec copyWith({String? label,}) {
    return DiagnosticableSpec(
      label: label ?? _\$this.label,
    );
  }

  /// Linearly interpolates between this [DiagnosticableSpec] and another [DiagnosticableSpec] based on the given parameter [t].
///
/// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
/// When [t] is 0.0, the current [DiagnosticableSpec] is returned. When [t] is 1.0, the [other] [DiagnosticableSpec] is returned.
/// For values of [t] between 0.0 and 1.0, an interpolated [DiagnosticableSpec] is returned.
///
/// If [other] is null, this method returns the current [DiagnosticableSpec] instance.
///
/// The interpolation is performed on each property of the [DiagnosticableSpec] using the appropriate
/// interpolation method:
/// For [label], the interpolation is performed using a step function.
/// If [t] is less than 0.5, the value from the current [DiagnosticableSpec] is used. Otherwise, the value
/// from the [other] [DiagnosticableSpec] is used.
///
/// This method is typically used in animations to smoothly transition between
/// different [DiagnosticableSpec] configurations.
  @override
  DiagnosticableSpec lerp(DiagnosticableSpec? other, double t) {
    if (other == null) return _\$this;

    return DiagnosticableSpec(label: t < 0.5 ? _\$this.label : other.label,);
  }


    /// The list of properties that constitute the state of this [DiagnosticableSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [DiagnosticableSpec] instances for equality.
  @override
  List<Object?> get props => [
_\$this.label,
    ];

  DiagnosticableSpec get _\$this => this as DiagnosticableSpec;

    
  void _debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties.add(DiagnosticsProperty('label', _\$this.label, defaultValue: null));
  }
}''';

      // Normalize whitespace for comparison
      final normalizedGenerated = _normalizeWhitespace(generatedCode);
      final normalizedExpected = _normalizeWhitespace(expectedCode);

      expect(normalizedGenerated, normalizedExpected);
    });

    test('respects existing methods', () async {
      // Define test code for a spec with existing methods
      const testCode = '''
        class ExistingMethodsSpec extends Spec {
          final String name;
          
          const ExistingMethodsSpec({required this.name});
          
          @override
          ExistingMethodsSpec copyWith({String? name}) {
            return ExistingMethodsSpec(
              name: name ?? this.name,
            );
          }
          
          @override
          List<Object?> get props => [name];
        }
      ''';

      // Resolve the library with our test code
      final library = await resolveMixTestLibrary(testCode);

      // Get the class element for our test spec
      final classElement = library.getClass('ExistingMethodsSpec')!;

      // Extract fields from the class element
      final parameters = ParameterMetadata.extractFromConstructor(classElement);

      // Create a custom SpecMetadata subclass that overrides hasMethod
      final metadata = _TestSpecMetadata(
        element: classElement,
        name: 'ExistingMethodsSpec',
        parameters: parameters,
        isConst: true,
        isDiagnosticable: false,
        constructor: classElement.unnamedConstructor!,
        isAbstract: false,
        generatedMethods: GeneratedSpecMethods.all,
        generatedComponents: GeneratedSpecComponents.all,
        isWidgetModifier: false,
      );

      // Create the builder and generate the code
      final builder = SpecMixinBuilder(metadata);
      final generatedCode = builder.build();

      // Define the expected code pattern
      const expectedCode = '''
/// A mixin that provides spec functionality for [ExistingMethodsSpec].
mixin _\$ExistingMethodsSpec on Spec<ExistingMethodsSpec> {
  static ExistingMethodsSpec from(MixData mix) {
  return mix.attributeOf<ExistingMethodsSpecAttribute>()?.resolve(mix) ?? const ExistingMethodsSpec();
}

  /// {@template existing_methods_spec_of}
/// Retrieves the [ExistingMethodsSpec] from the nearest [ComputedStyle] ancestor in the widget tree.
///
/// This method uses [ComputedStyle.specOf] for surgical rebuilds - only widgets
/// that call this method will rebuild when [ExistingMethodsSpec] changes, not when other specs change.
/// If no ancestor [ComputedStyle] is found, this method returns an empty [ExistingMethodsSpec].
///
/// Example:
///
/// ```dart
/// final existingMethodsSpec = ExistingMethodsSpec.of(context);
/// ```
/// {@endtemplate}
static ExistingMethodsSpec of(BuildContext context) {
  return ComputedStyle.specOf<ExistingMethodsSpec>(context) ?? const ExistingMethodsSpec();
}

  /// Linearly interpolates between this [ExistingMethodsSpec] and another [ExistingMethodsSpec] based on the given parameter [t].
///
/// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
/// When [t] is 0.0, the current [ExistingMethodsSpec] is returned. When [t] is 1.0, the [other] [ExistingMethodsSpec] is returned.
/// For values of [t] between 0.0 and 1.0, an interpolated [ExistingMethodsSpec] is returned.
///
/// If [other] is null, this method returns the current [ExistingMethodsSpec] instance.
///
/// The interpolation is performed on each property of the [ExistingMethodsSpec] using the appropriate
/// interpolation method:
/// For [name], the interpolation is performed using a step function.
/// If [t] is less than 0.5, the value from the current [ExistingMethodsSpec] is used. Otherwise, the value
/// from the [other] [ExistingMethodsSpec] is used.
///
/// This method is typically used in animations to smoothly transition between
/// different [ExistingMethodsSpec] configurations.
  @override
  ExistingMethodsSpec lerp(ExistingMethodsSpec? other, double t) {
    if (other == null) return _\$this;

    return ExistingMethodsSpec(name: t < 0.5 ? _\$this.name : other.name,);
  }

  ExistingMethodsSpec get _\$this => this as ExistingMethodsSpec;
}''';

      // Normalize whitespace for comparison
      final normalizedGenerated = _normalizeWhitespace(generatedCode);
      final normalizedExpected = _normalizeWhitespace(expectedCode);

      expect(normalizedGenerated, normalizedExpected);
    });
  });
}

/// A test-specific subclass of SpecMetadata that overrides hasMethod
class _TestSpecMetadata extends SpecMetadata {
  _TestSpecMetadata({
    required super.element,
    required super.name,
    required super.parameters,
    required super.isConst,
    required super.isDiagnosticable,
    required super.constructor,
    required super.isAbstract,
    required super.generatedMethods,
    required super.generatedComponents,
    required super.isWidgetModifier,
  });

  @override
  bool hasMethod(String name) {
    if (name == 'copyWith' || name == 'props') {
      return true;
    }
    return super.hasMethod(name);
  }
}

/// Normalizes whitespace in a string to make comparison more reliable
String _normalizeWhitespace(String input) {
  // Replace all whitespace sequences with a single space
  return input.replaceAll(RegExp(r'\s+'), ' ').trim();
}
