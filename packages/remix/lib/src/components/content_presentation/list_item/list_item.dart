import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'list_item.g.dart';
part 'list_item_style.dart';
part 'list_item_widget.dart';

@MixableSpec()
base class ListItemSpec extends Spec<ListItemSpec>
    with _$ListItemSpec, Diagnosticable {
  final FlexBoxSpec container;
  final FlexBoxSpec titleSubtitleContainer;
  final TextSpec title;
  final TextSpec subtitle;

  /// {@macro list_item_spec_of}
  static const of = _$ListItemSpec.of;

  static const from = _$ListItemSpec.from;

  const ListItemSpec({
    FlexBoxSpec? container,
    FlexBoxSpec? titleSubtitleContainer,
    TextSpec? title,
    TextSpec? subtitle,
    super.modifiers,
    super.animated,
  })  : container = container ?? const FlexBoxSpec(),
        titleSubtitleContainer = titleSubtitleContainer ?? const FlexBoxSpec(),
        title = title ?? const TextSpec(),
        subtitle = subtitle ?? const TextSpec();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    _debugFillProperties(properties);
  }
}
