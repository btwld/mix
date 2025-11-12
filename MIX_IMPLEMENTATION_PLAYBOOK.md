# Mix Framework - Implementation Playbook

**A practical guide for developers implementing the 51 audit fixes**

---

## Quick Start Guide

### For Sprint Leads

1. **Sprint Planning Day:**
   - Review this playbook's section for your sprint
   - Assign tasks from the task matrix
   - Set up tracking board with columns: To Do, In Progress, Review, Done
   - Schedule mid-sprint sync and retrospective

2. **Daily:**
   - Run standup (15 min)
   - Update progress in tracking spreadsheet
   - Unblock developers
   - Monitor test pass rates

3. **Sprint End:**
   - Verify all definition-of-done criteria met
   - Run retrospective
   - Prepare demo for stakeholders

### For Developers

1. **Starting a Task:**
   - Read the issue details in CODE_AUDIT_REPORT.md
   - Follow the implementation pattern for that issue type
   - Create feature branch: `fix/issue-N-short-description`
   - Write failing tests first (TDD approach)

2. **During Development:**
   - Commit frequently with descriptive messages
   - Run tests after each change
   - Update documentation as you go
   - Ask for help early if blocked

3. **Completing a Task:**
   - Ensure all tests pass
   - Run linters and formatters
   - Update CHANGELOG.md
   - Create PR with template
   - Request code review

---

## Implementation Patterns

### Pattern 1: Fixing Null Pointer Exceptions

**Template for Issues: #2, #18**

```dart
// BEFORE (Unsafe)
List<WidgetModifier>? lerp(double t) {
  if (end != null) {
    final thisModifiers = begin!;  // ❌ Can crash
    final otherModifiers = end!;
    // ...
  }
}

// AFTER (Safe)
List<WidgetModifier>? lerp(double t) {
  // Step 1: Handle null cases explicitly
  if (end == null && begin == null) return null;
  if (end == null) return begin;
  if (begin == null) return end;

  // Step 2: Now safe to use non-null assertion
  final thisModifiers = begin!;
  final otherModifiers = end!;
  // ... rest of logic
}
```

**Testing Pattern:**
```dart
group('lerp null safety', () {
  test('returns null when both are null', () {
    final result = lerp(null, null, 0.5);
    expect(result, isNull);
  });

  test('returns begin when end is null', () {
    final begin = [...];
    final result = lerp(begin, null, 0.5);
    expect(result, equals(begin));
  });

  test('returns end when begin is null', () {
    final end = [...];
    final result = lerp(null, end, 0.5);
    expect(result, equals(end));
  });

  test('interpolates when both non-null', () {
    final begin = [...];
    final end = [...];
    final result = lerp(begin, end, 0.5);
    expect(result, isNotNull);
    // ... verify interpolation logic
  });
});
```

---

### Pattern 2: Fixing Unsafe Type Casts

**Template for Issues: #5, #6**

```dart
// BEFORE (Unsafe)
if (mixValues.isEmpty) {
  resolvedValue = values.last as V;  // ❌ Can crash
}

// AFTER (Safe with validation)
if (mixValues.isEmpty) {
  final lastValue = values.last;

  // Step 1: Validate type before casting
  if (lastValue is! V) {
    throw FlutterError.fromParts([
      ErrorSummary('Type mismatch in Prop<$V> resolution'),
      ErrorDescription(
        'Expected value of type $V but got ${lastValue.runtimeType}'
      ),
      ErrorHint('Check that the prop value is of the correct type'),
    ]);
  }

  // Step 2: Safe to assign (type already checked)
  resolvedValue = lastValue;
}
```

**Alternative Pattern (Graceful Fallback):**
```dart
if (mixValues.isEmpty) {
  final lastValue = values.last;

  // Try cast, use default on failure
  resolvedValue = lastValue is V
    ? lastValue
    : _defaultValue;  // or throw, depending on requirements
}
```

