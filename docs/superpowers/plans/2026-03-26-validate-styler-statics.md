# Add Missing Styler Static Factory Constructors

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add missing static factory constructors to all stylers so every primary setter has a corresponding dot-shorthand factory.

**Architecture:** Each styler class has instance setter methods (generated or hand-written) for spec fields. Each needs a matching `factory Styler.fieldName(Type value) => Styler(fieldName: value);` static factory. Composite stylers (FlexBoxStyler, StackBoxStyler) must include all factories from their component stylers.

**Tech Stack:** Dart, Flutter, Mix framework

---

### Task 1: Add missing FlexStyler factories

**Files:**
- Modify: `packages/mix/lib/src/specs/flex/flex_style.dart:100-114`

- [ ] **Step 1: Add 3 missing factory constructors**

After line 110 (`factory FlexStyler.clipBehavior ...`), add:

```dart
  factory FlexStyler.verticalDirection(VerticalDirection value) =>
      FlexStyler(verticalDirection: value);
  factory FlexStyler.textDirection(TextDirection value) =>
      FlexStyler(textDirection: value);
  factory FlexStyler.textBaseline(TextBaseline value) =>
      FlexStyler(textBaseline: value);
```

- [ ] **Step 2: Verify compilation**

Run: `cd packages/mix && dart analyze lib/src/specs/flex/flex_style.dart`
Expected: No errors

- [ ] **Step 3: Commit**

```bash
git add packages/mix/lib/src/specs/flex/flex_style.dart
git commit -m "feat(mix): add missing FlexStyler static factories"
```

---

### Task 2: Add missing IconStyler factories

**Files:**
- Modify: `packages/mix/lib/src/specs/icon/icon_style.dart:119-128`

- [ ] **Step 1: Add 5 missing factory constructors**

After line 128 (`factory IconStyler.shadow ...`), add:

```dart
  factory IconStyler.grade(double value) => IconStyler(grade: value);
  factory IconStyler.opticalSize(double value) => IconStyler(opticalSize: value);
  factory IconStyler.textDirection(TextDirection value) =>
      IconStyler(textDirection: value);
  factory IconStyler.applyTextScaling(bool value) =>
      IconStyler(applyTextScaling: value);
  factory IconStyler.blendMode(BlendMode value) => IconStyler(blendMode: value);
```

- [ ] **Step 2: Verify compilation**

Run: `cd packages/mix && dart analyze lib/src/specs/icon/icon_style.dart`
Expected: No errors

- [ ] **Step 3: Commit**

```bash
git add packages/mix/lib/src/specs/icon/icon_style.dart
git commit -m "feat(mix): add missing IconStyler static factories"
```

---

### Task 3: Add missing ImageStyler factories

**Files:**
- Modify: `packages/mix/lib/src/specs/image/image_style.dart:127-136`

- [ ] **Step 1: Add 7 missing factory constructors**

After line 136 (`factory ImageStyler.repeat ...`), add:

```dart
  factory ImageStyler.centerSlice(Rect value) =>
      ImageStyler(centerSlice: value);
  factory ImageStyler.filterQuality(FilterQuality value) =>
      ImageStyler(filterQuality: value);
  factory ImageStyler.colorBlendMode(BlendMode value) =>
      ImageStyler(colorBlendMode: value);
  factory ImageStyler.excludeFromSemantics(bool value) =>
      ImageStyler(excludeFromSemantics: value);
  factory ImageStyler.gaplessPlayback(bool value) =>
      ImageStyler(gaplessPlayback: value);
  factory ImageStyler.isAntiAlias(bool value) =>
      ImageStyler(isAntiAlias: value);
  factory ImageStyler.matchTextDirection(bool value) =>
      ImageStyler(matchTextDirection: value);
```

- [ ] **Step 2: Verify compilation**

Run: `cd packages/mix && dart analyze lib/src/specs/image/image_style.dart`
Expected: No errors

- [ ] **Step 3: Commit**

```bash
git add packages/mix/lib/src/specs/image/image_style.dart
git commit -m "feat(mix): add missing ImageStyler static factories"
```

---

### Task 4: Add missing StackStyler factory

**Files:**
- Modify: `packages/mix/lib/src/specs/stack/stack_style.dart:67-72`

