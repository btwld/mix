import 'package:ack/ack.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_schema/src/schema/discriminated_schema_builder.dart';

void main() {
  group('buildDiscriminatedSchema', () {
    test('preserves transformed branches', () {
      final schema = buildDiscriminatedSchema<Object>(
        discriminatorKey: 'type',
        branches: [
          discriminatedBranch<Object, Object>(
            type: 'demo',
            schema: Ack.object({
              'value': Ack.integer(),
            }).transform<Object>((data) => 'value:${data['value']}'),
          ),
        ],
      );

      final result = schema.safeParse({'type': 'demo', 'value': 7});

      expect(result.isOk, isTrue);
      expect(result.getOrNull(), 'value:7');
    });

    test('preserves transformed branch metadata', () {
      final branch = Ack.object({'value': Ack.string()})
          .transform<Object>((data) => data['value'] as String)
          .copyWith(defaultValue: 'fallback')
          .refine((value) => value == 'valid', message: 'Must be valid.');
      final schema = buildDiscriminatedSchema<Object>(
        discriminatorKey: 'type',
        branches: [
          discriminatedBranch<Object, Object>(type: 'demo', schema: branch),
        ],
      );

      final storedBranch =
          (schema as DiscriminatedObjectSchema<Object>).schemas['demo']!
              as TransformedSchema<Map<String, Object?>, Object>;
      final invalidResult = schema.safeParse({'type': 'demo', 'value': 'bad'});

      expect(storedBranch.defaultValue, 'fallback');
      expect(storedBranch.refinements, hasLength(1));
      expect(invalidResult.isFail, isTrue);
    });

    test('rejects manual discriminator fields', () {
      expect(
        () => buildDiscriminatedSchema<Object>(
          discriminatorKey: 'type',
          branches: [
            discriminatedBranch<Object, Object>(
              type: 'demo',
              schema: Ack.object({
                'type': Ack.literal('demo'),
              }).transform<Object>((data) => data),
            ),
          ],
        ),
        throwsA(isA<StateError>()),
      );
    });

    test('rejects duplicate branch types', () {
      expect(
        () => buildDiscriminatedSchema<Object>(
          discriminatorKey: 'type',
          branches: [
            discriminatedBranch<Object, Object>(
              type: 'demo',
              schema: Ack.object({}).transform<Object>((data) => data),
            ),
            discriminatedBranch<Object, Object>(
              type: 'demo',
              schema: Ack.object({}).transform<Object>((data) => data),
            ),
          ],
        ),
        throwsA(isA<StateError>()),
      );
    });

    test('exports discriminator details through Ack JSON schema', () {
      final schema = buildDiscriminatedSchema<Object>(
        discriminatorKey: 'type',
        branches: [
          discriminatedBranch<Object, Object>(
            type: 'demo',
            schema: Ack.object({
              'value': Ack.integer(),
            }).transform<Object>((data) => data),
          ),
        ],
      );

      final jsonSchema = schema.toJsonSchema();
      final branches = jsonSchema['anyOf']! as List<Object?>;
      final branch = branches.single! as Map<Object?, Object?>;
      final properties = branch['properties']! as Map<Object?, Object?>;

      expect(properties['type'], {'type': 'string', 'const': 'demo'});
      expect(branch['required'], contains('type'));
    });
  });
}