**Testing Pattern:**
```dart
group('type cast safety', () {
  test('accepts valid type', () {
    final prop = Prop<int>([1, 2, 3]);
    expect(() => prop.resolve(), returnsNormally);
  });

  test('throws on invalid type', () {
    final prop = Prop<int>(['wrong']);  // String instead of int
    expect(
      () => prop.resolve(),
      throwsA(isA<FlutterError>().having(
        (e) => e.toString(),
        'message',
        contains('Expected value of type int but got String'),
      )),
    );
  });
});
```

---

### Pattern 3: Fixing Memory Leaks

**Template for Issue: #4**

```dart
// BEFORE (Leaks)
class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(...);

    // ❌ Anonymous listener never removed
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // do something
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

// AFTER (No leak)
class _MyWidgetState extends State<MyWidget> {
  late AnimationController _controller;
  AnimationStatusListener? _statusListener;  // Step 1: Store reference

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(...);
    _setupAnimation();
  }

  void _setupAnimation() {
    // Step 2: Remove old listener if exists
    if (_statusListener != null) {
      _controller.removeStatusListener(_statusListener!);
    }

    // Step 3: Create and store listener
    _statusListener = (status) {
      if (status == AnimationStatus.completed) {
        // do something
      }
    };

    // Step 4: Add listener
    _controller.addStatusListener(_statusListener!);
  }

  @override
  void dispose() {
    // Step 5: Clean up listener before disposing controller
    if (_statusListener != null) {
      _controller.removeStatusListener(_statusListener!);
      _statusListener = null;
    }
    _controller.dispose();
    super.dispose();
  }
}
```

**Testing Pattern:**
```dart
testWidgets('animation listener is cleaned up', (tester) async {
  // Build widget
  await tester.pumpWidget(MyWidget());

  // Get initial memory baseline
  final initialMemory = await getMemoryUsage();

  // Rebuild widget many times
  for (int i = 0; i < 1000; i++) {
    await tester.pumpWidget(Container());
    await tester.pumpWidget(MyWidget());
  }

  // Force garbage collection
  await tester.runAsync(() async {
    await Future.delayed(Duration(milliseconds: 100));
  });

  // Memory should not have grown significantly
  final finalMemory = await getMemoryUsage();
  expect(finalMemory - initialMemory, lessThan(1024 * 1024)); // < 1MB growth
});
```

---

### Pattern 4: Removing Dead Code

**Template for Issues: #11, #19**

**Step-by-Step Process:**

```bash
# Step 1: Verify code is truly unused
rg "ColorProp" --type dart
# Should return 0 results outside the file itself

# Step 2: Check for dynamic imports
rg "color_mix.dart" --type dart
# Should return 0 results

# Step 3: Check pub.dev dependencies
# Search pub.dev for packages importing this code
# Contact maintainers if needed

# Step 4: Create backup branch
git checkout -b backup/dead-code-removal
git push origin backup/dead-code-removal

# Step 5: Delete file
git rm packages/mix/lib/src/properties/painting/color_mix.dart

# Step 6: Run tests
dart test

# Step 7: Check for compilation errors
dart analyze

# Step 8: Commit with descriptive message
git commit -m "refactor: remove unused ColorProp class

- Removed 203 lines of commented-out code
- Class was never used in codebase
- Verified no external dependencies via pub.dev

Issue: #11.2"
```

**Verification Checklist:**
- [ ] No import statements found
- [ ] No dynamic references found
- [ ] No external dependencies on pub.dev
- [ ] All tests pass
- [ ] No analyzer warnings
- [ ] Documentation doesn't reference deleted code

---

### Pattern 5: Refactoring God Classes

**Template for Issue: #10 (WidgetModifierConfig)**

**Phase 1: Extract Factory Methods**

```dart
// BEFORE: All factories in one class
class WidgetModifierConfig {
  factory WidgetModifierConfig.padding(...) { ... }
  factory WidgetModifierConfig.opacity(...) { ... }
  factory WidgetModifierConfig.rotate(...) { ... }
  // ... 30+ more
}

// AFTER: Dedicated factory class
class ModifierFactory {
  static WidgetModifierConfig padding(...) { ... }
  static WidgetModifierConfig opacity(...) { ... }
  static WidgetModifierConfig rotate(...) { ... }
  // ... all factories here
}

// Update usage (with deprecation period)
class WidgetModifierConfig {
  @Deprecated('Use ModifierFactory.padding instead')
  factory WidgetModifierConfig.padding(...) {
    return ModifierFactory.padding(...);
  }
  // ... other deprecated factories
}
```

