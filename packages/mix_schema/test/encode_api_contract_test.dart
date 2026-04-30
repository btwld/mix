import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_schema/encode.dart';

void main() {
  group('encode API contract', () {
    test('exports stable wire identifiers for producers', () {
      expect(SchemaStyler.box.wireValue, 'box');
      expect(SchemaModifier.defaultTextStyle.wireValue, 'default_text_style');
      expect(SchemaVariant.contextAllOf.wireValue, 'context_all_of');
      expect(
        SchemaGradientTransform.tailwindAngleRect.wireValue,
        'tailwind_css_angle_rect',
      );
    });

    test('exports low-level payload helpers for primitives and conditions', () {
      final JsonMap widgetState = payloadWidgetStateCondition(
        WidgetState.hovered,
      );
      final JsonMap enabled = payloadEnabledCondition();
      final JsonMap brightness = payloadBrightnessCondition(Brightness.dark);
      final JsonMap breakpoint = payloadBreakpointCondition(minWidth: 768);

      expect(widgetState, {'type': 'widget_state', 'state': 'hovered'});
      expect(enabled, {'type': 'enabled'});
      expect(brightness, {'type': 'context_brightness', 'brightness': 'dark'});
      expect(breakpoint, {'type': 'context_breakpoint', 'minWidth': 768.0});
      expect(payloadColor(const Color(0xFF336699)), '#336699FF');
      expect(payloadOffset(const Offset(3, 4)), {'dx': 3.0, 'dy': 4.0});
    });
  });
}
