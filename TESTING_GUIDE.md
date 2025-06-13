# Mix Testing Guide

This guide provides comprehensive testing methodology for the Mix project, covering all aspects of testing from understanding the codebase to achieving comprehensive test coverage.

## Table of Contents
- [Overview](#overview)
- [Testing Philosophy](#testing-philosophy)
- [Project Structure](#project-structure)
- [Testing Strategy](#testing-strategy)
- [Test Organization](#test-organization)
- [Writing Tests](#writing-tests)
- [Mocking Strategy](#mocking-strategy)
- [Coverage Requirements](#coverage-requirements)
- [Running Tests](#running-tests)
- [Best Practices](#best-practices)
- [CI/CD Integration](#cicd-integration)

## Overview

Mix uses a systematic approach to testing that ensures code quality, maintainability, and reliability across all packages in the monorepo.

## Testing Philosophy

### Core Principles
- **KISS** (Keep It Simple, Stupid): Write simple, focused tests
- **YAGNI** (You Aren't Gonna Need It): Don't over-test or create unnecessary test infrastructure
- **DRY** (Don't Repeat Yourself): Use test utilities and patterns to avoid duplication

### Testing Pyramid
```
         /\
        /  \  Integration Tests (10%)
       /----\
      /      \  Widget Tests (30%)
     /--------\
    /          \  Unit Tests (60%)
   /____________\
```

## Project Structure

### Source Code Organization
```
packages/
├── mix/                 # Core styling system
├── remix/              # Pre-built UI components
├── mix_lint/           # Custom lint rules
├── mix_generator/      # Code generation
└── mix_annotations/    # Annotations
```

### Test Organization
Each package maintains its own test directory that mirrors the source structure:
```
test/
├── src/
│   ├── attributes/     # Attribute and DTO tests
│   ├── core/          # Core functionality tests
│   ├── modifiers/     # Widget modifier tests
│   ├── specs/         # Specification tests
│   ├── theme/         # Theme and token tests
│   ├── variants/      # Variant tests
│   └── widgets/       # Widget tests
└── helpers/           # Test utilities and mocks
```

## Testing Strategy

### 1. Unit Tests (Priority: HIGH)
Focus on testing individual components in isolation:
- Business logic
- Data models and DTOs
- Utility functions
- Attribute creation and resolution
- Theme token resolution

### 2. Widget Tests (Priority: MEDIUM)
Test widget behavior and rendering:
- Widget construction
- Property application
- User interactions
- State changes
- Theme integration

### 3. Integration Tests (Priority: LOW)
Test complete features end-to-end:
- Complex styling scenarios
- Theme switching
- Variant application across widget trees
- Performance-critical paths

## Test Organization

### File Naming Conventions
- Test files: `{source_file_name}_test.dart`
- Mock files: `{source_file_name}_test.mocks.dart`
- Helper files: `{functionality}_test_utils.dart`

### Test Structure Template
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

// Import test utilities
import '../../../helpers/testing_utils.dart';

void main() {
  group('ClassName', () {
    // Setup
    setUp(() {
      // Initialize test dependencies
    });

    tearDown(() {
      // Clean up
    });

    group('constructor', () {
      test('should initialize with default values', () {
        // Test default constructor behavior
      });

      test('should accept custom values', () {
        // Test parameterized constructor
      });
    });

    group('methods', () {
      test('methodName should behave correctly', () {
        // Arrange
        final instance = ClassName();
        
        // Act
        final result = instance.methodName();
        
        // Assert
        expect(result, expectedValue);
      });
    });

    group('edge cases', () {
      test('should handle null values gracefully', () {
        // Test null handling
      });

      test('should handle empty collections', () {
        // Test empty state handling
      });
    });
  });
}
```

## Writing Tests

### Test Patterns

#### 1. Attribute Testing Pattern
```dart
test('should create correct attribute', () {
  final attribute = $box.padding(16);
  
  expect(attribute, isA<BoxSpecAttribute>());
  expect(attribute.value.padding, EdgeInsets.all(16));
});

test('should merge attributes correctly', () {
  final attr1 = $box.padding(16);
  final attr2 = $box.margin(8);
  final merged = attr1.merge(attr2);
  
  expect(merged.value.padding, EdgeInsets.all(16));
  expect(merged.value.margin, EdgeInsets.all(8));
});
```

#### 2. Widget Testing Pattern
```dart
testWidgets('should apply style correctly', (tester) async {
  await tester.pumpMaterialApp(
    Box(
      style: Style(
        $box.color(Colors.blue),
        $box.padding(16),
      ),
      child: const Text('Test'),
    ),
  );

  final container = tester.widget<Container>(find.byType(Container));
  expect(container.color, Colors.blue);
  expect(container.padding, EdgeInsets.all(16));
});
```

#### 3. Theme Testing Pattern
```dart
test('should resolve theme tokens', () {
  final theme = MixThemeData(
    colors: {
      $primary: Colors.blue,
    },
  );
  
  final context = MockBuildContext(theme: theme);
  final resolved = $primary.resolve(context);
  
  expect(resolved, Colors.blue);
});
```

### Using Test Utilities

Mix provides comprehensive test utilities in `test/helpers/testing_utils.dart`:

```dart
// Mock context with theme
final context = MockBuildContext(
  theme: MixThemeData(...),
);

// Test with themed widget
await tester.pumpWithMixTheme(
  widget,
  theme: customTheme,
);

// Create test mix data
final mixData = MockMixData(
  style: Style(...),
);
```

## Mocking Strategy

### When to Mock
- External dependencies (APIs, databases)
- BuildContext for theme/media query access
- Complex widgets for isolated testing
- Time-sensitive operations

### Mock Guidelines
1. Use the provided mock utilities when possible
2. Create minimal mocks that only implement required functionality
3. Avoid over-mocking - prefer real objects when feasible
4. Document mock behavior clearly

### Example Mock Usage
```dart
// Using provided mocks
final mockContext = MockBuildContext();
final mockMixData = MockMixData();

// Creating custom mocks for specific tests
class MockCustomWidget extends StatelessWidget {
  final bool wasCalled;
  
  const MockCustomWidget({
    super.key,
    this.wasCalled = false,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```

## Coverage Requirements

### Coverage Targets by Layer
- **Core Components** (specs, attributes, core): 95%
- **Utilities and Helpers**: 90%
- **Modifiers and Variants**: 85%
- **Widgets**: 80%
- **Generated Code**: Excluded from coverage

### Measuring Coverage
```bash
# Generate coverage report
melos run test:coverage

# Generate HTML report
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html

# Check coverage for specific package
cd packages/mix
flutter test --coverage
```

### Coverage Exclusions
```bash
# Files to exclude from coverage
lcov --remove coverage/lcov.info \
  'lib/**/*.g.dart' \
  'lib/**/*.gen.dart' \
  'lib/**/generated/**' \
  -o coverage/lcov.info
```

## Running Tests

### Essential Commands
```bash
# Run all tests in monorepo
melos run test

# Run Flutter tests only
melos run test:flutter

# Run Dart tests only  
melos run test:dart

# Run tests with coverage
melos run test:coverage

# Run specific test file
flutter test test/src/specs/box/box_spec_test.dart

# Run tests in watch mode
flutter test --watch

# Run tests with specific name pattern
flutter test --name="should create"
```

### Test Organization Scripts
```bash
# Run tests by category
flutter test test/src/specs/        # All spec tests
flutter test test/src/attributes/   # All attribute tests
flutter test test/src/modifiers/    # All modifier tests
```

## Best Practices

### 1. Test Naming
- Use descriptive test names that explain what is being tested
- Follow the pattern: "should [expected behavior] when [condition]"
- Group related tests logically

### 2. Test Independence
- Each test should be independent and not rely on others
- Use `setUp` and `tearDown` for test initialization/cleanup
- Avoid shared mutable state between tests

### 3. Assertion Guidelines
- Use specific matchers (e.g., `isA<Type>()` instead of `isNotNull`)
- Test one concept per test
- Include edge cases and error conditions

### 4. Performance
- Keep tests fast - mock expensive operations
- Use `testWidgets` only when necessary
- Avoid unnecessary widget pumps

### 5. Maintenance
- Update tests when changing implementation
- Remove obsolete tests
- Refactor tests to use new utilities/patterns

### 6. Documentation
```dart
// Document complex test scenarios
/// Tests that theme tokens are correctly resolved when
/// multiple themes are nested in the widget tree.
/// 
/// This ensures that the closest theme ancestor provides
/// the token value, following Flutter's inheritance model.
test('should resolve tokens from nearest theme ancestor', () {
  // test implementation
});
```

## CI/CD Integration

### GitHub Actions Configuration
The project uses GitHub Actions for continuous testing:

```yaml
# .github/workflows/test.yml
name: Tests
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: melos bootstrap
      - run: melos run test:flutter
      - run: melos run analyze
```

### Pre-commit Hooks
Consider adding pre-commit hooks for local testing:
```bash
#!/bin/bash
# .git/hooks/pre-commit

# Run tests for changed packages
melos run test --scope="*changed*"
```

## Troubleshooting

### Common Issues

1. **Mock Generation Failures**
   ```bash
   # Regenerate mocks
   melos run gen:build
   ```

2. **Test Timeouts**
   ```dart
   // Increase timeout for complex tests
   test('complex operation', () async {
     // test code
   }, timeout: const Timeout(Duration(seconds: 10)));
   ```

3. **Widget Test Failures**
   ```dart
   // Ensure proper widget setup
   await tester.pumpWidget(
     MaterialApp(
       home: YourWidget(),
     ),
   );
   await tester.pumpAndSettle();
   ```

## Quick Reference

### Test Checklist
- [ ] Test follows naming conventions
- [ ] Test is independent and isolated
- [ ] Edge cases are covered
- [ ] Mocks are properly set up
- [ ] Test uses appropriate utilities
- [ ] Coverage targets are met
- [ ] Documentation is clear

### Common Test Patterns
```dart
// Testing equality
expect(obj1, equals(obj2));

// Testing types
expect(result, isA<ExpectedType>());

// Testing exceptions
expect(() => dangerousOperation(), throwsException);

// Testing async operations
expect(futureOperation(), completes);
expect(futureOperation(), completion(equals(expected)));

// Widget testing
expect(find.text('Hello'), findsOneWidget);
expect(find.byType(Container), findsNWidgets(2));
```

## Contributing

When contributing tests:
1. Follow this guide's conventions
2. Ensure new code has appropriate test coverage
3. Run all tests before submitting PR
4. Update test documentation as needed

For questions or improvements to this guide, please open an issue or PR.