import 'package:mix/mix.dart';

import '../../../components/feedback/callout/callout.dart';
import '../../../helpers/spec_style.dart';
import '../tokens.dart';

class FortalezaCalloutStyle extends CalloutStyle {
  static const surface = Variant('for.callout.surface');
  static const outline = Variant('for.callout.outline');

  const FortalezaCalloutStyle();

  static List<Variant> get variants => [surface, outline];

  @override
  Style makeStyle(SpecConfiguration<CalloutSpecUtility> spec) {
    final $ = spec.utilities;

    final baseStyle = super.makeStyle(spec);
    final baseOverrides = Style(
      baseStyle,
      $.container
        ..borderRadius(8)
        ..color.$accent(3)
        ..border.all.width(0)
        ..border.all.style.none()
        ..padding(16)
        ..flex.gap.$space3()
        ..flex.crossAxisAlignment.center()
        ..flex.mainAxisAlignment.start(),
      $.icon
        ..color.$accentAlpha(11)
        ..size(20),
      $.text
        ..style.color.$accentAlpha(11)
        ..style.fontWeight.w400(),
    );

    final surfaceVariant = Style(
      $.container
        ..border.all.style.solid()
        ..color.$accentAlpha(3)
        ..border.width(1)
        ..border.color.$accent(7),
    );

    final outlineVariant = Style(
      $.container
        ..border.all.style.solid()
        ..color.transparent()
        ..border.width(1)
        ..border.color.$accentAlpha(8),
    );

    return Style.create(
      [baseOverrides, surface(surfaceVariant), outline(outlineVariant)],
    );
  }
}
