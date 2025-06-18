import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:remix/remix.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Card Component',
  type: RxCard,
)
Widget buildCard(BuildContext context) {
  return Scaffold(
    body: Center(
      child: RxCard(
        child: HBox(
          style: Style(
            $flex.gap(12),
            $flex.mainAxisSize.min(),
          ),
          children: [
            Avatar(
              fallbackBuilder: (spec) => spec('LF'),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StyledText(
                  'Leo Farias',
                  style: Style(
                    $text.chain
                      ..style.fontSize(14)
                      ..style.fontWeight.bold()
                      ..style.color.black87(),
                    $on.dark(
                      $text.style.color.white(),
                    ),
                  ),
                ),
                StyledText(
                  'Flutter Engineer',
                  style: Style(
                    $text.chain
                      ..style.fontSize(12)
                      ..style.color.black54(),
                    $on.dark(
                      $text.style.color.white70(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
