# Flutter Mix 2.0 - YouTube Episode Presentation (v2)

## Episode Title

"Mix 2.0: The Styling System Flutter Has Been Missing"

---

## Revised Episode Structure

### SEGMENT 1: The Hook - Before/After (3-4 min)

**Opening - show, don't tell:**

Start with the code on screen. No preamble, no "hey guys welcome back." Just code.

> "Here's a button. It changes color on hover, adapts to dark mode, and animates
> smoothly between states. This is what it takes in vanilla Flutter."

Show the 60-line `StatefulWidget` version. Let it sink in. The `MouseRegion`, the
`setState`, the `AnimatedContainer`, the `Theme.of(context)` checks, the nested
`BoxDecoration`. Viewers who've written Flutter will feel this in their bones.

> "And here's the same button with Mix."

Show the 20-line `StatelessWidget` version. Side by side if possible.

**The real story isn't the line count.** Call this out explicitly:

> "The line count is nice - 60 lines down to 20. But that's not the real win.
> Look at the widget type. The vanilla version is a StatefulWidget. The Mix
> version is a StatelessWidget. That state variable for hover tracking? Gone.
> The MouseRegion wrapper? Gone. The manual Theme.of(context) lookup? Gone.
> Mix handles all of that declaratively.
>
> Fewer stateful widgets means fewer lifecycle bugs, fewer setState timing
> issues, simpler testing. That's not a cosmetic improvement. That's a
> different architecture."

**Code - WITHOUT Mix (~60 lines):**

```dart
class InteractiveButton extends StatefulWidget {
  @override
  State<InteractiveButton> createState() => _InteractiveButtonState();
}

class _InteractiveButtonState extends State<InteractiveButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: 60,
        width: 200,
        decoration: BoxDecoration(
          color: isDark
              ? (_isHovered ? Colors.blue.shade700 : Colors.grey.shade800)
              : (_isHovered ? Colors.blue.shade300 : Colors.blue),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: Offset(0, 4),
              blurRadius: 10,
            ),
          ],
        ),
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: Duration(milliseconds: 300),
            style: TextStyle(
              color: isDark ? Colors.black : Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            child: Text('Click me'),
          ),
        ),
      ),
    );
  }
}
```

**Code - WITH Mix (~20 lines):**

```dart
class InteractiveButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final style = BoxStyler()
        .height(60)
        .width(200)
        .color(Colors.blue)
        .borderRounded(30)
        .shadowOnly(
          color: Colors.black.withValues(alpha: 0.1),
          offset: Offset(0, 4),
          blurRadius: 10,
        )
        .animate(.easeInOut(300.ms))
        .onHovered(BoxStyler().color(Colors.blue.shade300))
        .onDark(BoxStyler().color(Colors.grey.shade800)
            .onHovered(BoxStyler().color(Colors.blue.shade700)));

    return PressableBox(
      style: style,
      onPress: () {},
      child: StyledText('Click me',
        style: TextStyler()
            .color(Colors.white)
            .fontSize(16)
            .fontWeight(.w600)
            .animate(.easeInOut(300.ms))
            .onDark(TextStyler().color(Colors.black)),
      ),
    );
  }
}
```

**Comparison table to show on screen:**

| Aspect              | Without Mix          | With Mix                |
|---------------------|----------------------|-------------------------|
| Widget type         | StatefulWidget       | StatelessWidget         |
| Hover tracking      | Manual MouseRegion   | Built-in `.onHovered()` |
| Dark mode           | Theme.of() checks    | `.onDark()` variant     |
| Animation           | AnimatedContainer    | `.animate()` one-liner  |
| Style location      | Inside widget tree   | Separate, reusable      |
| Lines of code       | ~60                  | ~20                     |

> "That's Mix. A type-safe styling system for Flutter that separates style
> definitions from widget structure. Let me show you how it works."

---

### SEGMENT 2: What Is Mix? (2-3 min)

**Core Architecture - three parts:**

