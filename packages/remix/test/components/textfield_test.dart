import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:remix/remix.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';

import '../utils/interaction_tests.dart';

void main() {
  group('RxTextField', () {
    const hintText = 'Enter your text';
    const label = 'Label';
    const helperText = 'Helper text';
    const prefixIcon = Icons.search;
    const suffixIcon = Icons.clear;
    const variants = [Variant('primary')];
    final style = RxTextFieldStyle();
    final controller = TextEditingController();

    group('Constructor', () {
      testWidgets('should initialize with all parameters correctly',
          (tester) async {
        final textField = RxTextField(
          controller: controller,
          maxLength: 100,
          focusNode: FocusNode(),
          enabled: true,
          ignorePointers: false,
          onPressed: () {},
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.done,
          textDirection: TextDirection.ltr,
          autofocus: true,
          readOnly: false,
          showCursor: true,
          obscuringCharacter: '*',
          obscureText: true,
          hintText: hintText,
          autocorrect: false,
          smartDashesType: SmartDashesType.disabled,
          smartQuotesType: SmartQuotesType.disabled,
          enableSuggestions: false,
          maxLines: 1,
          minLines: 1,
          expands: false,
          onChanged: (value) {},
          onEditingComplete: () {},
          onSubmitted: (value) {},
          inputFormatters: [],
          enableInteractiveSelection: true,
          selectionControls: null,
          scrollController: ScrollController(),
          scrollPhysics: const BouncingScrollPhysics(),
          clipBehavior: Clip.antiAlias,
          restorationId: 'textfield',
          scribbleEnabled: true,
          enableIMEPersonalizedLearning: true,
          autofillHints: const <String>['username'],
          contentInsertionConfiguration: null,
          dragStartBehavior: DragStartBehavior.start,
          groupId: EditableText,
          onAppPrivateCommand: (command, data) {},
          onTapOutside: (event) {},
          canRequestFocus: true,
          onTapAlwaysCalled: false,
          undoController: UndoHistoryController(),
          magnifierConfiguration: TextMagnifierConfiguration.disabled,
          spellCheckConfiguration: const SpellCheckConfiguration.disabled(),
          contextMenuBuilder: (context, editableTextState) => Container(),
          style: style,
          variants: variants,
          error: false,
          label: label,
          helperText: helperText,
          prefix: const Icon(prefixIcon),
          suffix: const Icon(suffixIcon),
        );

        await tester.pumpRxWidget(textField);

        expect(find.text(label), findsOneWidget);
        expect(find.text(helperText), findsOneWidget);
        expect(find.byIcon(prefixIcon), findsOneWidget);
        expect(find.byIcon(suffixIcon), findsOneWidget);

        expect(textField.controller, controller);
        expect(textField.maxLength, 100);
        expect(textField.focusNode, isA<FocusNode>());
        expect(textField.enabled, true);
        expect(textField.ignorePointers, false);
        expect(textField.onPressed, isNotNull);
        expect(textField.maxLengthEnforcement, MaxLengthEnforcement.enforced);
        expect(textField.keyboardType, TextInputType.text);
        expect(textField.textCapitalization, TextCapitalization.words);
        expect(textField.textInputAction, TextInputAction.done);
        expect(textField.textDirection, TextDirection.ltr);
        expect(textField.autofocus, true);
        expect(textField.readOnly, false);
        expect(textField.showCursor, true);
        expect(textField.obscuringCharacter, '*');
        expect(textField.obscureText, true);
        expect(textField.hintText, hintText);
        expect(textField.autocorrect, false);
        expect(textField.smartDashesType, SmartDashesType.disabled);
        expect(textField.smartQuotesType, SmartQuotesType.disabled);
        expect(textField.enableSuggestions, false);
        expect(textField.maxLines, 1);
        expect(textField.minLines, 1);
        expect(textField.expands, false);
        expect(textField.onChanged, isNotNull);
        expect(textField.onEditingComplete, isNotNull);
        expect(textField.onSubmitted, isNotNull);
        expect(textField.inputFormatters, isEmpty);
        expect(textField.enableInteractiveSelection, true);
        expect(textField.selectionControls, isNull);
        expect(textField.scrollController, isA<ScrollController>());
        expect(textField.scrollPhysics, isA<BouncingScrollPhysics>());
        expect(textField.clipBehavior, Clip.antiAlias);
        expect(textField.restorationId, 'textfield');
        expect(textField.scribbleEnabled, true);
        expect(textField.enableIMEPersonalizedLearning, true);
        expect(textField.autofillHints, ['username']);
        expect(textField.contentInsertionConfiguration, isNull);
        expect(textField.dragStartBehavior, DragStartBehavior.start);
        expect(textField.groupId, EditableText);
        expect(textField.onAppPrivateCommand, isNotNull);
        expect(textField.onTapOutside, isNotNull);
        expect(textField.canRequestFocus, true);
        expect(textField.onTapAlwaysCalled, false);
        expect(textField.undoController, isA<UndoHistoryController>());
        expect(textField.magnifierConfiguration,
            TextMagnifierConfiguration.disabled);
        expect(textField.spellCheckConfiguration,
            const SpellCheckConfiguration.disabled());
        expect(textField.contextMenuBuilder, isNotNull);
        expect(textField.style, style);
        expect(textField.variants, variants);
        expect(textField.error, false);
        expect(textField.label, label);
        expect(textField.helperText, helperText);
        expect(textField.prefix, isA<Icon>());
        expect(textField.suffix, isA<Icon>());
      });
    });

    group('prefix and suffix', () {
      testWidgets('should display prefix widget', (tester) async {
        await tester.pumpRxWidget(
          RxTextField(
            controller: controller,
            prefix: const Icon(Icons.search),
          ),
        );

        expect(find.byIcon(Icons.search), findsOneWidget);
      });

      testWidgets('should display suffix widget', (tester) async {
        await tester.pumpRxWidget(
          RxTextField(
            controller: controller,
            suffix: const Icon(Icons.clear),
          ),
        );

        expect(find.byIcon(Icons.clear), findsOneWidget);
      });

      testWidgets('should display both prefix and suffix widgets',
          (tester) async {
        await tester.pumpRxWidget(
          RxTextField(
            controller: controller,
            prefix: const Icon(Icons.search),
            suffix: const Icon(Icons.clear),
          ),
        );

        expect(find.byIcon(Icons.search), findsOneWidget);
        expect(find.byIcon(Icons.clear), findsOneWidget);
      });
    });

    group('interactions', () {
      testWidgets('should call onChanged when text is entered', (tester) async {
        final controller = TextEditingController();
        String value = '';

        await tester.pumpRxWidget(
          RxTextField(
            controller: controller,
            onChanged: (newValue) {
              value = newValue;
            },
          ),
        );

        await tester.enterText(find.byType(RxTextField), 'test');
        await tester.pump();

        expect(value, 'test');
        expect(controller.text, 'test');
      });

      testWidgets('should call onSubmitted when text is submitted', (tester) async {
        final controller = TextEditingController();
        String submittedValue = '';

        await tester.pumpRxWidget(
          RxTextField(
            controller: controller,
            onSubmitted: (value) {
              submittedValue = value;
            },
          ),
        );

        await tester.enterText(find.byType(RxTextField), 'test');
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pump();

        expect(submittedValue, 'test');
        expect(controller.text, 'test');
      });

      testFocusWidget('should handle focus state correctly', (focusNode) {
        return RxTextField(
          controller: controller,
          focusNode: focusNode,
        );
      }, shouldExpectFocus: true);

      testFocusWidget('should not focus when disabled', (focusNode) {
        return RxTextField(
          controller: controller,
          enabled: false,
          focusNode: focusNode,
        );
      }, shouldExpectFocus: false);

      testHoverWidget('should handle hover state when enabled', () {
        return RxTextField(
          controller: controller,
          enabled: true,
        );
      }, shouldExpectHover: true);

      testHoverWidget('should handle hover state when disabled', () {
        return RxTextField(
          controller: controller,
          enabled: false,
        );
      }, shouldExpectHover: false);

      testTapWidget('should call onPressed when tapped and enabled', (holder) {
        return RxTextField(
          controller: controller,
          onPressed: () {
            holder.value = true;
          },
        );
      }, shouldExpectPress: true);

      testTapWidget('should call onPressed when tapped and disabled', (holder) {
        return RxTextField(
          controller: controller,
          enabled: false,
          onPressed: () {
            holder.value = true;
          },
        );
      }, shouldExpectPress: true);
    });
  });
}
