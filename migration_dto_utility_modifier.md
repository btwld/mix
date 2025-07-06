# Complete Guide: Migrating DTO, Utility & Modifier .g.dart Files

This guide provides a systematic approach to migrate all remaining generated `.g.dart` files for DTOs, utilities, and modifiers into their corresponding main files.

## 📋 File Categories & Inventory

### 🎯 DTO Files (9 files)
```
Attributes DTOs:
☐ border_dto.g.dart → border_dto.dart
☐ shape_border_dto.g.dart → shape_border_dto.dart  
☐ constraints_dto.g.dart → constraints_dto.dart ✅ (part directive added)
☐ decoration_dto.g.dart → decoration_dto.dart ✅ (part directive exists)
☐ gradient_dto.g.dart → gradient_dto.dart
☐ shadow_dto.g.dart → shadow_dto.dart
☐ edge_insets_dto.g.dart → edge_insets_dto.dart
☐ strut_style_dto.g.dart → strut_style_dto.dart
☐ text_height_behavior_dto.g.dart → text_height_behavior_dto.dart
```

### 🛠️ Utility Files (2 files)
```
Core Utilities:
☐ enum_util.g.dart → enum_util.dart
☐ scalar_util.g.dart → scalar_util.dart
```

### 🔧 Modifier Files (14 files)
```
Widget Modifiers:
☐ align_widget_modifier.g.dart → align_widget_modifier.dart
☐ aspect_ratio_widget_modifier.g.dart → aspect_ratio_widget_modifier.dart
☐ clip_widget_modifier.g.dart → clip_widget_modifier.dart
☐ default_text_style_widget_modifier.g.dart → default_text_style_widget_modifier.dart
☐ flexible_widget_modifier.g.dart → flexible_widget_modifier.dart
☐ fractionally_sized_box_widget_modifier.g.dart → fractionally_sized_box_widget_modifier.dart
☐ intrinsic_widget_modifier.g.dart → intrinsic_widget_modifier.dart
☐ mouse_cursor_modifier.g.dart → mouse_cursor_modifier.dart
☐ opacity_widget_modifier.g.dart → opacity_widget_modifier.dart
☐ padding_widget_modifier.g.dart → padding_widget_modifier.dart
☐ rotated_box_widget_modifier.g.dart → rotated_box_widget_modifier.dart
☐ scroll_view_widget_modifier.g.dart → scroll_view_widget_modifier.dart
☐ sized_box_widget_modifier.g.dart → sized_box_widget_modifier.dart
☐ transform_widget_modifier.g.dart → transform_widget_modifier.dart
☐ visibility_widget_modifier.g.dart → visibility_widget_modifier.dart
☐ reset_modifier.g.dart → reset_modifier.dart (internal)
```

### 📋 Remaining Spec Files (3 files)
```
Remaining Specs:
☐ flex_spec.g.dart → flex_spec.dart
☐ flexbox_spec.g.dart → flexbox_spec.dart  
☐ text_spec.g.dart → text_spec.dart
```

## 🔄 Migration Process by Category

### 📦 DTO Migration Pattern

DTOs typically contain utility classes and sometimes extension methods.

#### Phase 1: Information Gathering (1 tool call)
```
codebase-retrieval: "Get complete [dto_name].dart and [dto_name].g.dart files with all utility classes and extensions"
```

#### Phase 2: Main File Transformation (1-2 tool calls)
```
1. Remove code generation imports and decorators:
   - Remove: import 'package:mix_annotations/mix_annotations.dart';
   - Remove: part '[dto_name].g.dart';
   - Remove: @MixableDto() or similar annotations

2. Add utility classes from .g.dart:
   - [DtoName]Utility classes
   - Extension methods
   - Helper methods

3. Keep existing DTO classes and add generated utilities
```

#### Phase 3: Remove .g.dart & Validate (2 tool calls)
```
remove-files: ["packages/mix/lib/src/attributes/[category]/[dto_name].g.dart"]
diagnostics: ["packages/mix/lib/src/attributes/[category]/[dto_name].dart"]
```

### 🛠️ Utility Migration Pattern

Utility files contain mixin classes with utility methods.

#### Phase 1: Information Gathering (1 tool call)
```
codebase-retrieval: "Get complete [util_name].dart and [util_name].g.dart files with all mixin classes and utility methods"
```

#### Phase 2: Main File Transformation (1-2 tool calls)
```
1. Remove code generation decorators:
   - Remove: @MixableUtility() annotations
   - Remove: part '[util_name].g.dart';
   - Remove: with _$[UtilityName] mixins

2. Move mixin content directly into utility classes:
   - Move _$[UtilityName] mixin methods into main class
   - Add all utility methods and properties
   - Preserve existing utility structure
```

#### Phase 3: Remove .g.dart & Validate (2 tool calls)
```
remove-files: ["packages/mix/lib/src/attributes/[category]/[util_name].g.dart"]
diagnostics: ["packages/mix/lib/src/attributes/[category]/[util_name].dart"]
```

### 🔧 Modifier Migration Pattern

Modifier files contain spec classes with mixins, attributes, and tweens.

#### Phase 1: Information Gathering (1 tool call)
```
codebase-retrieval: "Get complete [modifier_name].dart and [modifier_name].g.dart files with spec mixins, attributes, and tween classes"
```