```
Spec (immutable data)  +  Styler (builder)  +  Widget (renders)
```

Keep the explanation tight. No jargon.

- **Spec** is an immutable data class. A frozen snapshot of "here's how this widget
  should look." Once resolved, it doesn't change.
- **Styler** is what you write day-to-day. Fluent builder with method chaining.
  Every call returns the styler so you can keep chaining.
- **Widget** is a Mix-aware widget that consumes a style and renders it. `Box`,
  `StyledText`, `StyledIcon`, `Pressable`, etc.

**Why separate them?**

- Styles become testable without building widgets
- Styles become reusable across different widgets
- Styles become composable. Merge them, override them, extend them.
- Context resolution (dark mode, screen size) happens automatically at render time

**Widget mapping table:**

| Mix Widget    | Replaces                  |
|---------------|---------------------------|
| `Box`         | `Container`               |
| `RowBox`      | `Row` + `Container`       |
| `ColumnBox`   | `Column` + `Container`    |
| `ZBox`        | `Stack` + `Container`     |
| `StyledText`  | `Text`                    |
| `StyledIcon`  | `Icon`                    |
| `StyledImage` | `Image`                   |
| `Pressable`   | `GestureDetector` + state |

**Important to mention here:** Mix widgets live alongside regular Flutter widgets.
You don't have to convert your whole app. A `Box` can be a child of a regular
`Column`. A regular `Text` can be a child of a `Box`. They interoperate naturally.

---

### SEGMENT 3: The Fluent API - Composition First (3-5 min)

**Lead with composition, not gradients.** The `baseCard` pattern is what sells
experienced developers. Start there.

**Style Composition & Reuse:**

```dart
// Define a base style
final baseCard = BoxStyler()
    .borderRounded(12)
    .paddingAll(16)
    .shadowOnly(color: Colors.black12, blurRadius: 10);

// Extend it for different variants - just chain more methods
final primaryCard = baseCard.color(Colors.blue);
final successCard = baseCard.color(Colors.green);
final errorCard   = baseCard.color(Colors.red);
```

> "In vanilla Flutter, you'd extract a function that returns a BoxDecoration
> with parameters. Or copy-paste the Container and change the color. Neither
> is clean. With Mix, you just chain onto the base. The base style is shared,
> the variants are one-liners."

**Then show a simple styled box:**

```dart
final style = BoxStyler()
    .height(50)
    .width(100)
    .borderRounded(10)
    .linearGradient(
      colors: [Colors.deepPurple.shade700, Colors.deepPurple.shade200],
      begin: .topLeft,
      end: .bottomRight,
    )
    .shadowOnly(
      color: Colors.deepPurple.shade700,
      offset: Offset(0, 4),
      blurRadius: 10,
    );

Box(style: style)
```

**Then the gradient circle (flashy, fun, quick):**

```dart
final style = BoxStyler()
    .height(120)
    .width(120)
    .borderRounded(60)
    .shadowOnly(
      color: Colors.purple.shade300,
      blurRadius: 25,
      spreadRadius: 2,
    )
    .sweepGradient(
      colors: [
        Colors.blue.shade400,
        Colors.purple.shade400,
        Colors.pink.shade400,
        Colors.orange.shade400,
        Colors.blue.shade400,
      ],
      center: .center,
      startAngle: 0,
      endAngle: math.pi * 2,
    );

Box(style: style) // Glowing rainbow circle
```

**Key points to call out:**

- Every method returns the styler, enabling chaining
- API mirrors Flutter naming: `.paddingAll()`, `.borderRounded()`, `.color()`
- Dart 3.10 dot-shorthands: `.center`, `.cover`, `.bold`
- Merge two style fragments: `baseCard.merge(elevated)`

---

### SEGMENT 4: Dynamic Styling with Variants (4-5 min)

**This is where Mix shines.** Variants let you declare conditional styles
inline. No state management required.

**Dark Mode Toggle:**

