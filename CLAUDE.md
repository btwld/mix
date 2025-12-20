# CLAUDE.md

This document provides comprehensive guidance for AI assistants working with the Mix codebase.

## Project Overview

**Mix** is a styling framework for Flutter that provides a utility-first, composable approach to styling widgets. It separates style semantics from widgets while maintaining an intuitive relationship between them.

- **Documentation**: https://fluttermix.com
- **Repository**: https://github.com/btwld/mix
- **Package**: https://pub.dev/packages/mix
- **Current Version**: 2.0.0-rc.0

### Key Features

- Fluent, chainable API for defining styles (`BoxStyler().color(Colors.red).height(100)`)
- First-class variant support for conditional/responsive styling
- Design tokens and theming system
- BuildContext-aware style resolution
- Animation support built-in
- Optimized for Dart's dot notation syntax (requires Dart SDK ≥ 3.10.0)

## Repository Structure

This is a **Melos-managed monorepo** with the following structure:

```
mix/
├── packages/
│   ├── mix/                 # Core styling package
│   ├── mix_annotations/     # Annotations for code generation
│   ├── mix_generator/       # Code generation for Spec/Dto classes
│   └── mix_lint/            # Custom lint rules for Mix
├── examples/                # Example Flutter app with Mix demos
├── guides/                  # API composition guidelines
├── website/                 # Documentation website
├── scripts/                 # Build and utility scripts
└── melos.yaml               # Monorepo configuration
```

### Package Dependencies

```
mix_annotations ← mix_generator ← mix
                                    ↑
                              mix_lint
```

## Core Architecture Concepts

### Spec Classes

Final resolved form of styling attributes. Immutable data classes that hold concrete values.

```dart
// packages/mix/lib/src/specs/box/box_spec.dart
class BoxSpec extends Spec<BoxSpec> {
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? padding;
  // ...
}
```

### Style/Styler Classes

Style classes that can be resolved to Specs. Provide the fluent API for building styles.

```dart
// BoxStyler (alias: BoxMix) provides chainable methods
final style = BoxStyler()
    .color(Colors.purple)
    .height(100)
    .borderRounded(12)
    .paddingAll(16);
```

### Mix Base Class

Base class for composable, resolvable types that support merging.

```dart
abstract class Mix<V> extends Mixable<V> implements Resolvable<V> {
  V resolve(BuildContext context);
  Mix<V> merge(covariant Mix<V>? other);
}
```

### Prop System

Property wrappers that handle values, tokens, and nested Mix types:

```dart
// Properties use Prop<T> for flexible value resolution
final Prop<EdgeInsetsGeometry>? $padding;
final Prop<Decoration>? $decoration;
```

### Variants

Three types of conditional styling:

1. **NamedVariant** - Manual variants applied explicitly
2. **ContextVariant** - Auto-apply based on BuildContext conditions
3. **WidgetStateVariant** - Based on widget states (hover, pressed, focused)

```dart
// Widget state variants
final buttonStyle = BoxStyler()
    .color(Colors.blue)
    .onHovered(BoxStyler().color(Colors.blue.shade700))
    .onPressed(BoxStyler().color(Colors.blue.shade900));

// Context variants
final style = BoxStyler()
    .color(Colors.black)
    .onDark(BoxStyler().color(Colors.white));
```

### Design Tokens

Type-safe design tokens for consistent theming:

```dart
final $primaryColor = ColorToken('primary');

MixScope(
  tokens: {$primaryColor: Colors.blue},
  child: Box(style: BoxStyler().color($primaryColor())),
);
```

## Development Workflows

### Prerequisites

- **Flutter**: ≥ 3.38.1 (managed via FVM)
- **Dart SDK**: ≥ 3.10.0
- **Melos**: Installed globally (`dart pub global activate melos`)

### Initial Setup

```bash
# Install FVM (if not already installed)
dart pub global activate fvm

# Use the correct Flutter version
fvm use

# Bootstrap the workspace
melos bootstrap
```

### Common Commands

| Command | Description |
|---------|-------------|
| `melos bootstrap` | Install dependencies for all packages |
| `melos run test:flutter` | Run Flutter tests |
| `melos run test:dart` | Run Dart tests |
| `melos run ci` | Run all tests (CI pipeline) |
| `melos run analyze` | Run static analysis (Dart + DCM) |
| `melos run fix` | Auto-fix lint issues |
| `melos run gen:build` | Generate code (build_runner) |
| `melos run gen:watch` | Watch mode for code generation |
| `melos run gen:clean` | Clean generated files |
| `melos run exports` | Generate barrel exports for mix package |
| `melos run api-check` | Check API compatibility |

### Code Generation

The project uses `build_runner` for code generation (primarily in `mix_generator`):

```bash
# Generate all code
melos run gen:build

# Watch mode during development
melos run gen:watch

# Clean and regenerate
melos run gen:clean && melos run gen:build
```

### Testing

```bash
# Run all tests
melos run ci

# Run with coverage
melos run test:coverage

# Run specific package tests
cd packages/mix && flutter test
```

### Analysis & Linting

```bash
# Full analysis
melos run analyze

# Dart analysis only
melos run analyze:dart

# DCM (Dart Code Metrics) analysis
melos run analyze:dcm

# Apply fixes
melos run lint:fix:all
```

## Code Conventions

### File Organization

- **Styler classes**: `packages/mix/lib/src/specs/{widget}/{widget}_style.dart`
- **Spec classes**: `packages/mix/lib/src/specs/{widget}/{widget}_spec.dart`
- **Widget implementations**: `packages/mix/lib/src/specs/{widget}/{widget}_widget.dart`
- **Mix types for properties**: `packages/mix/lib/src/properties/{category}/{property}_mix.dart`
- **Utility classes**: `packages/mix/lib/src/properties/{category}/{property}_util.dart`