**Phase 2: Extract Ordering Policy**

```dart
// BEFORE: Hardcoded in class
class WidgetModifierConfig {
  static const _orderingMap = {
    AspectRatioModifier: 0,
    PaddingModifier: 1,
    // ... 80 lines of configuration
  };
}

// AFTER: Separate policy class
class ModifierOrderingPolicy {
  const ModifierOrderingPolicy();

  int getOrder(Type modifierType) {
    return _orderingMap[modifierType] ?? 999;
  }

  static const _orderingMap = {
    AspectRatioModifier: 0,
    PaddingModifier: 1,
    // ...
  };
}

// Update WidgetModifierConfig
class WidgetModifierConfig {
  final ModifierOrderingPolicy orderingPolicy;

  const WidgetModifierConfig({
    this.orderingPolicy = const ModifierOrderingPolicy(),
    // ... other params
  });
}
```

**Phase 3: Extract Merge Strategy**

```dart
// BEFORE: Merge logic mixed in
class WidgetModifierConfig {
  WidgetModifierConfig merge(WidgetModifierConfig other) {
    // 50+ lines of merge logic
  }
}

// AFTER: Separate strategy
abstract class ModifierMergeStrategy {
  List<WidgetModifier> merge(
    List<WidgetModifier> first,
    List<WidgetModifier> second,
  );
}

class AppendMergeStrategy implements ModifierMergeStrategy {
  @override
  List<WidgetModifier> merge(List<WidgetModifier> first, List<WidgetModifier> second) {
    return [...first, ...second];
  }
}

class ReplaceMergeStrategy implements ModifierMergeStrategy {
  @override
  List<WidgetModifier> merge(List<WidgetModifier> first, List<WidgetModifier> second) {
    final map = <Type, WidgetModifier>{};
    for (var modifier in first) {
      map[modifier.runtimeType] = modifier;
    }
    for (var modifier in second) {
      map[modifier.runtimeType] = modifier;  // Replace
    }
    return map.values.toList();
  }
}

// Update WidgetModifierConfig
class WidgetModifierConfig {
  final ModifierMergeStrategy mergeStrategy;

  WidgetModifierConfig merge(WidgetModifierConfig other) {
    return WidgetModifierConfig(
      modifiers: mergeStrategy.merge(modifiers, other.modifiers),
      // ...
    );
  }
}
```

**Testing Strategy for Refactoring:**

```dart
// Step 1: Capture current behavior (before refactoring)
group('WidgetModifierConfig behavior baseline', () {
  test('padding factory creates correct modifier', () {
    final config = WidgetModifierConfig.padding(...);
    expect(config.modifiers.length, 1);
    expect(config.modifiers.first, isA<PaddingModifier>());
    // ... capture all properties
  });

  // Repeat for all factories
});

// Step 2: After refactoring, verify behavior unchanged
group('ModifierFactory behavior (after refactoring)', () {
  test('padding factory creates identical modifier', () {
    final config = ModifierFactory.padding(...);
    expect(config.modifiers.length, 1);
    expect(config.modifiers.first, isA<PaddingModifier>());
    // ... verify properties match baseline
  });

  // All tests should pass with identical assertions
});
```

---

### Pattern 6: Code Generation

**Template for Issues: #9, #16**

**Step 1: Create Generator Infrastructure**

```yaml
# build.yaml
targets:
  $default:
    builders:
      mix_generator:curve_factories:
        enabled: true
        generate_for:
          - lib/src/animation/animation_config.dart

builders:
  curve_factories:
    import: "package:mix_generator/builders.dart"
    builder_factories: ["curveFactoriesBuilder"]
    build_extensions: {".dart": [".curve_factories.g.dart"]}
    auto_apply: dependents
    build_to: source
```

**Step 2: Define Generator Input**

