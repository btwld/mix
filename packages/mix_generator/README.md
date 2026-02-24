# mix_generator



A package that provides code generation for Spec and Dto classes in the Mix package. It simplifies the creation of Spec and Dto classes by automatically generating the necessary code based on annotated classes.

## Installation

To use Mix Generator, add the following dependencies to your `pubspec.yaml` file:

```bash
flutter pub add mix
flutter pub add mix_annotations
flutter pub add --dev mix_generator
```

pubspec.yaml

```yaml
dependencies:
  mix: ^0.0.0
  mix_annotations: ^0.0.0

dev_dependencies:
  build_runner: ^0.0.0
  mix_generator: ^0.0.0
```

## Usage

### MixableSpec

The `@MixableSpec()` annotation generates code for a mixable class. Here's an example:

#### Options

- `withCopyWith` - Defaults to true, generates a copyWith method.
- `withEquality` - Defaults to true, generates equality methods.
- `withLerp` - Defaults to true, generates a lerp method.
- `skipUtility` - Defaults to false, skips the utility class.
- `prefix` - Defaults to name of `Spec` class, adds a prefix to the generated class.

```dart
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'my_spec.g.dart';

@MixableSpec()
final class MySpec extends Spec<MySpec> with _$MySpec {
  final String? name;
  final int? age;

  const MySpec({this.name, this.age});
}
```

### MixableType

The `@MixableType()` annotation generates code for a mixable. Here's an example:

#### Options

- `mergeLists` - Defaults to true, merges lists in place.
- `generateUtility` - Defaults to true, generates a utility class.
- `generateValueExtension` - Defaults to true, generates a value extension to convert `Value` to Dto with a `toDto()` extension.

```dart
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'value_dto.g.dart';

@MixableType()
final class ValueDto<Value> extends Mixable<Value> with _$ValueDto {
  final String? name;
  final int? age;

  const ValueDto({this.name, this.age});
}
```

### MixableField

The `@MixableField()` annotation specifies a mixable property for code generation. Here's an example:

```dart
import 'package:mix_generator/mix_generator.dart';

@MixableField(
  dto: MixableFieldDto(type: BoxConstraintsDto),
  utilities: [
    MixableFieldUtility(
      properties: [
        (path: 'minWidth', alias: 'minWidth'),
        (path: 'maxWidth', alias: 'maxWidth'),
      ],
    ),
  ],
)
final BoxConstraints? constraints;
```

### MixableFieldUtility

The `@MixableFieldUtility()` annotation generates utility methods for both enum values and class constants. It can be used in two main ways:

#### Options

- `alias` - Optional name for the generated utility.
- `type` - Optional type to use for mapping constants (useful for separate constant classes).
- `properties` - List of properties to include in the utility.
- `generateCallMethod` - Defaults to true, generates a call method for the utility.

#### Example 1: Enum Utility

```dart
// Define an enum
enum Color {
  red,
  green,
  blue,
}

// Create a utility class for the enum
@MixableFieldUtility()
class ColorUtility extends MixUtility<ColorAttribute, Color> {
  const ColorUtility(super.builder);
}

// After generation, you can use it like:
final colorUtility = ColorUtility((color) => ColorAttribute(color));
final redAttribute = colorUtility.red();
final greenAttribute = colorUtility.green();
```

#### Example 2: Class Utility with Constants

```dart
// Define a class with constants
class BorderRadius {
  final double radius;
  
  const BorderRadius(this.radius);
  
  static const BorderRadius none = BorderRadius(0);
  static const BorderRadius small = BorderRadius(4);
  static const BorderRadius large = BorderRadius(16);
}

// Create a utility class for the class constants
@MixableFieldUtility()
class BorderRadiusUtility extends MixUtility<BorderRadiusAttribute, BorderRadius> {
  const BorderRadiusUtility(super.builder);
}

// After generation, you can use it like:
final radiusUtility = BorderRadiusUtility((radius) => BorderRadiusAttribute(radius));
final smallRadius = radiusUtility.small();
final largeRadius = radiusUtility.large();
```

#### Example 3: Class Utility with Mapping

```dart
// Define a value class
class Spacing {
  final double value;
  const Spacing(this.value);
}

// Define a class with constants
class Spacings {
  static const Spacing none = Spacing(0);
  static const Spacing small = Spacing(8);
  static const Spacing large = Spacing(24);
}

// Create a utility class with mapping to the constants class
@MixableFieldUtility(type: Spacings)
class EdgeInsetsGeometryUtility extends MixUtility<SpacingAttribute, Spacing> {
  const EdgeInsetsGeometryUtility(super.builder);
}

// After generation, you can use it like:
final spacingUtility = EdgeInsetsGeometryUtility((spacing) => SpacingAttribute(spacing));
final smallSpacing = spacingUtility.small();
final largeSpacing = spacingUtility.large();
```

### Code Generation

To generate the code for your mixable classes and Dtos, run the following command:

```bash
flutter pub run build_runner build
```

## Debugging Code Generators

To debug the code generators, follow these steps:

### Option 1: Using VS Code

1. Open the project in VS Code.
2. Set breakpoints in the generator code, such as:
   - `lib/src/generators/mixable_spec_generator.dart`
   - `lib/src/generators/mixable_dto_generator.dart`
   - `lib/src/helpers/base_generator.dart`

3. Select the "Debug build_runner" launch configuration from the Run panel.
4. Press F5 to start debugging.

### Option 2: Manual Debugging

1. Run build_runner with the VM service enabled:
   ```bash
   dart --enable-vm-service=8888 --pause-isolates-on-start run build_runner build --verbose
   ```

2. Connect your debugger to localhost:8888.

3. Resume execution once your debugger is connected.

### Common Issues

- Code generation for test files is disabled by default in build.yaml.
- If you need to test generation with files in the test directory, you can temporarily modify build.yaml or use the debug_build_runner.dart script.