- [ ] **Step 1: Add 1 missing factory constructor**

After line 72 (`factory StackStyler.clipBehavior ...`), add:

```dart
  factory StackStyler.textDirection(TextDirection value) =>
      StackStyler(textDirection: value);
```

- [ ] **Step 2: Verify compilation**

Run: `cd packages/mix && dart analyze lib/src/specs/stack/stack_style.dart`
Expected: No errors

- [ ] **Step 3: Commit**

```bash
git add packages/mix/lib/src/specs/stack/stack_style.dart
git commit -m "feat(mix): add missing StackStyler static factory"
```

---

### Task 5: Add missing TextStyler factories

**Files:**
- Modify: `packages/mix/lib/src/specs/text/text_style.dart:133-143`

- [ ] **Step 1: Add 6 missing factory constructors**

After line 143 (`factory TextStyler.style ...`), add:

```dart
  factory TextStyler.strutStyle(StrutStyleMix value) =>
      TextStyler(strutStyle: value);
  factory TextStyler.textWidthBasis(TextWidthBasis value) =>
      TextStyler(textWidthBasis: value);
  factory TextStyler.textScaler(TextScaler value) =>
      TextStyler(textScaler: value);
  factory TextStyler.textHeightBehavior(TextHeightBehaviorMix value) =>
      TextStyler(textHeightBehavior: value);
  factory TextStyler.selectionColor(Color value) =>
      TextStyler(selectionColor: value);
  factory TextStyler.locale(Locale value) => TextStyler(locale: value);
```

- [ ] **Step 2: Verify compilation**

Run: `cd packages/mix && dart analyze lib/src/specs/text/text_style.dart`
Expected: No errors

- [ ] **Step 3: Commit**

```bash
git add packages/mix/lib/src/specs/text/text_style.dart
git commit -m "feat(mix): add missing TextStyler static factories"
```

---

### Task 6: Add missing FlexBoxStyler factories

**Files:**
- Modify: `packages/mix/lib/src/specs/flexbox/flexbox_style.dart:129-198`

- [ ] **Step 1: Add 3 missing factory constructors**

After line 155 (`factory FlexBoxStyler.spacing ...`), add:

```dart
  factory FlexBoxStyler.verticalDirection(VerticalDirection value) =>
      FlexBoxStyler(verticalDirection: value);
  factory FlexBoxStyler.textDirection(TextDirection value) =>
      FlexBoxStyler(textDirection: value);
  factory FlexBoxStyler.textBaseline(TextBaseline value) =>
      FlexBoxStyler(textBaseline: value);
```

- [ ] **Step 2: Verify compilation**

Run: `cd packages/mix && dart analyze lib/src/specs/flexbox/flexbox_style.dart`
Expected: No errors

- [ ] **Step 3: Commit**

```bash
git add packages/mix/lib/src/specs/flexbox/flexbox_style.dart
git commit -m "feat(mix): add missing FlexBoxStyler static factories"
```

---

### Task 7: Add missing StackBoxStyler factories

**Files:**
- Modify: `packages/mix/lib/src/specs/stackbox/stackbox_style.dart:117-178`

- [ ] **Step 1: Add 2 missing factory constructors**

After line 137 (`factory StackBoxStyler.fit ...`), add:

```dart
  factory StackBoxStyler.textDirection(TextDirection value) =>
      StackBoxStyler(textDirection: value);
  factory StackBoxStyler.stackClipBehavior(Clip value) =>
      StackBoxStyler(stackClipBehavior: value);
```

- [ ] **Step 2: Verify compilation**

Run: `cd packages/mix && dart analyze lib/src/specs/stackbox/stackbox_style.dart`
Expected: No errors

- [ ] **Step 3: Commit**

```bash
git add packages/mix/lib/src/specs/stackbox/stackbox_style.dart
git commit -m "feat(mix): add missing StackBoxStyler static factories"
```

---

### Task 8: Final verification

- [ ] **Step 1: Run full analysis**

Run: `cd packages/mix && dart analyze lib/src/specs/`
Expected: No errors

- [ ] **Step 2: Run tests**

Run: `melos run test:flutter`
Expected: All tests pass
