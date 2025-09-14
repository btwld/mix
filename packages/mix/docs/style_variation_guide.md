# StyleVariation System Guide

## Overview

The StyleVariation system enables creating **contextually adaptive design system components** in Mix. Unlike traditional variants that apply fixed styling, StyleVariations dynamically adjust their behavior based on which other variants are active, enabling sophisticated design system patterns.

## Key Concepts

### Traditional Variants vs StyleVariations

```dart
// Traditional NamedVariant - static styling
const primary = NamedVariant('primary');
final primaryStyle = VariantStyle(primary, BoxStyler().color(Colors.blue));

// StyleVariation - dynamic, contextual styling  
class OutlinedButton extends BoxStyler implements StyleVariation<BoxSpec> {
  @override
  String get variantName => 'outlined';
  
  @override
  BoxStyler styleBuilder(BoxStyler style, List<NamedVariant> activeVariants) =>
    switch (activeVariants) {
      _ when hasVariant(activeVariants, small) => style.border(color: Colors.grey).padding(horizontal: 8.0),
      _ when hasVariant(activeVariants, large) => style.border(color: Colors.grey).padding(horizontal: 24.0),
      _ => style.border(color: Colors.grey).padding(horizontal: 16.0),
    };
}
```

## Core Features

### 1. Natural API Design
StyleVariations ARE Style objects, enabling natural fluent APIs:

```dart
class OutlinedButtonStyler extends BoxStyler implements StyleVariation<BoxSpec> {
  // Implementation...
}

// Usage - feels like regular styling
final button = OutlinedButtonStyler()
    .height(48.0)        // User modifications
    .width(200.0)        // User modifications  
    .margin(all: 8.0);   // User modifications
```

### 2. Contextual Adaptation
Variants adapt based on which other variants are active:

```dart
@override
BoxStyler styleBuilder(BoxStyler style, List<NamedVariant> activeVariants) {
  final result = switch (activeVariants) {
    _ when hasVariant(activeVariants, small) => style.border(color: Colors.grey).padding(horizontal: 8.0),
    _ => style.border(color: Colors.grey).padding(horizontal: 16.0),
  };
  
  return switch (activeVariants) {
    _ when hasVariant(activeVariants, primary) => result.border(color: Colors.blue),
    _ => result,
  };
}
```

### 3. Type Safety
The system maintains full type safety with covariant parameters:

```dart
class OutlinedButtonStyler extends BoxStyler implements StyleVariation<BoxSpec> {
  @override
  BoxStyler styleBuilder(covariant BoxStyler style, List<NamedVariant> activeVariants) {
    // style parameter is specifically BoxStyler, not generic Style
    return style.someBoxStylerMethod(); // Type-safe access to BoxStyler methods
  }
}
```

## Implementation Guide

### Basic StyleVariation Implementation

```dart
class YourCustomStyler extends BoxStyler implements StyleVariation<BoxSpec> {
  YourCustomStyler() : super();
  
  @override
  String get variantName => 'your-variant-name';
  
  @override
  BoxStyler styleBuilder(BoxStyler style, List<NamedVariant> activeVariants) {
    var result = style; // Start with user modifications
    
    // 1. Apply base styling for this variant
    result = result.someBaseStyling();
    
    // 2. Add contextual adaptations based on activeVariants
    for (final variant in activeVariants) {
      switch (variant.name) {
        case 'small':
          result = result.someSmallAdaptation();
          break;
        case 'large':
          result = result.someLargeAdaptation();
          break;
        // ... more adaptations
      }
    }
    
    // 3. Handle complex combinations
    if (hasMultipleVariants(activeVariants, ['small', 'primary'])) {
      result = result.someComplexAdaptation();
    }
    
    return result;
  }
  
  bool hasMultipleVariants(List<NamedVariant> variants, List<String> names) {
    return names.every((name) => variants.any((v) => v.name == name));
  }
}
```

## Usage Patterns

### 1. Design System Categories

Organize StyleVariations into logical categories:

```dart
// Base variants - define primary appearance
class OutlinedButtonStyler extends BoxStyler implements StyleVariation<BoxSpec> { }
class SolidButtonStyler extends BoxStyler implements StyleVariation<BoxSpec> { }
class GhostButtonStyler extends BoxStyler implements StyleVariation<BoxSpec> { }

// Size modifiers - affect sizing
class SmallButtonStyler extends BoxStyler implements StyleVariation<BoxSpec> { }
class LargeButtonStyler extends BoxStyler implements StyleVariation<BoxSpec> { }

// Semantic variants - use traditional NamedVariants
const primary = NamedVariant('primary');
const secondary = NamedVariant('secondary');
const danger = NamedVariant('danger');
```

### 2. Contextual Adaptation Strategies

#### Size-Based Adaptation
```dart
if (activeVariants.any((v) => v.name == 'small')) {
  result = result.padding(horizontal: 8.0, vertical: 4.0);
} else if (activeVariants.any((v) => v.name == 'large')) {
  result = result.padding(horizontal: 24.0, vertical: 16.0);
}
```

