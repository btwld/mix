# Mix Architecture Consolidation Plan - AI IMPLEMENTATION GUIDE

**Date**: 2025-08-26  
**Goal**: Achieve maximum clarity through unified architecture

## Executive Summary for AI Implementation

This plan consolidates the Mix design system to follow one simple rule:
**One Spec → One Mix → One Styling per domain**

No more ambient vs per-widget distinction. No more duplicate specs. Just clean, consistent naming.

## Core Architecture Pattern

```
Spec (data structure) → Mix (lightweight builder) → Styling (heavyweight with animations/modifiers)
```

Every Mix class has a `toStyle()` extension method that returns a `*Styling` type for conversion when needed.

## CRITICAL IMPLEMENTATION NOTES

- **NO DEPRECATION**: Replace classes directly, no deprecation notices needed
- **TEST AFTER EACH PHASE**: Run `melos run test:flutter` after each phase
- **COMMIT AFTER EACH PHASE**: Create checkpoint commits for rollback if needed

## Complete Consolidation Actions

### Phase 1: Unify Icon System

**Step 1.1: Merge Icon Specs**
```dart
// IN: lib/src/specs/icon/icon_spec.dart
// ADD these properties from IconographySpec (if not already present):
// - All properties that IconographySpec has
// Result: IconSpec has ALL icon properties (ambient + per-widget)
```

**Step 1.2: Create Proper IconMix**
```dart
// CREATE: lib/src/specs/icon/icon_mix.dart
class IconMix extends Mix<IconSpec> {
  final Prop<double>? $size;
  final Prop<double>? $fill;
  final Prop<double>? $weight;
  final Prop<double>? $grade;
  final Prop<double>? $opticalSize;
  final Prop<Color>? $color;
  final Prop<double>? $opacity;
  final Prop<List<Shadow>>? $shadows;
  final Prop<bool>? $applyTextScaling;
  final Prop<TextDirection>? $textDirection;
  final Prop<String>? $semanticsLabel;
  final Prop<BlendMode>? $blendMode;
  final Prop<IconData>? $icon;
  
  // Constructors, merge(), resolve() methods
}

extension IconMixToStyle on IconMix {
  IconStyling toStyle() => IconStyling.from(this);
}
```

**Step 1.3: Update IconStyling**
```dart
// IN: lib/src/specs/icon/icon_styling.dart
// REMOVE: typedef IconMix = IconStyling;
// ADD: factory IconStyling.from(IconMix mix) { ... }
```

**Step 1.4: Create IconScope**
```dart
// CREATE: lib/src/providers/icon_scope.dart
// Copy IconographyScope but rename class to IconScope
// Update to use IconMix instead of IconographyMix
class IconScope extends StatelessWidget {
  final IconMix icon;
  // Implementation using IconTheme
}
```

**Step 1.5: Delete Old Files**
```bash
rm lib/src/properties/iconography/iconography_spec.dart
rm lib/src/properties/iconography/iconography_mix.dart
rm lib/src/providers/iconography_scope.dart
```

**Step 1.6: Update Imports**
```bash
# Find and replace all imports
# FROM: 'iconography/iconography_spec.dart' → 'icon/icon_spec.dart'
# FROM: 'iconography/iconography_mix.dart' → 'icon/icon_mix.dart'
# FROM: 'providers/iconography_scope.dart' → 'providers/icon_scope.dart'
```

### Phase 2: Unify Text System

**Step 2.1: Merge Text Specs**
```dart
// IN: lib/src/specs/text/text_spec.dart
// ADD these properties from TypographySpec (if not already present):
// Likely already has all properties, just verify
```

**Step 2.2: Create Proper TextMix**
```dart
// CREATE: lib/src/specs/text/text_mix.dart
class TextMix extends Mix<TextSpec> {
  final Prop<TextStyle>? $style;
  final Prop<TextAlign>? $textAlign;
  final Prop<bool>? $softWrap;
  final Prop<TextOverflow>? $overflow;
  final Prop<int>? $maxLines;
  final Prop<TextWidthBasis>? $textWidthBasis;
  final Prop<TextHeightBehavior>? $textHeightBehavior;
  final Prop<StrutStyle>? $strutStyle;
  final Prop<TextScaler>? $textScaler;
  final Prop<TextDirection>? $textDirection;
  final Prop<List<Directive<String>>>? $textDirectives;
  final Prop<Color>? $selectionColor;
  final Prop<String>? $semanticsLabel;
  final Prop<Locale>? $locale;

  // Constructors, merge(), resolve() methods
}

extension TextMixToStyle on TextMix {
  TextStyling toStyle() => TextStyling.from(this);
}
```

