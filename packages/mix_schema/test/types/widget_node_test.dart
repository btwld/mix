import 'package:mix_schema/mix_schema.dart';
import 'package:test/test.dart';

void roundTrip(WidgetNode node) {
  final encoded = node.toJson();
  final decoded = WidgetNode.fromJson(encoded);
  expect(decoded, equals(node), reason: 'round-trip failed for widget=${node.widget}');
  expect(decoded.toJson(), equals(encoded));
}

void main() {
  test('WidgetBox', () {
    roundTrip(const WidgetBox());
    roundTrip(WidgetBox(style: StyleBox(const LeafStyleProps())));
  });

  test('WidgetFlexBox / RowBox / ColumnBox / StackBox', () {
    final children = [const WidgetBox()];
    roundTrip(WidgetFlexBox(children: children));
    roundTrip(WidgetRowBox(children: children));
    roundTrip(WidgetColumnBox(children: children));
    roundTrip(WidgetStackBox(children: children));
  });

  test('WidgetStyledText', () {
    roundTrip(const WidgetStyledText(text: 'Hello'));
    roundTrip(const WidgetStyledText(text: 'Hi', style: StyleText()));
  });

  test('WidgetStyledIcon', () {
    roundTrip(const WidgetStyledIcon(
      icon: IconMaterialLiteral(name: 'add'),
    ));
  });

  test('WidgetStyledImage — with host source', () {
    roundTrip(const WidgetStyledImage(
      image: ImageHostLiteral(id: 'banner.hero'),
    ));
    roundTrip(const WidgetStyledImage(
      image: ImageNetworkLiteral(url: 'https://example/x.png'),
    ));
    roundTrip(const WidgetStyledImage(
      image: ImageAssetLiteral(path: 'assets/x.png'),
    ));
  });

  test('WidgetPressable — child REQUIRED', () {
    roundTrip(const WidgetPressable(child: WidgetBox()));
  });

  test('WidgetPressableBox — child OPTIONAL', () {
    roundTrip(const WidgetPressableBox());
    roundTrip(const WidgetPressableBox(child: WidgetBox()));
  });

  test('WidgetExtension — preserves x: payload', () {
    final w = WidgetExtension(
      ExtensionId.unsafe('x:my-card'),
      const {'style': {'spec': 'x:my-card', 'props': {}}},
    );
    roundTrip(w);
  });

  test('Nested children round-trip', () {
    final nested = WidgetColumnBox(children: [
      const WidgetBox(),
      WidgetRowBox(children: const [
        WidgetStyledText(text: 'A'),
        WidgetStyledText(text: 'B'),
      ]),
    ]);
    roundTrip(nested);
  });

  test('Unknown widget throws', () {
    expect(
      () => WidgetNode.fromJson({'widget': 'NotAWidget'}),
      throwsFormatException,
    );
  });
}
