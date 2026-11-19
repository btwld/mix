---
name: mix-interactions
description: >-
  Design, implement, or review micro-interactions in Flutter projects that use
  or explicitly request Mix. Use for press and toggle behavior, drag and
  disclosure, loading and recovery, keyboard and screen-reader feedback,
  reduced motion, or adapting a Mix showcase Snack.
---

# Mix Interactions

Start with one user moment. Name the trigger, the rule that changes state, the
feedback the person gets, and when the interaction repeats, expires or changes
mode. For example, holding a switch acknowledges the press, canceling restores
its appearance, and activation changes its value once. The thumb position
continues to show the value after the animation settles.

For a working example, choose the closest entry in the
[Snacks catalog](references/snacks-catalog.md). For API signatures, styling
architecture or generation, use the general `mix` skill when available and
check the consuming project's installed source.

## Choose feedback the user can act on

- Show the current value and available action before activation. Reuse the
  product's labels, tokens, density, focus indicators and touch-target conventions.
- Acknowledge input immediately. Let a changed position, label, icon or value
  carry the lasting meaning. Choose motion that explains the transition and
  keeps nearby content and hit areas stable. Check optical alignment, inset
  radii and contrast at both endpoints.
- For asynchronous work, distinguish accepting an action from completing it.
  Drive success, progress and failure from the operation. Use an indeterminate
  state when progress is unknown. Keep Stop or Retry available when supported.
  On cancellation or replacement, ignore late results from the previous run.
- Keep focus in place for an inline result. Give important status changes a
  concise accessible message when the updated control alone cannot convey the
  outcome. Avoid announcing each animation frame.

## Build with Mix

Choose the API from the resolved package in the consumer. For a copied
DartPad Snack, check the version served by DartPad as well. A local Melos
override can expose a newer API.

- From Mix 2.3.0, finish the `BoxStyler` chain, then call
  `.pressable(onPress: ..., child: ...)`. It takes a required child and returns
  a `PressableBox` immediately. Keep `PressableBox(style: ..., child: ...)` for
  an earlier compatible version. Use direct `Pressable` around a row, stack,
  icon, text or other widget tree that should act as one control.
- Reuse styles across instances. Keep domain state with its existing owner and
  supply each control's callback, focus node and controller at the widget
  boundary. Keep `@MixWidget` style factories focused on styles.
- Use `.onPressed()`, `.onHovered()`, focus and disabled variants for visual
  feedback. Set `enabled: false` for a disabled pressable. Removing the callback
  alone can leave it focusable and announced as enabled. Keep a visible focus
  treatment for keyboard input.
- Preserve the outer key, hit area, gesture wrappers and keyboard behavior when
  changing syntax. Give an icon-only action a name. Let visible text supply its
  label once. For a custom switch, an outer `Semantics` can own the label,
  toggled value and tap action. Use `excludeFromSemantics: true` on the inner
  pressable and gate both activation paths on the same enabled state.

For example, bind the Save callback after composing the style.

```dart
final saveButton = BoxStyler()
    .padding(.all(16))
    .onPressed(.scale(0.97))
    .animate(.easeOut(140.ms));

return saveButton.pressable(onPress: save, child: const Text('Save'));
```

## Pick the smallest motion that explains the change

| Moment | Mix pattern | What to check |
| --- | --- | --- |
| Press, hover, focus or reveal | Variant with implicit `.animate()` | Start around 0.96–0.98 scale for a press or 120–200 ms for a reveal. Keep frequent actions easy to repeat. |
| Toggle or selection | Spring on the moving styler | Retarget from the current position on reversal. A restrained 220–360 ms spring is a starting point. |
| Drag | Follow the pointer directly. Swipe Row uses `.linear(1.ms)` while dragging | Decide on release using the threshold. Handle cancellation and restore. |
| One-off accent | `keyframeAnimation` with a `Listenable` trigger | A quick tap still plays the accent. Put thumb travel and thumb stretch on separate stylers if they have different animation owners. |
| Multi-step visual sequence | `phaseAnimation` with named phases | Use `onEnd` for visual sequencing. Keep the real operation's outcome independent of animation completion. |

For reduced motion, read `MediaQuery.disableAnimationsOf(context)` (or the
project's equivalent) and show the selected endpoint immediately. For Squish
Switch, skip the thumb stretch and spring travel while keeping its final
position, accessible value and activation behavior. Its showcase demo
deliberately plays the full motion.

## Review and verify

Review the reachable states for this control. Is its trigger discoverable,
its current state visible, and its response predictable and immediate? Does
the strength of feedback fit the event? After a repeat, cancellation or mode
change, can a first-time user tell what happened and what they can do next?

Report each finding with the trigger, observed consequence, smallest Mix or
semantics change, and a way to verify it. Distinguish source inspection from
behavior you exercised. For example, if empty input removes Send's callback but leaves the action enabled,
pass `enabled: canSend || busy` and
verify that empty input exposes a disabled action while a busy request still
offers Stop.

- Test meaningful before, intermediate and settled states. For a toggle, try a
  canceled press, rapid reversal, and keyboard activation. For a drag, release
  on both sides of its threshold and cancel mid-gesture.
- For a request, start A, stop it, start B and deliver A's completion. B and
  any newer draft must survive. Exercise recovery if the operation can fail.
- Inspect the semantics tree for one named action, correct role, value and
  enabled state. Exercise reduced motion and confirm the same outcome. Pump
  bounded durations for a repeating loader.
- In an app, run its focused tests. When changing a showcase Snack, follow the
  catalog's [contributor steps](references/snacks-catalog.md#changing-a-showcase-snack).