```dart
final buttonStyle = BoxStyler()
    .height(60)
    .width(60)
    .borderRounded(30)
    .color(Colors.grey.shade200)
    .animate(.easeInOut(600.ms))
    .onDark(BoxStyler().color(Colors.grey.shade800))
    .shadowOnly(
      color: Colors.black.withValues(alpha: 0.1),
      offset: Offset(0, 4),
      blurRadius: 10,
    );

final iconStyle = IconStyler()
    .color(Colors.grey.shade800)
    .size(28)
    .icon(Icons.dark_mode)
    .animate(.easeInOut(200.ms))
    .onDark(IconStyler().icon(Icons.light_mode).color(Colors.yellow));

PressableBox(
  style: buttonStyle,
  onPress: () => setState(() => isDark = !isDark),
  child: StyledIcon(style: iconStyle),
)
```

**Built-in Variants:**

```
Interaction:  .onHovered()  .onPressed()  .onFocused()  .onDisabled()
Theme:        .onDark()     .onLight()
Screen size:  .onMobile()   .onTablet()   .onDesktop()
Orientation:  .onPortrait() .onLandscape()
Platform:     .onIos()      .onAndroid()  .onWeb()  .onMacos()
Custom:       .onBreakpoint(Breakpoint.maxWidth(575), ...)
Logic:        .onNot(variant)  .onBuilder((context) => ...)
```

**Responsive Example:**

```dart
final style = BoxStyler()
    .width(100)
    .height(100)
    .color(Colors.blue.shade400)
    .onBreakpoint(
      Breakpoint.maxWidth(575),
      BoxStyler().color(Colors.green),
    )
    .borderRounded(16)
    .animate(.spring(300.ms));
```

**How variants compose:** When multiple variants are active, they're applied in
declaration order. Last-declared variant wins for conflicting properties.
`.onDark().onHovered()` means: in dark mode, apply the dark override. When also
hovered, apply the hover override on top. You can nest them for combined states:
`.onDark(BoxStyler().onHovered(BoxStyler().color(...)))`.

**Comparison moment:** Without Mix, that dark mode + hover button requires a
`StatefulWidget`, a `MouseRegion`, `Theme.of(context)`, multiple `if` statements,
and animation controllers. With Mix, it's all declarative in the style definition.

---

### SEGMENT 5: Animations (4-5 min)

**Three levels of complexity. Most apps only need Level 1.**

#### Level 1: Implicit Animations (the 80% case)

Add `.animate()` to any style. State changes animate automatically.

```dart
final style = BoxStyler()
    .color(Colors.black)
    .height(100)
    .width(100)
    .borderRounded(10)
    .transform(.identity())
    .translate(0, _translated ? 100 : -100)
    .animate(.spring(300.ms, bounce: 0.6));

Box(style: style)
```

> "One `.animate()` call. Spring physics on every property change. No
> AnimationController, no Tween, no TickerProviderStateMixin. When
> `_translated` changes, the box bounces to its new position."

Under the hood, Mix creates and manages an AnimationController for you. It's
auto-disposed when the widget leaves the tree.

#### Level 2: Keyframe Animations

For choreographed sequences, Mix has a track-based keyframe system:

```dart
BoxStyler()
    .keyframeAnimation(
      trigger: _trigger,
      timeline: [
        KeyframeTrack('scale', [
          .easeOutSine(1.25, 200.ms),
          .elasticOut(0.85, 500.ms),
        ], initial: 0.85),
        KeyframeTrack<double>('width', [
          .decelerate(50, 100.ms),
          .linear(50, 100.ms),
          .elasticOut(40, 500.ms),
        ], initial: 40, tweenBuilder: Tween.new),
      ],
      styleBuilder: (values, style) => style
          .scale(values.get('scale'))
          .width(values.get('width')),
    )
```

Multiple named tracks run simultaneously, each with its own curve and duration.
Triggered by `ValueNotifier` changes.

**A note on the string-based keys:** Yes, `values.get('scale')` uses string
lookup. This is a tradeoff. The keyframe system needs to map arbitrary animated
values back to style properties, and string keys keep the API flexible without
requiring codegen for every animation. For the implicit animation API (Level 1),
everything is fully type-safe.

