import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_markdown/mix_markdown.dart';

void main() {
  testWidgets('factory and instance shorthand resolve the same slots', (
    tester,
  ) async {
    final fromFactory = MarkdownStyler.paragraph(TextStyler.fontSize(16));
    final fromInstance = MarkdownStyler()
        .paragraph(.fontSize(16))
        .h1(.fontSize(32).fontWeight(FontWeight.bold))
        .alert(.note(.container(BoxStyler().padding(.all(12)))));

    late MarkdownSpec factorySpec;
    late MarkdownSpec instanceSpec;
    await tester.pumpWidget(
      Builder(
        builder: (context) {
          factorySpec = fromFactory.resolve(context).spec;
          instanceSpec = fromInstance.resolve(context).spec;

          return const SizedBox.shrink();
        },
      ),
    );

    expect(factorySpec.paragraph?.spec.style?.fontSize, 16);
    expect(instanceSpec.paragraph?.spec.style?.fontSize, 16);
    expect(instanceSpec.h1?.spec.style?.fontWeight, FontWeight.bold);
    expect(
      instanceSpec.alert?.spec.note?.spec.container?.spec.padding,
      const EdgeInsets.all(12),
    );
  });

  testWidgets('the widget renders with a styler and with a resolved spec', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: Column(
            children: [
              MarkdownStyler.h1(.fontSize(30))(data: '# Styled'),
              const MixMarkdown(
                data: 'Resolved',
                styleSpec: StyleSpec(
                  spec: MarkdownSpec(
                    paragraph: StyleSpec(
                      spec: TextSpec(style: TextStyle(fontSize: 12)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    expect(tester.widget<Text>(find.text('Styled')).style?.fontSize, 30);
    expect(tester.widget<Text>(find.text('Resolved')).style?.fontSize, 12);
  });
}