#### Semantic Adaptation
```dart
if (activeVariants.any((v) => v.name == 'primary')) {
  result = result.border(color: Colors.blue);
} else if (activeVariants.any((v) => v.name == 'danger')) {
  result = result.border(color: Colors.red);
}
```

#### Complex Combinations
```dart
// Different behavior when multiple variants are active
final isSmallPrimary = activeVariants.any((v) => v.name == 'small') && 
                      activeVariants.any((v) => v.name == 'primary');
if (isSmallPrimary) {
  result = result.border(width: 2.0).borderRadius(4.0);
}
```

### 3. Factory Methods and Convenience APIs

Create convenient factory methods:

```dart
class ButtonStyleSystem {
  static final outlined = OutlinedButtonStyler();
  static final solid = SolidButtonStyler();
  
  // Usage becomes very clean
  static BoxStyler outlinedButton() => outlined;
  static BoxStyler solidButton() => solid;
}

// Usage
final myButton = ButtonStyleSystem.outlinedButton()
    .height(48.0)
    .width(200.0);
```

## Advanced Patterns

### 1. Variant Hierarchies
Some variants can have parent-child relationships:

```dart
@override
BoxStyler styleBuilder(BoxStyler style, List<NamedVariant> activeVariants) {
  var result = style;
  
  // Parent category styling
  if (activeVariants.any((v) => v.name.startsWith('button-'))) {
    result = result.borderRadius(8.0);
  }
  
  // Specific variant styling
  if (activeVariants.any((v) => v.name == 'button-primary')) {
    result = result.color(Colors.blue);
  }
  
  return result;
}
```

### 2. Responsive Adaptations
Variants can adapt based on breakpoints or device characteristics:

```dart
@override
BoxStyler styleBuilder(BoxStyler style, List<NamedVariant> activeVariants) {
  var result = style;
  
  // Base mobile styling
  result = result.padding(horizontal: 16.0);
  
  // Adapt for larger screens when 'desktop' variant is active
  if (activeVariants.any((v) => v.name == 'desktop')) {
    result = result.padding(horizontal: 32.0);
  }
  
  return result;
}
```

### 3. Theme Integration
StyleVariations can adapt to different themes:

```dart
@override
BoxStyler styleBuilder(BoxStyler style, List<NamedVariant> activeVariants) {
  var result = style;
  
  if (activeVariants.any((v) => v.name == 'dark')) {
    result = result.color(Colors.grey.shade800).border(color: Colors.grey.shade600);
  } else {
    result = result.color(Colors.white).border(color: Colors.grey.shade300);
  }
  
  return result;
}
```

## Best Practices

### 1. Naming Conventions
- Use descriptive, consistent names for variants
- Group related variants with prefixes (`button-`, `card-`, etc.)
- Use semantic names over visual descriptions (`primary` vs `blue`)

### 2. Avoid Conflicts
- Don't create conflicting adaptations (e.g., two variants setting the same property to different values)
- Use priority systems when conflicts are necessary
- Test variant combinations thoroughly

### 3. Performance Considerations
- Keep styleBuilder implementations lightweight
- Cache expensive calculations when possible
- Avoid creating complex objects in hot paths

### 4. Documentation
- Document which variants your StyleVariation responds to
- Provide examples of common combinations
- Explain the reasoning behind contextual adaptations

## Migration from Traditional Variants

### Before (Traditional VariantStyle)
```dart
const primaryVariant = NamedVariant('primary');
const smallVariant = NamedVariant('small');

final primaryStyle = VariantStyle(primaryVariant, BoxStyler().color(Colors.blue));
final smallStyle = VariantStyle(smallVariant, BoxStyler().padding(all: 8.0));

// No contextual adaptation - styles are independent
```

### After (StyleVariation)
```dart
class PrimaryButtonStyler extends BoxStyler implements StyleVariation<BoxSpec> {
  @override
  String get variantName => 'primary';
  
  @override
  BoxStyler styleBuilder(BoxStyler style, List<NamedVariant> activeVariants) {
    var result = style.color(Colors.blue);
    
    // Contextual adaptation - primary buttons adapt when small
    if (activeVariants.any((v) => v.name == 'small')) {
      result = result.padding(all: 6.0); // Different padding for small primary
    }
    
    return result;
  }
}
```

## Troubleshooting

### Common Issues

1. **Infinite Recursion**: Avoid creating new StyleVariation instances within styleBuilder
2. **Type Errors**: Ensure covariant parameter types match your Style class
3. **Unexpected Behavior**: Check variant name matching (case-sensitive)
4. **Performance**: Profile styleBuilder methods with many active variants

### Debugging Tips

```dart
@override
BoxStyler styleBuilder(BoxStyler style, List<NamedVariant> activeVariants) {
  print('StyleVariation $variantName active variants: ${activeVariants.map((v) => v.name)}');
  
  var result = style;
  // ... implementation
  
  return result;
}
```

## Conclusion

The StyleVariation system enables sophisticated, contextually-adaptive design systems that go beyond traditional static variants. By allowing variants to dynamically adapt based on context, you can create more flexible and maintainable styling systems that naturally handle complex design requirements.