#### Level 3: The Heart Animation (show-stopper demo)

Show the heart animation running first. Let the audience react. Then walk
through the code:

```dart
BoxStyler().keyframeAnimation(
  trigger: _trigger,
  timeline: [
    // Scale - grows then settles
    KeyframeTrack('scale', [
      .linear(1.0, 360.ms),
      .elasticOut(1.5, 800.ms),
      .elasticOut(1.0, 800.ms),
    ], initial: 1.0),
    // Vertical position - dips then floats up
    KeyframeTrack('verticalOffset', [
      .linear(0.0, 100.ms),
      .easeIn(20.0, 150.ms),
      .elasticOut(-60.0, 1000.ms),
      .elasticOut(0.0, 800.ms),
    ], initial: 0.0),
    // Squash & stretch
    KeyframeTrack('verticalStretch', [
      .ease(1.0, 100.ms),
      .ease(0.6, 150.ms),
      .ease(1.5, 100.ms),
      .ease(1.05, 150.ms),
      .ease(1.0, 880.ms),
      .ease(0.8, 100.ms),
      .ease(1.04, 400.ms),
      .ease(1.0, 220.ms),
    ], initial: 1.0),
    // Rotation wobble
    KeyframeTrack('angle', [
      .easeIn(0.0, 580.ms),
      .easeIn(16.0 * (pi / 180), 125.ms),
      .easeIn(-16.0 * (pi / 180), 125.ms),
      .easeIn(16.0 * (pi / 180), 125.ms),
      .easeIn(0.0, 125.ms),
    ], initial: 0.0),
  ],
  styleBuilder: (values, style) {
    final scale = values.get('scale');
    final verticalOffset = values.get('verticalOffset');
    final verticalStretch = values.get('verticalStretch');
    final angle = values.get('angle');

    return style
        .wrap(.new().scale(scale, scale * verticalStretch))
        .wrap(.new().translate(x: 0, y: verticalOffset))
        .wrap(.new().rotate(radians: angle));
  },
)
```

Four animation tracks running simultaneously: scale, bounce, squash-and-stretch,
and wobble. Each with different curves and durations.

**What Mix animations don't replace:** Gesture-driven animations (drag-to-dismiss,
swipe physics), `Hero` transitions, and route animations. Those still use Flutter's
built-in animation system. Mix handles state-driven visual transitions. Use both
in the same app without conflict.

---

### SEGMENT 6: Real-World Example - The Okinawa Card (2-3 min)

**Show the final result first.** The polished card running on screen. Background
image, frosted glass effect, clean layout. Let viewers see the payoff before the
code.

Then show every line:

```dart
class OkinawaCard extends StatelessWidget {
  const OkinawaCard({super.key});

  @override
  Widget build(BuildContext context) {
    final boxStyle = BoxStyler()
        .height(200)
        .width(200)
        .paddingAll(8)
        .alignment(Alignment.bottomCenter)
        .borderRounded(10)
        .backgroundImageUrl(
          'https://images.pexels.com/photos/5472603/pexels-photo-5472603.jpeg',
          fit: .cover,
        )
        .borderAll(
          color: Colors.white,
          width: 6,
          strokeAlign: BorderSide.strokeAlignOutside,
        )
        .color(Colors.blueGrey.shade50)
        .shadowOnly(
          color: Colors.black.withValues(alpha: 0.35),
          blurRadius: 100,
        );

    final columnBoxStyle = FlexBoxStyler()
        .paddingAll(8)
        .width(.infinity)
        .color(Colors.black.withValues(alpha: 0.1))
        .mainAxisSize(.min)
        .crossAxisAlignment(.start);

    final titleStyle = TextStyler()
        .color(Colors.white)
        .fontWeight(.bold)
        .fontSize(16);

    final subtitleStyle = TextStyler()
        .color(Colors.white70)
        .fontSize(14);

    return Box(
      style: boxStyle,
      child: ClipRRect(
        borderRadius: .circular(8),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: ColumnBox(
            style: columnBoxStyle,
            children: [
              titleStyle('Okinawa'),
              subtitleStyle('Japan'),
            ],
          ),
        ),
      ),
    );
  }
}
```

