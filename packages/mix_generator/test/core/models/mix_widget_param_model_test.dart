import 'package:mix_generator/src/core/models/mix_widget_param_model.dart';
import 'package:test/test.dart';

void main() {
  group('MixWidgetParam', () {
    test('nullable positional param is not required', () {
      const param = MixWidgetParam(
        name: 'child',
        typeDisplay: 'Widget?',
        isPositional: true,
        isRequired: false,
        defaultValueCode: null,
      );
      expect(param.isRequired, isFalse);
    });
  });

  group('mergeMixWidgetParams', () {
    test('keeps unique params from both lists', () {
      const source = [
        MixWidgetParam(
          name: 'color',
          typeDisplay: 'Color',
          isPositional: false,
          isRequired: false,
          defaultValueCode: 'Colors.white',
        ),
      ];
      const call = [
        MixWidgetParam(
          name: 'child',
          typeDisplay: 'Widget?',
          isPositional: false,
          isRequired: false,
          defaultValueCode: null,
        ),
      ];
      final merged = mergeMixWidgetParams(source: source, call: call);
      expect(merged.map((p) => p.name), ['color', 'child']);
    });

    test('source params win on name collision', () {
      const source = [
        MixWidgetParam(
          name: 'child',
          typeDisplay: 'Widget',
          isPositional: true,
          isRequired: true,
          defaultValueCode: null,
        ),
      ];
      const call = [
        MixWidgetParam(
          name: 'child',
          typeDisplay: 'Widget?',
          isPositional: false,
          isRequired: false,
          defaultValueCode: null,
        ),
      ];
      final merged = mergeMixWidgetParams(source: source, call: call);
      expect(merged, hasLength(1));
      expect(merged.single.typeDisplay, 'Widget');
      expect(merged.single.isRequired, isTrue);
    });

    test('drops key param from call list (handled via super.key)', () {
      const call = [
        MixWidgetParam(
          name: 'key',
          typeDisplay: 'Key?',
          isPositional: false,
          isRequired: false,
          defaultValueCode: null,
        ),
        MixWidgetParam(
          name: 'child',
          typeDisplay: 'Widget?',
          isPositional: false,
          isRequired: false,
          defaultValueCode: null,
        ),
      ];
      final merged = mergeMixWidgetParams(source: const [], call: call);
      expect(merged.map((p) => p.name), ['child']);
    });
  });
}