#### Phase 2: Main File Transformation (1-2 tool calls)
```
1. Remove code generation imports and decorators:
   - Remove: import 'package:mix_annotations/mix_annotations.dart';
   - Remove: part '[modifier_name].g.dart';
   - Remove: @MixableSpec() annotations
   - Remove: with _$[ModifierName] mixins

2. Transform main spec class:
   - Move _$[ModifierName] mixin methods into main class
   - Add copyWith, lerp, props methods
   - Add _debugFillProperties method

3. Add generated classes:
   - [ModifierName]Attribute class
   - [ModifierName]Tween class
```

#### Phase 3: Remove .g.dart & Validate (2 tool calls)
```
remove-files: ["packages/mix/lib/src/modifiers/[modifier_name].g.dart"]
diagnostics: ["packages/mix/lib/src/modifiers/[modifier_name].dart"]
```

## 🎯 Efficient Workflow Template

For each file type, use this **4-step process**:

```
1. codebase-retrieval: "Get complete [file_name].dart and [file_name].g.dart with all classes"
2. str-replace-editor: Transform main file (remove decorators, add classes/methods)
3. remove-files: Remove .g.dart file
4. diagnostics: Validate no errors
```

## 🛠️ Common Patterns & Templates

### Template: DTO Utility Class
```dart
class [DtoName]Utility<T extends StyleElement> extends DtoUtility<T, [DtoName], [ValueType]> {
  // Utility properties and methods from .g.dart
  
  const [DtoName]Utility(super.builder);
  
  // Methods from generated file
}
```

### Template: Utility Mixin Integration
```dart
final class [UtilityName]<T extends StyleElement> extends MixUtility<T, [ValueType]> {
  const [UtilityName](super.builder);
  
  // Methods from _$[UtilityName] mixin moved here directly
}
```

### Template: Modifier Spec Class
```dart
final class [ModifierName]Spec extends WidgetModifierSpec<[ModifierName]Spec> {
  // Properties
  
  const [ModifierName]Spec({
    // Constructor parameters
  });
  
  // Methods from _$[ModifierName] mixin:
  @override
  [ModifierName]Spec copyWith({
    // Parameters
  }) {
    return [ModifierName]Spec(
      // Implementation
    );
  }
  
  @override
  [ModifierName]Spec lerp([ModifierName]Spec? other, double t) {
    // Implementation
  }
  
  @override
  List<Object?> get props => [
    // Properties
  ];
  
  @override
  Widget build(Widget child) {
    // Implementation
  }
}

// Add [ModifierName]Attribute and [ModifierName]Tween classes
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
diagnostics: ["packages/mix/lib/src/[category]/[file_name].dart"]
```

### Common Issues & Fixes:

#### Issue: Missing Imports
```
Error: "Undefined class '[UtilityName]'"
Fix: Add missing imports for utility classes or DTOs
```

#### Issue: Missing Base Classes
```
Error: "Classes can only extend other classes"
Fix: Ensure proper inheritance from DtoUtility, MixUtility, or WidgetModifierSpec
```

#### Issue: Missing Methods
```
Error: "The method '[method]' isn't defined"
Fix: Ensure all mixin methods are moved to main class
```

## 📊 Progress Tracking

### DTO Files Progress:
```
☐ border_dto.dart
☐ shape_border_dto.dart
☐ constraints_dto.dart (part directive ready)
☐ decoration_dto.dart (part directive ready)
☐ gradient_dto.dart
☐ shadow_dto.dart
☐ edge_insets_dto.dart
☐ strut_style_dto.dart
☐ text_height_behavior_dto.dart
```

### Utility Files Progress:
```
☐ enum_util.dart
☐ scalar_util.dart
```

### Modifier Files Progress:
```
☐ align_widget_modifier.dart
☐ aspect_ratio_widget_modifier.dart
☐ clip_widget_modifier.dart
☐ default_text_style_widget_modifier.dart
☐ flexible_widget_modifier.dart
☐ fractionally_sized_box_widget_modifier.dart
☐ intrinsic_widget_modifier.dart
☐ mouse_cursor_modifier.dart
☐ opacity_widget_modifier.dart
☐ padding_widget_modifier.dart
☐ rotated_box_widget_modifier.dart
☐ scroll_view_widget_modifier.dart
☐ sized_box_widget_modifier.dart
☐ transform_widget_modifier.dart
☐ visibility_widget_modifier.dart
☐ reset_modifier.dart (internal)
```

### Remaining Spec Files Progress:
```
☐ flex_spec.dart
☐ flexbox_spec.dart
☐ text_spec.dart
```

## 🎯 Success Criteria

For each migrated file:
- ✅ No .g.dart file exists
- ✅ No code generation imports/decorators
- ✅ All classes/methods moved to main file
- ✅ No diagnostic errors (verified with diagnostics tool)
- ✅ Functionality preserved

## 🔍 Validation Process

### After Each Migration:
```
Use diagnostics tool to check for errors:
diagnostics: ["packages/mix/lib/src/[category]/[file_name].dart"]
```

### Expected Clean Result:
```
No diagnostics found.
```

## 📝 Migration Order Recommendation

### Phase 1: DTOs (Foundation)
Start with DTOs as they provide utilities used by other components.

### Phase 2: Core Utilities
Migrate enum_util and scalar_util as they're used throughout the codebase.

### Phase 3: Modifiers
Migrate widget modifiers as they're self-contained.

### Phase 4: Remaining Specs
Complete the remaining spec files using the spec migration guide.

This systematic approach ensures **consistent**, **efficient**, and **safe** migration of all remaining generated files while maintaining full functionality through analyzer validation.