**What to highlight:**

- Background image with URL loading built in
- `BackdropFilter` for frosted glass composes naturally with Mix widgets
- Text styles used as callable constructors: `titleStyle('Okinawa')`
- The whole card is ~45 lines of readable code
- Mix widgets and regular Flutter widgets (`ClipRRect`, `BackdropFilter`) coexist
  in the same tree. No conversion needed.

---

### SEGMENT 7: Design Tokens & Theme Integration (3-4 min)

**Address the ThemeData question directly.** This is what experienced Flutter
developers will be wondering.

> "If you've used ThemeData and ThemeExtension, you might be wondering: why
> do I need another theming system? Fair question. Here's the relationship:
> Mix tokens complement Flutter's Theme. They don't replace it."

**How tokens work:**

```dart
// 1. Define tokens
final $primaryColor = ColorToken('primary');
final $pill = RadiusToken('pill');
final $spacing = SpaceToken('spacing.large');

// 2. Provide values via MixScope
MixScope(
  colors: {$primaryColor: Colors.blue},
  spaces: {$spacing: 16.0},
  radii: {$pill: Radius.circular(20)},
  child: MyApp(),
)

// 3. Use tokens in styles
final style = BoxStyler()
    .borderRadiusTopLeft($pill())
    .color($primaryColor())
    .height(100)
    .width(100)
    .paddingAll(16.0);

// 4. Override tokens deeper in the tree
MixScope(
  colors: {$primaryColor: Colors.red},
  child: StyledText(
    'Hello, World!',
    style: TextStyler().color($primaryColor()),
  ),
)
```

**Token types available:**

| Token Type          | Controls                      |
|---------------------|-------------------------------|
| `ColorToken`        | Colors                        |
| `SpaceToken`        | Spacing, padding, margins     |
| `RadiusToken`       | Border radii                  |
| `TextStyleToken`    | Typography                    |
| `DoubleToken`       | Numeric values                |
| `BorderSideToken`   | Border styling                |
| `ShadowToken`       | Shadows                       |
| `FontWeightToken`   | Font weights                  |
| `DurationToken`     | Animation durations           |
| `BreakpointToken`   | Responsive breakpoints        |

**The Theme integration story:**

- Use Flutter's `ThemeData` for what it's good at: `AppBarTheme`, `TextTheme`,
  Material component theming
- Use Mix tokens for what they're good at: scoped overrides, granular design
  values, styling Mix widgets
- You can bridge between them. In your `MixScope` setup, reference
  `Theme.of(context).colorScheme.primary` as a token value. One source of truth,
  two systems consuming it.

**Why tokens matter for teams:**

- Change your entire app's color scheme in one place
- Swap themes (light/dark, brand A/brand B) by swapping token maps
- Type-safe references. No magic strings or numbers.
- Scoped overrides. Different tokens for different subtrees.

---

### SEGMENT 8: Under the Hood (2-3 min)

**NEW SEGMENT. Addresses the #1 concern from technically-minded developers.**

> "You've seen what Mix can do. Now let's look at what it's doing underneath,
> because abstractions that hide too much are abstractions you can't trust."

**What does a styled Box produce?**

Walk through the widget tree that a `Box` with padding, border radius, color,
and a shadow actually generates. Show it in Flutter DevTools. Point out that
Mix produces the same underlying Flutter widgets you'd write by hand:
`DecoratedBox`, `Padding`, `ConstrainedBox`, etc. No custom RenderObjects.
No magic layers.

**How variants resolve:**

- Context-dependent variants (`.onDark()`, `.onMobile()`) resolve through
  standard `MediaQuery` and `Theme` lookups
