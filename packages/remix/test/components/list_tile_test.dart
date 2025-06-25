import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:remix/remix.dart';

import '../utils/interaction_tests.dart';

void main() {
  group('RxListItem', () {
    group('Constructor', () {
      const title = 'Settings';
      const subtitle = 'Manage your preferences';
      const enabled = true;
      final style = RxListItemStyle();
      void onPress() {}
      const variants = [Variant('primary')];
      const leading = Icon(Icons.settings);
      const trailing = Icon(Icons.arrow_forward);

      testWidgets('should initialize with correct properties', (tester) async {
        final listItem = RxListItem(
          title: title,
          subtitle: subtitle,
          leading: leading,
          trailing: trailing,
          enabled: enabled,
          style: style,
          onPress: onPress,
          variants: variants,
        );

        expect(listItem.title, title);
        expect(listItem.subtitle, subtitle);
        expect(listItem.enabled, enabled);
        expect(listItem.style, style);
        expect(listItem.onPress, onPress);
        expect(listItem.variants, variants);
        expect(listItem.leading, leading);
        expect(listItem.trailing, trailing);
      });

      testWidgets('should render correct UI output', (tester) async {
        const listItem = RxListItem(
          title: 'Settings',
          subtitle: 'Manage your preferences',
          leading: leading,
          trailing: trailing,
        );

        await tester.pumpRxWidget(listItem);

        final titleFinder = find.text('Settings');
        expect(titleFinder, findsOneWidget);

        final subtitleFinder = find.text('Manage your preferences');
        expect(subtitleFinder, findsOneWidget);

        final leadingIconFinder = find.byIcon(Icons.settings);
        expect(leadingIconFinder, findsOneWidget);

        final trailingIconFinder = find.byIcon(Icons.arrow_forward);
        expect(trailingIconFinder, findsOneWidget);
      });

      testWidgets('should display leading and trailing widgets',
          (tester) async {
        const listItem = RxListItem(
          title: 'Profile',
          leading: CircleAvatar(child: Text('JD')),
          trailing: Text('John Doe'),
        );

        await tester.pumpRxWidget(listItem);

        final leadingAvatarFinder = find.byType(CircleAvatar);
        expect(leadingAvatarFinder, findsOneWidget);

        final trailingTextFinder = find.text('John Doe');
        expect(trailingTextFinder, findsOneWidget);
      });
    });

    testWidgets('should apply style correctly', (tester) async {
      final style = RxListItemStyle()..container.color.blue();

      final listItem = RxListItem(
        title: 'Settings',
        subtitle: 'Manage preferences',
        style: style,
      );

      await tester.pumpRxWidget(listItem);

      // Verify container decoration
      final containerFinder = find
          .descendant(
            of: find.byType(RxListItem),
            matching: find.byType(Container),
          )
          .first;
      final containerWidget = tester.widget<Container>(containerFinder);
      expect((containerWidget.decoration as BoxDecoration).color, Colors.blue);
    });

    group('interactions', () {
      //   testTapWidget('should call onPress when tapped', (holder) {
      //     return RxListItem(
      //       title: 'Settings',
      //       onPress: () {
      //         holder.value = true;
      //       },
      //     );
      //   }, shouldExpectPress: true);

      // testTapWidget('should not call onPress when disabled', (holder) {
      //   return RxListItem(
      //     title: 'Settings',
      //     enabled: false,
      //     onPress: () {
      //       holder.value = true;
      //     },
      //   );
      // }, shouldExpectPress: false);

      testHoverWidget('should handle hover state when enabled', () {
        return RxListItem(
          title: 'Settings',
          onPress: () {},
        );
      }, shouldExpectHover: true);

      testHoverWidget('should handle hover state when disabled', () {
        return RxListItem(
          title: 'Settings',
          enabled: false,
          onPress: () {},
        );
      }, shouldExpectHover: false);

      testFocusWidget('should handle focus state when enabled', (focusNode) {
        return RxListItem(
          title: 'Settings',
          focusNode: focusNode,
          onPress: () {},
        );
      }, shouldExpectFocus: true);

      testFocusWidget('should not focus when disabled', (focusNode) {
        return RxListItem(
          title: 'Settings',
          enabled: false,
          focusNode: focusNode,
        );
      }, shouldExpectFocus: false);
    });
  });
}
