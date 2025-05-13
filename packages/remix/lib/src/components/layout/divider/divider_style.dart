part of 'divider.dart';

class DividerStyle extends SpecStyle<DividerSpecUtility> {
  static const vertical = Variant('divider.vertical');
  static const horizontal = Variant('divider.horizontal');

  const DividerStyle();

  @override
  Style makeStyle(SpecConfiguration<DividerSpecUtility> spec) {
    final $ = spec.utilities;

    final containerStyle = [
      $.container.chain
        ..color.grey.shade300()
        ..borderRadius(99),
      horizontal($.container.height(1)),
      vertical($.container.width(1)),
    ];

    return Style.create([...containerStyle]);
  }
}

class DividerDarkStyle extends DividerStyle {
  const DividerDarkStyle();

  @override
  Style makeStyle(SpecConfiguration<DividerSpecUtility> spec) {
    final $ = spec.utilities;

    return Style.create([
      super.makeStyle(spec).call(),
      $.container.color.grey.shade800(),
    ]);
  }
}
