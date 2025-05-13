part of 'textfield.dart';

class IsEmptyContextVariant extends ContextVariant {
  const IsEmptyContextVariant();

  @override
  bool when(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<_TextFieldContext>()
          ?.isEmpty ??
      false;
}

class TextFieldSpecConfiguration
    extends SpecConfiguration<TextFieldSpecUtility> {
  const TextFieldSpecConfiguration(super.context, super._utility);

  @override
  TextFieldContextVariantUtil get on => TextFieldContextVariantUtil(super.on);
}

extension type const TextFieldContextVariantUtil(
    OnContextVariantUtility _utility) implements OnContextVariantUtility {
  ContextVariant get isEmpty => const IsEmptyContextVariant();
  ContextVariant get isNotEmpty => const OnNotVariant(IsEmptyContextVariant());
}

class TextFieldStyle extends SpecStyle<TextFieldSpecUtility> {
  const TextFieldStyle();
  Style platformSettings(SpecConfiguration<TextFieldSpecUtility> spec) {
    final $ = spec.utilities;

    final iOS = spec.on.ios(
      $.chain
        ..paintCursorAboveText.on()
        ..cursorOpacityAnimates.on()
        ..cursorRadius(2)
        ..cursorOffset(
          m.iOSHorizontalOffset / MediaQuery.devicePixelRatioOf(spec.context),
          0,
        ),
    );

    final androidAndFuchsia = (spec.on.android | spec.on.fuchsia)(
      $.chain
        ..paintCursorAboveText.off()
        ..cursorOpacityAnimates.off(),
    );

    final macos = spec.on.macos(
      $.chain
        ..paintCursorAboveText.on()
        ..cursorOpacityAnimates.off()
        ..cursorRadius(2)
        ..cursorOffset(
          m.iOSHorizontalOffset / MediaQuery.devicePixelRatioOf(spec.context),
          0,
        ),
    );

    final windows = spec.on.windows(
      $.chain
        ..paintCursorAboveText.off()
        ..cursorOpacityAnimates.off(),
    );

    final linux = spec.on.linux(
      $.chain
        ..paintCursorAboveText.off()
        ..cursorOpacityAnimates.off(),
    );

    return Style(androidAndFuchsia, iOS, macos, windows, linux);
  }

  @override
  Style makeStyle(SpecConfiguration<TextFieldSpecUtility> spec) {
    spec as TextFieldSpecConfiguration;

    final $ = spec.utilities;

    final containerStyle = $.container.chain
      ..color.white()
      ..padding.horizontal(10)
      ..padding.vertical(8)
      ..borderRadius(6)
      ..border.all.color.grey.shade300()
      ..shadow.spreadRadius(0)
      ..shadow.blurRadius(2)
      ..shadow.offset(-1, 1)
      ..shadow.color.grey.shade200()
      ..flex.direction.horizontal()
      ..flex.mainAxisSize.min()
      ..flex.mainAxisAlignment.start()
      ..flex.crossAxisAlignment.center()
      ..flex.gap(8);

    final outerContainerStyle = $.outerContainer.flex.chain
      ..direction.vertical()
      ..mainAxisSize.min()
      ..mainAxisAlignment.start()
      ..crossAxisAlignment.start()
      ..gap(6);

    final textStyle = $.chain
      ..style.color.black87()
      ..style.fontSize(14);

    final hintStyle = [
      $.hintTextStyle.color.black54(),
      $.hintTextStyle.fontSize(14),
    ];

    final icon = $.icon.chain
      ..color.grey.shade800()
      ..size(18);

    final helperStyle = $.helperText.chain
      ..style.color.black54()
      ..style.fontSize(12)
      ..wrap.padding.left(12);

    final focus = spec.on.focus($.container.border.all.color.black());

    return Style.create([
      platformSettings(spec).call(),
      outerContainerStyle,
      $.floatingLabel.off(),
      $.selectionColor.black12(),
      containerStyle,
      textStyle,
      helperStyle,
      ...hintStyle,
      icon,
      focus,
    ]);
  }
}

class TextFieldDarkStyle extends TextFieldStyle {
  const TextFieldDarkStyle();

  @override
  Style makeStyle(SpecConfiguration<TextFieldSpecUtility> spec) {
    final $ = spec.utilities;
    final cursor = $.cursorColor.grey.shade100();

    final containerStyle = $.container.chain
      ..color.black()
      ..border.all.color.grey.shade800()
      ..shadow.spreadRadius(0)
      ..shadow.blurRadius(0)
      ..shadow.offset(0, 0)
      ..shadow.color.transparent();

    final textStyle = $.style.color.white();

    final hintStyle = [
      $.hintTextStyle.color.grey.shade400(),
      $.hintTextStyle.fontSize(14),
    ];

    final helperStyle = $.helperText.style.color.grey.shade400();
    final icon = $.icon.color.grey.shade300();

    final focus = spec.on.focus($.container.border.all.color.white());

    return Style.create([
      super.makeStyle(spec).call(),
      cursor,
      containerStyle,
      focus,
      textStyle,
      helperStyle,
      icon,
      ...hintStyle,
    ]);
  }
}
