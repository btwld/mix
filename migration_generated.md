# Complete Guide: Migrating .g.dart Files to Main Files

This guide provides a systematic approach to migrate all generated `.g.dart` files into their corresponding main files, removing code generation dependencies.

## 📋 Pre-Migration Checklist

### 1. Identify All .g.dart Files
```
Expected files to migrate:
- box_spec.g.dart ✅ (already done)
- icon_spec.g.dart ✅ (already done)
- image_spec.g.dart ✅ (already done)
- stack_spec.g.dart ✅ (already done)
- text_spec.g.dart
- flex_spec.g.dart
- [other spec files]
```

## 🔄 Migration Process (Per File)

### Phase 1: Information Gathering (1 tool call)
```
Use codebase-retrieval to get:
- Complete [spec_name].dart file content
- Complete [spec_name].g.dart file content  
- All classes: [Spec]Attribute, [Spec]Utility, [Spec]Tween
- Required utility imports and dependencies
- Any missing part directives in related files
```

### Phase 2: Dependency Check & Fix (1 tool call if needed)
```
Check for missing part directives in DTO files:
- constraints_dto.dart needs: part 'constraints_dto.g.dart';
- decoration_dto.dart needs: part 'decoration_dto.g.dart';
- [other_dto].dart files may need similar fixes
```

### Phase 3: Main File Transformation (1-2 tool calls)

#### For files that already have classes (like icon_spec, image_spec):
1. **Remove .g.dart file**
2. **Add missing classes** (usually just [Spec]Tween)

#### For files that still use code generation (like text_spec, flex_spec):
1. **Remove code generation imports and decorators**:
   ```dart
   // Remove these lines:
   import 'package:mix_annotations/mix_annotations.dart';
   part '[spec_name].g.dart';
   @MixableSpec()
   with _$[SpecName]
   ```

2. **Add required imports**:
   ```dart
   // Add these imports:
   import '../../attributes/animation/animated_config_dto.dart';
   import '../../attributes/animation/animated_util.dart';
   import '../../attributes/enum/enum_util.dart';
   import '../../attributes/modifiers/widget_modifiers_config_dto.dart';
   import '../../attributes/modifiers/widget_modifiers_util.dart';
   import '../../attributes/scalars/scalar_util.dart';
   import '../../core/factory/style_mix.dart';
   import '../../core/helpers.dart';
   import '../../core/utility.dart';
   // Add other specific imports as needed
   ```

3. **Transform the main class**:
   ```dart
   // From:
   @MixableSpec()
   final class [SpecName] extends Spec<[SpecName]> with _$[SpecName], Diagnosticable {
     static const of = _$[SpecName].of;
     static const from = _$[SpecName].from;
   
   // To:
   final class [SpecName] extends Spec<[SpecName]> with Diagnosticable {
     static [SpecName] from(MixContext mix) {
       return mix.attributeOf<[SpecName]Attribute>()?.resolve(mix) ?? const [SpecName]();
     }
   
     static [SpecName] of(BuildContext context) {
       return ComputedStyle.specOf<[SpecName]>(context) ?? const [SpecName]();
     }
   
     // Add copyWith, lerp, props methods from .g.dart file
   ```

4. **Add the three main classes from .g.dart**:
   - `[SpecName]Attribute` class
   - `[SpecName]Utility` class  
   - `[SpecName]Tween` class

### Phase 4: Remove .g.dart File (1 tool call)
```
Remove the generated file:
remove-files: ["packages/mix/lib/src/specs/[spec_name]/[spec_name].g.dart"]
```

### Phase 5: Validation (1 tool call)
```
Run analyzer to ensure no errors:
diagnostics: ["packages/mix/lib/src/specs/[spec_name]/[spec_name].dart"]
```

## 🎯 Efficient Workflow Template

For each spec file, use this **5-step process**:

```
1. codebase-retrieval: "Get complete [spec_name].dart and [spec_name].g.dart with all classes and imports"
2. [IF NEEDED] str-replace-editor: Fix missing part directives in DTO files
3. str-replace-editor: Transform main file (remove decorators, add imports, move classes)
4. remove-files: Remove .g.dart file
5. diagnostics: Run analyzer to validate no errors
```

## 🛠️ Common Patterns & Templates

### Template: Static Methods
```dart
static [SpecName] from(MixContext mix) {
  return mix.attributeOf<[SpecName]Attribute>()?.resolve(mix) ?? const [SpecName]();
}

static [SpecName] of(BuildContext context) {
  return ComputedStyle.specOf<[SpecName]>(context) ?? const [SpecName]();
}
```

### Template: Instance Methods
```dart
@override
[SpecName] copyWith({
  // All properties with ? types
}) {
  return [SpecName](
    // All properties with ?? this.property fallbacks
  );
}

@override
[SpecName] lerp([SpecName]? other, double t) {
  if (other == null) return this;
  return [SpecName](
    // Interpolation logic for each property
  );
}

@override
List<Object?> get props => [
  // All properties
];
```

### Template: Utility Class
```dart
class [SpecName]Utility<T extends SpecAttribute> extends SpecUtility<T, [SpecName]Attribute> {
  // Utility properties for each field
  late final [property] = [PropertyUtility]((v) => only([property]: v));
  
  [SpecName]Utility(super.attributeBuilder, {
    @Deprecated('mutable parameter is no longer used. All SpecUtilities are now mutable by default.')
    bool? mutable,
  });

  @Deprecated('Use "this" instead of "chain" for method chaining.')
  [SpecName]Utility<T> get chain => [SpecName]Utility(attributeBuilder);

  static [SpecName]Utility<[SpecName]Attribute> get self => [SpecName]Utility((v) => v);

  @override
  T only({
    // All properties with DTO types where applicable
  }) {
    return builder([SpecName]Attribute(
      // All properties
    ));
  }
}
```

