import 'package:flutter_test/flutter_test.dart';
import 'package:mix_winds_example/showcase/showcase_view_data.dart';

void main() {
  test('parses supported per-view initial data', () {
    final data = ShowcaseViewData.fromMap({'exampleId': '04'});

    expect(data.exampleId, '04');
  });

  test('rejects unsupported ids', () {
    final data = ShowcaseViewData.fromMap({'exampleId': '99'});

    expect(data.exampleId, '01');
  });
}
