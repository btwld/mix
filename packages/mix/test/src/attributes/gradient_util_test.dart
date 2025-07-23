import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  group('Gradient Utilities', () {
    group('GradientUtility', () {
      final utility = GradientUtility(UtilityTestAttribute.new);

      test('call() creates GradientMix', () {
        final gradientMix = LinearGradientMix.only(
          colors: const [Colors.red, Colors.blue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
        final attr = utility(gradientMix);
        expect(attr.value, isA<Prop<Mix<Gradient>>>());
      });

      test('as() creates GradientMix from LinearGradient', () {
        const gradient = LinearGradient(
          colors: [Colors.red, Colors.blue],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
        final attr = utility.as(gradient);
        expect(attr.value, isA<Prop<Mix<Gradient>>>());
      });

      test('as() creates GradientMix from RadialGradient', () {
        const gradient = RadialGradient(
          colors: [Colors.green, Colors.yellow],
          center: Alignment.center,
          radius: 0.5,
        );
        final attr = utility.as(gradient);
        expect(attr.value, isA<Prop<Mix<Gradient>>>());
      });

      test('as() creates GradientMix from SweepGradient', () {
        const gradient = SweepGradient(
          colors: [Colors.purple, Colors.orange],
          center: Alignment.center,
          startAngle: 0.0,
          endAngle: 6.28,
        );
        final attr = utility.as(gradient);
        expect(attr.value, isA<Prop<Mix<Gradient>>>());
      });

      group('Nested Utilities', () {
        test('linear provides access to LinearGradientUtility', () {
          final linearGradientMix = LinearGradientMix.only(
            colors: const [Colors.red, Colors.blue],
          );
          final attr = utility.linear(linearGradientMix);
          expect(attr.value, isA<Prop<Mix<Gradient>>>());
        });

        test('radial provides access to RadialGradientUtility', () {
          final radialGradientMix = RadialGradientMix.only(
            colors: const [Colors.green, Colors.yellow],
          );
          final attr = utility.radial(radialGradientMix);
          expect(attr.value, isA<Prop<Mix<Gradient>>>());
        });

        test('sweep provides access to SweepGradientUtility', () {
          final sweepGradientMix = SweepGradientMix.only(
            colors: const [Colors.purple, Colors.orange],
          );
          final attr = utility.sweep(sweepGradientMix);
          expect(attr.value, isA<Prop<Mix<Gradient>>>());
        });
      });

      test('token() creates gradient from token', () {
        const token = MixToken<Gradient>('test.gradient');
        final attr = utility.token(token);
        expect(attr.value, isA<Prop<Mix<Gradient>>>());
      });
    });

    group('LinearGradientUtility', () {
      final utility = LinearGradientUtility(UtilityTestAttribute.new);

      test('call() creates LinearGradientMix', () {
        final gradientMix = LinearGradientMix.only(
          colors: const [Colors.red, Colors.blue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.0, 1.0],
          tileMode: TileMode.clamp,
        );
        final attr = utility(gradientMix);
        expect(attr.value, isA<Prop<Mix<LinearGradient>>>());
      });

      test('as() creates LinearGradientMix from LinearGradient', () {
        const gradient = LinearGradient(
          colors: [Colors.red, Colors.blue],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 1.0],
          tileMode: TileMode.repeated,
        );
        final attr = utility.as(gradient);
        expect(attr.value, isA<Prop<Mix<LinearGradient>>>());
      });

      group('Property Utilities', () {
        test('colors() creates linear gradient with colors', () {
          final attr = utility.colors([Colors.red, Colors.blue, Colors.green]);
          expect(attr.value, isA<Prop<Mix<LinearGradient>>>());
        });

        test('stops() creates linear gradient with stops', () {
          final attr = utility.stops([0.0, 0.5, 1.0]);
          expect(attr.value, isA<Prop<Mix<LinearGradient>>>());
        });

        test('begin() creates linear gradient with begin alignment', () {
          final attr = utility.begin(Alignment.topLeft);
          expect(attr.value, isA<Prop<Mix<LinearGradient>>>());
        });

        test('begin.topLeft() creates linear gradient with top left begin', () {
          final attr = utility.begin.topLeft();
          expect(attr.value, isA<Prop<Mix<LinearGradient>>>());
        });

        test('begin.center() creates linear gradient with center begin', () {
          final attr = utility.begin.center();
          expect(attr.value, isA<Prop<Mix<LinearGradient>>>());
        });

        test('end() creates linear gradient with end alignment', () {
          final attr = utility.end(Alignment.bottomRight);
          expect(attr.value, isA<Prop<Mix<LinearGradient>>>());
        });

        test(
          'end.bottomRight() creates linear gradient with bottom right end',
          () {
            final attr = utility.end.bottomRight();
            expect(attr.value, isA<Prop<Mix<LinearGradient>>>());
          },
        );

        test(
          'end.centerLeft() creates linear gradient with center left end',
          () {
            final attr = utility.end.centerLeft();
            expect(attr.value, isA<Prop<Mix<LinearGradient>>>());
          },
        );

        test('tileMode() creates linear gradient with tile mode', () {
          final attr = utility.tileMode(TileMode.mirror);
          expect(attr.value, isA<Prop<Mix<LinearGradient>>>());
        });

        test(
          'tileMode.clamp() creates linear gradient with clamp tile mode',
          () {
            final attr = utility.tileMode.clamp();
            expect(attr.value, isA<Prop<Mix<LinearGradient>>>());
          },
        );

        test(
          'tileMode.repeated() creates linear gradient with repeated tile mode',
          () {
            final attr = utility.tileMode.repeated();
            expect(attr.value, isA<Prop<Mix<LinearGradient>>>());
          },
        );

        test(
          'tileMode.mirror() creates linear gradient with mirror tile mode',
          () {
            final attr = utility.tileMode.mirror();
            expect(attr.value, isA<Prop<Mix<LinearGradient>>>());
          },
        );

        test(
          'tileMode.decal() creates linear gradient with decal tile mode',
          () {
            final attr = utility.tileMode.decal();
            expect(attr.value, isA<Prop<Mix<LinearGradient>>>());
          },
        );

        test('transform() creates linear gradient with transform', () {
          final attr = utility.transform(const GradientRotation(1.57));
          expect(attr.value, isA<Prop<Mix<LinearGradient>>>());
        });

        test(
          'transform.rotate() creates linear gradient with rotation transform',
          () {
            final attr = utility.transform.rotate(1.57);
            expect(attr.value, isA<Prop<Mix<LinearGradient>>>());
          },
        );
      });

      test('token() creates linear gradient from token', () {
        const token = MixToken<LinearGradient>('test.linearGradient');
        final attr = utility.token(token);
        expect(attr.value, isA<Prop<Mix<LinearGradient>>>());
      });
    });

    group('RadialGradientUtility', () {
      final utility = RadialGradientUtility(UtilityTestAttribute.new);

      test('call() creates RadialGradientMix', () {
        final gradientMix = RadialGradientMix.only(
          colors: const [Colors.red, Colors.blue],
          center: Alignment.center,
          radius: 0.5,
          focal: Alignment.topLeft,
          focalRadius: 0.1,
          stops: const [0.0, 1.0],
          tileMode: TileMode.clamp,
        );
        final attr = utility(gradientMix);
        expect(attr.value, isA<Prop<Mix<RadialGradient>>>());
      });

      test('as() creates RadialGradientMix from RadialGradient', () {
        const gradient = RadialGradient(
          colors: [Colors.green, Colors.yellow],
          center: Alignment.center,
          radius: 0.8,
          focal: Alignment.bottomRight,
          focalRadius: 0.2,
          stops: [0.0, 1.0],
          tileMode: TileMode.mirror,
        );
        final attr = utility.as(gradient);
        expect(attr.value, isA<Prop<Mix<RadialGradient>>>());
      });

      group('Property Utilities', () {
        test('colors() creates radial gradient with colors', () {
          final attr = utility.colors([
            Colors.purple,
            Colors.pink,
            Colors.orange,
          ]);
          expect(attr.value, isA<Prop<Mix<RadialGradient>>>());
        });

        test('stops() creates radial gradient with stops', () {
          final attr = utility.stops([0.0, 0.3, 1.0]);
          expect(attr.value, isA<Prop<Mix<RadialGradient>>>());
        });

        test('center() creates radial gradient with center alignment', () {
          final attr = utility.center(Alignment.topCenter);
          expect(attr.value, isA<Prop<Mix<RadialGradient>>>());
        });

        test(
          'center.center() creates radial gradient with center alignment',
          () {
            final attr = utility.center.center();
            expect(attr.value, isA<Prop<Mix<RadialGradient>>>());
          },
        );

        test(
          'center.bottomLeft() creates radial gradient with bottom left center',
          () {
            final attr = utility.center.bottomLeft();
            expect(attr.value, isA<Prop<Mix<RadialGradient>>>());
          },
        );

        test('radius() creates radial gradient with radius', () {
          final attr = utility.radius(0.7);
          expect(attr.value, isA<Prop<Mix<RadialGradient>>>());
        });

        test('radius.zero() creates radial gradient with zero radius', () {
          final attr = utility.radius.zero();
          expect(attr.value, isA<Prop<Mix<RadialGradient>>>());
        });

        test(
          'radius.infinity() creates radial gradient with infinite radius',
          () {
            final attr = utility.radius.infinity();
            expect(attr.value, isA<Prop<Mix<RadialGradient>>>());
          },
        );

        test('focal() creates radial gradient with focal alignment', () {
          final attr = utility.focal(Alignment.topRight);
          expect(attr.value, isA<Prop<Mix<RadialGradient>>>());
        });

        test(
          'focal.topRight() creates radial gradient with top right focal',
          () {
            final attr = utility.focal.topRight();
            expect(attr.value, isA<Prop<Mix<RadialGradient>>>());
          },
        );

        test('focalRadius() creates radial gradient with focal radius', () {
          final attr = utility.focalRadius(0.3);
          expect(attr.value, isA<Prop<Mix<RadialGradient>>>());
        });

        test(
          'focalRadius.zero() creates radial gradient with zero focal radius',
          () {
            final attr = utility.focalRadius.zero();
            expect(attr.value, isA<Prop<Mix<RadialGradient>>>());
          },
        );

        test('tileMode() creates radial gradient with tile mode', () {
          final attr = utility.tileMode(TileMode.decal);
          expect(attr.value, isA<Prop<Mix<RadialGradient>>>());
        });

        test(
          'tileMode.mirror() creates radial gradient with mirror tile mode',
          () {
            final attr = utility.tileMode.mirror();
            expect(attr.value, isA<Prop<Mix<RadialGradient>>>());
          },
        );

        test('transform() creates radial gradient with transform', () {
          final attr = utility.transform(const GradientRotation(3.14));
          expect(attr.value, isA<Prop<Mix<RadialGradient>>>());
        });

        test(
          'transform.rotate() creates radial gradient with rotation transform',
          () {
            final attr = utility.transform.rotate(3.14);
            expect(attr.value, isA<Prop<Mix<RadialGradient>>>());
          },
        );
      });

      test('token() creates radial gradient from token', () {
        const token = MixToken<RadialGradient>('test.radialGradient');
        final attr = utility.token(token);
        expect(attr.value, isA<Prop<Mix<RadialGradient>>>());
      });
    });

    group('SweepGradientUtility', () {
      final utility = SweepGradientUtility(UtilityTestAttribute.new);

      test('call() creates SweepGradientMix', () {
        final gradientMix = SweepGradientMix.only(
          colors: const [Colors.red, Colors.blue, Colors.green],
          center: Alignment.center,
          startAngle: 0.0,
          endAngle: 6.28,
          stops: const [0.0, 0.5, 1.0],
          tileMode: TileMode.clamp,
        );
        final attr = utility(gradientMix);
        expect(attr.value, isA<Prop<Mix<SweepGradient>>>());
      });

      test('as() creates SweepGradientMix from SweepGradient', () {
        const gradient = SweepGradient(
          colors: [Colors.purple, Colors.orange, Colors.pink],
          center: Alignment.bottomCenter,
          startAngle: 1.57,
          endAngle: 4.71,
          stops: [0.0, 0.3, 1.0],
          tileMode: TileMode.repeated,
        );
        final attr = utility.as(gradient);
        expect(attr.value, isA<Prop<Mix<SweepGradient>>>());
      });

      group('Property Utilities', () {
        test('colors() creates sweep gradient with colors', () {
          final attr = utility.colors([
            Colors.cyan,
            Colors.purple,
            Colors.yellow,
          ]);
          expect(attr.value, isA<Prop<Mix<SweepGradient>>>());
        });

        test('stops() creates sweep gradient with stops', () {
          final attr = utility.stops([0.0, 0.25, 0.75, 1.0]);
          expect(attr.value, isA<Prop<Mix<SweepGradient>>>());
        });

        test('center() creates sweep gradient with center alignment', () {
          final attr = utility.center(Alignment.centerRight);
          expect(attr.value, isA<Prop<Mix<SweepGradient>>>());
        });

        test(
          'center.centerRight() creates sweep gradient with center right alignment',
          () {
            final attr = utility.center.centerRight();
            expect(attr.value, isA<Prop<Mix<SweepGradient>>>());
          },
        );

        test('startAngle() creates sweep gradient with start angle', () {
          final attr = utility.startAngle(1.57);
          expect(attr.value, isA<Prop<Mix<SweepGradient>>>());
        });

        test(
          'startAngle.zero() creates sweep gradient with zero start angle',
          () {
            final attr = utility.startAngle.zero();
            expect(attr.value, isA<Prop<Mix<SweepGradient>>>());
          },
        );

        test('endAngle() creates sweep gradient with end angle', () {
          final attr = utility.endAngle(4.71);
          expect(attr.value, isA<Prop<Mix<SweepGradient>>>());
        });

        test(
          'endAngle.infinity() creates sweep gradient with infinite end angle',
          () {
            final attr = utility.endAngle.infinity();
            expect(attr.value, isA<Prop<Mix<SweepGradient>>>());
          },
        );

        test('tileMode() creates sweep gradient with tile mode', () {
          final attr = utility.tileMode(TileMode.repeated);
          expect(attr.value, isA<Prop<Mix<SweepGradient>>>());
        });

        test(
          'tileMode.decal() creates sweep gradient with decal tile mode',
          () {
            final attr = utility.tileMode.decal();
            expect(attr.value, isA<Prop<Mix<SweepGradient>>>());
          },
        );

        test('transform() creates sweep gradient with transform', () {
          final attr = utility.transform(const GradientRotation(0.785));
          expect(attr.value, isA<Prop<Mix<SweepGradient>>>());
        });

        test(
          'transform.rotate() creates sweep gradient with rotation transform',
          () {
            final attr = utility.transform.rotate(0.785);
            expect(attr.value, isA<Prop<Mix<SweepGradient>>>());
          },
        );
      });

      test('token() creates sweep gradient from token', () {
        const token = MixToken<SweepGradient>('test.sweepGradient');
        final attr = utility.token(token);
        expect(attr.value, isA<Prop<Mix<SweepGradient>>>());
      });
    });
  });
}