```dart
// animation_config.dart
import 'package:meta/meta.dart';

@GenerateCurveFactories([
  CurveDefinition('ease', Curves.ease),
  CurveDefinition('easeIn', Curves.easeIn),
  CurveDefinition('easeOut', Curves.easeOut),
  CurveDefinition('easeInOut', Curves.easeInOut),
  // ... all curves
])
class AnimationConfig {
  // Core implementation
}
```

**Step 3: Implement Generator**

```dart
// packages/mix_generator/lib/src/builders/curve_factories_builder.dart
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

Builder curveFactoriesBuilder(BuilderOptions options) =>
    SharedPartBuilder([CurveFactoriesGenerator()], 'curve_factories');

class CurveFactoriesGenerator extends GeneratorForAnnotation<GenerateCurveFactories> {
  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    final curves = annotation.read('curves').listValue;

    final buffer = StringBuffer();
    buffer.writeln('// GENERATED CODE - DO NOT MODIFY BY HAND');
    buffer.writeln();

    for (final curve in curves) {
      final name = curve.getField('name')!.toStringValue()!;
      final curveName = curve.getField('curve')!.toStringValue()!;

      buffer.writeln('''
  factory AnimationConfig.$name(
    Duration duration, {
    VoidCallback? onEnd,
    Duration? delay,
  }) =>
      CurveAnimationConfig(
        duration: duration,
        curve: $curveName,
        onEnd: onEnd,
        delay: delay,
      );
''');
    }

    return buffer.toString();
  }
}
```

**Step 4: Generate and Integrate**

```bash
# Generate code
dart run build_runner build --delete-conflicting-outputs

# Verify generated code
cat lib/src/animation/animation_config.curve_factories.g.dart

# Update main file to use generated code
```

```dart
// animation_config.dart
part 'animation_config.curve_factories.g.dart';

@GenerateCurveFactories([...])
class AnimationConfig {
  const AnimationConfig({...});

  // Generated factories will be in .g.dart file
}
```

**Testing Generated Code:**

```dart
group('generated curve factories', () {
  test('ease factory creates correct config', () {
    final config = AnimationConfig.ease(Duration(milliseconds: 300));
    expect(config, isA<CurveAnimationConfig>());
    expect(config.duration, Duration(milliseconds: 300));
    expect((config as CurveAnimationConfig).curve, Curves.ease);
  });

  // Test all generated factories with parameterized tests
  for (final curveName in ['ease', 'easeIn', 'easeOut', /* ... */]) {
    test('$curveName factory works correctly', () {
      final config = AnimationConfig.fromName(curveName, Duration(milliseconds: 300));
      expect(config, isA<CurveAnimationConfig>());
    });
  }
});
```

---

### Pattern 7: Breaking Circular Dependencies

**Template for Issue: #22 (Prop/Mix coupling)**

**Problem:**
```dart
// Prop depends on Mix
class Prop<T> {
  T resolve(Mix mix) { ... }
}

// Mix depends on Prop
class Mix {
  Map<String, Prop> props;
}

// Circular dependency! 🔄
```

**Solution: Interface Extraction**

```dart
// Step 1: Extract interface
abstract class MixDataProvider {
  T? getValue<T>(String key);
  bool hasValue(String key);
}

// Step 2: Prop now depends on interface (not concrete Mix)
class Prop<T> {
  T resolve(MixDataProvider provider) {
    return provider.getValue<T>(_key) ?? _defaultValue;
  }
}

// Step 3: Mix implements interface
class Mix implements MixDataProvider {
  final Map<String, Prop> _props;

  @override
  T? getValue<T>(String key) {
    return _props[key]?.value as T?;
  }

  @override
  bool hasValue(String key) {
    return _props.containsKey(key);
  }
}

// No more circular dependency! ✅
// Prop → MixDataProvider ← Mix
```

**Migration Strategy:**

