// Example demonstrating the concept of using MixableFieldUtility annotation
// for both enum and class utilities
//
// NOTE: This is a conceptual example and not meant to be run directly.
// In a real project, you would need to:
// 1. Import the mix and mix_annotations packages
// 2. Run the build_runner to generate the .g.dart file
// 3. Implement the Attribute and MixUtility classes

// ignore_for_file: unused_local_variable

// Example 1: Enum Utility
// Define an enum for colors
enum Color { red, green, blue, yellow, purple }

// Create a utility class for the Color enum
// In a real project, you would use @MixableFieldUtility()
class ColorUtility {
  // This would extend MixUtility<ColorAttribute, Color> in a real project
  final Function(Color) builder;

  const ColorUtility(this.builder);
}

// Define a custom attribute for colors
class ColorAttribute {
  final Color color;

  const ColorAttribute(this.color);

  // In a real project, this would implement merge and props methods
}

// Example 2: Class Utility with Constants
// Define a class for border radius
class BorderRadius {
  final double radius;

  // Define static constants
  static const BorderRadius none = BorderRadius(0);

  static const BorderRadius small = BorderRadius(4);
  static const BorderRadius medium = BorderRadius(8);
  static const BorderRadius large = BorderRadius(16);
  static const BorderRadius circular = BorderRadius(999);
  const BorderRadius(this.radius);
}

// Create a utility class for the BorderRadius class
// In a real project, you would use @MixableFieldUtility()
class BorderRadiusUtility {
  // This would extend MixUtility<BorderRadiusAttribute, BorderRadius> in a real project
  final Function(BorderRadius) builder;

  const BorderRadiusUtility(this.builder);
}

// Define a custom attribute for border radius
class BorderRadiusAttribute {
  final BorderRadius radius;

  const BorderRadiusAttribute(this.radius);

  // In a real project, this would implement merge and props methods
}

// Example 3: Class Utility with Mapping
// Define a class for spacing
class Spacing {
  final double value;

  const Spacing(this.value);
}

// Define a class with static constants for spacing
class Spacings {
  static const Spacing none = Spacing(0);
  static const Spacing xs = Spacing(4);
  static const Spacing sm = Spacing(8);
  static const Spacing md = Spacing(16);
  static const Spacing lg = Spacing(24);
  static const Spacing xl = Spacing(32);
}

// Create a utility class for spacing with mapping to Spacings class
// In a real project, you would use @MixableFieldUtility(type: Spacings)
class SpacingUtility {
  // This would extend MixUtility<SpacingAttribute, Spacing> in a real project
  final Function(Spacing) builder;

  const SpacingUtility(this.builder);
}

// Define a custom attribute for spacing
class SpacingAttribute {
  final Spacing spacing;

  const SpacingAttribute(this.spacing);

  // In a real project, this would implement merge and props methods
}

// Example usage (conceptual)
void exampleUsage() {
  // After generation, you would use the utilities like this:

  // Using the enum utility
  final colorUtility = ColorUtility((color) => ColorAttribute(color));
  // final redAttribute = colorUtility.red();  // This would work after generation

  // Using the class utility with constants
  final borderRadiusUtility = BorderRadiusUtility(
    (radius) => BorderRadiusAttribute(radius),
  );

  // Using the class utility with mapping
  final spacingUtility = SpacingUtility((spacing) => SpacingAttribute(spacing));
}
