# CLAUDE.md

## Project Overview

**Mix** is a styling framework for Flutter providing utility-first, composable widget styling.

- **Docs**: https://fluttermix.com | **Pub**: https://pub.dev/packages/mix
- **Version**: 2.0.0-rc.0
- **Requirements**: Flutter ≥ 3.38.1, Dart SDK ≥ 3.10.0

## Repository Structure

Melos-managed monorepo:

```
packages/
├── mix/                 # Core styling package
├── mix_annotations/     # Code generation annotations
├── mix_generator/       # Spec/Dto code generator
└── mix_lint/            # Custom lint rules
```

Other directories: `examples/`, `guides/`, `website/`, `scripts/`

## Quick Start

```bash
fvm use                 # Use correct Flutter version
melos bootstrap         # Install all dependencies
```

## Essential Commands

| Command | Purpose |
|---------|---------|
| `melos run ci` | Run all tests |
| `melos run analyze` | Static analysis (Dart + DCM) |
| `melos run fix` | Auto-fix lint issues |
| `melos run gen:build` | Generate code |
| `melos run gen:clean` | Clean generated files |

## Architecture

### Core Concepts

- **Spec** - Immutable resolved styling (e.g., `BoxSpec`)
- **Style/Styler** - Fluent API for building styles (e.g., `BoxStyler`)
- **Mix** - Base class for composable, resolvable types
- **Prop** - Property wrapper handling values, tokens, and Mix types
- **Variants** - Conditional styling (NamedVariant, ContextVariant, WidgetStateVariant)

### Widget Mapping

| Widget | Styler | Spec |
|--------|--------|------|
| `Box` | `BoxStyler` | `BoxSpec` |
| `FlexBox` | `FlexBoxStyler` | `FlexBoxSpec` |
| `StackBox` | `StackBoxStyler` | `StackBoxSpec` |
| `StyledText` | `TextStyler` | `TextSpec` |
| `StyledIcon` | `IconStyler` | `IconSpec` |
| `StyledImage` | `ImageStyler` | `ImageSpec` |

## Code Conventions

### File Locations

- Stylers: `packages/mix/lib/src/specs/{widget}/{widget}_style.dart`
- Specs: `packages/mix/lib/src/specs/{widget}/{widget}_spec.dart`
- Widgets: `packages/mix/lib/src/specs/{widget}/{widget}_widget.dart`
- Mix types: `packages/mix/lib/src/properties/{category}/{property}_mix.dart`

### Naming Patterns

- `{Widget}Styler` with alias `{Widget}Mix` (e.g., `BoxStyler`, `BoxMix`)
- `{Widget}Spec` for resolved specs
- `$` prefix for internal fields (e.g., `$padding`, `$decoration`)

### IMPORTANT Conventions

- **Use relative imports** within packages (enforced by linter)
- **Prefer fluent chaining**: `BoxStyler().color(Colors.blue).height(100)`
- **Use merge() for composition**: `base.merge(elevated)`
- **Dot-shorthands enabled**: Project uses `enable-experiment: dot-shorthands`

## Testing

### Test Utilities (`packages/mix/test/helpers/testing_utils.dart`)

- `MockBuildContext` - Testing without widget tree
- `resolvesTo(expected)` - Matcher for Prop/Mix resolution
- `tester.pumpWithMixScope(widget)` - Widget test helper

### Test Organization

- Tests mirror source structure: `packages/mix/test/src/`
- Each source file has corresponding `_test.dart`

## Common Patterns

### Creating New Spec/Style

1. Create Spec class extending `Spec<T>` in `specs/{widget}/{widget}_spec.dart`
2. Create Style class extending `Style<T>` with mixins in `specs/{widget}/{widget}_style.dart`
3. Create widget in `specs/{widget}/{widget}_widget.dart`
4. Add exports to `packages/mix/lib/mix.dart`

### Available Style Mixins

`SpacingStyleMixin`, `BorderStyleMixin`, `BorderRadiusStyleMixin`, `DecorationStyleMixin`, `ConstraintStyleMixin`, `AnimationStyleMixin`, `TransformStyleMixin`, `VariantStyleMixin`, `WidgetStateVariantMixin`

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Code gen not working | `melos run gen:clean && melos run gen:build` |
| FVM version mismatch | `fvm use` |
| Analysis errors | Ensure relative imports, run `melos run analyze` |
| Context errors in tests | Use `MockBuildContext` or `pumpWithMixScope` |

## Resources

- [API Composition Guide](guides/api-composition-guidelines.md)
- [Examples](examples/)
- [Mix Lint Rules](packages/mix_lint/README.md)
- [Code Generator](packages/mix_generator/README.md)