```dart
// Step 1: Add interface (non-breaking)
abstract class MixDataProvider { ... }

// Step 2: Make Mix implement it (non-breaking)
class Mix implements MixDataProvider { ... }

// Step 3: Add new method to Prop (non-breaking)
class Prop<T> {
  T resolve(Mix mix) { ... }  // Old method

  T resolveFrom(MixDataProvider provider) { ... }  // New method
}

// Step 4: Deprecate old method
class Prop<T> {
  @Deprecated('Use resolveFrom instead. Will be removed in v3.0.0')
  T resolve(Mix mix) {
    return resolveFrom(mix);  // Delegate to new method
  }

  T resolveFrom(MixDataProvider provider) { ... }
}

// Step 5: Update all usage sites over 6 months
// Step 6: Remove deprecated method in v3.0.0
```

---

## Testing Strategies

### Unit Testing Template

```dart
// test/src/core/[file]_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/src/core/[file].dart';

void main() {
  group('[ClassName]', () {
    late [ClassName] subject;

    setUp(() {
      subject = [ClassName](...);
    });

    tearDown(() {
      // Clean up if needed
    });

    group('constructor', () {
      test('creates instance with default values', () {
        expect(subject, isNotNull);
        expect(subject.property, expectedValue);
      });

      test('throws on invalid parameters', () {
        expect(
          () => [ClassName](invalidParam: null),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('method', () {
      test('returns expected value for typical input', () {
        final result = subject.method(input);
        expect(result, expectedOutput);
      });

      test('handles edge case: null input', () {
        final result = subject.method(null);
        expect(result, isNull);
      });

      test('handles edge case: empty input', () {
        final result = subject.method([]);
        expect(result, isEmpty);
      });
    });

    group('equality', () {
      test('equal instances are equal', () {
        final a = [ClassName](...);
        final b = [ClassName](...);
        expect(a, equals(b));
        expect(a.hashCode, equals(b.hashCode));
      });

      test('different instances are not equal', () {
        final a = [ClassName](value: 1);
        final b = [ClassName](value: 2);
        expect(a, isNot(equals(b)));
      });
    });
  });
}
```

### Integration Testing Template

```dart
// test/integration/[feature]_integration_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('[Feature] integration', () {
    testWidgets('full workflow: [description]', (tester) async {
      // Step 1: Build widget tree
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Box(
              style: Style(
                $box.padding(16),
                $box.color.red(),
              ),
              child: Text('Test'),
            ),
          ),
        ),
      );

      // Step 2: Verify initial state
      expect(find.text('Test'), findsOneWidget);
      final box = tester.widget<Container>(
        find.byType(Container).first,
      );
      expect(box.padding, EdgeInsets.all(16));

      // Step 3: Trigger interaction
      await tester.tap(find.text('Test'));
      await tester.pump();

      // Step 4: Verify updated state
      // ...
    });
  });
}
```

### Memory Leak Testing

```dart
// test/memory/[feature]_memory_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('no memory leak on rebuild', (tester) async {
    // Get VM service
    final vmService = await vmServiceConnectUri('...');

    // Force GC
    await vmService.getAllocationProfile(
      isolateId,
      gc: true,
    );

    // Get baseline
    final baseline = await vmService.getAllocationProfile(isolateId);

    // Rebuild widget many times
    for (int i = 0; i < 1000; i++) {
      await tester.pumpWidget(Container());
      await tester.pumpWidget(MyWidget());
    }

    // Force GC
    await vmService.getAllocationProfile(
      isolateId,
      gc: true,
    );

    // Get final memory
    final final = await vmService.getAllocationProfile(isolateId);

    // Memory growth should be minimal
    final growth = final.memoryUsage - baseline.memoryUsage;
    expect(growth, lessThan(1024 * 1024)); // < 1MB
  });
}
```

### Performance Benchmarking

```dart
// benchmark/[feature]_benchmark.dart
import 'package:benchmark_harness/benchmark_harness.dart';

class PropResolutionBenchmark extends BenchmarkBase {
  late Prop<int> prop;
  late Mix mix;

  PropResolutionBenchmark() : super('PropResolution');

  @override
  void setup() {
    prop = Prop<int>(42);
    mix = Mix(...);
  }

  @override
  void run() {
    prop.resolve(mix);
  }
}

void main() {
  PropResolutionBenchmark().report();
}
```

---

## Code Review Checklist

### For Code Authors

