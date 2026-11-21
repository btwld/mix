import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_winds/mix_winds.dart';

import 'winds_test_helpers.dart';

typedef _DivFactory = Div Function(String classNames, [List<Widget> children]);
typedef _TextFactory<T extends Widget> =
    T Function(String classNames, String text);
typedef _ButtonFactory =
    Button Function(
      String classNames,
      List<Widget> children, {
      required VoidCallback? onPressed,
      String? semanticsLabel,
    });
typedef _IconFactory =
    TwIcon Function(String classNames, IconData icon, {String? semanticLabel});

void main() {
  test(
    'public barrel exposes strongly typed class-first element functions',
    () {
      final _DivFactory divFactory = div;
      final _TextFactory<P> pFactory = p;
      final _TextFactory<Span> spanFactory = span;
      final _TextFactory<H1> h1Factory = h1;
      final _TextFactory<H2> h2Factory = h2;
      final _TextFactory<H3> h3Factory = h3;
      final _TextFactory<H4> h4Factory = h4;
      final _TextFactory<H5> h5Factory = h5;
      final _TextFactory<H6> h6Factory = h6;
      final _ButtonFactory buttonFactory = button;
      final _IconFactory iconFactory = twIcon;
      final _TextFactory<TruncatedP> truncatedPFactory = truncatedP;
      final children = <Widget>[const SizedBox(width: 12)];
      void onPressed() {}

      final container = divFactory('flex gap-2', children);
      expect(container, isA<Div>());
      expect(container.classNames, 'flex gap-2');
      expect(container.children, same(children));
      expect(divFactory('h-px').children, isEmpty);

      final paragraph = pFactory('text-sm', 'Paragraph');
      expect(paragraph, isA<P>());
      expect(paragraph.classNames, 'text-sm');
      expect(paragraph.text, 'Paragraph');

      final inline = spanFactory('font-bold', 'Inline');
      expect(inline, isA<Span>());
      expect(inline.classNames, 'font-bold');
      expect(inline.text, 'Inline');

      final heading1 = h1Factory('text-6xl', 'Heading 1');
      expect(heading1, isA<H1>());
      expect(heading1.classNames, 'text-6xl');
      expect(heading1.text, 'Heading 1');

      final heading2 = h2Factory('text-5xl', 'Heading 2');
      expect(heading2, isA<H2>());
      expect(heading2.classNames, 'text-5xl');
      expect(heading2.text, 'Heading 2');

      final heading3 = h3Factory('text-4xl', 'Heading 3');
      expect(heading3, isA<H3>());
      expect(heading3.classNames, 'text-4xl');
      expect(heading3.text, 'Heading 3');

      final heading4 = h4Factory('text-3xl', 'Heading 4');
      expect(heading4, isA<H4>());
      expect(heading4.classNames, 'text-3xl');
      expect(heading4.text, 'Heading 4');

      final heading5 = h5Factory('text-2xl', 'Heading 5');
      expect(heading5, isA<H5>());
      expect(heading5.classNames, 'text-2xl');
      expect(heading5.text, 'Heading 5');

      final heading6 = h6Factory('text-xl', 'Heading 6');
      expect(heading6, isA<H6>());
      expect(heading6.classNames, 'text-xl');
      expect(heading6.text, 'Heading 6');

      final control = buttonFactory(
        'flex px-4',
        children,
        onPressed: onPressed,
        semanticsLabel: 'Run action',
      );
      expect(control, isA<Button>());
      expect(control.classNames, 'flex px-4');
      expect(control.children, same(children));
      expect(control.onPressed, same(onPressed));
      expect(control.semanticsLabel, 'Run action');

      final disabledControl = buttonFactory(
        'opacity-50',
        const [],
        onPressed: null,
      );
      expect(disabledControl.onPressed, isNull);

      final icon = iconFactory(
        'h-4 w-4 text-blue-600',
        Icons.add,
        semanticLabel: 'Add',
      );
      expect(icon, isA<TwIcon>());
      expect(icon.classNames, 'h-4 w-4 text-blue-600');
      expect(icon.icon, Icons.add);
      expect(icon.semanticLabel, 'Add');

      final truncated = truncatedPFactory('text-slate-500', 'Long value');
      expect(truncated, isA<TruncatedP>());
      expect(truncated.classNames, 'text-slate-500');
      expect(truncated.text, 'Long value');
    },
  );

  testWidgets('lowercase headings expose their semantic heading levels', (
    tester,
  ) async {
    final semanticsHandle = tester.ensureSemantics();
    var semanticsDisposed = false;
    void disposeSemantics() {
      if (semanticsDisposed) return;
      semanticsDisposed = true;
      semanticsHandle.dispose();
    }

    addTearDown(disposeSemantics);
    final headings = <(int, String, Widget)>[
      (1, 'Heading 1', h1('', 'Heading 1')),
      (2, 'Heading 2', h2('', 'Heading 2')),
      (3, 'Heading 3', h3('', 'Heading 3')),
      (4, 'Heading 4', h4('', 'Heading 4')),
      (5, 'Heading 5', h5('', 'Heading 5')),
      (6, 'Heading 6', h6('', 'Heading 6')),
    ];

    try {
      await pumpSized(
        tester,
        Column(children: [for (final heading in headings) heading.$3]),
      );

      for (final (level, text, _) in headings) {
        final semantics = tester.getSemantics(find.text(text));
        expect(semantics.getSemanticsData().label, text);
        expect(
          semantics.getSemanticsData().headingLevel,
          level,
          reason: '$text must expose heading level $level',
        );
      }
    } finally {
      disposeSemantics();
    }
  });

  testWidgets(
    'lowercase button invokes its callback and uses visible child semantics',
    (tester) async {
      final semanticsHandle = tester.ensureSemantics();
      var semanticsDisposed = false;
      void disposeSemantics() {
        if (semanticsDisposed) return;
        semanticsDisposed = true;
        semanticsHandle.dispose();
      }

      addTearDown(disposeSemantics);
      var presses = 0;

      try {
        await pumpSized(
          tester,
          button(
            'flex h-10 w-20 items-center justify-center',
            [span('', 'Save')],
            onPressed: () => presses++,
          ),
        );

        final semantics = tester.getSemantics(find.byType(Pressable));
        expect(
          semantics,
          isSemantics(
            label: 'Save',
            isButton: true,
            hasEnabledState: true,
            isEnabled: true,
            hasTapAction: true,
            hasLongPressAction: false,
          ),
        );
        expect(semantics.childrenCountInTraversalOrder, 0);

        await tester.tap(find.text('Save'));
        await tester.pump();
        expect(presses, 1);
      } finally {
        disposeSemantics();
      }
    },
  );

  testWidgets('lowercase button forwards an optional semantics label', (
    tester,
  ) async {
    final semanticsHandle = tester.ensureSemantics();
    var semanticsDisposed = false;
    void disposeSemantics() {
      if (semanticsDisposed) return;
      semanticsDisposed = true;
      semanticsHandle.dispose();
    }

    addTearDown(disposeSemantics);

    try {
      await pumpSized(
        tester,
        button(
          'flex h-10 w-10 items-center justify-center',
          [twIcon('h-4 w-4', Icons.add)],
          onPressed: () {},
          semanticsLabel: 'Add item',
        ),
      );

      expect(
        tester.getSemantics(find.byType(Pressable)),
        isSemantics(
          label: 'Add item',
          isButton: true,
          hasEnabledState: true,
          isEnabled: true,
          hasTapAction: true,
          hasLongPressAction: false,
        ),
      );
    } finally {
      disposeSemantics();
    }
  });
}