## 🚨 Recovery Mode

### If Migration Fails:

#### 1. Immediate Recovery
```
Use str-replace-editor to revert changes to specific files by restoring original content
Use view tool to examine the original .g.dart file content if needed
```

#### 2. Diagnostic Recovery
```
Use diagnostics tool to check what's broken:
diagnostics: ["packages/mix/lib/src/specs/[spec_name]/[spec_name].dart"]
```

### Common Issues & Fixes:

#### Issue: Missing Utility Classes
```
Error: "Undefined class 'BoxConstraintsUtility'"
Fix: Add missing part directive to constraints_dto.dart:
     part 'constraints_dto.g.dart';
```

#### Issue: Missing SpecUtility Import
```
Error: "Classes can only extend other classes"
Fix: Add import: import '../../core/factory/style_mix.dart';
```

#### Issue: Wrong Constructor Parameters
```
Error: "No associated positional super constructor parameter"
Fix: Use super.attributeBuilder instead of super.builder
```

#### Issue: Missing Methods
```
Error: "The method 'builder' isn't defined"
Fix: SpecUtility provides builder() method, check inheritance
```

## 📊 Progress Tracking

Create a checklist for all spec files:

```
Migration Progress:
☑️ box_spec.dart (DONE)
☑️ icon_spec.dart (DONE)
☑️ image_spec.dart (DONE)
☑️ stack_spec.dart (DONE)
☐ text_spec.dart
☐ flex_spec.dart
☐ [other_spec].dart

For each file:
☐ Phase 1: Information Gathering
☐ Phase 2: Dependency Check
☐ Phase 3: Main File Transformation
☐ Phase 4: Remove .g.dart File
☐ Phase 5: Analyzer Validation
☐ No Diagnostic Errors
```

## 🎯 Success Criteria

For each migrated file:
- ✅ No .g.dart file exists
- ✅ No code generation imports/decorators
- ✅ All classes moved to main file
- ✅ No diagnostic errors (verified with diagnostics tool)
- ✅ Functionality preserved

## 🔍 Validation Process

### After Each Migration:
```
Use diagnostics tool to check for errors:
diagnostics: ["packages/mix/lib/src/specs/[spec_name]/[spec_name].dart"]
```

### Expected Clean Result:
```
No diagnostics found.
```

This systematic approach ensures **consistent**, **efficient**, and **safe** migration of all generated files while maintaining full functionality through analyzer validation.

## 🚨 Recovery Mode

### If Migration Fails:

#### 1. Immediate Recovery
```bash
# Revert to backup
git checkout backup-before-migration
git checkout -b feature/remove-code-generation-retry
```

#### 2. Partial Recovery (Fix Individual Files)
```bash
# Revert specific file
git checkout HEAD~1 -- packages/mix/lib/src/specs/[spec_name]/[spec_name].dart

# Restore .g.dart file if accidentally deleted
git checkout HEAD~1 -- packages/mix/lib/src/specs/[spec_name]/[spec_name].g.dart
```

#### 3. Diagnostic Recovery
```bash
# Check what's broken
dart analyze packages/mix/lib/src/specs/[spec_name]/[spec_name].dart

# Run tests to see failures
dart test packages/mix/test/src/specs/[spec_name]/
```

### Common Issues & Fixes:

#### Issue: Missing Utility Classes
```
Error: "Undefined class 'BoxConstraintsUtility'"
Fix: Add missing part directive to constraints_dto.dart:
     part 'constraints_dto.g.dart';
```

#### Issue: Missing SpecUtility Import
```
Error: "Classes can only extend other classes"
Fix: Add import: import '../../core/factory/style_mix.dart';
```

#### Issue: Wrong Constructor Parameters
```
Error: "No associated positional super constructor parameter"
Fix: Use super.attributeBuilder instead of super.builder
```

#### Issue: Missing Methods
```
Error: "The method 'builder' isn't defined"
Fix: SpecUtility provides builder() method, check inheritance
```

## 📊 Progress Tracking

Create a checklist for all spec files:

```
Migration Progress:
☑️ box_spec.dart (DONE)
☑️ icon_spec.dart (DONE)
☑️ image_spec.dart (DONE)
☑️ stack_spec.dart (DONE)
☐ text_spec.dart
☐ flex_spec.dart
☐ [other_spec].dart

For each file:
☐ Phase 1: Information Gathering
☐ Phase 2: Dependency Check
☐ Phase 3: Main File Transformation
☐ Phase 4: Remove .g.dart File
☐ Phase 5: Validation
☐ Tests Pass
```

## 🧪 Testing Strategy

### After Each Migration:
```bash
# Test specific spec
dart test packages/mix/test/src/specs/[spec_name]/

# Test all specs
dart test packages/mix/test/src/specs/

# Full test suite
dart test packages/mix/
```

### Before Final Commit:
```bash
# Full analysis
dart analyze packages/mix/

# Full test suite
dart test packages/mix/

# Integration tests
dart test packages/mix/test/integration/
```

## 🎯 Success Criteria

For each migrated file:
- ✅ No .g.dart file exists
- ✅ No code generation imports/decorators
- ✅ All classes moved to main file
- ✅ No diagnostic errors
- ✅ All tests pass
- ✅ Functionality preserved

This systematic approach ensures **consistent**, **efficient**, and **safe** migration of all generated files while maintaining full functionality and providing clear recovery options.
