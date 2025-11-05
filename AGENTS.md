# Mix Architecture & Agent Context

> **Last Updated**: 2025-11-04
> **Current Version**: v2.0.0-dev.6
> **Status**: Active development on v2.0

## Executive Summary

Mix is a production-grade Flutter styling system that separates style semantics from widgets. It's architected as a monorepo with four interdependent packages, uses extensive code generation, and is currently in v2.0 development with breaking changes from v1.x.

## Architecture Overview

### Monorepo Structure

```
mix/
├── packages/
│   ├── mix/                    # Core library (the main package)
│   ├── mix_annotations/        # Annotations for code generation
│   ├── mix_generator/          # Build runner generators
│   └── mix_lint/               # Custom lint rules
├── scripts/                    # Utility scripts
└── melos.yaml                  # Workspace configuration
```

### Package Dependencies

```
mix_annotations (annotations only)
      ↓
mix_generator (depends on annotations)
      ↓
mix (depends on annotations, uses generator)
      ↓
mix_lint (analyzes mix code)
```

### Core Library Architecture (`packages/mix/lib/src`)

```
src/
├── animation/          # Animation system
├── core/              # Core abstractions (27 files)
│   ├── attribute.dart      # Attribute system
│   ├── styled_widget.dart  # Widget integration
│   └── ...
├── modifiers/         # Widget modification system (23 files)
├── properties/        # Style properties
├── providers/         # Context providers
├── specs/             # Widget specifications (12 files)
├── style/             # Style composition system
├── theme/             # Theme and design tokens
└── variants/          # Conditional styling (variants)
```

## Key Architectural Patterns

### 1. Attribute System

**Pattern**: Type-safe property definitions using attributes.

**Location**: `packages/mix/lib/src/core/attribute.dart`

**How it works**:
- Attributes are immutable property definitions
- Combine via `merge()` operations
- Resolve to concrete values during build

**Example**:
```dart
// Attribute defines a property
final heightAttr = ScalarAttribute(100);

// Attributes merge to form complete definitions
final boxAttrs = heightAttr.merge(widthAttr);
```

### 2. Spec System

**Pattern**: Widget specifications that define renderable output.

**Location**: `packages/mix/lib/src/specs/`

**How it works**:
- Specs transform style attributes into widget properties
- Generated via `build_runner` from annotations
- Resolve attributes to concrete Flutter widget properties

**Critical**: Specs are partially generated. Modifying requires regeneration.

### 3. Modifier System

**Pattern**: Composable widget transformations.

**Location**: `packages/mix/lib/src/modifiers/`

**How it works**:
- Modifiers wrap widgets to apply transformations
- Chain via composition
- Applied during widget build phase

**Example**: Opacity, padding, transforms, etc.

### 4. Variant System

**Pattern**: Conditional style application.

**Location**: `packages/mix/lib/src/variants/`

**Types**:
- **NamedVariant**: User-defined variants (e.g., `outlined`, `primary`)
- **ContextVariant**: BuildContext-based (e.g., `$on.dark`, `$on.hover`)
- **MultiVariant**: Composite variants

**How it works**:
```dart
final style = Style(
  $box.color.black(),
  $on.dark($box.color.white()),  // Applies in dark mode
  onPressed($box.color.blue()),   // Applies when pressed
);
```

### 5. Style Composition

**Pattern**: Immutable style merging and resolution.

**Location**: `packages/mix/lib/src/style/`

**Recent Changes** (v2.0.0-dev.6):
- Introduced `Style.of()` and `Style.maybeOf()` static methods
- BaseStyle utility class for common patterns
- Unified SpecUtility, Style, and Attributes as compatible values

**How it works**:
- Styles are immutable collections of attributes
- Merge via `Style.combine()` or `+` operator
- Resolve during widget build with BuildContext

### 6. Code Generation

**Pattern**: Annotation-driven code generation for boilerplate reduction.

**Generator Location**: `packages/mix_generator/`

**Generated Code**:
- Spec implementations (`.spec.g.dart`)
- Utility classes (`.util.g.dart`)
- Attribute definitions

**Critical Workflow**:
1. Modify source with annotations
2. Run `melos run gen:build`
3. Never edit `.g.dart` files directly

## Current State & Recent Changes

### v2.0.0-dev.6 (Latest - Nov 4, 2025)

**Major Changes**:
- ✅ Refactored `Stack` and `StackBox`
- ✅ Introduced `Style.of()` and `Style.maybeOf()` static methods
- ✅ Implemented call method for `Stack` and `FlexBox`
- ✅ Added number directives and extension for numeric transformations

### Recent Architecture Evolution (v1.7.0 → v2.0)

**Breaking Changes**:
- Removed `SpecConfiguration` and `SpecStyle` from environment
- Removed `NestedStyleAttribute` (migrated to direct Style usage)
- Deprecated `MixWidgetStateController`
- Moved widget state handling from `MixBuilder` to `SpecBuilder`
- Replaced `MixWidgetState` with Flutter's `WidgetState`

**Improvements**:
- Builder optimization
- Unified attribute system
- Generated style-focused modifiers and specs
- Cleaner API surface

### Known Deprecations

Check for these when modifying code:
- ❌ `MixWidgetStateController` - deprecated
- ❌ Old styled widget names - deprecated in favor of new conventions
- ❌ `NestedStyleAttribute` - removed

## Development Workflows

### Adding a New Style Property

