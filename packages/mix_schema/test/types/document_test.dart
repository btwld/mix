import 'package:mix_schema/mix_schema.dart';
import 'package:test/test.dart';

void main() {
  test('Envelope round-trips minimal document', () {
    final doc = MixJsonDocument(
      schema: '1.0.0',
      root: const WidgetBox(),
    );
    final encoded = doc.toJson();
    expect(encoded, equals({'schema': '1.0.0', 'root': {'widget': 'Box'}}));
    expect(MixJsonDocument.fromJson(encoded), equals(doc));
  });

  test('Envelope carries optional fields', () {
    final doc = MixJsonDocument(
      schemaUri: 'https://mix.dev/schema/v1.json',
      schema: '1.0.0',
      mixRuntime: '^2.0.0',
      tokens: TokenBundle(const {
        'color.primary': ValueLiteral('#2196f3ff'),
        'space.md': ValueLiteral(16),
      }),
      root: const WidgetBox(),
    );
    final encoded = doc.toJson();
    expect(encoded, contains(r'$schema'));
    expect(encoded, contains('mixRuntime'));
    expect(encoded, contains('tokens'));
    expect(MixJsonDocument.fromJson(encoded), equals(doc));
  });

  test('Envelope rejects missing schema', () {
    expect(
      () => MixJsonDocument.fromJson({'root': {'widget': 'Box'}}),
      throwsFormatException,
    );
  });

  test('Envelope rejects missing root', () {
    expect(
      () => MixJsonDocument.fromJson({'schema': '1.0.0'}),
      throwsFormatException,
    );
  });

  test('TokenBundle round-trip', () {
    final tb = TokenBundle(const {
      'color.primary': ValueLiteral('#2196f3ff'),
      'space.md': ValueLiteral(16),
    });
    final encoded = tb.toJson();
    final decoded = TokenBundle.fromJson(encoded);
    expect(decoded, equals(tb));
  });
}
