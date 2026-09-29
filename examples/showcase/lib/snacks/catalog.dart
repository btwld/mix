import 'package:flutter/widgets.dart';

import 'examples.dart';

enum SnackGroup {
  controls('Controls'),
  actions('Actions'),
  motion('Motion'),
  agent('Agent');

  const SnackGroup(this.label);
  final String label;
}

class SnackDemo {
  const SnackDemo({
    required this.title,
    required this.caption,
    required this.group,
    required this.builder,
  });

  final String title;
  final String caption;
  final SnackGroup group;
  final WidgetBuilder builder;

  String get slug => title.toLowerCase().replaceAll(' ', '_');
  String get componentName => title.replaceAll(' ', '');
  String get sourceAsset => 'lib/examples/snacks/$slug.dart';
}

final snackDemos = <SnackDemo>[
  SnackDemo(
    title: 'Squish Switch',
    caption: 'Press to compress; release to spring into a new color.',
    group: SnackGroup.controls,
    builder: (_) => const SquishSwitch(),
  ),
  SnackDemo(
    title: 'Peek Rating',
    caption: 'Sweep the stars to preview, click to commit the rating.',
    group: SnackGroup.controls,
    builder: (_) => const PeekRating(),
  ),
  SnackDemo(
    title: 'Spring Check',
    caption:
        'A spring fills the checkbox while the tick fades and the label strikes.',
    group: SnackGroup.controls,
    builder: (_) => const SpringCheck(),
  ),
  SnackDemo(
    title: 'Rubber Segment',
    caption:
        'A spring slides the selection; keyframes stretch and settle its capsule.',
    group: SnackGroup.controls,
    builder: (_) => const RubberSegment(),
  ),
  SnackDemo(
    title: 'Jelly Radio',
    caption: 'The chosen chip swells and barges its neighbours outward.',
    group: SnackGroup.controls,
    builder: (_) => const JellyRadio(),
  ),
  SnackDemo(
    title: 'Glide Select',
    caption: 'Menu highlight glides between rows instead of blinking in.',
    group: SnackGroup.controls,
    builder: (_) => const GlideSelect(),
  ),
  SnackDemo(
    title: 'Scrub Field',
    caption: 'Drag to scrub a number; tap without moving to type.',
    group: SnackGroup.controls,
    builder: (_) => const ScrubField(),
  ),
  SnackDemo(
    title: 'Code Slots',
    caption:
        'Four digits: 1234 turns green; other codes tilt the slots in error.',
    group: SnackGroup.controls,
    builder: (_) => const CodeSlots(),
  ),
  SnackDemo(
    title: 'Wake Slider',
    caption:
        'Drag across the bars; speed raises a wake around the current value.',
    group: SnackGroup.controls,
    builder: (_) => const WakeSlider(),
  ),
  SnackDemo(
    title: 'Comet Dial',
    caption:
        'Drag horizontally to move the lit head and reveal its comet trail.',
    group: SnackGroup.controls,
    builder: (_) => const CometDial(),
  ),
  SnackDemo(
    title: 'Hold Button',
    caption: 'Hold-to-confirm. The liquid fill rises, then the label swaps.',
    group: SnackGroup.actions,
    builder: (_) => const HoldButton(),
  ),
  SnackDemo(
    title: 'Pulse Heart',
    caption:
        'A keyframed heart contracts and rebounds as the like count changes.',
    group: SnackGroup.actions,
    builder: (_) => const PulseHeart(),
  ),
  SnackDemo(
    title: 'Slide Commit',
    caption: 'Slide to the end; the inset capsule expands into the paid state.',
    group: SnackGroup.actions,
    builder: (_) => const SlideCommit(),
  ),
  SnackDemo(
    title: 'Fuse Button',
    caption: 'Archive crossfades to Undo while an amber outline burns away.',
    group: SnackGroup.actions,
    builder: (_) => const FuseButton(),
  ),
  SnackDemo(
    title: 'Bell Toggle',
    caption: 'The bell rings on keyframes inside a steady, pressable pill.',
    group: SnackGroup.actions,
    builder: (_) => const BellToggle(),
  ),
  SnackDemo(
    title: 'Sling Button',
    caption: 'Pull left past the threshold, then release to send.',
    group: SnackGroup.actions,
    builder: (_) => const SlingButton(),
  ),
  SnackDemo(
    title: 'Dodge Field',
    caption: 'The child flees the pointer, then relents after a few tries.',
    group: SnackGroup.motion,
    builder: (_) => const DodgeField(),
  ),
  SnackDemo(
    title: 'Swipe Row',
    caption: 'Swipe to reveal Delete, or swipe farther to remove the row.',
    group: SnackGroup.motion,
    builder: (_) => const SwipeRow(),
  ),
  SnackDemo(
    title: 'Warm Tooltip',
    caption:
        'First label waits; siblings open instantly while the group is warm.',
    group: SnackGroup.motion,
    builder: (_) => const WarmTooltip(),
  ),
  SnackDemo(
    title: 'Swipe Toast',
    caption: 'Show a timed notification; swipe down to dismiss it early.',
    group: SnackGroup.motion,
    builder: (_) => const SwipeToast(),
  ),
  SnackDemo(
    title: 'Folder Float',
    caption: 'Hover or press: notes spring out from behind the flap.',
    group: SnackGroup.motion,
    builder: (_) => const FolderFloat(),
  ),
  SnackDemo(
    title: 'Branched Menu',
    caption:
        'Sections unfold; the selected row springs into an accent outline.',
    group: SnackGroup.motion,
    builder: (_) => const BranchedMenu(),
  ),
  SnackDemo(
    title: 'Lattice Loader',
    caption: 'A 3×3 lattice advances beside a verb and elapsed time.',
    group: SnackGroup.agent,
    builder: (_) => const LatticeLoader(),
  ),
  SnackDemo(
    title: 'Status Mark',
    caption: 'Idle ring, spinning arc, then a check or a cross.',
    group: SnackGroup.agent,
    builder: (_) => const StatusMark(),
  ),
  SnackDemo(
    title: 'Call Chip',
    caption: 'A linear fill completes a call; run again to show a retry state.',
    group: SnackGroup.agent,
    builder: (_) => const CallChip(),
  ),
  SnackDemo(
    title: 'Prompt Bar',
    caption: 'Send or stop a request with a springy action tile.',
    group: SnackGroup.agent,
    builder: (_) => const PromptBar(),
  ),
  SnackDemo(
    title: 'Voice Pill',
    caption:
        'Hold the mic to reveal a continuously animated synthetic waveform.',
    group: SnackGroup.agent,
    builder: (_) => const VoicePill(),
  ),
  SnackDemo(
    title: 'Thought Line',
    caption: 'Steps appear, then the line settles into “Thought for 1.3s”.',
    group: SnackGroup.agent,
    builder: (_) => const ThoughtLine(),
  ),
  SnackDemo(
    title: 'Refine Frame',
    caption: 'Queued → generating → refining → complete, without layout shift.',
    group: SnackGroup.agent,
    builder: (_) => const RefineFrame(),
  ),
  SnackDemo(
    title: 'Slosh Gauge',
    caption: 'Drag the liquid directly; release to settle its tilted surface.',
    group: SnackGroup.agent,
    builder: (_) => const SloshGauge(),
  ),
  SnackDemo(
    title: 'Border Glow',
    caption:
        'Press play: a comet spins around the border while the button glows.',
    group: SnackGroup.agent,
    builder: (_) => const BorderGlow(),
  ),
];
