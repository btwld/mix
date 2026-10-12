# Mix Snacks

Thirty-one small, stateful styling lessons inspired by the [React Bits Micro catalog](https://github.com/DavidHDev/react-bits/tree/5fc9addb5b2362043332ad6d403bb436f2596318/src/content/Micro).
These are **Mix adaptations, not behavior-identical ports**. Named styles describe
the appearance and motion; widget state owns interaction and composition.

In the combined showcase, **Snacks** starts with one live example per group and
its widget code alongside. Filter to a group to compare its first two examples;
the remaining entries stay available as lightweight links. Opening an example
gives the preview and code more room. The visible code leads with the widget;
**Copy code** still copies the complete, runnable DartPad file. The separate
dark `SnacksGalleryScreen` remains an interaction and golden-test host.

Run from `examples/showcase`:

```sh
flutter run -d chrome
flutter test test/snacks/snacks_gallery_test.dart test/snacks/snacks_animation_test.dart
flutter analyze
```

## Self-contained examples

Every gallery card is backed by one canonical, copy/paste-ready Dart file. Each
file contains its own `main()`, small local palette, named styles and interaction.
Fixed styles are top-level values; state-dependent styles are functions with
explicit inputs. Callable stylers keep widget composition compact. There are no
token maps or shared setup helpers to copy. Each snippet keeps the app shell it
needs: Material supports typography and editable fields, while Squish Switch
uses WidgetsApp. It has no project-relative imports, so the entire file can be
pasted into [DartPad](https://dartpad.dev/) and run as a Flutter example.

| Controls | Actions | Motion | Agent |
|---|---|---|---|
| [Squish Switch](../lib/examples/snacks/squish_switch.dart) | [Hold Button](../lib/examples/snacks/hold_button.dart) | [Dodge Field](../lib/examples/snacks/dodge_field.dart) | [Lattice Loader](../lib/examples/snacks/lattice_loader.dart) |
| [Peek Rating](../lib/examples/snacks/peek_rating.dart) | [Pulse Heart](../lib/examples/snacks/pulse_heart.dart) | [Swipe Row](../lib/examples/snacks/swipe_row.dart) | [Status Mark](../lib/examples/snacks/status_mark.dart) |
| [Spring Check](../lib/examples/snacks/spring_check.dart) | [Slide Commit](../lib/examples/snacks/slide_commit.dart) | [Warm Tooltip](../lib/examples/snacks/warm_tooltip.dart) | [Call Chip](../lib/examples/snacks/call_chip.dart) |
| [Rubber Segment](../lib/examples/snacks/rubber_segment.dart) | [Fuse Button](../lib/examples/snacks/fuse_button.dart) | [Swipe Toast](../lib/examples/snacks/swipe_toast.dart) | [Prompt Bar](../lib/examples/snacks/prompt_bar.dart) |
| [Jelly Radio](../lib/examples/snacks/jelly_radio.dart) | [Bell Toggle](../lib/examples/snacks/bell_toggle.dart) | [Folder Float](../lib/examples/snacks/folder_float.dart) | [Voice Pill](../lib/examples/snacks/voice_pill.dart) |
| [Glide Select](../lib/examples/snacks/glide_select.dart) | [Sling Button](../lib/examples/snacks/sling_button.dart) | [Branched Menu](../lib/examples/snacks/branched_menu.dart) | [Thought Line](../lib/examples/snacks/thought_line.dart) |
| [Scrub Field](../lib/examples/snacks/scrub_field.dart) |  |  | [Refine Frame](../lib/examples/snacks/refine_frame.dart) |
| [Code Slots](../lib/examples/snacks/code_slots.dart) |  |  | [Slosh Gauge](../lib/examples/snacks/slosh_gauge.dart) |
| [Wake Slider](../lib/examples/snacks/wake_slider.dart) |  |  | [Border Glow](../lib/examples/snacks/border_glow.dart) |
| [Comet Dial](../lib/examples/snacks/comet_dial.dart) |  |  |  |

The gallery imports these same files through `lib/snacks/examples.dart`; there is no
second implementation to drift. `lib/snacks/theme.dart` only styles the gallery shell.
The copy button on every card loads and copies its exact `.dart` asset.
On narrow screens, a preview that needs more room can scroll horizontally.

The gallery declares Mix ^2.2.0. DartPad stable currently reports Dart 3.13.4,
Flutter 3.47.5, and Mix 2.2.0. The snippets retain their existing syntax, which
was also verified with Mix 2.1.0; this consolidation does not change their
styling or interaction APIs. Recheck the live service below before adopting
newer APIs. See [app setup](../README.md) for local overrides and published-dependency
web builds.

From `examples/showcase`, recheck the live DartPad service with:

```sh
dart run tool/verify_dartpad.dart
```

## Intentional adaptations

- **Spring Check:** 28×28 visual square within a 44px hit row, 2px border at 28% opacity (50% hover), centered 18px Material tick, and a label-width strike. Its 6px radius is a deliberate checkbox-like treatment; upstream defaults to 9px. Upstream draws the tick and coordinates the fill, outer swell, label and strike from one spring. Here, a Mix spring fill, fading icon and animated strike keep the lesson compact. The fill overshoot is clipped to the square.
- **Rubber Segment:** spring travel with a brief stretch/squash keyframe; not independently simulated leading/trailing edges. **Sling Button:** drag left and release to send, with spring recoil, without the upstream tether/flight. **Branched Menu:** clipped animated section folding, without drawn branch paths.
- **Wake Slider / Comet Dial:** custom-painted direct-input accents with 320ms release decay. The comet trail follows drag direction; angular flick/momentum physics remain outside this example.
- **Slosh Gauge:** direct liquid-level input and a temporarily tilted surface that springs flat on release; no splash simulation. Fill height and tilt animate separately so a spring cannot overshoot the height below zero.
- **Status Mark / Prompt Bar / Thought Line:** status glyph reveal, send/stop, and animated staged rows; not upstream's full shape morphs, composer features or interactive trace.
- **Border Glow:** a Mix adaptation of the animated border from [Libraries.dev](https://libraries.dev), with no painter. A keyframe loop spins a comet-shaped `SweepGradientMix` behind the card, and the card covers all but a 1.5px padding ring. Inside, the card spins a dimmed copy of the comet under an inset veil whose surface-colored shadow feathers it into an inner glow. The play button springs on hover and press, its icon pops on a triggered keyframe, and a soft halo orbits it in step with the comet. When stopped, an ease-out replaces each loop.
- **Voice Pill:** a synthetic waveform, not microphone capture. **Refine Frame:** a gradient specimen, not generation output.

Roundness follows purpose: 6px checkbox; 8–10px inset selections/menu; 12–16px fields and action surfaces; 20px gallery cards; stadium/circle only for pills, tracks and round handles.

- **Slide Commit:** full-travel white capsule, pending spinner, green expanding confirmation and timed reset. Simulated success only.
- **Fuse Button:** 4s amber perimeter countdown, crossfaded Archive/Undo faces, hover-reentry and app-lifecycle pause.
- **Glide Select / Swipe Toast / Swipe Row:** fixed-width trigger and anchored menu pop and delayed exit unmount; clipped toast reveal/exit; row departure and restore crossfade. Swipe Row keeps a stable demo stage rather than collapsing the gallery card.

- **Folder Float:** three evenly separated cards fade out completely when closed; a fixed hover area contains the whole spread. A visible tab and upright front keep the folder silhouette clear.
- **Prompt Bar / Thought Line:** explicit text-field inset matches the send tile; a fixed thought stage keeps the heading anchored while indented steps reveal. Idle state says “Run thought.”

## Animation and Flutter boundaries

Implicit Mix animations cover state and variant transitions. Heart, bell and segment stretch use keyframes because their choreography is the point. Controllers are retained for interruptible hold/countdown progress and continuous status/waveform motion. Painted wake/trail amplitudes use Flutter tweens because they feed custom painters. Timers model simulated work, not hand-stepped tweening. Raw pointer listeners distinguish canceled accepted drags from successful releases; Flutter can otherwise report both through `onDragEnd`.

Flutter `TextField` owns text editing, selection, focus and formatters. Painters own wake bars, radial ticks/trails and status glyphs. These exceptions do not replace ordinary Mix styling. Positioned layers are used only for geometry independent of a sibling's measured size (checkbox strike and bottom-anchored hold fill).

## Verification

The Snacks tests cover all 31 primary interactions, interruption/reversal, deterministic intermediate and settled frames, compact/wide gallery layouts, source-asset integrity, clipboard behavior, and three goldens (wide gallery and unchecked/checked Spring Check). Continuous animations use exact duration pumps, never `pumpAndSettle`. Pixel comparisons are used for custom drawing, while ordinary motion checks use global painted geometry rather than generated Transform nesting.

`test/snacks/snacks_standalone_test.dart` also launches every snippet's real `main()` on
a compact screen, without the gallery's theme, tokens or overlay setup. Dedicated
switch and checkbox tests cover keyboard activation and the merged semantics;
the checkbox test also checks strike alignment during and after its animation.

```sh
flutter test test/snacks/snacks_standalone_test.dart test/snacks/snacks_animation_test.dart \
  test/snacks/snacks_gallery_test.dart test/snacks/spring_check_app_test.dart \
  test/snacks/squish_switch_app_test.dart
```

These are focused interaction demos, not a complete accessible component library.
Pointer-oriented hold/drag examples still need equivalent keyboard and semantic
actions for production use; hidden menu actions also need a dedicated focus audit.
The cleanup preserves those interaction boundaries rather than silently replacing
them with different controls.


### Headless integration tests (no desktop input)

`integration_test/snacks_gallery_test.dart` runs all 31 examples inside the real
scrollable app, with one scenario per example. It covers hover, drag, hold,
text entry, timed completion, and reruns using Flutter-injected input. Existing
widget tests remain the place for exact intermediate-frame/golden assertions.

Install a ChromeDriver matching your Chrome version, then run from the example
package (keep ChromeDriver running in a separate terminal):

```sh
chromedriver --port=4444
```

```sh
flutter drive --driver=test_driver/integration_test.dart \
  --target=integration_test/snacks_gallery_test.dart \
  -d web-server --browser-name=chrome --headless --driver-port=4444 \
  --browser-dimension=1100x900 --no-web-resources-cdn
```

This launches an isolated headless browser. It does not move the system pointer,
focus a desktop app, or type through the OS. The integration binding supplies
the test extension; the production entry point stays unchanged.

For capture tools, `--dart-define=SNACKS_RECORDING=true` enables fully live frames,
brief viewing pauses, and start/end console markers per example. Recording
remains separate from assertions. Headless debug runs verify behavior, not
native-device frame-time budgets or perceptual smoothness.