**Step 2.3: Fix Current TextMix (currently TextStyling)**
```dart
// IN: lib/src/specs/text/text_styling.dart
// The current TextMix is actually a Styling class
// RENAME: class TextMix → class TextStyling
// ADD: factory TextStyling.from(TextMix mix) { ... }
```

**Step 2.4: Create TextScope**
```dart
// CREATE: lib/src/providers/text_scope.dart
// Copy TypographyScope but rename class to TextScope
// Update to use TextMix instead of TypographyMix
class TextScope extends StatelessWidget {
  final TextMix text;
  // Implementation using DefaultTextStyle
}
```

**Step 2.5: Delete Old Files**
```bash
rm lib/src/properties/typography/typography_spec.dart
rm lib/src/properties/typography/typography_mix.dart
rm lib/src/providers/typography_scope.dart
```

**Step 2.6: Update Imports**
```bash
# Find and replace all imports
# FROM: 'typography/typography_spec.dart' → 'text/text_spec.dart'
# FROM: 'typography/typography_mix.dart' → 'text/text_mix.dart'
# FROM: 'providers/typography_scope.dart' → 'providers/text_scope.dart'
```

### Phase 3: Fix Box System

**Step 3.1: Create typedef for ContainerSpec**
```dart
// IN: lib/src/properties/container/container_spec.dart
// REPLACE entire file content with:
typedef ContainerSpec = BoxSpec;
```

**Step 3.2: Move and Rename ContainerMix to BoxMix**
```bash
mv lib/src/properties/container/container_mix.dart lib/src/specs/box/box_mix.dart
```

**Step 3.3: Update BoxMix Class**
```dart
// IN: lib/src/specs/box/box_mix.dart (formerly container_mix.dart)
// RENAME: class ContainerMix → class BoxMix
// CHANGE: extends Mix<ContainerSpec> → extends Mix<BoxSpec>

extension BoxMixToStyle on BoxMix {
  BoxStyling toStyle() => BoxStyling.from(this);
}
```

**Step 3.4: Fix BoxStyling**
```dart
// IN: lib/src/specs/box/box_styling.dart
// REMOVE: typedef BoxMix = BoxStyling;
// ADD: factory BoxStyling.from(BoxMix mix) { ... }
```

**Step 3.5: Create ContainerMix typedef**
```dart
// CREATE: lib/src/properties/container/container_mix.dart
typedef ContainerMix = BoxMix;
```

### Phase 4: Fix Flex System

**Step 4.1: Create FlexMix**
```dart
// CREATE: lib/src/specs/flex/flex_mix.dart
class FlexMix extends Mix<FlexSpec> {
  final Prop<Axis>? $direction;
  final Prop<MainAxisAlignment>? $mainAxisAlignment;
  final Prop<CrossAxisAlignment>? $crossAxisAlignment;
  final Prop<MainAxisSize>? $mainAxisSize;
  final Prop<VerticalDirection>? $verticalDirection;
  final Prop<TextDirection>? $textDirection;
  final Prop<TextBaseline>? $textBaseline;
  final Prop<Clip>? $clipBehavior;
  final Prop<double>? $spacing;
  
  // Constructors, merge(), resolve() methods
}

extension FlexMixToStyle on FlexMix {
  FlexStyling toStyle() => FlexStyling.from(this);
}
```

**Step 4.2: Update FlexStyling**
```dart
// IN: lib/src/specs/flex/flex_styling.dart
// ADD: factory FlexStyling.from(FlexMix mix) { ... }
```

**Step 4.3: Move and Rename FlexContainerMix to FlexBoxMix**
```bash
mv lib/src/specs/flex_container/flex_container_mix.dart lib/src/specs/flexbox/flexbox_mix.dart
```

