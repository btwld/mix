import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  final boxStyle = BoxStyler();
  final textStyle = TextStyler();
  final iconStyle = IconStyler();
  final imageStyle = ImageStyler();
  final flexStyle = FlexBoxStyler();
  final stackStyle = StackBoxStyler();
  final wrapStyle = WrapBoxStyler();
  final gridStyle = GridBoxStyler();

  final boxBuilder = boxStyle.pressable();
  final textBuilder = textStyle.pressable();
  final iconBuilder = iconStyle.pressable();
  final imageBuilder = imageStyle.pressable();
  final flexBuilder = flexStyle.pressable();
  final stackBuilder = stackStyle.pressable();
  final wrapBuilder = wrapStyle.pressable();
  final gridBuilder = gridStyle.pressable();

  final surfaces = <String, (Function, List<Object>)>{
    'Box': (boxBuilder.call, []),
    'Text': (textBuilder.call, ['Settings']),
    'Icon': (iconBuilder.call, []),
    'Image': (imageBuilder.call, []),
    'FlexBox': (flexBuilder.call, []),
    'StackBox': (stackBuilder.call, []),
    'WrapBox': (wrapBuilder.call, []),
    'GridBox': (gridBuilder.call, []),
  };

  for (final entry in surfaces.entries) {
    test('${entry.key} preserves Pressable defaults and every option', () {
      final (call, positional) = entry.value;
      final defaults = Function.apply(call, positional) as Pressable;
      const reference = Pressable(child: SizedBox());
      expect(_options(defaults), _options(reference));
      expect(defaults.key, isNull);
      expect(defaults.child.key, isNull);

      final node = FocusNode();
      final controller = WidgetStatesController();
      addTearDown(node.dispose);
      addTearDown(controller.dispose);
      void onPress() {}
      void onLongPress() {}
      void onFocusChange(bool value) {}
      KeyEventResult onKeyEvent(FocusNode node, KeyEvent event) =>
          KeyEventResult.handled;
      final actions = <Type, Action<Intent>>{
        ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: (_) => null),
      };
      final expected = Pressable(
        key: const Key('surface'),
        enabled: false,
        enableFeedback: true,
        onPress: onPress,
        onLongPress: onLongPress,
        onFocusChange: onFocusChange,
        autofocus: true,
        focusNode: node,
        mouseCursor: SystemMouseCursors.help,
        canRequestFocus: false,
        excludeFromSemantics: true,
        semanticsLabel: 'Action label',
        semanticsRole: .link,
        onKeyEvent: onKeyEvent,
        controller: controller,
        actions: actions,
        hitTestBehavior: .translucent,
        child: const SizedBox(),
      );
      final actual =
          Function.apply(call, positional, {
                #key: expected.key,
                #enabled: expected.enabled,
                #enableFeedback: expected.enableFeedback,
                #onPress: onPress,
                #onLongPress: onLongPress,
                #onFocusChange: onFocusChange,
                #autofocus: expected.autofocus,
                #focusNode: node,
                #mouseCursor: expected.mouseCursor,
                #canRequestFocus: expected.canRequestFocus,
                #excludeFromSemantics: expected.excludeFromSemantics,
                #semanticsLabel: expected.semanticsLabel,
                #semanticsRole: expected.semanticsRole,
                #onKeyEvent: onKeyEvent,
                #controller: controller,
                #actions: actions,
                #hitTestBehavior: expected.hitTestBehavior,
              })
              as Pressable;
      expect(_options(actual), _options(expected));
      expect(actual.key, expected.key);
      expect(actual.child.key, isNull);
    });
  }

  test('native content parameters and defaults are retained', () {
    const child = SizedBox();
    final box = boxBuilder(child: child).child as Box;
    expect(box.style, same(boxStyle));
    expect(box.child, same(child));
    expect((boxBuilder().child as Box).child, isNull);

    final text = textBuilder('Settings').child as StyledText;
    expect(text.style, same(textStyle));
    expect(text.text, 'Settings');

    final icon = iconBuilder(
      icon: Icons.star,
      semanticLabel: 'Star',
      semanticsLabel: 'Favorite',
    );
    final styledIcon = icon.child as StyledIcon;
    expect(styledIcon.style, same(iconStyle));
    expect(styledIcon.icon, Icons.star);
    expect(styledIcon.semanticLabel, 'Star');
    expect(icon.semanticsLabel, 'Favorite');

    const provider = AssetImage('photo.png');
    const opacity = AlwaysStoppedAnimation<double>(0.5);
    Widget frameBuilder(
      BuildContext context,
      Widget child,
      int? frame,
      bool synchronouslyLoaded,
    ) => child;
    Widget loadingBuilder(
      BuildContext context,
      Widget child,
      ImageChunkEvent? progress,
    ) => child;
    Widget errorBuilder(
      BuildContext context,
      Object error,
      StackTrace? stackTrace,
    ) => const SizedBox();
    final image =
        imageBuilder(
              image: provider,
              opacity: opacity,
              frameBuilder: frameBuilder,
              loadingBuilder: loadingBuilder,
              errorBuilder: errorBuilder,
            ).child
            as StyledImage;
    expect(image.style, same(imageStyle));
    expect(image.image, same(provider));
    expect(image.opacity, same(opacity));
    expect(image.frameBuilder, same(frameBuilder));
    expect(image.loadingBuilder, same(loadingBuilder));
    expect(image.errorBuilder, same(errorBuilder));

    final children = <Widget>[const Text('First'), const Text('Second')];
    final flex = flexBuilder(children: children).child as FlexBox;
    final stack = stackBuilder(children: children).child as StackBox;
    final wrap = wrapBuilder(children: children).child as WrapBox;
    final grid = gridBuilder(children: children).child as GridBox;
    expect(flex.style, same(flexStyle));
    expect(flex.children, same(children));
    expect(stack.style, same(stackStyle));
    expect(stack.children, same(children));
    expect(wrap.style, same(wrapStyle));
    expect(wrap.children, same(children));
    expect(grid.style, same(gridStyle));
    expect(grid.children, same(children));
    expect((flexBuilder().child as FlexBox).children, isEmpty);
    expect((stackBuilder().child as StackBox).children, isEmpty);
    expect((wrapBuilder().child as WrapBox).children, isEmpty);
    expect((gridBuilder().child as GridBox).children, isEmpty);
  });
}

List<Object?> _options(Pressable widget) => [
  widget.enabled,
  widget.enableFeedback,
  widget.onPress,
  widget.onLongPress,
  widget.onFocusChange,
  widget.autofocus,
  widget.focusNode,
  widget.mouseCursor,
  widget.canRequestFocus,
  widget.excludeFromSemantics,
  widget.semanticsLabel,
  widget.semanticsRole,
  widget.onKeyEvent,
  widget.controller,
  widget.actions,
  widget.hitTestBehavior,
];