- Interaction variants (`.onHovered()`, `.onPressed()`) are handled by
  `Pressable`, which manages a single state internally
- Mix diffs the resolved Spec before rebuilding. If the style resolves to the
  same values, the widget doesn't rebuild.

**Performance:**

- For simple styled widgets, Mix adds negligible overhead. The widget tree
  depth is comparable to what you'd write by hand.
- Animations use Flutter's standard `AnimationController` and `Ticker`.
- Variant resolution is a single pass, not per-variant evaluation.

> "The goal isn't to be faster than hand-written Flutter. It's to be the
> same speed with less code and better composition."

---

### SEGMENT 9: Incremental Adoption (1-2 min)

**NEW SEGMENT. Removes the biggest adoption fear.**

> "You don't have to rewrite your app. Mix works alongside your existing code."

Show a real example: a regular Flutter `Scaffold` with a `Column` containing
both vanilla `Container` widgets and Mix `Box` widgets. They coexist. No
wrapper needed, no special setup.

```dart
// Your existing Flutter code
Scaffold(
  body: Column(
    children: [
      // Regular Flutter widget - unchanged
      Container(
        padding: EdgeInsets.all(16),
        child: Text('This is vanilla Flutter'),
      ),

      // New Mix widget - living right next to it
      Box(
        style: BoxStyler()
            .paddingAll(16)
            .color(Colors.blue.shade50)
            .borderRounded(8)
            .onHovered(BoxStyler().color(Colors.blue.shade100))
            .animate(.easeInOut(200.ms)),
        child: Text('This is Mix'),
      ),

      // Regular Flutter widget - also unchanged
      ElevatedButton(
        onPressed: () {},
        child: Text('Still works'),
      ),
    ],
  ),
)
```

> "Start with one component. A card, a button, a hover effect. See how it
> feels. Then expand from there. If you decide Mix isn't for you, removing
> it is straightforward. Each Mix widget maps to a clear Flutter equivalent."

---

### SEGMENT 10: What Mix Doesn't Do (1 min)

**NEW SEGMENT. Builds trust through honesty.**

Be direct about limitations:

- **Not a layout system.** Mix doesn't change how Row, Column, Stack, or Flex
  work. It styles widgets. Layout is still Flutter.
- **Not for gesture-driven animations.** Drag-to-dismiss, swipe physics, scroll
  effects: use Flutter's animation controllers and physics simulations.
- **Keyframe string keys aren't type-safe.** The `values.get('scale')` pattern
  uses string lookup. It's a conscious tradeoff for API flexibility. Implicit
  animations (Level 1) are fully type-safe.
- **RC status.** Mix 2.0 is in release candidate. The API is stabilizing but
  not yet at 1.0-stable-level guarantees. Track progress on GitHub.

---

### SEGMENT 11: Getting Started & The Team Behind Mix (2-3 min)

**Installation:**

```yaml
dependencies:
  mix: ^2.0.0-rc.0
```

**Requirements:**
- Dart SDK >= 3.10.0
- Flutter >= 3.38.1

**About code generation:** `build_runner` is only needed if you're creating
custom Specs. For basic usage (Box, StyledText, variants, animations, tokens),
you just add the package and go. No codegen required.

**Ecosystem:**

- **mix** - Core framework. This is all you need to start.
- **mix_annotations** + **mix_generator** - Optional. Code generation for custom specs.
- **mix_lint** - Optional. Custom linter rules for Mix best practices.

**Who's behind this:**

[Fill in: team/company info, how long in development, contributor count,
GitHub stars, release cadence, maintenance commitment. This is the trust
signal that tech leads need before bringing this to their teams.]

**Resources:**

- GitHub: github.com/conceptadev/mix
- Documentation website with interactive examples
- 59+ examples in the `examples/` directory

---

### SEGMENT 12: Wrap-Up (1 min)

**Summary - no fluff, just the facts:**

Mix lets you describe what your UI should look like in every state, and it
handles the how.

