# AI Slop Detector

A collection of lint rules designed to detect common patterns in AI-generated code that look correct but cause problems in production.

## Philosophy

AI-generated code has specific failure modes that differ from human-written bugs:

1. **Confident wrongness** - Code looks professional and compiles, but fails at runtime
2. **Pattern mimicry** - Follows patterns from training data that don't fit the actual context
3. **Over-engineering** - Applies enterprise patterns to simple problems
4. **Test theater** - Tests that pass but verify nothing meaningful

The goal is to find the dangerous things that slip past normal review because they look correct.

## Rules

### Comment Anti-patterns (Medium Severity)

#### `ai_slop_obvious_comments`
Detects comments that merely restate what the code already expresses.

```dart
// BAD
counter++;  // Increment counter
return result;  // Return the result

// GOOD
// Apply rate limiting to prevent abuse
counter++;
```

#### `ai_slop_hedging_comments`
Detects comments indicating uncertainty that should be resolved.

```dart
// BAD
// This should work
// Hopefully this fixes the issue
// I think this is correct

// GOOD: Verify the code works correctly instead of hedging
```

#### `ai_slop_placeholder_comments`
Detects TODO/FIXME comments indicating incomplete code.

```dart
// BAD
// TODO: implement
// FIXME: handle edge case
// NOTE: temporary solution

// GOOD: Complete the implementation before merging
```

#### `ai_slop_over_documentation`
Detects excessive documentation for trivial code.

```dart
// BAD
/// Adds two numbers together.
/// @param a - The first number to add
/// @param b - The second number to add
/// @returns The sum of a and b
int add(int a, int b) => a + b;

// GOOD: Let self-explanatory code speak for itself
int add(int a, int b) => a + b;
```

### Test Theater (Critical Severity)

#### `ai_slop_empty_test_body`
Detects tests with no assertions or meaningful verification.

```dart
// BAD
test('should process data', () {
  processData(input);
  // No assertion - test passes without verifying anything!
});

// GOOD
test('should process data', () {
  final result = processData(input);
  expect(result.isValid, isTrue);
  expect(result.items, hasLength(3));
});
```

#### `ai_slop_tautological_assertion`
Detects assertions that always pass.

```dart
// BAD
expect(true, isTrue);
expect(1, equals(1));
assert(true);

// GOOD
expect(calculator.add(2, 3), equals(5));
```

### Error Handling Theater (High Severity)

#### `ai_slop_silent_catch`
Detects empty catch blocks that swallow exceptions.

```dart
// BAD
try {
  riskyOperation();
} catch (e) {
  // Swallows all errors silently!
}

// GOOD
try {
  riskyOperation();
} catch (e) {
  logger.error('Failed to perform operation', error: e);
  rethrow;
}
```

#### `ai_slop_generic_exception`
Detects generic exception messages that don't help debugging.

```dart
// BAD
throw Exception('An error occurred');
throw Exception('Something went wrong');

// GOOD
throw InvalidUserInputException(
  'Email validation failed: $email does not match pattern',
);
```

#### `ai_slop_overbroad_catch`
Detects catch-all exception handling that hides bugs.

```dart
// BAD
try {
  parseUserData(input);
} catch (e) {
  return null;  // Hides all errors including programmer mistakes
}

// GOOD
try {
  parseUserData(input);
} on FormatException catch (e) {
  logger.warn('Invalid input format', error: e);
  return null;
}
```

### Dead Code (Medium Severity)

#### `ai_slop_unreachable_code`
Detects code after return/throw statements.

```dart
// BAD
void process() {
  return result;
  cleanupResources();  // Never executes!
}

// GOOD
void process() {
  cleanupResources();
  return result;
}
```

#### `ai_slop_commented_code`
Detects large blocks of commented-out code.

```dart
// BAD
// void oldImplementation() {
//   doSomething();
//   doSomethingElse();
// }

// GOOD: Delete the code. Use version control to recover it if needed.
```

#### `ai_slop_unused_parameter`
Detects function parameters that are never used.

```dart
// BAD
void processData(String data, int unused, bool alsoUnused) {
  print(data);
  // unused and alsoUnused are never referenced!
}

// GOOD
void processData(String data) {
  print(data);
}
```

### Structural Issues (High/Medium Severity)

#### `ai_slop_god_class`
Detects classes with too many members.

**Configuration:**
```yaml
custom_lint:
  rules:
    - ai_slop_god_class:
        max_methods: 20
        max_fields: 15
```

#### `ai_slop_long_function`
Detects functions that are too long.

**Configuration:**
```yaml
custom_lint:
  rules:
    - ai_slop_long_function:
        max_lines: 100
        max_lines_error: 200
```

#### `ai_slop_deep_nesting`
Detects code with excessive nesting depth.

```dart
// BAD
if (a) {
  if (b) {
    if (c) {
      if (d) {
        if (e) {
          // Way too deep!
        }
      }
    }
  }
}

// GOOD: Use early returns and extract functions
if (!a) return;
if (!b) return;
if (!c) return;
processDE();
```

**Configuration:**
```yaml
custom_lint:
  rules:
    - ai_slop_deep_nesting:
        max_depth: 4
```

## Configuration

Add to your `analysis_options.yaml`:

```yaml
analyzer:
  plugins:
    - custom_lint

custom_lint:
  rules:
    # Enable all AI slop detection with defaults
    - ai_slop_obvious_comments
    - ai_slop_hedging_comments
    - ai_slop_placeholder_comments
    - ai_slop_over_documentation
    - ai_slop_empty_test_body
    - ai_slop_tautological_assertion
    - ai_slop_silent_catch
    - ai_slop_generic_exception
    - ai_slop_overbroad_catch
    - ai_slop_unreachable_code
    - ai_slop_commented_code
    - ai_slop_unused_parameter
    - ai_slop_god_class:
        max_methods: 20
        max_fields: 15
    - ai_slop_long_function:
        max_lines: 100
    - ai_slop_deep_nesting:
        max_depth: 4
```

## Severity Levels

### Critical (Fix immediately)
- `ai_slop_empty_test_body` - False test confidence
- `ai_slop_tautological_assertion` - Tests that verify nothing
- `ai_slop_silent_catch` - Hidden failures

### High (Fix before merge)
- `ai_slop_generic_exception` - Poor error messages
- `ai_slop_overbroad_catch` - Hidden bugs
- `ai_slop_god_class` - Unmaintainable code
- `ai_slop_long_function` - Complex functions

### Medium (Fix in this sprint)
- `ai_slop_obvious_comments` - Code clutter
- `ai_slop_hedging_comments` - Uncertainty markers
- `ai_slop_placeholder_comments` - Incomplete code
- `ai_slop_unreachable_code` - Dead code
- `ai_slop_commented_code` - Dead code
- `ai_slop_unused_parameter` - Confusing API
- `ai_slop_deep_nesting` - Complex logic
- `ai_slop_over_documentation` - Documentation noise