**Before Requesting Review:**
- [ ] All tests pass locally
- [ ] No analyzer warnings
- [ ] Code formatted with `dart format`
- [ ] Added/updated tests for changes
- [ ] Updated documentation if API changed
- [ ] Added entry to CHANGELOG.md
- [ ] Self-reviewed the diff
- [ ] Tested manually in example app
- [ ] Checked performance (if applicable)

**PR Description Template:**
```markdown
## Issue
Fixes #XX

## Changes
- Added null checks to prevent crash
- Extracted helper function for reusability
- Updated tests to cover edge cases

## Testing
- Added 3 new unit tests
- Verified manually in example app
- Ran performance benchmark (no regression)

## Breaking Changes
None / [describe breaking changes]

## Migration Guide
[If breaking changes, explain how to migrate]

## Screenshots
[If UI changes, add before/after screenshots]
```

### For Code Reviewers

**Check:**
- [ ] Code matches issue description
- [ ] Tests cover new functionality
- [ ] Tests cover edge cases
- [ ] No obvious bugs or security issues
- [ ] Code is readable and maintainable
- [ ] Documentation is clear
- [ ] Performance is acceptable
- [ ] No unnecessary complexity
- [ ] Follows project conventions
- [ ] Breaking changes are documented

**Review Questions:**
- What happens if this parameter is null?
- What happens if the list is empty?
- What's the performance impact?
- Is this the simplest solution?
- Could this be reused elsewhere?

---

## Common Pitfalls and How to Avoid Them

### Pitfall 1: Breaking Existing Tests

**Problem:** Your fix breaks unrelated tests

**Solution:**
```bash
# Before making changes, run full test suite
dart test

# After each change, run affected tests
dart test test/src/core/prop_test.dart

# Before committing, run full suite again
dart test

# If you broke tests, ask:
# - Did I break actual functionality?
# - Or is the test wrong?
# - Or do I need to update the test?
```

### Pitfall 2: Forgetting to Update Documentation

**Problem:** Code works but docs are outdated

**Checklist:**
- [ ] Inline code comments updated
- [ ] DartDoc comments updated
- [ ] README updated (if public API)
- [ ] Migration guide updated (if breaking)
- [ ] Examples updated
- [ ] Changelog updated

### Pitfall 3: Performance Regression

**Problem:** Fix works but makes code slower

**Solution:**
```dart
// Before optimization
void method() {
  // 100ms
}

// After optimization
void method() {
  // 150ms - REGRESSION!
}

// Fix: Benchmark and optimize
void method() {
  // Profile to find bottleneck
  // Use caching if needed
  // Consider lazy evaluation
  // 95ms - IMPROVED!
}
```

### Pitfall 4: Incomplete Null Handling

**Problem:** Added null check in one place, missed others

**Solution:**
```bash
# Search for all usages
rg "\.lerp\(" --type dart

# Check each call site
# Add null checks where needed
# Update tests to cover all paths
```

### Pitfall 5: God Class Refactoring Scope Creep

**Problem:** Started refactoring one class, ended up changing 20 files

**Solution:**
- Set clear boundaries before starting
- Use feature flags for gradual rollout
- Split work into multiple PRs if needed
- Keep backward compatibility during transition

---

## Debugging Guide

### Issue: Tests Failing After Bug Fix

**Debug Steps:**
1. **Identify which tests are failing**
   ```bash
   dart test --reporter=json | jq '.test | select(.result == "failure")'
   ```

2. **Understand what test expects**
   - Read test description
   - Check assertions
   - Understand expected behavior

3. **Determine if fix or test is wrong**
   - If fix is correct, update test
   - If test is correct, fix the code
   - If both need updating, do both

4. **Verify fix doesn't break other functionality**
   ```bash
   # Run related tests
   dart test test/src/core/
   ```

### Issue: Memory Leak Still Occurring

**Debug Steps:**
1. **Use Flutter DevTools**
   ```bash
   flutter run --profile
   # Open DevTools > Memory
   # Take heap snapshot before
   # Exercise feature 1000 times
   # Take heap snapshot after
   # Compare allocations
   ```

2. **Check for common leak sources**
   - Listeners not removed
   - Streams not closed
   - Timers not cancelled
   - Animation controllers not disposed
   - Callbacks holding references

