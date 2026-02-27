import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart' show OrdinalSortKey;
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_schema/src/ast/schema_semantics.dart';
import 'package:mix_schema/src/render/handlers/style_helpers.dart';

void main() {
  group('parseFontWeight', () {
    test('parses string names', () {
      expect(parseFontWeight('thin'), FontWeight.w100);
      expect(parseFontWeight('light'), FontWeight.w300);
      expect(parseFontWeight('normal'), FontWeight.w400);
      expect(parseFontWeight('regular'), FontWeight.w400);
      expect(parseFontWeight('medium'), FontWeight.w500);
      expect(parseFontWeight('semiBold'), FontWeight.w600);
      expect(parseFontWeight('bold'), FontWeight.w700);
      expect(parseFontWeight('extraBold'), FontWeight.w800);
      expect(parseFontWeight('black'), FontWeight.w900);
    });

    test('parses weight number strings', () {
      expect(parseFontWeight('100'), FontWeight.w100);
      expect(parseFontWeight('200'), FontWeight.w200);
      expect(parseFontWeight('400'), FontWeight.w400);
      expect(parseFontWeight('700'), FontWeight.w700);
      expect(parseFontWeight('900'), FontWeight.w900);
    });

    test('parses w-prefixed strings', () {
      expect(parseFontWeight('w100'), FontWeight.w100);
      expect(parseFontWeight('w400'), FontWeight.w400);
      expect(parseFontWeight('w700'), FontWeight.w700);
    });

    test('passes through FontWeight directly', () {
      expect(parseFontWeight(FontWeight.w500), FontWeight.w500);
    });

    test('defaults to w400 for unknown values', () {
      expect(parseFontWeight('unknown'), FontWeight.w400);
      expect(parseFontWeight(42), FontWeight.w400);
    });
  });

  group('parseTextOverflow', () {
    test('parses all known values', () {
      expect(parseTextOverflow('ellipsis'), TextOverflow.ellipsis);
      expect(parseTextOverflow('clip'), TextOverflow.clip);
      expect(parseTextOverflow('fade'), TextOverflow.fade);
      expect(parseTextOverflow('visible'), TextOverflow.visible);
    });

    test('defaults to clip for unknown', () {
      expect(parseTextOverflow('unknown'), TextOverflow.clip);
    });
  });

  group('parseClip', () {
    test('parses all known values', () {
      expect(parseClip('none'), Clip.none);
      expect(parseClip('hardEdge'), Clip.hardEdge);
      expect(parseClip('antiAlias'), Clip.antiAlias);
      expect(parseClip('antiAliasWithSaveLayer'), Clip.antiAliasWithSaveLayer);
    });

    test('defaults to none for unknown', () {
      expect(parseClip('unknown'), Clip.none);
    });
  });

  group('parseCrossAxis', () {
    test('parses all known values', () {
      expect(parseCrossAxis('start'), CrossAxisAlignment.start);
      expect(parseCrossAxis('end'), CrossAxisAlignment.end);
      expect(parseCrossAxis('center'), CrossAxisAlignment.center);
      expect(parseCrossAxis('stretch'), CrossAxisAlignment.stretch);
      expect(parseCrossAxis('baseline'), CrossAxisAlignment.baseline);
    });

    test('defaults to start for unknown', () {
      expect(parseCrossAxis('unknown'), CrossAxisAlignment.start);
    });
  });

  group('parseMainAxis', () {
    test('parses all known values', () {
      expect(parseMainAxis('start'), MainAxisAlignment.start);
      expect(parseMainAxis('end'), MainAxisAlignment.end);
      expect(parseMainAxis('center'), MainAxisAlignment.center);
      expect(parseMainAxis('spaceBetween'), MainAxisAlignment.spaceBetween);
      expect(parseMainAxis('spaceAround'), MainAxisAlignment.spaceAround);
      expect(parseMainAxis('spaceEvenly'), MainAxisAlignment.spaceEvenly);
    });

    test('defaults to start for unknown', () {
      expect(parseMainAxis('unknown'), MainAxisAlignment.start);
    });
  });

  group('parseAlignment', () {
    test('parses all known values', () {
      expect(parseAlignment('topLeft'), Alignment.topLeft);
      expect(parseAlignment('topCenter'), Alignment.topCenter);
      expect(parseAlignment('topRight'), Alignment.topRight);
      expect(parseAlignment('centerLeft'), Alignment.centerLeft);
      expect(parseAlignment('center'), Alignment.center);
      expect(parseAlignment('centerRight'), Alignment.centerRight);
      expect(parseAlignment('bottomLeft'), Alignment.bottomLeft);
      expect(parseAlignment('bottomCenter'), Alignment.bottomCenter);
      expect(parseAlignment('bottomRight'), Alignment.bottomRight);
    });

    test('defaults to center for unknown', () {
      expect(parseAlignment('unknown'), Alignment.center);
    });
  });

  group('parseCurve', () {
    test('parses all known values', () {
      expect(parseCurve('linear'), Curves.linear);
      expect(parseCurve('easeIn'), Curves.easeIn);
      expect(parseCurve('easeOut'), Curves.easeOut);
      expect(parseCurve('easeInOut'), Curves.easeInOut);
      expect(parseCurve('bounceIn'), Curves.bounceIn);
      expect(parseCurve('bounceOut'), Curves.bounceOut);
      expect(parseCurve('elasticIn'), Curves.elasticIn);
      expect(parseCurve('elasticOut'), Curves.elasticOut);
    });

    test('defaults to easeOut for null/unknown', () {
      expect(parseCurve(null), Curves.easeOut);
      expect(parseCurve('unknown'), Curves.easeOut);
    });
  });

  group('resolveIconData', () {
    test('resolves known icon names', () {
      expect(resolveIconData('star'), Icons.star);
      expect(resolveIconData('home'), Icons.home);
      expect(resolveIconData('settings'), Icons.settings);
      expect(resolveIconData('search'), Icons.search);
      expect(resolveIconData('close'), Icons.close);
      expect(resolveIconData('add'), Icons.add);
      expect(resolveIconData('delete'), Icons.delete);
      expect(resolveIconData('edit'), Icons.edit);
      expect(resolveIconData('person'), Icons.person);
      expect(resolveIconData('favorite'), Icons.favorite);
    });

    test('returns help_outline for unknown name', () {
      expect(resolveIconData('nonexistent'), Icons.help_outline);
    });

    test('handles int codepoints', () {
      final icon = resolveIconData(0xe87d); // star codepoint
      expect(icon.codePoint, 0xe87d);
      expect(icon.fontFamily, 'MaterialIcons');
    });

    test('passes through IconData directly', () {
      expect(resolveIconData(Icons.check), Icons.check);
    });

    test('returns help_outline for other types', () {
      expect(resolveIconData(3.14), Icons.help_outline);
      expect(resolveIconData(null), Icons.help_outline);
    });
  });

  group('toDouble', () {
    test('converts numeric types', () {
      expect(toDouble(42), 42.0);
      expect(toDouble(3.14), 3.14);
      expect(toDouble(0), 0.0);
    });

    test('returns 0.0 for non-numeric', () {
      expect(toDouble('hello'), 0.0);
      expect(toDouble(null), 0.0);
    });
  });

  group('wrapWithSemantics', () {
    test('returns child unchanged when semantics is null', () {
      const child = Text('hello');
      final result = wrapWithSemantics(child, null);
      expect(identical(result, child), true);
    });

    test('returns child when semantics has no content', () {
      const child = Text('hello');
      const semantics = SchemaSemantics();
      final result = wrapWithSemantics(child, semantics);
      expect(identical(result, child), true);
    });

    test('wraps with Semantics widget for label', () {
      const child = Text('hello');
      const semantics = SchemaSemantics(label: 'test label');
      final result = wrapWithSemantics(child, semantics);

      expect(result, isA<Semantics>());
      final sem = result as Semantics;
      expect(sem.properties.label, 'test label');
    });

    test('maps button role correctly', () {
      const child = Text('click me');
      const semantics = SchemaSemantics(role: 'button', label: 'click');
      final result = wrapWithSemantics(child, semantics) as Semantics;

      expect(result.properties.button, true);
      expect(result.properties.header, false);
      expect(result.properties.image, false);
    });

    test('maps heading role correctly', () {
      const child = Text('title');
      const semantics = SchemaSemantics(role: 'heading', label: 'title');
      final result = wrapWithSemantics(child, semantics) as Semantics;

      expect(result.properties.header, true);
      expect(result.properties.button, false);
    });

    test('maps img role correctly', () {
      const child = Text('image');
      const semantics = SchemaSemantics(role: 'img', label: 'photo');
      final result = wrapWithSemantics(child, semantics) as Semantics;

      expect(result.properties.image, true);
      expect(result.properties.button, false);
    });

    test('applies focusOrder as OrdinalSortKey', () {
      const child = Text('ordered');
      const semantics = SchemaSemantics(label: 'item', focusOrder: 3);
      final result = wrapWithSemantics(child, semantics) as Semantics;

      expect(result.properties.sortKey, isA<OrdinalSortKey>());
      expect((result.properties.sortKey! as OrdinalSortKey).order, 3.0);
    });

    test('applies interactive properties', () {
      const child = Text('toggle');
      const semantics = SchemaSemantics(
        label: 'toggle',
        selected: true,
        checked: false,
        expanded: true,
        enabled: true,
      );
      final result = wrapWithSemantics(child, semantics) as Semantics;

      expect(result.properties.selected, true);
      expect(result.properties.checked, false);
      expect(result.properties.expanded, true);
      expect(result.properties.enabled, true);
    });

    test('enables liveRegion when mode is set', () {
      const child = Text('status');
      const semantics = SchemaSemantics(
        label: 'status',
        liveRegionMode: 'polite',
      );
      final result = wrapWithSemantics(child, semantics) as Semantics;

      expect(result.properties.liveRegion, true);
    });

    test('passes hint through', () {
      const child = Text('help');
      const semantics = SchemaSemantics(label: 'field', hint: 'Enter value');
      final result = wrapWithSemantics(child, semantics) as Semantics;

      expect(result.properties.hint, 'Enter value');
    });

    test('passes value through', () {
      const child = Text('slider');
      const semantics = SchemaSemantics(label: 'volume', value: '50%');
      final result = wrapWithSemantics(child, semantics) as Semantics;

      expect(result.properties.value, '50%');
    });
  });
}
