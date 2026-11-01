# Fluent API

Each setter returns a new merged styler. Plain values replace; Mix values
accumulate fields. Consult [authoring policy](styler-api-policy.md) for nullable,
directional and deprecated convenience-setter migrations.

```dart
final base = BoxStyler().padding(.all(16)).borderRadius(.circular(8));
final solid = base.color(Colors.blue);
final composed = solid.merge(BoxStyler().width(200));
```

Neither `solid` nor `composed` mutates `base`. A partial padding patch can retain
a previously set side; do not describe all chains as whole-value replacement.

## Common authoring surfaces

| Concern | Representative calls |
|---|---|
| Dimensions | `size(w, h)`, `width(v)`, `minWidth(v).maxWidth(v)` |
| Spacing | `padding(.all(v))`, `margin(.start(v).end(v))` |
| Decoration | `color`, `gradient`, `shape`, `border`, `borderRadius` |
| Shadow | `shadow(.color(c).blurRadius(b))`, `shadows`, `elevation` |
| Transform | `rotate`, `scale`, `translate`, `skew`, `transform(.identity())` |
| Typography | `fontSize`, `fontWeight`, `style(textToken.mix())` |

These are examples, not a generated API inventory. Read the styler's generated
part or version-pinned API for exact factories and parameter types.

Known uniform borders use `.border(.color(c).width(w))`. Specific sides and
nullable/reused `BorderSideMix` values use wrappers. Broad physical spacing or
constraint setters must precede specific ones when preserving an override;
`start` and `end` remain directional. The [policy](styler-api-policy.md) contains
fallback rules that a mechanical setter rename would miss.

Gradient helpers (`linearGradient`, `radialGradient`, `sweepGradient` and
foreground variants) accept stops, tile mode and transforms such as
`GradientRotation`; no raw gradient constructor is needed solely for rotation.

## Composite and layout stylers

`RowBox` and `ColumnBox` use `FlexBoxStyler`, not dedicated row/column stylers.
`WrapBoxStyler` combines Box fields with Wrap fields; `wrapAlignment` and
`wrapClipBehavior` address the inner Wrap, while `alignment` / `clipBehavior`
address the outer Box. `.flow(WrapStyler(...))` is its nested-style entry;
`.wrap(...)` remains the modifier API. Stack uses `stackAlignment`,
`stackClipBehavior` and `.stack(...)` for the same collision distinction.

Grid has no outer Box and is not callable. Give its initializer an explicit
type, e.g. `final GridBoxStyler grid = .equalColumns(3).gap(16)`.
See [Layout](layout.md) for selection, constraints and interpolation boundaries.

## Interaction Widgets

Use `Pressable` for interaction state around any child, and `PressableBox` (or `BoxStyler.pressable(...)`) when the interactive surface is also a `Box`.

```dart
final button = BoxStyler()
    .padding(.all(16))
    .onPressed(.scale(0.96));
final label = TextStyler().fontWeight(.w600);

button.pressable(onPress: submit, child: label('Save'));
```

`button.pressable(...)` is shorthand for `PressableBox(style: button, ...)` and takes the same parameters.

While focused, `Pressable` handles unmodified Space, Enter, numpad Enter,
select, and game button A itself: pressed on key down, activated once on key up.
It leaves those keys alone when a descendant holds focus, so a nested
`TextField` still receives them, and leaves modified chords to application
shortcuts. Those direct key bindings are handled before Flutter can dispatch an
`ActivateIntent`; use `onKeyEvent` to override them. `ActivateIntent` remains
bound so remapped shortcuts and programmatic invocation activate `onPress`, and
a custom action can override that binding. With `semanticsRole: .link`, Enter
activates but Space does not. Custom actions are not installed while the
Pressable is disabled.


`PressableBox` forwards the full Pressable surface and renders its child through
`Box`. It accepts focus/controller options, cursor, keyboard/actions, semantics
role and label, and exclusion of its own semantics without removing descendants.
Check the widget's current constructor instead of maintaining a second parameter
catalog here.

## Callable stylers

Widget-backed generated stylers can construct widgets directly:

```dart
BoxStyler().color(Colors.blue).padding(.all(16))(child: Text('Hello'));
TextStyler().fontSize(16)('Label');
```

Layout-only `FlexStyler`, `WrapStyler`, and `StackStyler` do not create widgets.
Handwritten `GridBoxStyler` needs `GridBox(style: ..., children: ...)`.
Use constructors for prebuilt values and `merge()` for reusable fragments;
confirm generated `call()` support against the target rather than assuming all
stylers expose it.
