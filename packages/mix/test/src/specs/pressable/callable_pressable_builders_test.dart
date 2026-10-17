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
    final box = boxStyle.pressable()(child: child);
    final text = textStyle.pressable()('Title');
    final icon = iconStyle.pressable()(
      icon: Icons.star,
      semanticLabel: 'star',
      semanticsLabel: 'Activate star',
    );
    final image = imageStyle.pressable()(image: const AssetImage('photo.png'));
    final flex = flexStyle.pressable()(children: const []);
    final stack = stackStyle.pressable()(children: const []);
    final wrap = wrapStyle.pressable()(children: const []);
    final grid = gridStyle.pressable()(children: const []);

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
