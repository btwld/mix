import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_example/snippets/bell_toggle/main.dart' as bell_toggle;
import 'package:mix_example/snippets/branched_menu/main.dart' as branched_menu;
import 'package:mix_example/snippets/call_chip/main.dart' as call_chip;
import 'package:mix_example/snippets/code_slots/main.dart' as code_slots;
import 'package:mix_example/snippets/comet_dial/main.dart' as comet_dial;
import 'package:mix_example/snippets/dodge_field/main.dart' as dodge_field;
import 'package:mix_example/snippets/folder_float/main.dart' as folder_float;
import 'package:mix_example/snippets/fuse_button/main.dart' as fuse_button;
import 'package:mix_example/snippets/glide_select/main.dart' as glide_select;
import 'package:mix_example/snippets/hold_button/main.dart' as hold_button;
import 'package:mix_example/snippets/jelly_radio/main.dart' as jelly_radio;
import 'package:mix_example/snippets/lattice_loader/main.dart'
    as lattice_loader;
import 'package:mix_example/snippets/peek_rating/main.dart' as peek_rating;
import 'package:mix_example/snippets/prompt_bar/main.dart' as prompt_bar;
import 'package:mix_example/snippets/pulse_heart/main.dart' as pulse_heart;
import 'package:mix_example/snippets/refine_frame/main.dart' as refine_frame;
import 'package:mix_example/snippets/rubber_segment/main.dart'
    as rubber_segment;
import 'package:mix_example/snippets/scrub_field/main.dart' as scrub_field;
import 'package:mix_example/snippets/slide_commit/main.dart' as slide_commit;
import 'package:mix_example/snippets/sling_button/main.dart' as sling_button;
import 'package:mix_example/snippets/slosh_gauge/main.dart' as slosh_gauge;
import 'package:mix_example/snippets/spring_check/main.dart' as spring_check;
import 'package:mix_example/snippets/squish_switch/main.dart' as squish_switch;
import 'package:mix_example/snippets/status_mark/main.dart' as status_mark;
import 'package:mix_example/snippets/swipe_row/main.dart' as swipe_row;
import 'package:mix_example/snippets/swipe_toast/main.dart' as swipe_toast;
import 'package:mix_example/snippets/thought_line/main.dart' as thought_line;
import 'package:mix_example/snippets/voice_pill/main.dart' as voice_pill;
import 'package:mix_example/snippets/wake_slider/main.dart' as wake_slider;
import 'package:mix_example/snippets/warm_tooltip/main.dart' as warm_tooltip;

/// Launch the actual snippets, not the gallery's theme/token/overlay harness.
void main() {
  final examples = <String, VoidCallback>{
    'bell_toggle': bell_toggle.main,
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