1. **Define annotation** in source file
2. **Run codegen**: `melos run gen:build`
3. **Create tests** for the property
4. **Add documentation** if public API
5. **Verify**: `melos run analyze && melos run ci`

### Modifying Generated Code

**Never edit `.g.dart` files**. Instead:

1. **Locate source**: Find the annotation or generator template
2. **Modify source**: Update annotation parameters or generator logic
3. **Regenerate**: `melos run gen:build`
4. **Verify output**: Check `.g.dart` files for expected changes
5. **Test**: Ensure tests pass with new generated code

### Adding a Widget Spec

1. **Create spec class** with appropriate annotations
2. **Define attributes** and resolution logic
3. **Run codegen**: `melos run gen:build`
4. **Test spec resolution** with various style combinations
5. **Document usage** patterns

### Working with Variants

1. **Define variant** (Named or Context)
2. **Test variant selection** in different contexts
3. **Ensure proper merging** behavior
4. **Document variant** purpose and usage

## Code Generation Details

### Triggered By

- `@MixableSpec()` - Generates spec implementations
- `@MixableProperty()` - Generates property utilities
- `@MixableUtility()` - Generates utility classes
- `@MixableDto()` - Generates data transfer objects

### Output Files

- `*.spec.g.dart` - Spec implementations
- `*.util.g.dart` - Utility functions
- `*.dto.g.dart` - DTO implementations

### Generator Entry Point

`packages/mix_generator/lib/src/builder.dart`

## Testing Strategy

### Unit Tests
- **Location**: `test/` in each package
- **Focus**: Attribute resolution, style merging, variant selection
- **Run**: `melos run test:flutter` or `melos run test:dart`

### Widget Tests
- **Location**: `packages/mix/test/`
- **Focus**: Widget rendering, modifier application, theme integration
- **Run**: `melos run test:flutter`

### Generator Tests
- **Location**: `packages/mix_generator/test/`
- **Focus**: Code generation output correctness
- **Run**: `melos run test:dart`

### Lint Tests
- **Location**: `packages/mix_lint/test/`
- **Focus**: Custom lint rule detection
- **Run**: `melos run test:dart`

## Common Patterns to Follow

### 1. Immutability

All style-related classes are immutable. Use `copyWith()` for modifications.

```dart
// Good
final newStyle = style.copyWith(color: Colors.red);

// Bad
style.color = Colors.red; // Won't compile
```

### 2. Null Safety

Mix fully embraces null safety. Use nullable types appropriately.

### 3. Type Safety

Leverage Dart's type system. Mix uses generics extensively for type-safe operations.

### 4. Builder Pattern

Many classes use builder pattern for construction:
```dart
final style = Style(
  $box.height(100),
  $box.width(100),
);
```

### 5. Fluent API

Mix prefers fluent, chainable APIs:
```dart
$box.padding.horizontal(20).vertical(10)
```

## Critical Files to Understand

| File | Purpose | Change Frequency |
|------|---------|------------------|
| `core/attribute.dart` | Attribute system foundation | Low |
| `core/styled_widget.dart` | Widget integration | Low |
| `style/style.dart` | Style composition | Medium |
| `specs/` | Widget specifications | High |
| `variants/variant.dart` | Variant system | Low |
| `modifiers/` | Widget modifiers | Medium |

## Breaking Change Policy

**v2.0 Development Phase**: Breaking changes are expected and documented in CHANGELOG.md.

**Pre-release versions**: No API stability guarantee.

**Stable releases**: Follow semantic versioning strictly.

## Integration Points

### Flutter Framework

- **Theme**: Integrates with `Theme.of(context)`
- **BuildContext**: Heavily context-dependent resolution
- **WidgetState**: Uses Flutter's standard `WidgetState`

### External Packages

- **build_runner**: Code generation
- **dart_code_metrics**: Static analysis
- **analyzer**: Dart analysis for custom lints

## Performance Considerations

1. **Style Resolution**: Happens during widget build - keep lean
2. **Caching**: Mix caches resolved styles where possible
3. **Immutability**: Enables efficient comparison and caching
4. **Build Runner**: Can be slow for large projects - use watch mode during dev

## Debugging Tips

### Style Not Applying

1. Check variant conditions are met
2. Verify attribute merge order (later attributes win)
3. Inspect with `Style.of(context)` to see resolved values

### Code Generation Issues

1. Clean and rebuild: `melos run gen:clean && melos run gen:build`
2. Check annotation parameters
3. Review generator error output

### Test Failures

1. Ensure code generation is current
2. Check for breaking changes in CHANGELOG
3. Verify test expectations match v2.0 API

## Resources

- **Architecture Docs**: https://fluttermix.com/docs
- **API Reference**: https://pub.dev/documentation/mix/latest/
- **Examples**: `packages/mix/example/`
- **Changelog**: `CHANGELOG.md`

## Current Priorities

Based on recent commits and v2.0.0-dev.6:

1. **API Stabilization**: Finalizing v2.0 API surface
2. **Performance**: Builder optimizations
3. **Developer Experience**: Improved utilities and directives
4. **Documentation**: Updating for v2.0 changes

## Questions to Ask When Modifying

1. **Does this require code generation?** If yes, run `melos run gen:build`
2. **Is this a breaking change?** If yes, document in CHANGELOG
3. **Does this affect multiple packages?** If yes, update all affected packages
4. **Are there tests?** If no, add them before implementing
5. **Is the existing pattern followed?** If no, understand why first

---

**Remember**: Mix is a styling _system_, not just a library. Changes should maintain system coherence, type safety, and composability principles.