1. **StatefulWidget to StatelessWidget** - fewer lifecycle bugs, simpler testing
2. **Style composition** - define once, extend everywhere
3. **Declarative variants** - hover, dark mode, responsive. No boilerplate.
4. **One-liner animations** - spring physics without AnimationController
5. **Design tokens** - scoped theming that works alongside Flutter's Theme
6. **Incremental adoption** - start with one widget, expand when ready

> "Mix doesn't replace Flutter's widget system. It gives your widgets a styling
> layer that's composable, declarative, and dramatically less verbose.
>
> Try it on one component. See how much code you can delete."

---

## Suggested Demo Flow

The `examples/` directory contains runnable demos. Suggested live-coding order
aligned with the new episode structure:

1. Before/After button comparison (new file or inline)
2. `examples/lib/api/widgets/box/gradient_box.dart` - Simple styled box
3. Style composition example (baseCard pattern)
4. `examples/lib/api/gradients/gradient_sweep.dart` - Rainbow gradient
5. `examples/lib/api/context_variants/on_dark_light.dart` - Dark mode toggle
6. `examples/lib/api/context_variants/responsive_size.dart` - Responsive design
7. `examples/lib/api/animation/implicit.spring.translate.dart` - Spring physics
8. `examples/lib/api/animation/keyframe.switch.dart` - Toggle switch
9. `examples/lib/api/animation/keyframe.heart.dart` - Heart animation
10. `examples/lib/examples/okinawa.card.dart` - Real-world component
11. Incremental adoption example (new file or inline)

---

## Key Terminology Cheat Sheet

| Term         | Definition                                                      |
|--------------|-----------------------------------------------------------------|
| **Spec**     | Immutable data class with resolved style values                 |
| **Styler**   | Fluent builder for constructing styles (e.g., `BoxStyler()`)    |
| **Style**    | The output of a Styler: a style definition                      |
| **Variant**  | Conditional style override (hover, dark mode, breakpoint, etc.) |
| **Token**    | Named design value resolved at runtime via `MixScope`           |
| **MixScope** | InheritedWidget that provides token values to the subtree       |
| **Modifier** | Widget wrappers applied via styling (padding, align, transform) |
| **Pressable**| Interactive widget that provides gesture + state variants       |

---

## Estimated Episode Length

| Segment                        | Duration   |
|--------------------------------|------------|
| The Hook (Before/After)        | 3-4 min    |
| What Is Mix?                   | 2-3 min    |
| Fluent API (Composition First) | 3-5 min    |
| Dynamic Styling / Variants     | 4-5 min    |
| Animations                     | 4-5 min    |
| Real-World Example             | 2-3 min    |
| Design Tokens & Theme          | 3-4 min    |
| Under the Hood                 | 2-3 min    |
| Incremental Adoption           | 1-2 min    |
| What Mix Doesn't Do            | 1 min      |
| Getting Started & Team         | 2-3 min    |
| Wrap-Up                        | 1 min      |
| **Total**                      | **28-38 min** |

---

## Changes From v1 (Summary)

**Restructured:**
- Moved Before/After comparison from Segment 8 to Segment 1 as the hook
- Reordered Fluent API demo to lead with composition, then aesthetics
- Moved Okinawa Card earlier (before tokens) for visual payoff sooner

**Added:**
- Segment 8: Under the Hood (widget tree, rebuilds, performance)
- Segment 9: Incremental Adoption (Mix + vanilla Flutter coexisting)
- Segment 10: What Mix Doesn't Do (honest limitations)
- Variant composition rules in Segment 4
- Animation lifecycle/disposal notes in Segment 5
- String-key acknowledgment in Segment 5
- Theme integration story in Segment 7
- Code generation clarification in Segment 11

**Removed/Changed:**
- Dropped the abstract "problem statement" opener. The Before/After code IS
  the problem statement. Viewers feel the pain by reading the code.
- Removed the generic closing quote. Replaced with direct summary.
- De-emphasized line count. Emphasized StatefulWidget → StatelessWidget instead.
