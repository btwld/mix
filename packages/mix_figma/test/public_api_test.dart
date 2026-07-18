import 'package:flutter_test/flutter_test.dart';
import 'package:mix_figma/mix_figma.dart';

void main() {
  test('curated package barrel exposes core and runtime entry points', () {
    const bridge = MixFigmaBridge();
    final document = parseDtcgDocument({
      'color': {
        r'$type': 'color',
        'brand': {r'$value': '#336699'},
      },
    });
    final mapped = buildProtocolThemeJsonFromDtcg(document);

    expect(bridge, isA<MixFigmaBridge>());
    expect(mapped.value['colors'], {'color.brand': '#336699'});
  });
}
