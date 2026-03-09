import 'package:flutter_test/flutter_test.dart';
import 'package:mix_docs_preview/main.dart';
import 'package:mix_docs_preview/preview_registry.dart';

void main() {
  testWidgets('PreviewRegistry has entries', (WidgetTester tester) async {
    expect(PreviewRegistry.all, isNotEmpty);
    expect(
      PreviewRegistry.getByPreviewId('overview/introduction.0'),
      isNotNull,
    );
  });

  testWidgets('MixExampleApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MixExampleApp());
    await tester.pumpAndSettle();
    expect(find.byType(MixExampleApp), findsOneWidget);
  });
}
