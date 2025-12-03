import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('TextSpec', () {
    group('Constructor', () {
      test('creates TextSpec with all properties', () {
        const spec = TextSpec(
          overflow: TextOverflow.ellipsis,
          strutStyle: StrutStyle(fontSize: 16.0),
          textAlign: TextAlign.center,
          textScaler: TextScaler.linear(1.2),
          maxLines: 3,
          style: TextStyle(fontSize: 14.0, color: Colors.blue),
          textWidthBasis: TextWidthBasis.longestLine,
          textHeightBehavior: TextHeightBehavior(
            applyHeightToFirstAscent: false,
            applyHeightToLastDescent: false,
          ),
          textDirection: TextDirection.rtl,
          softWrap: false,
          textDirectives: [],
        );

        expect(spec.overflow, TextOverflow.ellipsis);
        expect(spec.strutStyle?.fontSize, 16.0);
        expect(spec.textAlign, TextAlign.center);
        expect(spec.textScaler, isA<TextScaler>());
        expect(spec.maxLines, 3);
        expect(spec.style?.fontSize, 14.0);
        expect(spec.style?.color, Colors.blue);
        expect(spec.textWidthBasis, TextWidthBasis.longestLine);
        expect(spec.textHeightBehavior, isA<TextHeightBehavior>());
        expect(spec.textDirection, TextDirection.rtl);
        expect(spec.softWrap, false);
        expect(spec.textDirectives, isEmpty);
      });

      test('creates TextSpec with default values', () {
        const spec = TextSpec();

        expect(spec.overflow, isNull);
        expect(spec.strutStyle, isNull);
        expect(spec.textAlign, isNull);
        expect(spec.textScaler, isNull);
        expect(spec.maxLines, isNull);
        expect(spec.style, isNull);
        expect(spec.textWidthBasis, isNull);
        expect(spec.textHeightBehavior, isNull);
        expect(spec.textDirection, isNull);
        expect(spec.softWrap, isNull);
        expect(spec.textDirectives, isNull);
      });
    });

    group('copyWith', () {
      test('creates new instance with updated properties', () {
        const original = TextSpec(
          overflow: TextOverflow.clip,
          textAlign: TextAlign.left,
          maxLines: 2,
          style: TextStyle(fontSize: 12.0),
        );

        final updated = original.copyWith(
          overflow: TextOverflow.ellipsis,
          maxLines: 5,
          style: TextStyle(fontSize: 16.0, color: Colors.red),
        );

        expect(updated.overflow, TextOverflow.ellipsis);
        expect(updated.textAlign, TextAlign.left);
        expect(updated.maxLines, 5);
        expect(updated.style?.fontSize, 16.0);
        expect(updated.style?.color, Colors.red);
      });

      test('preserves original properties when not specified', () {
        const original = TextSpec(
          textAlign: TextAlign.center,
          softWrap: true,
          textDirection: TextDirection.ltr,
        );

        final updated = original.copyWith(textAlign: TextAlign.right);

        expect(updated.textAlign, TextAlign.right);
        expect(updated.softWrap, true);
        expect(updated.textDirection, TextDirection.ltr);
      });

      test('handles null values correctly', () {
        const original = TextSpec(maxLines: 3, overflow: TextOverflow.fade);
        final updated = original.copyWith();

        expect(updated.maxLines, 3);
        expect(updated.overflow, TextOverflow.fade);
      });
    });

    group('lerp', () {
      test('interpolates between two TextSpecs correctly', () {
        const spec1 = TextSpec(
          maxLines: 1,
          style: TextStyle(fontSize: 12.0),
          strutStyle: StrutStyle(fontSize: 12.0),
        );
        const spec2 = TextSpec(
          maxLines: 5,
          style: TextStyle(fontSize: 20.0),
          strutStyle: StrutStyle(fontSize: 20.0),
        );

        final lerped = spec1.lerp(spec2, 0.5);

        // Step function properties use lerpSnap (t < 0.5 uses spec1, t >= 0.5 uses spec2)
        expect(
          lerped.maxLines,
          MixOps.lerpSnap(3, 5, 0.5),
        ); // t = 0.5, so uses spec2

        // Interpolated properties
        expect(
          lerped.style?.fontSize,
          ui.lerpDouble(12.0, 20.0, 0.5),
        ); // (12 + 20) / 2
        expect(
          lerped.strutStyle?.fontSize,
          ui.lerpDouble(12.0, 20.0, 0.5),
        ); // (12 + 20) / 2
      });

      test('lerps animated text directives progress', () {
        const spec1 = TextSpec(
          textDirectives: [_TestAnimatedDirective()],
        );
        const spec2 = TextSpec(
          textDirectives: [_TestAnimatedDirective()],
        );

        final lerped = spec1.lerp(spec2, 0.5);

        // The directive should have progress interpolated to 0.5
        expect(_extractProgress(lerped.textDirectives!.single), closeTo(0.5, 1e-9));
      });

      test('handles mismatched directive list lengths - first longer', () {
        const spec1 = TextSpec(
          textDirectives: [
            _TestAnimatedDirective(),
            _TestAnimatedDirective(),
          ],
        );
        const spec2 = TextSpec(
          textDirectives: [_TestAnimatedDirective()],
        );

        final lerped = spec1.lerp(spec2, 0.5);

        expect(lerped.textDirectives?.length, 2);
        // First interpolates normally
        expect(
          _extractProgress(lerped.textDirectives![0]),
          closeTo(0.5, 1e-9),
        );
        // Second disappears (progress = 1 - t = 0.5)
        expect(
          _extractProgress(lerped.textDirectives![1]),
          closeTo(0.5, 1e-9),
        );
      });

      test('handles mismatched directive list lengths - second longer', () {
        const spec1 = TextSpec(
          textDirectives: [_TestAnimatedDirective()],
        );
        const spec2 = TextSpec(
          textDirectives: [
            _TestAnimatedDirective(),
            _TestAnimatedDirective(),
          ],
        );

        final lerped = spec1.lerp(spec2, 0.5);

        expect(lerped.textDirectives?.length, 2);
        expect(
          _extractProgress(lerped.textDirectives![0]),
          closeTo(0.5, 1e-9),
        );
        // Appearing directive animates from 0 to target, so at t=0.5 it's 0.5
        expect(
          _extractProgress(lerped.textDirectives![1]),
          closeTo(0.5, 1e-9),
        );
      });

      test('snaps when animated directives have different keys', () {
        const spec1 = TextSpec(
          textDirectives: [_TestAnimatedDirective()],
        );
        const spec2 = TextSpec(
          textDirectives: [_AnotherAnimatedDirective()],
        );

        final lerpedBefore = spec1.lerp(spec2, 0.4);
        final lerpedAfter = spec1.lerp(spec2, 0.6);

        expect(lerpedBefore.textDirectives?[0], isA<_TestAnimatedDirective>());
        expect(lerpedAfter.textDirectives?[0], isA<_AnotherAnimatedDirective>());
      });

      test('handles null textDirectives in first spec', () {
        const spec1 = TextSpec();
        const spec2 = TextSpec(
          textDirectives: [_TestAnimatedDirective()],
        );

        final lerped = spec1.lerp(spec2, 0.5);

        expect(lerped.textDirectives?.length, 1);
        // Appearing: progress at t=0.5 is 0.5
        expect(
          _extractProgress(lerped.textDirectives![0]),
          closeTo(0.5, 1e-9),
        );
      });

      test('handles null textDirectives in second spec', () {
        const spec1 = TextSpec(
          textDirectives: [_TestAnimatedDirective()],
        );
        const spec2 = TextSpec();

        final lerped = spec1.lerp(spec2, 0.5);

        expect(lerped.textDirectives?.length, 1);
        // Disappearing: progress at t=0.5 is 0.5
        expect(
          _extractProgress(lerped.textDirectives![0]),
          closeTo(0.5, 1e-9),
        );
      });

      test('typewriter directive reveals characters progressively', () {
        const directive = TypewriterDirective();

        const text = 'Hello World';

        expect(directive.apply(text, 0.0), '');
        expect(directive.apply(text, 0.5), 'Hello ');
        expect(directive.apply(text, 1.0), 'Hello World');
      });

      test('reverse typewriter directive hides characters progressively', () {
        const directive = TypewriterDirective(reverse: true);

        const text = 'Hello World';

        expect(directive.apply(text, 0.0), 'Hello World');
        expect(directive.apply(text, 0.5), 'Hello ');
        expect(directive.apply(text, 1.0), '');
      });

      test('typewriter directive lerps correctly during animation', () {
        const spec1 = TextSpec(
          textDirectives: [TypewriterDirective()],
        );
        const spec2 = TextSpec(
          textDirectives: [TypewriterDirective()],
        );

        final lerped0 = spec1.lerp(spec2, 0.0);
        final lerped50 = spec1.lerp(spec2, 0.5);
        final lerped100 = spec1.lerp(spec2, 1.0);

        // TypewriterDirective uses rounding, so we test with exact boundaries
        // At t=0.0, progress should be 0 (empty string)
        // At t=0.5, progress should be 0.5 (half string)
        // At t=1.0, progress should be 1.0 (full string)
        expect(
          _extractTypewriterProgress(lerped0.textDirectives![0]),
          closeTo(0.0, 0.01),
        );
        expect(
          _extractTypewriterProgress(lerped50.textDirectives![0]),
          closeTo(0.5, 0.01),
        );
        expect(
          _extractTypewriterProgress(lerped100.textDirectives![0]),
          closeTo(1.0, 0.01),
        );
      });

      test('handles null other parameter correctly', () {
        const spec = TextSpec(maxLines: 3, overflow: TextOverflow.ellipsis);

        // When t < 0.5, should preserve original values
        final lerped1 = spec.lerp(null, 0.3);
        expect(
          lerped1.maxLines,
          MixOps.lerpSnap(3, null, 0.3),
        ); // lerpSnap behavior
        expect(
          lerped1.overflow,
          MixOps.lerpSnap(TextOverflow.ellipsis, null, 0.3),
        ); // lerpSnap behavior

        // When t >= 0.5, snap properties become null, but new spec should be created
        final lerped2 = spec.lerp(null, 0.7);
        expect(
          lerped2.maxLines,
          MixOps.lerpSnap(3, null, 0.7),
        ); // lerpSnap behavior
        expect(
          lerped2.overflow,
          MixOps.lerpSnap(TextOverflow.ellipsis, null, 0.7),
        ); // overflow snaps to null when t >= 0.5
      });

      test('handles edge cases (t=0, t=1)', () {
        const spec1 = TextSpec(maxLines: 1, overflow: TextOverflow.clip);
        const spec2 = TextSpec(maxLines: 5, overflow: TextOverflow.ellipsis);

        final lerpedAt0 = spec1.lerp(spec2, 0.0);
        final lerpedAt1 = spec1.lerp(spec2, 1.0);

        expect(
          lerpedAt0.maxLines,
          MixOps.lerpSnap(1, 5, 0.0),
        ); // lerpSnap at t=0
        expect(
          lerpedAt0.overflow,
          MixOps.lerpSnap(TextOverflow.clip, TextOverflow.ellipsis, 0.0),
        ); // lerpSnap at t=0
        expect(
          lerpedAt1.maxLines,
          MixOps.lerpSnap(1, 5, 1.0),
        ); // lerpSnap at t=1
        expect(
          lerpedAt1.overflow,
          MixOps.lerpSnap(TextOverflow.clip, TextOverflow.ellipsis, 1.0),
        ); // lerpSnap at t=1
      });

      test('uses step function for discrete properties', () {
        const spec1 = TextSpec(
          overflow: TextOverflow.clip,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr,
          softWrap: true,
        );
        const spec2 = TextSpec(
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
          softWrap: false,
        );

        final lerpedBefore = spec1.lerp(spec2, 0.4);
        final lerpedAfter = spec1.lerp(spec2, 0.6);

        // t < 0.5 uses spec1
        expect(lerpedBefore.overflow, TextOverflow.clip);
        expect(lerpedBefore.textAlign, TextAlign.left);
        expect(lerpedBefore.textDirection, TextDirection.ltr);
        expect(lerpedBefore.softWrap, true);

        // t >= 0.5 uses spec2
        expect(lerpedAfter.overflow, TextOverflow.ellipsis);
        expect(lerpedAfter.textAlign, TextAlign.right);
        expect(lerpedAfter.textDirection, TextDirection.rtl);
        expect(lerpedAfter.softWrap, false);
      });

      test('interpolates TextStyle correctly', () {
        const spec1 = TextSpec(
          style: TextStyle(fontSize: 10.0, letterSpacing: 1.0),
        );
        const spec2 = TextSpec(
          style: TextStyle(fontSize: 20.0, letterSpacing: 3.0),
        );

        final lerped = spec1.lerp(spec2, 0.5);

        expect(lerped.style?.fontSize, 15.0);
        expect(lerped.style?.letterSpacing, 2.0);
      });

      test('interpolates StrutStyle correctly', () {
        const spec1 = TextSpec(
          strutStyle: StrutStyle(fontSize: 12.0, height: 1.0),
        );
        const spec2 = TextSpec(
          strutStyle: StrutStyle(fontSize: 18.0, height: 1.5),
        );

        final lerped = spec1.lerp(spec2, 0.5);

        expect(lerped.strutStyle?.fontSize, ui.lerpDouble(10.0, 20.0, 0.5));
        expect(lerped.strutStyle?.height, ui.lerpDouble(1.0, 1.5, 0.5));
      });
    });

    group('equality', () {
      test('specs with same properties are equal', () {
        const spec1 = TextSpec(
          overflow: TextOverflow.ellipsis,
          maxLines: 3,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14.0),
        );
        const spec2 = TextSpec(
          overflow: TextOverflow.ellipsis,
          maxLines: 3,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14.0),
        );

        expect(spec1, spec2);
        expect(spec1.hashCode, spec2.hashCode);
      });

      test('specs with different properties are not equal', () {
        const spec1 = TextSpec(maxLines: 3, overflow: TextOverflow.ellipsis);
        const spec2 = TextSpec(maxLines: 5, overflow: TextOverflow.ellipsis);

        expect(spec1, isNot(spec2));
      });

      test('specs with null vs non-null properties are not equal', () {
        const spec1 = TextSpec(maxLines: 3);
        const spec2 = TextSpec();

        expect(spec1, isNot(spec2));
      });
    });

    group('debugFillProperties', () {
      test('includes all properties in diagnostics', () {
        const spec = TextSpec(
          overflow: TextOverflow.ellipsis,
          strutStyle: StrutStyle(fontSize: 16.0),
          textAlign: TextAlign.center,
          textScaler: TextScaler.linear(1.2),
          maxLines: 3,
          style: TextStyle(fontSize: 14.0),
          textWidthBasis: TextWidthBasis.longestLine,
          textHeightBehavior: TextHeightBehavior(),
          textDirection: TextDirection.rtl,
          softWrap: false,
          textDirectives: [],
        );

        final diagnostics = DiagnosticPropertiesBuilder();
        spec.debugFillProperties(diagnostics);

        final properties = diagnostics.properties;
        expect(properties.any((p) => p.name == 'overflow'), isTrue);
        expect(properties.any((p) => p.name == 'strutStyle'), isTrue);
        expect(properties.any((p) => p.name == 'textAlign'), isTrue);
        expect(properties.any((p) => p.name == 'textScaler'), isTrue);
        expect(properties.any((p) => p.name == 'maxLines'), isTrue);
        expect(properties.any((p) => p.name == 'style'), isTrue);
        expect(properties.any((p) => p.name == 'textWidthBasis'), isTrue);
        expect(properties.any((p) => p.name == 'textHeightBehavior'), isTrue);
        expect(properties.any((p) => p.name == 'textDirection'), isTrue);
        expect(properties.any((p) => p.name == 'softWrap'), isTrue);
        expect(properties.any((p) => p.name == 'textDirectives'), isTrue);
      });
    });

    group('props', () {
      test('includes all properties in props list', () {
        const spec = TextSpec(
          overflow: TextOverflow.ellipsis,
          strutStyle: StrutStyle(fontSize: 16.0),
          textAlign: TextAlign.center,
          textScaler: TextScaler.linear(1.2),
          maxLines: 3,
          style: TextStyle(fontSize: 14.0),
          textWidthBasis: TextWidthBasis.longestLine,
          textHeightBehavior: TextHeightBehavior(),
          textDirection: TextDirection.rtl,
          softWrap: false,
          textDirectives: [],
        );

        // 14 TextSpec properties
        expect(spec.props.length, 14);
        expect(spec.props, contains(TextOverflow.ellipsis));
        expect(spec.props, contains(spec.strutStyle));
        expect(spec.props, contains(TextAlign.center));
        expect(spec.props, contains(spec.textScaler));
        expect(spec.props, contains(3));
        expect(spec.props, contains(spec.style));
        expect(spec.props, contains(TextWidthBasis.longestLine));
        expect(spec.props, contains(spec.textHeightBehavior));
        expect(spec.props, contains(TextDirection.rtl));
        expect(spec.props, contains(false));
        expect(spec.props, contains(spec.textDirectives));
      });
    });

  group('Real-world scenarios', () {
      test('creates heading text spec', () {
        const headingSpec = TextSpec(
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        );

        expect(headingSpec.style?.fontSize, 24.0);
        expect(headingSpec.style?.fontWeight, FontWeight.bold);
        expect(headingSpec.style?.color, Colors.black87);
        expect(headingSpec.maxLines, 2);
        expect(headingSpec.overflow, TextOverflow.ellipsis);
        expect(headingSpec.textAlign, TextAlign.center);
      });

      test('creates body text spec with custom strut', () {
        const bodySpec = TextSpec(
          style: TextStyle(fontSize: 16.0, height: 1.5),
          strutStyle: StrutStyle(
            fontSize: 16.0,
            height: 1.5,
            forceStrutHeight: true,
          ),
          softWrap: true,
          textAlign: TextAlign.justify,
        );

        expect(bodySpec.style?.fontSize, 16.0);
        expect(bodySpec.style?.height, 1.5);
        expect(bodySpec.strutStyle?.fontSize, 16.0);
        expect(bodySpec.strutStyle?.height, 1.5);
        expect(bodySpec.strutStyle?.forceStrutHeight, true);
        expect(bodySpec.softWrap, true);
        expect(bodySpec.textAlign, TextAlign.justify);
      });

      test('creates responsive text spec', () {
        const responsiveSpec = TextSpec(
          textScaler: TextScaler.linear(1.2),
          textWidthBasis: TextWidthBasis.longestLine,
          textHeightBehavior: TextHeightBehavior(
            applyHeightToFirstAscent: false,
            applyHeightToLastDescent: false,
          ),
        );

        expect(responsiveSpec.textScaler, isA<TextScaler>());
        expect(responsiveSpec.textWidthBasis, TextWidthBasis.longestLine);
        expect(responsiveSpec.textHeightBehavior, isA<TextHeightBehavior>());
      });
    });
  });
}

