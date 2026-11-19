# Mix Snacks catalog

In a Mix checkout, open the named file under
`examples/showcase/lib/examples/snacks/`. From an installed skill, the
[showcase guide](https://github.com/btwld/mix/blob/main/examples/showcase/docs/snacks.md)
links to the standalone Dart files and explains their adaptations from React
Bits Micro. Check the version used by your project before adopting a pattern.
The small local palettes make the demos portable. Use product tokens in an app.

| User moment | Snack | What to study |
| --- | --- | --- |
| Press and toggle | `squish_switch.dart` | Press shrink, spring-driven thumb travel, independent squish trigger, one outer switch semantics owner. |
| Toggle with an icon accent | `bell_toggle.dart` | The bell keyframes can replay while the pill retains its own pressed response. |
| Send, stop and edit | `prompt_bar.dart` | Empty-input guard, a cancelable demo timer, preserving a newer draft and swapping the accessible action name. |
| Progress and completion | `call_chip.dart` | A linear fill ends a **simulated** run and the label shows success or retry. In an app, the operation owns its outcome. |
| Drag to reveal or remove | `swipe_row.dart` | Pointer tracking, thresholds, a spring on release, cancellation and a reachable Restore action after removal. |
| Change selection | `rubber_segment.dart` | Indicator travel and stretch during selection. |
| Change a continuous value | `wake_slider.dart`, `scrub_field.dart` | Live value feedback, drag limits, release, and switching between scrub and text entry. |
| Disclose choices | `glide_select.dart`, `branched_menu.dart` | Highlight changes, opening and closing, nested selection. |
| Show activity or status | `lattice_loader.dart`, `status_mark.dart`, `thought_line.dart` | Waiting, distinct states and staged feedback. |
| Notify or explain | `swipe_toast.dart`, `warm_tooltip.dart` | Entry, exit, dismissal, contextual copy and timeout behavior. |
| Like, select or undo | `pulse_heart.dart`, `jelly_radio.dart`, `fuse_button.dart` | Bounded accents, interruptibility and a visible undo window. |
| Capture voice input | `voice_pill.dart` | Hold, release or cancel and synthetic waveform feedback. |

### Changing a showcase Snack

1. Start with the nearest existing example. Keep the new file self-contained
   with its own `main()`, named styles, and only Dart, Flutter and Mix imports.
   Match the filename to the lowercase, underscore-separated gallery title.
2. For an addition, export the widget from `lib/snacks/examples.dart` and add
   a `SnackDemo` to `lib/snacks/catalog.dart` in `examples/showcase`. The gallery
   uses the title to locate the source it previews and copies.
3. Cover the interaction in the relevant widget tests under `test/snacks/`.
   For an addition, register the entry point in `snacks_standalone_test.dart`,
   cover its gallery flow in `integration_test/snacks_gallery_test.dart`, update
   the showcase guide and reconcile the expected snippet count in
   `tool/verify_dartpad.dart`. Use goldens when appearance is the claim being tested.
4. From `examples/showcase`, run the focused Flutter tests. For a new example,
   include the standalone and gallery tests. For copyable source or dependency
   changes, `dart run tool/verify_dartpad.dart` checks the live service version
   and submits the standalone snippets for analysis and compilation. A local
   showcase build alone only verifies its own resolved dependencies.
