import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mix_schema/mix_schema.dart';

void main() {
  test('tw_parser uses schema wire enums for payload type literals', () {
    final source = File('lib/src/tw_parser.dart').readAsStringSync();
    final guardedWireValues = <String>{
      SchemaStyler.box.wireValue,
      SchemaStyler.text.wireValue,
      SchemaStyler.flexBox.wireValue,
      SchemaDecoration.box.wireValue,
      SchemaBorder.border.wireValue,
      SchemaBorderRadius.borderRadius.wireValue,
      SchemaGradient.linear.wireValue,
      SchemaGradientTransform.rotation.wireValue,
      SchemaGradientTransform.tailwindAngleRect.wireValue,
      SchemaVariant.widgetState.wireValue,
      SchemaVariant.enabled.wireValue,
      SchemaVariant.brightness.wireValue,
      SchemaVariant.breakpoint.wireValue,
      SchemaVariant.contextAllOf.wireValue,
      SchemaModifier.blur.wireValue,
      SchemaModifier.defaultTextStyle.wireValue,
    };

    for (final wireValue in guardedWireValues) {
      expect(
        source,
        isNot(
          contains(
            RegExp("'type'\\s*:\\s*['\"]${RegExp.escape(wireValue)}['\"]"),
          ),
        ),
        reason: 'Use Schema*.wireValue instead of raw "$wireValue".',
      );
    }
  });
}
