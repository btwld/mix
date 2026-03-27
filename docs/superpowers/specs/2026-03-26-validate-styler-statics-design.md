# Validate Styler Static Factory Constructors

## Goal

Every primary setter on each Styler must have a corresponding static factory constructor. Composite stylers (FlexBoxStyler, StackBoxStyler) must include all factories from their component stylers.

## Exclusions

- `semanticsLabel` / `semanticLabel` — excluded from all stylers
- Convenience/shorthand methods from mixins that aren't primary spec fields

## Missing Factories

### FlexStyler (7)
- `clipBehavior(Clip)`
- `crossAxisAlignment(CrossAxisAlignment)`
- `mainAxisAlignment(MainAxisAlignment)`
- `mainAxisSize(MainAxisSize)`
- `textBaseline(TextBaseline)`
- `textDirection(TextDirection)`
- `verticalDirection(VerticalDirection)`

### IconStyler (5)
- `applyTextScaling(bool)`
- `blendMode(BlendMode)`
- `grade(double)`
- `opticalSize(double)`
- `textDirection(TextDirection)`

### ImageStyler (7)
- `centerSlice(Rect)`
- `colorBlendMode(BlendMode)`
- `excludeFromSemantics(bool)`
- `filterQuality(FilterQuality)`
- `gaplessPlayback(bool)`
- `isAntiAlias(bool)`
- `matchTextDirection(bool)`

### StackStyler (1)
- `textDirection(TextDirection)`

### TextStyler (10)
- `locale(Locale)`
- `maxLines(int)`
- `overflow(TextOverflow)`
- `selectionColor(Color)`
- `softWrap(bool)`
- `strutStyle(StrutStyleMix)`
- `textDirection(TextDirection)`
- `textHeightBehavior(TextHeightBehaviorMix)`
- `textScaler(TextScaler)`
- `textWidthBasis(TextWidthBasis)`

### FlexBoxStyler
- Must propagate all new FlexStyler factories: `textBaseline`, `textDirection`, `verticalDirection`
- Plus any FlexStyler factories already missing

### StackBoxStyler
- Must propagate StackStyler's new `textDirection`
- Plus any other missing BoxStyler/StackStyler factories

## Pattern

```dart
factory FooStyler.fieldName(Type value) => FooStyler(fieldName: value);
```

## Approach

Mechanical addition following the established pattern in each `*_style.dart` file. No architectural changes.