**Step 4.4: Update FlexBoxMix Class**
```dart
// IN: lib/src/specs/flexbox/flexbox_mix.dart
// RENAME: class FlexContainerMix → class FlexBoxMix
// UPDATE to use composition:
class FlexBoxMix extends Mix<FlexBoxSpec> {
  final BoxMix? container;
  final FlexMix? flex;
  
  // Constructors, merge(), resolve() methods
}

extension FlexBoxMixToStyle on FlexBoxMix {
  FlexBoxStyling toStyle() => FlexBoxStyling.from(this);
}
```

**Step 4.5: Update FlexBoxSpec**
```dart
// IN: lib/src/specs/flexbox/flexbox_spec.dart
// CHANGE:
//   final ContainerSpec? container; → final BoxSpec? container;
//   final FlexLayoutSpec? flex; → final FlexSpec? flex;
```

**Step 4.6: Fix FlexBoxStyling**
```dart
// IN: lib/src/specs/flexbox/flexbox_styling.dart
// REMOVE: typedef FlexBoxMix = FlexBoxStyling;
// ADD: factory FlexBoxStyling.from(FlexBoxMix mix) { ... }
```

**Step 4.7: Delete Deprecated Files**
```bash
rm lib/src/properties/layout/flex_layout_spec.dart
rm lib/src/properties/layout/flex_layout_mix.dart
rm lib/src/specs/flex_container/flex_container_spec.dart
```

### Phase 5: Update Global Utilities

**Step 5.1: Update spec_util.dart**
```dart
// IN: lib/src/specs/spec_util.dart
// Ensure all utilities use new Mix classes:
IconSpecUtility get $icon => IconSpecUtility();
TextSpecUtility get $text => TextSpecUtility();
BoxSpecUtility get $box => BoxSpecUtility();
FlexSpecUtility get $flex => FlexSpecUtility();
```

### Phase 6: Update Exports

**Step 6.1: Update mix.dart main export**
```dart
// IN: lib/mix.dart
// Update all exports to reference new file locations
// Remove exports for deleted files
// Add exports for new Mix classes
```

## Testing Commands After Each Phase

```bash
# After Phase 1 (Icon):
melos exec --scope="mix" -- flutter test test/src/specs/icon/
melos exec --scope="mix" -- flutter test test/src/providers/icon_scope_test.dart

# After Phase 2 (Text):
melos exec --scope="mix" -- flutter test test/src/specs/text/
melos exec --scope="mix" -- flutter test test/src/providers/text_scope_test.dart

# After Phase 3 (Box):
melos exec --scope="mix" -- flutter test test/src/specs/box/

# After Phase 4 (Flex):
melos exec --scope="mix" -- flutter test test/src/specs/flex/
melos exec --scope="mix" -- flutter test test/src/specs/flexbox/

# Final full test:
melos run test:flutter
```

## Verification Checklist

After implementation, verify:

- [ ] No files contain `IconographySpec` or `IconographyMix` references
- [ ] No files contain `TypographySpec` or `TypographyMix` references
- [ logical ] No files contain `FlexLayoutSpec` or `FlexLayoutMix` references
- [ ] No files contain `FlexContainerSpec` or `FlexContainerMix` references
- [ ] All Mix classes extend `Mix<Spec>` (not `Style<Spec>`)
- [ ] All Mix classes have `toStyle()` extension methods returning `*Styling`
- [ ] All Styling classes have `from(Mix)` factory constructors
- [ ] Tests pass: `melos run test:flutter`
- [ ] Examples run: `cd examples && flutter run`

## Common Issues and Solutions

### Issue: Import not found after file deletion
**Solution**: Search and replace all imports with new paths

### Issue: Type mismatch after renaming
**Solution**: Ensure all references use new class names

### Issue: Tests fail after Mix changes
**Solution**: Update test files to use new Mix constructors

### Issue: Widget not building after Scope rename
**Solution**: Update widget code to use IconScope/TextScope

## Final Architecture Summary

```
Specs: IconSpec, TextSpec, BoxSpec, FlexSpec, FlexBoxSpec
Mixes: IconMix, TextMix, BoxMix, FlexMix, FlexBoxMix
Styling: IconStyling, TextStyling, BoxStyling, FlexStyling, FlexBoxStyling
Scopes: IconScope, TextScope
```

Every Spec has exactly ONE Mix and optionally ONE Styling.
No duplicates. No confusion. Perfect consistency.

---

**AI AGENT**: Execute phases in order. Test after each phase. Do NOT skip steps.