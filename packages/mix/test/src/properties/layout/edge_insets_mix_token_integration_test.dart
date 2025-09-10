import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix/src/theme/tokens/space_token.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('EdgeInsetsMix Token Integration', () {
    late SpaceToken smallSpace;
    late SpaceToken mediumSpace;
    late SpaceToken largeSpace;
    late SpaceToken extraLargeSpace;
    late MockBuildContext context;

    setUp(() {
      // Create test tokens
      smallSpace = SpaceToken('space.small');
      mediumSpace = SpaceToken('space.medium');
      largeSpace = SpaceToken('space.large');
      extraLargeSpace = SpaceToken('space.extra-large');

      // Create context with token values
      context = MockBuildContext(
        tokens: {
          smallSpace: 8.0,
          mediumSpace: 16.0,
          largeSpace: 24.0,
          extraLargeSpace: 32.0,
        },
      );
    });

    group('Token Call Resolution', () {
      test('spaceToken() creates DoubleRef that implements double', () {
        final tokenCall = smallSpace();
        
        expect(tokenCall, isA<double>());
        expect(isAnyTokenRef(tokenCall), isTrue);
      });

      test('raw spaceToken does not implement double', () {
        expect(smallSpace is double, isFalse);
        expect(smallSpace, isA<SpaceToken>());
      });
    });

    group('Main Constructor', () {
      test('accepts spaceToken() calls for all parameters', () {
        final mix = EdgeInsetsMix(
          top: smallSpace(),
          bottom: mediumSpace(),
          left: largeSpace(),
          right: extraLargeSpace(),
        );

        // Verify token detection in Props
        expect(mix.$top, PropMatcher.hasTokens);
        expect(mix.$bottom, PropMatcher.hasTokens);
        expect(mix.$left, PropMatcher.hasTokens);
        expect(mix.$right, PropMatcher.hasTokens);

        expect(mix.$top, PropMatcher.isToken(smallSpace));
        expect(mix.$bottom, PropMatcher.isToken(mediumSpace));
        expect(mix.$left, PropMatcher.isToken(largeSpace));
        expect(mix.$right, PropMatcher.isToken(extraLargeSpace));
      });

      test('resolves tokens correctly through MixScope', () {
        final mix = EdgeInsetsMix(
          top: smallSpace(),
          bottom: mediumSpace(),
          left: largeSpace(),
          right: extraLargeSpace(),
        );

        expect(
          mix,
          resolvesTo(
            EdgeInsets.fromLTRB(24.0, 8.0, 32.0, 16.0),
            context: context,
          ),
        );
      });

      test('mixing tokens and direct values works', () {
        final mix = EdgeInsetsMix(
          top: smallSpace(),  // 8.0 from token
          bottom: 12.0,       // direct value
          left: mediumSpace(), // 16.0 from token
          right: 20.0,        // direct value
        );

        expect(mix.$top, PropMatcher.hasTokens);
        expect(mix.$bottom, PropMatcher.hasValues);
        expect(mix.$left, PropMatcher.hasTokens);
        expect(mix.$right, PropMatcher.hasValues);

        expect(
          mix,
          resolvesTo(
            EdgeInsets.fromLTRB(16.0, 8.0, 20.0, 12.0),
            context: context,
          ),
        );
      });
    });

    group('Instance Factory Constructors', () {
      test('all() constructor works with token calls', () {
        final mix = EdgeInsetsMix.all(mediumSpace());

        expect(mix.$top, PropMatcher.isToken(mediumSpace));
        expect(mix.$bottom, PropMatcher.isToken(mediumSpace));
        expect(mix.$left, PropMatcher.isToken(mediumSpace));
        expect(mix.$right, PropMatcher.isToken(mediumSpace));

        expect(
          mix,
          resolvesTo(EdgeInsets.all(16.0), context: context),
        );
      });

      test('symmetric() constructor works with token calls', () {
        final mix = EdgeInsetsMix.symmetric(
          vertical: smallSpace(),
          horizontal: largeSpace(),
        );

        expect(mix.$top, PropMatcher.isToken(smallSpace));
        expect(mix.$bottom, PropMatcher.isToken(smallSpace));
        expect(mix.$left, PropMatcher.isToken(largeSpace));
        expect(mix.$right, PropMatcher.isToken(largeSpace));

        expect(
          mix,
          resolvesTo(
            EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
            context: context,
          ),
        );
      });

      test('horizontal() constructor works with token calls', () {
        final mix = EdgeInsetsMix.horizontal(mediumSpace());

        expect(mix.$left, PropMatcher.isToken(mediumSpace));
        expect(mix.$right, PropMatcher.isToken(mediumSpace));
        expect(mix.$top, isNull);
        expect(mix.$bottom, isNull);

        expect(
          mix,
          resolvesTo(EdgeInsets.symmetric(horizontal: 16.0), context: context),
        );
      });

      test('vertical() constructor works with token calls', () {
        final mix = EdgeInsetsMix.vertical(largeSpace());

        expect(mix.$top, PropMatcher.isToken(largeSpace));
        expect(mix.$bottom, PropMatcher.isToken(largeSpace));
        expect(mix.$left, isNull);
        expect(mix.$right, isNull);

        expect(
          mix,
          resolvesTo(EdgeInsets.symmetric(vertical: 24.0), context: context),
        );
      });

      test('fromLTRB() constructor works with token calls', () {
        final mix = EdgeInsetsMix.fromLTRB(
          smallSpace(),     // left: 8.0
          mediumSpace(),    // top: 16.0
          largeSpace(),     // right: 24.0
          extraLargeSpace(), // bottom: 32.0
        );

        expect(mix.$left, PropMatcher.isToken(smallSpace));
        expect(mix.$top, PropMatcher.isToken(mediumSpace));
        expect(mix.$right, PropMatcher.isToken(largeSpace));
        expect(mix.$bottom, PropMatcher.isToken(extraLargeSpace));

        expect(
          mix,
          resolvesTo(
            EdgeInsets.fromLTRB(8.0, 16.0, 24.0, 32.0),
            context: context,
          ),
        );
      });
    });

    group('Static Factory Methods', () {
      test('static all() works with token calls', () {
        final mix = EdgeInsetsGeometryMix.all(mediumSpace());

        expect(mix, isA<EdgeInsetsMix>());
        expect((mix).$top, PropMatcher.isToken(mediumSpace));
        expect(
          mix,
          resolvesTo(EdgeInsets.all(16.0), context: context),
        );
      });

      test('static only() works with token calls', () {
        final mix = EdgeInsetsGeometryMix.only(
          top: smallSpace(),
          left: mediumSpace(),
          right: largeSpace(),
          bottom: extraLargeSpace(),
        );

        expect(mix, isA<EdgeInsetsMix>());
        final edgeMix = mix;
        expect(edgeMix.$top, PropMatcher.isToken(smallSpace));
        expect(edgeMix.$left, PropMatcher.isToken(mediumSpace));
        expect(edgeMix.$right, PropMatcher.isToken(largeSpace));
        expect(edgeMix.$bottom, PropMatcher.isToken(extraLargeSpace));

        expect(
          mix,
          resolvesTo(
            EdgeInsets.only(top: 8.0, left: 16.0, right: 24.0, bottom: 32.0),
            context: context,
          ),
        );
      });

      test('static horizontal() works with token calls', () {
        final mix = EdgeInsetsGeometryMix.horizontal(largeSpace());

        expect(mix, isA<EdgeInsetsMix>());
        expect(
          mix,
          resolvesTo(EdgeInsets.symmetric(horizontal: 24.0), context: context),
        );
      });

      test('static vertical() works with token calls', () {
        final mix = EdgeInsetsGeometryMix.vertical(smallSpace());

        expect(mix, isA<EdgeInsetsMix>());
        expect(
          mix,
          resolvesTo(EdgeInsets.symmetric(vertical: 8.0), context: context),
        );
      });

      test('static symmetric() works with token calls', () {
        final mix = EdgeInsetsGeometryMix.symmetric(
          vertical: mediumSpace(),
          horizontal: largeSpace(),
        );

        expect(mix, isA<EdgeInsetsMix>());
        expect(
          mix,
          resolvesTo(
            EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
            context: context,
          ),
        );
      });

      test('static fromLTRB() works with token calls', () {
        final mix = EdgeInsetsGeometryMix.fromLTRB(
          smallSpace(),     // left: 8.0
          mediumSpace(),    // top: 16.0  
          largeSpace(),     // right: 24.0
          extraLargeSpace(), // bottom: 32.0
        );

        expect(mix, isA<EdgeInsetsMix>());
        expect(
          mix,
          resolvesTo(
            EdgeInsets.fromLTRB(8.0, 16.0, 24.0, 32.0),
            context: context,
          ),
        );
      });

      test('static individual edge methods work with token calls', () {
        final topMix = EdgeInsetsGeometryMix.top(smallSpace());
        final bottomMix = EdgeInsetsGeometryMix.bottom(mediumSpace());
        final leftMix = EdgeInsetsGeometryMix.left(largeSpace());
        final rightMix = EdgeInsetsGeometryMix.right(extraLargeSpace());

        expect(topMix, resolvesTo(EdgeInsets.only(top: 8.0), context: context));
        expect(bottomMix, resolvesTo(EdgeInsets.only(bottom: 16.0), context: context));
        expect(leftMix, resolvesTo(EdgeInsets.only(left: 24.0), context: context));
        expect(rightMix, resolvesTo(EdgeInsets.only(right: 32.0), context: context));
      });
    });

    group('Instance Fluent Methods', () {
      test('instance methods work with token calls', () {
        final baseMix = EdgeInsetsMix(top: 4.0); // Start with some value

        final topMix = baseMix.top(smallSpace());
        expect(topMix.$top, PropMatcher.isToken(smallSpace));
        expect(
          topMix,
          resolvesTo(EdgeInsets.only(top: 8.0), context: context),
        );

        final bottomMix = baseMix.bottom(mediumSpace());
        expect(bottomMix.$bottom, PropMatcher.isToken(mediumSpace));
        expect(
          bottomMix,
          resolvesTo(EdgeInsets.only(top: 4.0, bottom: 16.0), context: context),
        );

        final leftMix = baseMix.left(largeSpace());
        expect(leftMix.$left, PropMatcher.isToken(largeSpace));
        expect(
          leftMix,
          resolvesTo(EdgeInsets.only(top: 4.0, left: 24.0), context: context),
        );

        final rightMix = baseMix.right(extraLargeSpace());
        expect(rightMix.$right, PropMatcher.isToken(extraLargeSpace));
        expect(
          rightMix,
          resolvesTo(EdgeInsets.only(top: 4.0, right: 32.0), context: context),
        );
      });

      test('chainable instance methods work with token calls', () {
        final mix = EdgeInsetsMix()
            .top(smallSpace())
            .left(mediumSpace())
            .bottom(largeSpace())
            .right(extraLargeSpace());

        expect(mix.$top, PropMatcher.isToken(smallSpace));
        expect(mix.$left, PropMatcher.isToken(mediumSpace));
        expect(mix.$bottom, PropMatcher.isToken(largeSpace));
        expect(mix.$right, PropMatcher.isToken(extraLargeSpace));

        expect(
          mix,
          resolvesTo(
            EdgeInsets.fromLTRB(16.0, 8.0, 32.0, 24.0),
            context: context,
          ),
        );
      });

      test('symmetric() instance method works with token calls', () {
        final mix = EdgeInsetsMix().symmetric(
          vertical: smallSpace(),
          horizontal: largeSpace(),
        );

        expect(
          mix,
          resolvesTo(
            EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
            context: context,
          ),
        );
      });

      test('only() instance method works with token calls', () {
        final mix = EdgeInsetsMix().only(
          top: smallSpace(),
          left: mediumSpace(),
          right: largeSpace(),
          bottom: extraLargeSpace(),
        );

        expect(
          mix,
          resolvesTo(
            EdgeInsets.only(top: 8.0, left: 16.0, right: 24.0, bottom: 32.0),
            context: context,
          ),
        );
      });
    });

    group('Merge Behavior', () {
      test('merging EdgeInsetsMix with tokens preserves token references', () {
        final mix1 = EdgeInsetsMix(top: smallSpace(), left: mediumSpace());
        final mix2 = EdgeInsetsMix(bottom: largeSpace(), right: extraLargeSpace());

        final merged = mix1.merge(mix2);

        expect(merged.$top, PropMatcher.isToken(smallSpace));
        expect(merged.$left, PropMatcher.isToken(mediumSpace));
        expect(merged.$bottom, PropMatcher.isToken(largeSpace));
        expect(merged.$right, PropMatcher.isToken(extraLargeSpace));

        expect(
          merged,
          resolvesTo(
            EdgeInsets.fromLTRB(16.0, 8.0, 32.0, 24.0),
            context: context,
          ),
        );
      });

      test('last token wins when merging same property', () {
        final mix1 = EdgeInsetsMix(top: smallSpace());
        final mix2 = EdgeInsetsMix(top: largeSpace());

        final merged = mix1.merge(mix2);

        // After merging, the Prop will have both token sources
        expect(merged.$top, PropMatcher.hasTokens);
        // But during resolution, the last token (largeSpace) should win
        expect(
          merged,
          resolvesTo(EdgeInsets.only(top: 24.0), context: context),
        );
      });

      test('mixing token and direct value resolution', () {
        final tokenMix = EdgeInsetsMix(top: smallSpace());
        final valueMix = EdgeInsetsMix(top: 20.0);

        final merged = tokenMix.merge(valueMix);

        // Should have both sources, with direct value winning in resolution
        expect(
          merged,
          resolvesTo(EdgeInsets.only(top: 20.0), context: context),
        );
      });
    });

    group('Error Handling', () {
      test('missing token in scope throws error', () {
        final missingToken = SpaceToken('missing.token');
        final mix = EdgeInsetsMix(top: missingToken());

        expect(
          () => mix.resolve(context),
          throwsStateError,
        );
      });

      test('wrong parameter types are rejected', () {
        // These should fail at the type level in real usage
        // but we can't easily test compile-time errors in unit tests
        // The important thing is that spaceToken() works, not spaceToken
        final validMix = EdgeInsetsMix(top: smallSpace()); // ✅ This works
        expect(validMix, isA<EdgeInsetsMix>());

        // We can't test: EdgeInsetsMix(top: smallSpace) // ❌ Compile error
        // That's the whole point - it won't compile
      });
    });
  });

  group('EdgeInsetsDirectionalMix Token Integration', () {
    late SpaceToken smallSpace;
    late SpaceToken mediumSpace;
    late SpaceToken largeSpace;
    late SpaceToken extraLargeSpace;
    late MockBuildContext context;

    setUp(() {
      smallSpace = SpaceToken('space.small');
      mediumSpace = SpaceToken('space.medium');
      largeSpace = SpaceToken('space.large');
      extraLargeSpace = SpaceToken('space.extra-large');

      context = MockBuildContext(
        tokens: {
          smallSpace: 8.0,
          mediumSpace: 16.0,
          largeSpace: 24.0,
          extraLargeSpace: 32.0,
        },
      );
    });

    group('Main Constructor', () {
      test('accepts spaceToken() calls for all parameters', () {
        final mix = EdgeInsetsDirectionalMix(
          top: smallSpace(),
          bottom: mediumSpace(),
          start: largeSpace(),
          end: extraLargeSpace(),
        );

        expect(mix.$top, PropMatcher.isToken(smallSpace));
        expect(mix.$bottom, PropMatcher.isToken(mediumSpace));
        expect(mix.$start, PropMatcher.isToken(largeSpace));
        expect(mix.$end, PropMatcher.isToken(extraLargeSpace));

        expect(
          mix,
          resolvesTo(
            EdgeInsetsDirectional.fromSTEB(24.0, 8.0, 32.0, 16.0),
            context: context,
          ),
        );
      });
    });

    group('Instance Factory Constructors', () {
      test('all() constructor works with token calls', () {
        final mix = EdgeInsetsDirectionalMix.all(mediumSpace());

        expect(mix.$top, PropMatcher.isToken(mediumSpace));
        expect(mix.$bottom, PropMatcher.isToken(mediumSpace));
        expect(mix.$start, PropMatcher.isToken(mediumSpace));
        expect(mix.$end, PropMatcher.isToken(mediumSpace));

        expect(
          mix,
          resolvesTo(EdgeInsetsDirectional.all(16.0), context: context),
        );
      });

      test('symmetric() constructor works with token calls', () {
        final mix = EdgeInsetsDirectionalMix.symmetric(
          vertical: smallSpace(),
          horizontal: largeSpace(),
        );

        expect(
          mix,
          resolvesTo(
            EdgeInsetsDirectional.symmetric(vertical: 8.0, horizontal: 24.0),
            context: context,
          ),
        );
      });

      test('fromSTEB() constructor works with token calls', () {
        final mix = EdgeInsetsDirectionalMix.fromSTEB(
          smallSpace(),     // start: 8.0
          mediumSpace(),    // top: 16.0
          largeSpace(),     // end: 24.0
          extraLargeSpace(), // bottom: 32.0
        );

        expect(mix.$start, PropMatcher.isToken(smallSpace));
        expect(mix.$top, PropMatcher.isToken(mediumSpace));
        expect(mix.$end, PropMatcher.isToken(largeSpace));
        expect(mix.$bottom, PropMatcher.isToken(extraLargeSpace));

        expect(
          mix,
          resolvesTo(
            EdgeInsetsDirectional.fromSTEB(8.0, 16.0, 24.0, 32.0),
            context: context,
          ),
        );
      });
    });

    group('Static Factory Methods', () {
      test('static directional() works with token calls', () {
        final mix = EdgeInsetsGeometryMix.directional(
          start: smallSpace(),
          top: mediumSpace(),
          end: largeSpace(),
          bottom: extraLargeSpace(),
        );

        expect(mix, isA<EdgeInsetsDirectionalMix>());
        expect(
          mix,
          resolvesTo(
            EdgeInsetsDirectional.only(start: 8.0, top: 16.0, end: 24.0, bottom: 32.0),
            context: context,
          ),
        );
      });

      test('static fromSTEB() works with token calls', () {
        final mix = EdgeInsetsGeometryMix.fromSTEB(
          smallSpace(),     // start: 8.0
          mediumSpace(),    // top: 16.0
          largeSpace(),     // end: 24.0
          extraLargeSpace(), // bottom: 32.0
        );

        expect(mix, isA<EdgeInsetsDirectionalMix>());
        expect(
          mix,
          resolvesTo(
            EdgeInsetsDirectional.fromSTEB(8.0, 16.0, 24.0, 32.0),
            context: context,
          ),
        );
      });

      test('static start() and end() work with token calls', () {
        final startMix = EdgeInsetsGeometryMix.start(smallSpace());
        final endMix = EdgeInsetsGeometryMix.end(mediumSpace());

        expect(startMix, isA<EdgeInsetsDirectionalMix>());
        expect(endMix, isA<EdgeInsetsDirectionalMix>());

        expect(
          startMix,
          resolvesTo(EdgeInsetsDirectional.only(start: 8.0), context: context),
        );
        expect(
          endMix,
          resolvesTo(EdgeInsetsDirectional.only(end: 16.0), context: context),
        );
      });
    });

    group('Instance Fluent Methods', () {
      test('directional() instance method works with token calls', () {
        final mix = EdgeInsetsDirectionalMix().directional(
          start: smallSpace(),
          top: mediumSpace(),
          end: largeSpace(),
          bottom: extraLargeSpace(),
        );

        expect(
          mix,
          resolvesTo(
            EdgeInsetsDirectional.only(start: 8.0, top: 16.0, end: 24.0, bottom: 32.0),
            context: context,
          ),
        );
      });

      test('start() and end() instance methods work with token calls', () {
        final baseMix = EdgeInsetsDirectionalMix();

        final startMix = baseMix.start(smallSpace());
        expect(startMix.$start, PropMatcher.isToken(smallSpace));
        expect(
          startMix,
          resolvesTo(EdgeInsetsDirectional.only(start: 8.0), context: context),
        );

        final endMix = baseMix.end(mediumSpace());
        expect(endMix.$end, PropMatcher.isToken(mediumSpace));
        expect(
          endMix,
          resolvesTo(EdgeInsetsDirectional.only(end: 16.0), context: context),
        );
      });
    });
  });
}