3. **Add logging**
   ```dart
   @override
   void dispose() {
     print('Disposing ${hashCode}');
     if (_listener != null) {
       print('Removing listener');
       _controller.removeListener(_listener!);
     }
     super.dispose();
   }
   ```

### Issue: Circular Dependency After Refactoring

**Debug Steps:**
1. **Visualize dependency graph**
   ```bash
   # Use lakos tool
   dart pub global activate lakos
   lakos --metrics packages/mix/lib/
   ```

2. **Identify cycle**
   ```
   Prop → Mix → Prop  ❌
   ```

3. **Break cycle with interface**
   ```
   Prop → MixDataProvider ← Mix  ✅
   ```

### Issue: Code Generation Not Working

**Debug Steps:**
1. **Check build.yaml configuration**
   ```yaml
   # Verify paths and builder names
   ```

2. **Run with verbose output**
   ```bash
   dart run build_runner build --verbose --delete-conflicting-outputs
   ```

3. **Check generated file location**
   ```bash
   ls -la lib/src/**/*.g.dart
   ```

4. **Verify annotations are correct**
   ```dart
   // Check annotation is imported
   // Check parameters are valid
   ```

---

## Rollback Procedures

### Rolling Back a Single PR

```bash
# Find the PR merge commit
git log --oneline --merges

# Revert the merge
git revert -m 1 <merge-commit-hash>

# Push revert
git push origin main

# Update tracking
# Mark issue as "reopened"
```

### Rolling Back an Entire Sprint

```bash
# Find sprint start tag
git tag | grep sprint-5-start

# Create rollback branch
git checkout -b rollback/sprint-5

# Reset to sprint start
git reset --hard sprint-5-start

# Force push (CAUTION!)
git push origin rollback/sprint-5 --force

# Create PR to merge rollback
# Requires team approval
```

### Partial Rollback (Keep Some Changes)

```bash
# Create new branch from current state
git checkout -b partial-rollback

# Cherry-pick commits to keep
git cherry-pick <commit1>
git cherry-pick <commit2>

# Reset main to sprint start
git checkout main
git reset --hard sprint-5-start

# Merge cherry-picked changes back
git merge partial-rollback

# Push
git push origin main
```

---

## Communication Templates

### Daily Standup Template

**Developer Update:**
```
Yesterday:
- Completed #5 (unsafe type casts) - 3/5 locations fixed
- Started #6 (deep collection equality)
- PR #123 reviewed and merged

Today:
- Finish #5 (remaining 2 locations)
- Complete #6
- Review PR #124

Blockers:
- Need clarification on error message format for #5
- Waiting for design decision on #12.3 widget naming
```

### Sprint Review Template

**Sprint Lead Presentation:**
```
Sprint X Review

Goal: [Sprint goal]

Completed:
✅ Issue #1: Debug file writing removed
✅ Issue #2: Animation null pointer fixed
✅ Issue #3: Off-by-one error fixed
⚠️  Issue #4: Memory leak - 90% complete, needs more testing

Metrics:
- 8/8 planned issues completed or in progress
- 47 tests added
- 0 P0/P1 bugs introduced
- Code coverage: 92% → 95%

Challenges:
- Issue #4 took longer than estimated
- Discovered related issue #4a (not in original audit)

Next Sprint:
- Complete issue #4
- Start dead code cleanup
- Schedule architecture review for Sprint 4

Demo:
[Live demonstration of fixes]
```

### Bug Report Template

**When You Find a New Bug:**
```markdown
## Bug Description
[Clear description of the bug]

## Steps to Reproduce
1. Create a Prop<int> with null value
2. Call resolve() without Mix context
3. Observe crash

## Expected Behavior
Should return default value or throw clear error

## Actual Behavior
Null pointer exception with unclear error message

## Environment
- Mix version: 2.0.0-dev.6
- Flutter version: 3.16.0
- Dart version: 3.2.0

## Stack Trace
```
[paste stack trace]
```

## Suggested Fix
Add null check before accessing value

## Priority
P1 - Causes crash in production code

## Related Issues
May be related to #5 (unsafe type casts)
```

