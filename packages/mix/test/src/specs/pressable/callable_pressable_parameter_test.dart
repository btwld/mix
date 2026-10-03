import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  final surfaces = <String, (Function, List<Object>)>{
    'Box': (BoxStyler().pressable().call, []),
    'Text': (TextStyler().pressable().call, ['Settings']),
    'Icon': (IconStyler().pressable().call, []),
    'Image': (ImageStyler().pressable().call, []),
    'FlexBox': (FlexBoxStyler().pressable().call, []),
    'StackBox': (StackBoxStyler().pressable().call, []),
    'WrapBox': (WrapBoxStyler().pressable().call, []),
    'GridBox': (GridBoxStyler().pressable().call, []),
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
    expect((BoxStyler().pressable()().child as Box).child, isNull);
    final text = TextStyler().pressable()('Settings').child as StyledText;
    expect(text.text, 'Settings');
    final icon = IconStyler().pressable()(
      icon: Icons.star,
      semanticLabel: 'Star',
      semanticsLabel: 'Favorite',
    );
    expect((icon.child as StyledIcon).icon, Icons.star);
    expect((icon.child as StyledIcon).semanticLabel, 'Star');
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
        ImageStyler()
                .pressable()(
                  image: provider,
                  opacity: opacity,
                  frameBuilder: frameBuilder,
                  loadingBuilder: loadingBuilder,
                  errorBuilder: errorBuilder,
                )
                .child
            as StyledImage;
    expect(image.image, same(provider));
    expect(image.opacity, same(opacity));
    expect(image.frameBuilder, same(frameBuilder));
    expect(image.loadingBuilder, same(loadingBuilder));
    expect(image.errorBuilder, same(errorBuilder));

    final children = <Widget>[const Text('First'), const Text('Second')];
    expect(
      (FlexBoxStyler().pressable()(children: children).child as FlexBox)
          .children,
      same(children),
    );
    expect(
      (StackBoxStyler().pressable()(children: children).child as StackBox)
          .children,
      same(children),
    );
    expect(
      (WrapBoxStyler().pressable()(children: children).child as WrapBox)
          .children,
      same(children),
    );
    expect(
      (GridBoxStyler().pressable()(children: children).child as GridBox)
          .children,
      same(children),
    );
    expect((FlexBoxStyler().pressable()().child as FlexBox).children, isEmpty);
    expect(
      (StackBoxStyler().pressable()().child as StackBox).children,
      isEmpty,
    );
    expect((WrapBoxStyler().pressable()().child as WrapBox).children, isEmpty);
    expect((GridBoxStyler().pressable()().child as GridBox).children, isEmpty);
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