/// Helper to extract progress from a test animated directive
double _extractProgress(SpecDirective<String> directive) {
  final result = switch (directive) {
    _TestAnimatedDirective() => directive.apply('', 1.0),
    AnimatedSpecDirective<String>() => directive.apply('', 0),
    _ => '',
  };
  final match = RegExp(r'\[([\d.]+)\]').firstMatch(result);

  return match != null ? double.parse(match.group(1)!) : 0.0;
}

/// Helper to extract progress from a typewriter directive
double _extractTypewriterProgress(SpecDirective<String> directive) {
  // For typewriter, we test by using a known string length
  const text = '0123456789'; // 10 characters
  final result = switch (directive) {
    AnimatedSpecDirective<String>() => directive.apply(text, 0),
    _ => text,
  };

  return result.length / text.length;
}

// Test helper: Basic AnimatedSpecDirective
class _TestAnimatedDirective extends AnimatedSpecDirective<String> {
  const _TestAnimatedDirective();

  @override
  String apply(String value, double progress) => '$value[$progress]';

  @override
  String get key => '_test_animated_directive';
}

// Test helper: Another AnimatedSpecDirective with different key
class _AnotherAnimatedDirective extends AnimatedSpecDirective<String> {
  const _AnotherAnimatedDirective();

  @override
  String apply(String value, double progress) => '$value[$progress]';

  @override
  String get key => '_another_animated_directive';
}
