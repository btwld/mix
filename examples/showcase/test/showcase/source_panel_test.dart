import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_showcase/catalog/catalog.dart';
import 'package:mix_showcase/showcase/source_panel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('all visible examples omit the standalone app shell', () async {
    for (final example in examples) {
      final full = await rootBundle.loadString(example.source);
      final visible = widgetExcerpt(full);
      expect(visible, contains('class '), reason: example.title);
      expect(visible, isNot(contains('void main()')), reason: example.title);
      expect(visible, isNot(contains('MaterialApp(')), reason: example.title);
      expect(visible, isNot(contains('WidgetsApp(')), reason: example.title);
      expect(visible, isNot(contains('import ')), reason: example.title);
      expect(full, contains('void main()'), reason: example.title);
    }
  });
}
