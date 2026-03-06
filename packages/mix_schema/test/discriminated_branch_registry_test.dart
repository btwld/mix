import 'package:ack/ack.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_schema/src/schema/discriminated_branch_registry.dart';

void main() {
  group('DiscriminatedBranchRegistry', () {
    test('preserves transformed branches', () {
      final registry = DiscriminatedBranchRegistry<Object>(
        discriminatorKey: 'type',
      );

      registry.register(
        'demo',
        Ack.object({
          'value': Ack.integer(),
        }).transform<Object>((data) => 'value:${data!['value']}'),
      );

      final schema = registry.freeze();
      final result = schema.safeParse({'type': 'demo', 'value': 7});

      expect(result.isOk, isTrue);
      expect(result.getOrNull(), 'value:7');
    });

    test('rejects manual discriminator fields', () {
      final registry = DiscriminatedBranchRegistry<Object>(
        discriminatorKey: 'type',
      );

      expect(
        () => registry.register(
          'demo',
          Ack.object({
            'type': Ack.literal('demo'),
          }).transform<Object>((data) => data!),
        ),
        throwsA(isA<StateError>()),
      );
    });
  });
}
