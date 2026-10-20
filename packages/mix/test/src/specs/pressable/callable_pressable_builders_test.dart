import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  test('all supported stylers expose terminal callable builders', () {
    final boxStyle = BoxStyler();
    final textStyle = TextStyler();
    final iconStyle = IconStyler();
    final imageStyle = ImageStyler();
    final flexStyle = FlexBoxStyler();
    final stackStyle = StackBoxStyler();
    final wrapStyle = WrapBoxStyler();
    final gridStyle = GridBoxStyler();

    const child = SizedBox();
    final boxBuilder = boxStyle.pressable();
    final textBuilder = textStyle.pressable();
    final iconBuilder = iconStyle.pressable();
    final imageBuilder = imageStyle.pressable();
    final flexBuilder = flexStyle.pressable();
    final stackBuilder = stackStyle.pressable();
    final wrapBuilder = wrapStyle.pressable();
    final gridBuilder = gridStyle.pressable();

    final box = boxBuilder(child: child);
    final text = textBuilder('Title');
    final icon = iconBuilder(
      icon: Icons.star,
      semanticLabel: 'star',
      semanticsLabel: 'Activate star',
    );
    final image = imageBuilder(image: const AssetImage('photo.png'));
    final flex = flexBuilder(children: const []);
    final stack = stackBuilder(children: const []);
    final wrap = wrapBuilder(children: const []);
    final grid = gridBuilder(children: const []);

    expect((box.child as Box).style, same(boxStyle));
    expect((box.child as Box).child, same(child));
    expect((text.child as StyledText).style, same(textStyle));
    expect((icon.child as StyledIcon).style, same(iconStyle));
    expect((icon.child as StyledIcon).semanticLabel, 'star');
    expect(icon.semanticsLabel, 'Activate star');
    expect((image.child as StyledImage).style, same(imageStyle));
    expect((flex.child as FlexBox).style, same(flexStyle));
    expect((stack.child as StackBox).style, same(stackStyle));
    expect((wrap.child as WrapBox).style, same(wrapStyle));
    expect((grid.child as GridBox).style, same(gridStyle));
  });
}
