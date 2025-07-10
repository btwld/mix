# DTO and Utility Test Reorganization Plan

## Current Problems (What Actually Needs Fixing)

1. **Scattered Tests**: DTO and utility tests are spread across 15+ directories
2. **Repeated Patterns**: Same basic tests (merge, resolve, equality) copied everywhere
3. **Hard to Run Groups**: Can't easily run "all DTO tests" or "all utility tests"
4. **No Shared Helpers**: Common assertions duplicated across files

## KISS Solution (Keep It Simple)

### Phase 1: Simple File Reorganization
Move tests into logical groups WITHOUT changing test code:

```
test/
├── src/
│   ├── dto/                     # All DTO tests
│   │   ├── border_dto_test.dart
│   │   ├── text_style_dto_test.dart
│   │   ├── decoration_dto_test.dart
│   │   └── ... (all other DTOs)
│   │
│   ├── utilities/               # All utility tests
│   │   ├── border_util_test.dart
│   │   ├── text_style_util_test.dart
│   │   └── ... (all other utils)
│   │
│   └── ... (keep other tests where they are)
```

**Benefits:**
- Can run `flutter test test/src/dto` for all DTO tests
- Can run `flutter test test/src/utilities` for all utility tests
- No code changes needed, just file moves

### Phase 2: Extract Simple Helpers (Only What's Actually Repeated)

Create ONE simple helper file:

```dart
// test/helpers/dto_helpers.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

/// Common DTO test helpers - only the stuff we actually repeat
class DtoTestHelpers {
  /// Test basic merge behavior (used in EVERY DTO test)
  static void testMergeWithNull<T extends Mix>(
    String dtoName,
    T dto,
  ) {
    test('$dtoName merges with null returns self', () {
      final merged = dto.merge(null);
      expect(merged, equals(dto));
    });
  }
  
  /// Test that two different DTOs are not equal (common pattern)
  static void testInequality<T>(
    String dtoName,
    T dto1,
    T dto2,
  ) {
    test('$dtoName with different values are not equal', () {
      expect(dto1, isNot(equals(dto2)));
    });
  }
  
  /// Test resolve doesn't throw (basic smoke test)
  static void testResolveDoesntThrow<T extends Mix>(
    String dtoName,
    T dto,
  ) {
    test('$dtoName resolves without throwing', () {
      expect(() => dto.resolve(EmptyMixData), returnsNormally);
    });
  }
}
```

### Phase 3: Update Tests to Use Helpers (Incrementally)

Example of updating BorderDto test:

```dart
// BEFORE: 
test('merge with null returns self', () {
  final dto = BorderDto(top: BorderSideDto(width: 1.0));
  final merged = dto.merge(null);
  expect(merged, equals(dto));
});

// AFTER:
DtoTestHelpers.testMergeWithNull(
  'BorderDto',
  BorderDto(top: BorderSideDto(width: 1.0)),
);
```

## What We're NOT Doing (YAGNI)

1. ❌ **No abstract base classes** - Too complex, not needed
2. ❌ **No test generators** - Overkill for ~15 files
3. ❌ **No complex inheritance** - Keep tests flat and simple
4. ❌ **No fancy matchers** - Flutter's built-in matchers work fine
5. ❌ **No forced standardization** - Let each DTO keep its specific tests

## Implementation Steps

### Step 1: Move Files (30 minutes)
```bash
# Create directories
mkdir -p test/src/dto
mkdir -p test/src/utilities

# Move DTO tests
mv test/src/attributes/*/border_dto_test.dart test/src/dto/
mv test/src/attributes/*/text_style_dto_test.dart test/src/dto/
# ... etc

# Move utility tests  
mv test/src/attributes/*/border_util_test.dart test/src/utilities/
# ... etc
```

### Step 2: Create Simple Helper (15 minutes)
- Create `test/helpers/dto_helpers.dart` with 3-4 helper methods
- Only extract the MOST repeated patterns

### Step 3: Update Imports (1 hour)
- Fix import paths after moving files
- Run tests to ensure nothing broke

### Step 4: Gradually Use Helpers (Optional, ongoing)
- When touching a test, update it to use helpers
- Don't update all at once - not worth the time

## Success Metrics

✅ Can run all DTO tests with one command  
✅ Can run all utility tests with one command  
✅ No duplicated test helpers  
✅ Tests still readable and simple  
✅ Minimal code changes  

## Why This Approach?

1. **Minimal Risk**: Just moving files, not rewriting tests
2. **Immediate Benefit**: Better organization right away
3. **Incremental**: Can stop at any phase
4. **Simple**: Anyone can understand the structure
5. **Practical**: Solves the actual problems without over-engineering

## Questions to Answer Before Starting

1. Is the team OK with moving test files?
2. Should we keep the current directory structure instead?
3. Are there CI/CD scripts that depend on current test locations?
4. Is it worth the git history disruption?

## Alternative: Even Simpler

If moving files is too disruptive, just create test suite files:

```dart
// test/suites/all_dto_tests.dart
import '../src/attributes/border/border_dto_test.dart' as border;
import '../src/attributes/text_style/text_style_dto_test.dart' as text;
// ... more imports

void main() {
  group('All DTO Tests', () {
    border.main();
    text.main();
    // ... etc
  });
}
```

Then run with: `flutter test test/suites/all_dto_tests.dart`

This requires NO file moves and gives us grouped test execution.