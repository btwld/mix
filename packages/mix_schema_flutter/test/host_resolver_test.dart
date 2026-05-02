import 'package:flutter_test/flutter_test.dart';
import 'package:mix_schema_flutter/mix_schema_flutter.dart';

void main() {
  group('AllowlistHostResolver', () {
    test('resolves bound ids', () {
      final resolver = AllowlistHostResolver({
        'gradient.brand': 'gradient-impl',
        'clipper.ticket': 'clipper-impl',
      });
      expect(resolver.resolve('gradient.brand'), equals('gradient-impl'));
      expect(resolver.resolve('clipper.ticket'), equals('clipper-impl'));
    });

    test('returns null for unbound ids', () {
      final resolver = AllowlistHostResolver(const {'allowed': 'x'});
      expect(resolver.resolve('not.there'), isNull);
    });
  });

  test('EmptyHostResolver returns null for everything', () {
    const resolver = EmptyHostResolver();
    expect(resolver.resolve('anything'), isNull);
    expect(resolver.resolve(''), isNull);
  });
}