---

## Sprint Completion Criteria

### Sprint 1: Critical Bugs

**Must Have:**
- [ ] All 8 critical bugs fixed
- [ ] 100% test coverage for fixes
- [ ] 0 new P0/P1 bugs
- [ ] Memory profiling shows no leaks
- [ ] All example apps run without crashes

**Nice to Have:**
- [ ] Performance improved by 5%
- [ ] Additional edge cases covered
- [ ] Documentation improvements

**Definition of Done:**
- Code merged to main
- Tests passing in CI
- Documentation updated
- Release notes drafted
- Demo completed
- Retrospective held

### Sprint 2: Dead Code

**Must Have:**
- [ ] 1,700+ lines removed
- [ ] 0 broken imports
- [ ] All tests still pass
- [ ] Documentation build successful

**Nice to Have:**
- [ ] Additional dead code found and removed
- [ ] Build time improvement measured
- [ ] Automated dead code detection in CI

### Sprint 3: Consistency

**Must Have:**
- [ ] All consistency issues resolved
- [ ] Coding standards documented
- [ ] Lint rules implemented
- [ ] Team agreement on standards

**Nice to Have:**
- [ ] Automated formatting in pre-commit hook
- [ ] Style guide published
- [ ] Consistency checker in CI

### Sprint 4-6: Architecture

**Must Have:**
- [ ] All planned refactoring complete
- [ ] 0 circular dependencies
- [ ] Performance within baseline
- [ ] Migration guide complete
- [ ] All tests passing

**Nice to Have:**
- [ ] Performance improved beyond baseline
- [ ] Additional architecture improvements
- [ ] Code generation for other boilerplate

---

## Quick Reference Commands

### Common Git Commands
```bash
# Create feature branch
git checkout -b fix/issue-5-type-casts

# Commit with conventional format
git commit -m "fix: add type validation before unsafe casts

- Added type checks in prop.dart
- Added validation in token_refs.dart
- Added tests for invalid type scenarios

Fixes #5"

# Push and create PR
git push origin fix/issue-5-type-casts
gh pr create --title "Fix #5: Add type validation" --body "..."

# Update from main
git fetch origin
git rebase origin/main

# Squash commits before merging
git rebase -i HEAD~3
```

### Common Dart Commands
```bash
# Run tests
dart test
dart test --coverage
dart test test/src/core/prop_test.dart

# Analyze code
dart analyze
dart analyze --fatal-infos

# Format code
dart format .
dart format --set-exit-if-changed .

# Code generation
dart run build_runner build
dart run build_runner watch
dart run build_runner build --delete-conflicting-outputs

# Documentation
dart doc .
dart doc --validate-links
```

### Common Search Commands
```bash
# Find all usages
rg "ClassName" --type dart

# Find TODOs
rg "TODO|FIXME" --type dart

# Find potential null issues
rg "!\s*;" --type dart

# Find commented code
rg "^\s*//" --type dart | head -100

# Find large files
find lib -name "*.dart" -exec wc -l {} \; | sort -rn | head -20
```

---

## Success Stories Template

**After completing a challenging fix, document:**

```markdown
## Success Story: Issue #22 Prop/Mix Decoupling

### Challenge
Circular dependency between core classes, affecting entire architecture

### Approach
1. Extracted MixDataProvider interface
2. Updated Prop to depend on interface
3. Made Mix implement interface
4. Added deprecation period for old API

### Results
- ✅ Circular dependency eliminated
- ✅ Code complexity reduced by 30%
- ✅ New design patterns enabled
- ✅ 0 breaking changes for users

### Lessons Learned
- Interface extraction is powerful for breaking cycles
- Gradual migration reduces risk
- Comprehensive tests enable confident refactoring
- Team collaboration essential for architecture changes

### Metrics
- Before: 15 circular dependencies
- After: 0 circular dependencies
- Code coverage: 89% → 96%
- Team satisfaction: ⭐⭐⭐⭐⭐

### What We'd Do Differently
- Start with smaller interfaces
- Prototype design before full implementation
- Allocate more time for testing
```

---

*This playbook is a living document. Update it as you discover better practices!*
