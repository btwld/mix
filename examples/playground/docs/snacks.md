# Mix Snacks

Thirty small, stateful styling lessons inspired by the [React Bits Micro catalog](https://github.com/DavidHDev/react-bits/tree/5fc9addb5b2362043332ad6d403bb436f2596318/src/content/Micro).
These are **Mix adaptations, not behavior-identical ports**. Named styles describe
the appearance and motion; widget state owns interaction and composition.

Run from `examples/playground`:

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
| [Squish Switch](../lib/snippets/squish_switch/main.dart) | [Hold Button](../lib/snippets/hold_button/main.dart) | [Dodge Field](../lib/snippets/dodge_field/main.dart) | [Lattice Loader](../lib/snippets/lattice_loader/main.dart) |
| [Peek Rating](../lib/snippets/peek_rating/main.dart) | [Pulse Heart](../lib/snippets/pulse_heart/main.dart) | [Swipe Row](../lib/snippets/swipe_row/main.dart) | [Status Mark](../lib/snippets/status_mark/main.dart) |
| [Spring Check](../lib/snippets/spring_check/main.dart) | [Slide Commit](../lib/snippets/slide_commit/main.dart) | [Warm Tooltip](../lib/snippets/warm_tooltip/main.dart) | [Call Chip](../lib/snippets/call_chip/main.dart) |
| [Rubber Segment](../lib/snippets/rubber_segment/main.dart) | [Fuse Button](../lib/snippets/fuse_button/main.dart) | [Swipe Toast](../lib/snippets/swipe_toast/main.dart) | [Prompt Bar](../lib/snippets/prompt_bar/main.dart) |
| [Jelly Radio](../lib/snippets/jelly_radio/main.dart) | [Bell Toggle](../lib/snippets/bell_toggle/main.dart) | [Folder Float](../lib/snippets/folder_float/main.dart) | [Voice Pill](../lib/snippets/voice_pill/main.dart) |
| [Glide Select](../lib/snippets/glide_select/main.dart) | [Sling Button](../lib/snippets/sling_button/main.dart) | [Branched Menu](../lib/snippets/branched_menu/main.dart) | [Thought Line](../lib/snippets/thought_line/main.dart) |
| [Scrub Field](../lib/snippets/scrub_field/main.dart) |  |  | [Refine Frame](../lib/snippets/refine_frame/main.dart) |
| [Code Slots](../lib/snippets/code_slots/main.dart) |  |  | [Slosh Gauge](../lib/snippets/slosh_gauge/main.dart) |
| [Wake Slider](../lib/snippets/wake_slider/main.dart) |  |  |  |
| [Comet Dial](../lib/snippets/comet_dial/main.dart) |  |  |  |

The gallery imports these same files through `lib/snacks/examples.dart`; there is no
second implementation to drift. `lib/snacks/theme.dart` only styles the gallery shell.
The copy button on every card loads and copies its exact `main.dart` asset.
On narrow screens, a preview that needs more room can scroll horizontally.

The gallery declares Mix ^2.2.0. DartPad stable currently reports Dart 3.13.4,
Flutter 3.47.5, and Mix 2.2.0. The snippets retain their existing syntax, which
was also verified with Mix 2.1.0; this consolidation does not change their
styling or interaction APIs. Recheck the live service below before adopting
newer APIs. See [app setup](../README.md) for local overrides and published-dependency
web builds.

From `examples/playground`, recheck the live DartPad service with:

```sh
dart run tool/verify_dartpad.dart
```

## Intentional adaptations

- **Spring Check:** 28×28 visual square within a 44px hit row, 2px border at 28% opacity (50% hover), centered 18px Material tick, and a label-width strike. Its 6px radius is a deliberate checkbox-like treatment; upstream defaults to 9px. Upstream draws the tick and coordinates the fill, outer swell, label and strike from one spring. Here, a Mix spring fill, fading icon and animated strike keep the lesson compact. The fill overshoot is clipped to the square.
- **Rubber Segment:** spring travel with a brief stretch/squash keyframe; not independently simulated leading/trailing edges. **Sling Button:** drag left and release to send, with spring recoil, without the upstream tether/flight. **Branched Menu:** clipped animated section folding, without drawn branch paths.
- **Wake Slider / Comet Dial:** custom-painted direct-input accents with 320ms release decay. The comet trail follows drag direction; angular flick/momentum physics remain outside this example.
- **Slosh Gauge:** direct liquid-level input and a temporarily tilted surface that springs flat on release; no splash simulation. Fill height and tilt animate separately so a spring cannot overshoot the height below zero.
- **Status Mark / Prompt Bar / Thought Line:** status glyph reveal, send/stop, and animated staged rows; not upstream's full shape morphs, composer features or interactive trace.
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

The Snacks tests cover all 30 primary interactions, interruption/reversal, deterministic intermediate and settled frames, compact/wide gallery layouts, source-asset integrity, clipboard behavior, and three goldens (wide gallery and unchecked/checked Spring Check). Continuous animations use exact duration pumps, never `pumpAndSettle`. Pixel comparisons are used for custom drawing, while ordinary motion checks use global painted geometry rather than generated Transform nesting.

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

`integration_test/snacks_gallery_test.dart` runs all 30 examples inside the real
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
