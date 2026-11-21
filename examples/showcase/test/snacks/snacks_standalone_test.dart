import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_showcase/examples/snacks/bell_toggle.dart' as bell_toggle;
import 'package:mix_showcase/examples/snacks/border_glow.dart' as border_glow;
import 'package:mix_showcase/examples/snacks/branched_menu.dart'
    as branched_menu;
import 'package:mix_showcase/examples/snacks/call_chip.dart' as call_chip;
import 'package:mix_showcase/examples/snacks/code_slots.dart' as code_slots;
import 'package:mix_showcase/examples/snacks/comet_dial.dart' as comet_dial;
import 'package:mix_showcase/examples/snacks/dodge_field.dart' as dodge_field;
import 'package:mix_showcase/examples/snacks/folder_float.dart' as folder_float;
import 'package:mix_showcase/examples/snacks/fuse_button.dart' as fuse_button;
import 'package:mix_showcase/examples/snacks/glide_select.dart' as glide_select;
import 'package:mix_showcase/examples/snacks/hold_button.dart' as hold_button;
import 'package:mix_showcase/examples/snacks/jelly_radio.dart' as jelly_radio;
import 'package:mix_showcase/examples/snacks/lattice_loader.dart'
    as lattice_loader;
import 'package:mix_showcase/examples/snacks/peek_rating.dart' as peek_rating;
import 'package:mix_showcase/examples/snacks/prompt_bar.dart' as prompt_bar;
import 'package:mix_showcase/examples/snacks/pulse_heart.dart' as pulse_heart;
import 'package:mix_showcase/examples/snacks/refine_frame.dart' as refine_frame;
import 'package:mix_showcase/examples/snacks/rubber_segment.dart'
    as rubber_segment;
import 'package:mix_showcase/examples/snacks/scrub_field.dart' as scrub_field;
import 'package:mix_showcase/examples/snacks/slide_commit.dart' as slide_commit;
import 'package:mix_showcase/examples/snacks/sling_button.dart' as sling_button;
import 'package:mix_showcase/examples/snacks/slosh_gauge.dart' as slosh_gauge;
import 'package:mix_showcase/examples/snacks/spring_check.dart' as spring_check;
import 'package:mix_showcase/examples/snacks/squish_switch.dart'
    as squish_switch;
import 'package:mix_showcase/examples/snacks/status_mark.dart' as status_mark;
import 'package:mix_showcase/examples/snacks/swipe_row.dart' as swipe_row;
import 'package:mix_showcase/examples/snacks/swipe_toast.dart' as swipe_toast;
import 'package:mix_showcase/examples/snacks/thought_line.dart' as thought_line;
import 'package:mix_showcase/examples/snacks/voice_pill.dart' as voice_pill;
import 'package:mix_showcase/examples/snacks/wake_slider.dart' as wake_slider;
import 'package:mix_showcase/examples/snacks/warm_tooltip.dart' as warm_tooltip;

/// Launch the actual snippets, not the gallery's theme/token/overlay harness.
void main() {
  final examples = <String, VoidCallback>{
    'bell_toggle': bell_toggle.main,
    'border_glow': border_glow.main,
    'branched_menu': branched_menu.main,
    'call_chip': call_chip.main,
    'code_slots': code_slots.main,
    'comet_dial': comet_dial.main,
    'dodge_field': dodge_field.main,
    'folder_float': folder_float.main,
    'fuse_button': fuse_button.main,
    'glide_select': glide_select.main,
    'hold_button': hold_button.main,
    'jelly_radio': jelly_radio.main,
    'lattice_loader': lattice_loader.main,
    'peek_rating': peek_rating.main,
    'prompt_bar': prompt_bar.main,
    'pulse_heart': pulse_heart.main,
    'refine_frame': refine_frame.main,
    'rubber_segment': rubber_segment.main,
    'scrub_field': scrub_field.main,
    'slide_commit': slide_commit.main,
    'sling_button': sling_button.main,
    'slosh_gauge': slosh_gauge.main,
    'spring_check': spring_check.main,
    'squish_switch': squish_switch.main,
    'status_mark': status_mark.main,
    'swipe_row': swipe_row.main,
    'swipe_toast': swipe_toast.main,
    'thought_line': thought_line.main,
    'voice_pill': voice_pill.main,
    'wake_slider': wake_slider.main,
    'warm_tooltip': warm_tooltip.main,
  };
  for (final entry in examples.entries) {
    testWidgets('${entry.key} runs standalone on a compact screen', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(780, 600);
      tester.view.devicePixelRatio = 2;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      entry.value();
      await tester.pumpAndSettle();
      expect(find.byType(WidgetsApp), findsOneWidget);
      expect(tester.takeException(), isNull);
      // Dispose controllers and pending timers before the test ends.
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
      expect(tester.takeException(), isNull);
    });
  }
}