### Naming Conventions

- **Styler classes**: `{Widget}Styler` (e.g., `BoxStyler`, `TextStyler`)
- **Type aliases**: `{Widget}Mix` as alias to Styler (e.g., `typedef BoxMix = BoxStyler;`)
- **Spec classes**: `{Widget}Spec` (e.g., `BoxSpec`, `TextSpec`)
- **Mix classes**: `{Type}Mix` (e.g., `EdgeInsetsGeometryMix`, `DecorationMix`)
- **Internal fields**: Prefix with `$` (e.g., `$padding`, `$alignment`)

### API Design Patterns

#### Fluent Chaining

Prefer fluent method chaining over constructor parameters:

```dart
// Preferred
final style = BoxStyler()
    .height(100)
    .width(200)
    .color(Colors.blue);

// Less preferred for everyday usage
final style = BoxStyler(
  constraints: BoxConstraintsMix.tight(100, 200),
  decoration: DecorationMix.color(Colors.blue),
);
```

#### Merging for Composition

Use `merge()` when combining reusable style fragments:

```dart
final base = BoxStyler().padding(EdgeInsetsMix.all(16));
final elevated = BoxStyler().borderRadius(BorderRadiusMix.circular(12));
final card = base.merge(elevated);
```

### Import Style

- Use **relative imports** within packages
- The linter enforces `prefer_relative_imports: true`

### Analysis Options

The project uses Dart's experimental dot-shorthands feature:

```yaml
# analysis_options.yaml
analyzer:
  enable-experiment:
    - dot-shorthands
```

## Testing Patterns

### Test Utilities

Located in `packages/mix/test/helpers/testing_utils.dart`:

```dart
// MockBuildContext for testing without widget tree
final context = MockBuildContext(tokens: {colorToken: Colors.red});

// resolvesTo matcher for testing Prop/Mix resolution
expect(boxStyle.$padding, resolvesTo(EdgeInsets.all(16)));

// Widget tester extensions
await tester.pumpWithMixScope(widget, tokens: {...});
```

### Test File Organization

- Tests mirror the source structure under `packages/mix/test/src/`
- Each source file should have a corresponding `_test.dart` file

### Test Naming

```dart
group('BoxStyler', () {
  test('merges padding correctly', () {
    // ...
  });

  test('resolves decoration with context', () {
    // ...
  });
});
```

## Widget Inventory

| Widget | Styler | Spec | Description |
|--------|--------|------|-------------|
| `Box` | `BoxStyler` | `BoxSpec` | Styled container (like Container) |
| `FlexBox` | `FlexBoxStyler` | `FlexBoxSpec` | Flex container with box styling |
| `StackBox` | `StackBoxStyler` | `StackBoxSpec` | Stack with box styling |
| `StyledText` | `TextStyler` | `TextSpec` | Styled text widget |
| `StyledIcon` | `IconStyler` | `IconSpec` | Styled icon widget |
| `StyledImage` | `ImageStyler` | `ImageSpec` | Styled image widget |
| `Pressable` | - | - | Interactive widget with state tracking |

## Common Patterns

### Creating a New Spec/Style

1. Create the Spec class extending `Spec<T>`
2. Create the Style class extending `Style<T>` with appropriate mixins
3. Create the widget that uses the spec
4. Add exports to `packages/mix/lib/mix.dart`

### Adding Widget State Variants

```dart
class MyStyler extends Style<MySpec>
    with WidgetStateVariantMixin<MyStyler, MySpec> {
  // Automatically gets onHovered, onPressed, onFocused, etc.
}
```

### Using Style Mixins

Common mixins for adding styling capabilities:

- `SpacingStyleMixin` - padding/margin methods
- `BorderStyleMixin` - border methods
- `BorderRadiusStyleMixin` - borderRadius methods
- `DecorationStyleMixin` - decoration methods
- `ConstraintStyleMixin` - size/constraint methods
- `AnimationStyleMixin` - animate method
- `TransformStyleMixin` - transform methods
- `VariantStyleMixin` - variant support

## CI/CD

### GitHub Workflows

- **test.yml**: Runs on push/PR to main/next branches
- **publish.yml**: Publishes to pub.dev on version tags
- **changelog.yml**: Validates changelog updates
- **title_validation.yml**: Validates PR titles

### Publishing

1. Update version in package `pubspec.yaml`
2. Update `CHANGELOG.md`
3. Create and push a git tag: `v{version}` (e.g., `v2.0.0-rc.0`)
4. GitHub Actions will publish to pub.dev

## Troubleshooting

### Common Issues

1. **Code generation not working**: Run `melos run gen:clean && melos run gen:build`
2. **FVM version mismatch**: Run `fvm use` to switch to project's Flutter version
3. **Analysis errors after changes**: Ensure imports are relative and run `melos run analyze`
4. **Tests failing with context errors**: Use `MockBuildContext` or `pumpWithMixScope`

### Debugging Code Generators

```bash
# VS Code: Use "Debug build_runner" launch configuration
# or manually:
dart --enable-vm-service=8888 --pause-isolates-on-start \
  run build_runner build --verbose
```

## Resources

- [Mix Documentation](https://fluttermix.com/docs)
- [API Composition Guide](guides/api-composition-guidelines.md)
- [Examples Directory](examples/)
- [Mix Lint Rules](packages/mix_lint/README.md)
- [Code Generator Usage](packages/mix_generator/README.md)
