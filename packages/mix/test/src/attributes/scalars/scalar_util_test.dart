import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('StackFitUtility Tests', () {
    const utility = StackFitUtility(UtilityTestAttribute.new);
    test('Properties are initialized correctly', () {
      expect(utility.loose().value, isA<StackFit>());
      expect(utility.expand().value, isA<StackFit>());
      expect(utility.passthrough().value, isA<StackFit>());
      expect(utility.loose().value, StackFit.loose);
      expect(utility.expand().value, StackFit.expand);
      expect(utility.passthrough().value, StackFit.passthrough);
    });
  });

  group('ClipUtility Tests', () {
    const utility = ClipUtility(UtilityTestAttribute.new);
    test('Properties are initialized correctly', () {
      expect(utility.none().value, isA<Clip>());
      expect(utility.hardEdge().value, isA<Clip>());
      expect(utility.antiAlias().value, isA<Clip>());
      expect(utility.antiAliasWithSaveLayer().value, isA<Clip>());
      expect(utility.none().value, Clip.none);
      expect(utility.hardEdge().value, Clip.hardEdge);
      expect(utility.antiAlias().value, Clip.antiAlias);
      expect(
        utility.antiAliasWithSaveLayer().value,
        Clip.antiAliasWithSaveLayer,
      );
    });
  });

  group('VerticalDirectionUtility Tests', () {
    const utility = VerticalDirectionUtility(UtilityTestAttribute.new);
    test('Properties are initialized correctly', () {
      expect(utility.up().value, isA<VerticalDirection>());
      expect(utility.down().value, isA<VerticalDirection>());
      expect(utility.up().value, VerticalDirection.up);
      expect(utility.down().value, VerticalDirection.down);
    });
  });

  group('TextOverflowUtility Tests', () {
    const utility = TextOverflowUtility(UtilityTestAttribute.new);
    test('Properties are initialized correctly', () {
      expect(utility.clip().value, isA<TextOverflow>());
      expect(utility.ellipsis().value, isA<TextOverflow>());
      expect(utility.fade().value, isA<TextOverflow>());
      expect(utility.clip().value, TextOverflow.clip);
      expect(utility.ellipsis().value, TextOverflow.ellipsis);
      expect(utility.fade().value, TextOverflow.fade);
    });
  });

  group('TextWidthBasisUtility Tests', () {
    const utility = TextWidthBasisUtility(UtilityTestAttribute.new);
    test('Properties are initialized correctly', () {
      expect(utility.parent().value, isA<TextWidthBasis>());
      expect(utility.longestLine().value, isA<TextWidthBasis>());
      expect(utility.parent().value, TextWidthBasis.parent);
      expect(utility.longestLine().value, TextWidthBasis.longestLine);
    });
  });

  group('TextAlignUtility Tests', () {
    const utility = TextAlignUtility(UtilityTestAttribute.new);
    test('Properties are initialized correctly', () {
      expect(utility.left().value, isA<TextAlign>());
      expect(utility.right().value, isA<TextAlign>());
      expect(utility.center().value, isA<TextAlign>());
      expect(utility.justify().value, isA<TextAlign>());
      expect(utility.start().value, isA<TextAlign>());
      expect(utility.end().value, isA<TextAlign>());
      expect(utility.left().value, TextAlign.left);
      expect(utility.right().value, TextAlign.right);
      expect(utility.center().value, TextAlign.center);
      expect(utility.justify().value, TextAlign.justify);
      expect(utility.start().value, TextAlign.start);
      expect(utility.end().value, TextAlign.end);
    });
  });

  group('FlexFitUtility Tests', () {
    const utility = FlexFitUtility(UtilityTestAttribute.new);
    test('Properties are initialized correctly', () {
      expect(utility.tight().value, isA<FlexFit>());
      expect(utility.loose().value, isA<FlexFit>());
      expect(utility.tight().value, FlexFit.tight);
      expect(utility.loose().value, FlexFit.loose);
    });
  });

  group('AxisUtility Tests', () {
    const utility = AxisUtility(UtilityTestAttribute.new);
    test('Properties are initialized correctly', () {
      expect(utility.horizontal().value, isA<Axis>());
      expect(utility.vertical().value, isA<Axis>());
      expect(utility.horizontal().value, Axis.horizontal);
      expect(utility.vertical().value, Axis.vertical);
    });
  });

  group('MainAxisAlignmentUtility Tests', () {
    const utility = MainAxisAlignmentUtility(UtilityTestAttribute.new);
    test('Properties are initialized correctly', () {
      expect(utility.start().value, isA<MainAxisAlignment>());
      expect(utility.end().value, isA<MainAxisAlignment>());
      expect(utility.center().value, isA<MainAxisAlignment>());
      expect(utility.spaceBetween().value, isA<MainAxisAlignment>());
      expect(utility.spaceAround().value, isA<MainAxisAlignment>());
      expect(utility.spaceEvenly().value, isA<MainAxisAlignment>());
      expect(utility.start().value, MainAxisAlignment.start);
      expect(utility.end().value, MainAxisAlignment.end);
      expect(utility.center().value, MainAxisAlignment.center);
      expect(utility.spaceBetween().value, MainAxisAlignment.spaceBetween);
      expect(utility.spaceAround().value, MainAxisAlignment.spaceAround);
      expect(utility.spaceEvenly().value, MainAxisAlignment.spaceEvenly);
    });
  });

  group('CrossAxisAlignmentUtility Tests', () {
    const utility = CrossAxisAlignmentUtility(UtilityTestAttribute.new);
    test('Properties are initialized correctly', () {
      expect(utility.start().value, isA<CrossAxisAlignment>());
      expect(utility.end().value, isA<CrossAxisAlignment>());
      expect(utility.center().value, isA<CrossAxisAlignment>());
      expect(utility.stretch().value, isA<CrossAxisAlignment>());
      expect(utility.baseline().value, isA<CrossAxisAlignment>());
      expect(utility.start().value, CrossAxisAlignment.start);
      expect(utility.end().value, CrossAxisAlignment.end);
      expect(utility.center().value, CrossAxisAlignment.center);
      expect(utility.stretch().value, CrossAxisAlignment.stretch);
      expect(utility.baseline().value, CrossAxisAlignment.baseline);
    });
  });

  group('MainAxisSizeUtility Tests', () {
    const utility = MainAxisSizeUtility(UtilityTestAttribute.new);
    test('Properties are initialized correctly', () {
      expect(utility.min().value, isA<MainAxisSize>());
      expect(utility.max().value, isA<MainAxisSize>());
      expect(utility.min().value, MainAxisSize.min);
      expect(utility.max().value, MainAxisSize.max);
    });
  });

  group('TextBaselineUtility Tests', () {
    const utility = TextBaselineUtility(UtilityTestAttribute.new);
    test('Properties are initialized correctly', () {
      expect(utility.alphabetic().value, isA<TextBaseline>());
      expect(utility.ideographic().value, isA<TextBaseline>());
      expect(utility.alphabetic().value, TextBaseline.alphabetic);
      expect(utility.ideographic().value, TextBaseline.ideographic);
    });
  });

  group('ImageRepeatUtility Tests', () {
    const utility = ImageRepeatUtility(UtilityTestAttribute.new);
    test('Properties are initialized correctly', () {
      expect(utility.noRepeat().value, isA<ImageRepeat>());
      expect(utility().value, isA<ImageRepeat>());
      expect(utility.repeatX().value, isA<ImageRepeat>());
      expect(utility.repeatY().value, isA<ImageRepeat>());
      expect(utility.noRepeat().value, ImageRepeat.noRepeat);
      expect(utility().value, ImageRepeat.repeat);
      expect(utility.repeatX().value, ImageRepeat.repeatX);
      expect(utility.repeatY().value, ImageRepeat.repeatY);
    });
  });

  group('AlignmentUtility Tests', () {
    const utility = AlignmentUtility(UtilityTestAttribute.new);

    test('only() returns correct instance', () {
      final alignment = utility.only(x: 10, y: 8);
      final alignmnetDirectional = utility.only(y: 8, start: 10);

      expect(alignment.value, equals(const Alignment(10, 8)));
      expect(
        alignmnetDirectional.value,
        equals(const AlignmentDirectional(10, 8)),
      );

      expect(() => utility.only(x: 10, start: 8), throwsAssertionError);
    });
    test('Properties are initialized correctly', () {
      expect(utility.topLeft().value, isA<Alignment>());
      expect(utility.topCenter().value, isA<Alignment>());
      expect(utility.topRight().value, isA<Alignment>());
      expect(utility.centerLeft().value, isA<Alignment>());
      expect(utility.center().value, isA<Alignment>());
      expect(utility.centerRight().value, isA<Alignment>());
      expect(utility.bottomLeft().value, isA<Alignment>());
      expect(utility.bottomCenter().value, isA<Alignment>());
      expect(utility.bottomRight().value, isA<Alignment>());
      expect(utility.topLeft().value, Alignment.topLeft);
      expect(utility.topCenter().value, Alignment.topCenter);
      expect(utility.topRight().value, Alignment.topRight);
      expect(utility.centerLeft().value, Alignment.centerLeft);
      expect(utility.center().value, Alignment.center);
      expect(utility.centerRight().value, Alignment.centerRight);
      expect(utility.bottomLeft().value, Alignment.bottomLeft);
      expect(utility.bottomCenter().value, Alignment.bottomCenter);
      expect(utility.bottomRight().value, Alignment.bottomRight);
    });
  });

  group('BorderStyleUtility Tests', () {
    const utility = BorderStyleUtility(UtilityTestAttribute.new);
    test('Properties are initialized correctly', () {
      expect(utility.none().value, isA<BorderStyle>());
      expect(utility.solid().value, isA<BorderStyle>());
      expect(utility.none().value, BorderStyle.none);
      expect(utility.solid().value, BorderStyle.solid);
    });
  });

  group('ShapeBorderUtility', () {
    final utility = ShapeBorderUtility(UtilityTestAttribute.new);

    test('circle() returns correct instance', () {
      final shapeBorder = utility.circle();

      expect(shapeBorder.value, isA<CircleBorderDto>());
    });

    test('stadium() returns correct instance', () {
      final shapeBorder = utility.stadium();

      expect(shapeBorder.value, isA<StadiumBorderDto>());
    });

    test('rounded() returns correct instance', () {
      final shapeBorder = utility.roundedRectangle.borderRadius(20);

      expect(shapeBorder.value, isA<RoundedRectangleBorderDto>());
      expect(
        (shapeBorder.value as RoundedRectangleBorderDto).borderRadius,
        MixProp<BorderRadiusGeometry, BorderRadiusGeometryDto>.value(
          BorderRadiusDto.value(BorderRadius.circular(20)),
        ),
      );
    });

    test('beveled() returns correct instance', () {
      final shapeBorder = utility.beveled();

      expect(shapeBorder.value, isA<BeveledRectangleBorderDto>());
    });
  });
  group('BoxFitUtility Tests', () {
    const utility = BoxFitUtility(UtilityTestAttribute.new);
    test('Properties are initialized correctly', () {
      expect(utility.fill().value, isA<BoxFit>());
      expect(utility.contain().value, isA<BoxFit>());
      expect(utility.cover().value, isA<BoxFit>());
      expect(utility.fitWidth().value, isA<BoxFit>());
      expect(utility.fitHeight().value, isA<BoxFit>());
      expect(utility.none().value, isA<BoxFit>());
      expect(utility.scaleDown().value, isA<BoxFit>());
      expect(utility.fill().value, BoxFit.fill);
      expect(utility.contain().value, BoxFit.contain);
      expect(utility.cover().value, BoxFit.cover);
      expect(utility.fitWidth().value, BoxFit.fitWidth);
      expect(utility.fitHeight().value, BoxFit.fitHeight);
      expect(utility.none().value, BoxFit.none);
      expect(utility.scaleDown().value, BoxFit.scaleDown);
    });
  });

  group('BoxShapeUtility Tests', () {
    const utility = BoxShapeUtility(UtilityTestAttribute.new);
    test('Properties are initialized correctly', () {
      expect(utility.circle().value, isA<BoxShape>());
      expect(utility.rectangle().value, isA<BoxShape>());
      expect(utility.circle().value, BoxShape.circle);
      expect(utility.rectangle().value, BoxShape.rectangle);
    });
  });

  group('TextDirectionUtility Tests', () {
    const utility = TextDirectionUtility(UtilityTestAttribute.new);
    test('Properties are initialized correctly', () {
      expect(utility.ltr().value, isA<TextDirection>());
      expect(utility.rtl().value, isA<TextDirection>());
      expect(utility.ltr().value, TextDirection.ltr);
      expect(utility.rtl().value, TextDirection.rtl);
    });
  });

  group('TileModeUtility Tests', () {
    const utility = TileModeUtility(UtilityTestAttribute.new);
    test('Properties are initialized correctly', () {
      expect(utility.clamp().value, isA<TileMode>());
      expect(utility.mirror().value, isA<TileMode>());
      expect(utility.repeated().value, isA<TileMode>());
      expect(utility.clamp().value, TileMode.clamp);
      expect(utility.mirror().value, TileMode.mirror);
      expect(utility.repeated().value, TileMode.repeated);

      expect(utility.decal().value, isA<TileMode>());
    });
  });

  group('GradientTransformUtility Tests', () {
    const utility = GradientTransformUtility(UtilityTestAttribute.new);
    test('rotate', () {
      expect(utility.rotate(20).value, isA<GradientTransform>());
      expect(utility.rotate(20).value, const GradientRotation(20));
    });
  });

  group('Matrix4Utility Tests', () {
    const utility = Matrix4Utility(UtilityTestAttribute.new);
    test('identity', () {
      expect(utility.identity().value, isA<Matrix4>());
      expect(utility.identity().value, Matrix4.identity());
    });

    test('rotationX', () {
      expect(utility.rotationX(20).value, isA<Matrix4>());
      expect(utility.rotationX(20).value, Matrix4.rotationX(20));
    });

    test('rotationY', () {
      expect(utility.rotationY(20).value, isA<Matrix4>());
      expect(utility.rotationY(20).value, Matrix4.rotationY(20));
    });

    test('rotationZ', () {
      expect(utility.rotationZ(20).value, isA<Matrix4>());
      expect(utility.rotationZ(20).value, Matrix4.rotationZ(20));
    });

    test('translation', () {
      expect(utility.translationValues(20, 20, 20).value, isA<Matrix4>());
      expect(
        utility.translationValues(20, 20, 20).value,
        Matrix4.translationValues(20, 20, 20),
      );
    });
    //fromList
    test('fromList', () {
      final list = <double>[1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1];
      expect(
        utility.fromList(list).value,
        isA<Matrix4>(),
      );
      expect(
        utility.fromList(list).value,
        Matrix4.fromList(list),
      );
    });

    // diagonal3Values
    test('diagonal3Values', () {
      expect(
        utility.diagonal3Values(1, 2, 3).value,
        isA<Matrix4>(),
      );
      expect(
        utility.diagonal3Values(1, 2, 3).value,
        Matrix4.diagonal3Values(1, 2, 3),
      );
    });

    // skewX
    test('skewX', () {
      expect(
        utility.skewX(20).value,
        isA<Matrix4>(),
      );
      expect(
        utility.skewX(20).value,
        Matrix4.skewX(20),
      );
    });

    // skewY
    test('skewY', () {
      expect(
        utility.skewY(20).value,
        isA<Matrix4>(),
      );
      expect(
        utility.skewY(20).value,
        Matrix4.skewY(20),
      );
    });

    // skew
    test('skew', () {
      expect(
        utility.skew(20, 20).value,
        isA<Matrix4>(),
      );
      expect(
        utility.skew(20, 20).value,
        Matrix4.skew(20, 20),
      );
    });
    test('fromBuffer', () {
      final list = List.generate(130, (index) => index * 1.0);
      final float32List = Float32List.fromList(list);

      expect(
        utility.fromBuffer(float32List.buffer, 0).value,
        isA<Matrix4>(),
      );

      expect(
        utility.fromBuffer(float32List.buffer, 0).value,
        Matrix4.fromBuffer(float32List.buffer, 0),
      );
    });
  });

  group('BlendModeUtility Tests', () {
    test('Properties are initialized correctly', () {
      const utility = BlendModeUtility(UtilityTestAttribute.new);
      expect(utility.clear().value, BlendMode.clear);
      expect(utility.src().value, BlendMode.src);
      expect(utility.dst().value, BlendMode.dst);
      expect(utility.srcOver().value, BlendMode.srcOver);
      expect(utility.dstOver().value, BlendMode.dstOver);
      expect(utility.srcIn().value, BlendMode.srcIn);
      expect(utility.dstIn().value, BlendMode.dstIn);
      expect(utility.srcOut().value, BlendMode.srcOut);
      expect(utility.dstOut().value, BlendMode.dstOut);
      expect(utility.srcATop().value, BlendMode.srcATop);
      expect(utility.dstATop().value, BlendMode.dstATop);
      expect(utility.xor().value, BlendMode.xor);
      expect(utility.plus().value, BlendMode.plus);
    });
  });

  group('BlendModeUtility Tests', () {
    const utility = BlendModeUtility(UtilityTestAttribute.new);
    test('Properties are initialized correctly', () {
      expect(utility.clear().value, isA<BlendMode>());
      expect(utility.src().value, isA<BlendMode>());
      expect(utility.dst().value, isA<BlendMode>());
      expect(utility.srcOver().value, isA<BlendMode>());
      expect(utility.dstOver().value, isA<BlendMode>());
      expect(utility.srcIn().value, isA<BlendMode>());
      expect(utility.dstIn().value, isA<BlendMode>());
      expect(utility.srcOut().value, isA<BlendMode>());
      expect(utility.dstOut().value, isA<BlendMode>());
      expect(utility.srcATop().value, isA<BlendMode>());
      expect(utility.dstATop().value, isA<BlendMode>());
      expect(utility.xor().value, isA<BlendMode>());
      expect(utility.plus().value, isA<BlendMode>());
      expect(utility.clear().value, BlendMode.clear);
      expect(utility.src().value, BlendMode.src);
      expect(utility.dst().value, BlendMode.dst);
      expect(utility.srcOver().value, BlendMode.srcOver);
      expect(utility.dstOver().value, BlendMode.dstOver);
      expect(utility.srcIn().value, BlendMode.srcIn);
      expect(utility.dstIn().value, BlendMode.dstIn);
      expect(utility.srcOut().value, BlendMode.srcOut);
      expect(utility.dstOut().value, BlendMode.dstOut);
      expect(utility.srcATop().value, BlendMode.srcATop);
      expect(utility.dstATop().value, BlendMode.dstATop);
      expect(utility.xor().value, BlendMode.xor);
      expect(utility.plus().value, BlendMode.plus);
    });
  });

  group('FontWeightUtility Tests', () {
    const utility = FontWeightUtility(UtilityTestAttribute.new);
    test('Properties are initialized correctly', () {
      expect(utility.bold().value, isA<FontWeight>());
      expect(utility.normal().value, isA<FontWeight>());
      expect(utility.bold().value, FontWeight.bold);
      expect(utility.normal().value, FontWeight.normal);
      expect(utility.w100().value, isA<FontWeight>());
      expect(utility.w200().value, isA<FontWeight>());
      expect(utility.w300().value, isA<FontWeight>());
      expect(utility.w400().value, isA<FontWeight>());
      expect(utility.w500().value, isA<FontWeight>());
      expect(utility.w600().value, isA<FontWeight>());
      expect(utility.w700().value, isA<FontWeight>());
      expect(utility.w800().value, isA<FontWeight>());
      expect(utility.w900().value, isA<FontWeight>());
      expect(utility.w100().value, FontWeight.w100);
      expect(utility.w200().value, FontWeight.w200);
      expect(utility.w300().value, FontWeight.w300);
      expect(utility.w400().value, FontWeight.w400);
      expect(utility.w500().value, FontWeight.w500);
      expect(utility.w600().value, FontWeight.w600);
      expect(utility.w700().value, FontWeight.w700);
      expect(utility.w800().value, FontWeight.w800);
      expect(utility.w900().value, FontWeight.w900);
    });
  });

  group('TextDecorationUtility Tests', () {
    const utility = TextDecorationUtility(UtilityTestAttribute.new);
    test('Properties are initialized correctly', () {
      expect(utility.none().value, isA<TextDecoration>());
      expect(utility.underline().value, isA<TextDecoration>());
      expect(utility.overline().value, isA<TextDecoration>());
      expect(utility.lineThrough().value, isA<TextDecoration>());
      expect(utility.none().value, TextDecoration.none);
      expect(utility.underline().value, TextDecoration.underline);
      expect(utility.overline().value, TextDecoration.overline);
      expect(utility.lineThrough().value, TextDecoration.lineThrough);

      expect(utility.combine([TextDecoration.underline]).value,
          isA<TextDecoration>());

      expect(utility(TextDecoration.underline).value, isA<TextDecoration>());
    });
  });

  group('FontStyleUtility Tests', () {
    const utility = FontStyleUtility(UtilityTestAttribute.new);
    test('Properties are initialized correctly', () {
      expect(utility.normal().value, isA<FontStyle>());
      expect(utility.italic().value, isA<FontStyle>());
      expect(utility.normal().value, FontStyle.normal);
      expect(utility.italic().value, FontStyle.italic);
    });
  });

  group('RadiusUtility Tests', () {
    const utility = RadiusUtility(UtilityTestAttribute.new);
    test('Properties are initialized correctly', () {
      expect(utility.circular(10).value, isA<Radius>());
      expect(utility.circular(10).value, const Radius.circular(10));
      expect(utility.elliptical(10, 20).value, isA<Radius>());
      expect(utility.elliptical(10, 20).value, const Radius.elliptical(10, 20));
    });
  });

  group('TextDecorationStyleUtility Tests', () {
    const utility = TextDecorationStyleUtility(UtilityTestAttribute.new);
    test('Properties are initialized correctly', () {
      expect(utility.solid().value, isA<TextDecorationStyle>());
      expect(utility.double().value, isA<TextDecorationStyle>());
      expect(utility.dotted().value, isA<TextDecorationStyle>());
      expect(utility.dashed().value, isA<TextDecorationStyle>());
      expect(utility.wavy().value, isA<TextDecorationStyle>());
      expect(utility.solid().value, TextDecorationStyle.solid);
      expect(utility.double().value, TextDecorationStyle.double);
      expect(utility.dotted().value, TextDecorationStyle.dotted);
      expect(utility.dashed().value, TextDecorationStyle.dashed);
      expect(utility.wavy().value, TextDecorationStyle.wavy);
    });
  });

  group('ImageProviderUtility Tests', () {
    const utility = ImageProviderUtility(UtilityTestAttribute.new);

    test('network() returns correct instance', () {
      final imageProvider = utility.network('https://example.com/image.png');

      expect(imageProvider.value, isA<NetworkImage>());
      expect((imageProvider.value as NetworkImage).url,
          'https://example.com/image.png');
    });

    test('file() returns correct instance', () {
      final file = File('path/to/image.png');
      final imageProvider = utility.file(file);

      expect(imageProvider.value, isA<FileImage>());
      expect((imageProvider.value as FileImage).file, file);
    });

    test('asset() returns correct instance', () {
      final imageProvider = utility.asset('assets/image.png');

      expect(imageProvider.value, isA<AssetImage>());
      expect((imageProvider.value as AssetImage).assetName, 'assets/image.png');
    });

    test('memory() returns correct instance', () {
      final bytes = Uint8List.fromList([0, 1, 2, 3]);
      final imageProvider = utility.memory(bytes);

      expect(imageProvider.value, isA<MemoryImage>());
      expect((imageProvider.value as MemoryImage).bytes, bytes);
    });
  });

  group('TextScalerUtility Tests', () {
    const utility = TextScalerUtility(UtilityTestAttribute.new);

    test('call() returns correct instance', () {
      final textScaler = utility(
        const TextScaler.linear(2),
      );

      final linearTextScaler = utility.linear(3);

      final noScalingTextScaler = utility.noScaling();

      expect(textScaler.value, isA<TextScaler>());
      expect(textScaler.value, const TextScaler.linear(2));
      expect(linearTextScaler.value, const TextScaler.linear(3));
      expect(noScalingTextScaler.value, TextScaler.noScaling);
    });
  });
  group('DurationUtility Tests', () {
    const utility = DurationUtility(UtilityTestAttribute.new);
    test('microseconds() returns correct instance', () {
      final duration = utility.microseconds(500);
      expect(duration.value, isA<Duration>());
      expect(duration.value.inMicroseconds, 500);
    });

    test('milliseconds() returns correct instance', () {
      final duration = utility.milliseconds(1500);
      expect(duration.value, isA<Duration>());
      expect(duration.value.inMilliseconds, 1500);
    });

    test('seconds() returns correct instance', () {
      final duration = utility.seconds(30);
      expect(duration.value, isA<Duration>());
      expect(duration.value.inSeconds, 30);
    });

    test('minutes() returns correct instance', () {
      final duration = utility.minutes(2);
      expect(duration.value, isA<Duration>());
      expect(duration.value.inMinutes, 2);
    });

    test('zero() returns correct instance', () {
      final duration = utility.zero();
      expect(duration.value, isA<Duration>());
      expect(duration.value.inMicroseconds, 0);
    });

    test('call() returns correct instance', () {
      final duration = utility(const Duration(seconds: 5));
      expect(duration.value, isA<Duration>());
      expect(duration.value.inSeconds, 5);
    });
  });
  group('FontFeatureUtility Tests', () {
    const utility = FontFeatureUtility(UtilityTestAttribute.new);

    test('call() returns correct instance', () {
      final fontFeature = utility(
        const FontFeature('liga', 1),
      );

      expect(fontFeature.value, isA<FontFeature>());
      expect(fontFeature.value.feature, 'liga');
      expect(fontFeature.value.value, 1);
    });

    test('enable() returns correct instance', () {
      final fontFeature = utility.enable('liga');

      expect(fontFeature.value, isA<FontFeature>());
      expect(fontFeature.value.feature, 'liga');
      expect(fontFeature.value.value, 1);
    });

    test('disable() returns correct instance', () {
      final fontFeature = utility.disable('liga');

      expect(fontFeature.value, isA<FontFeature>());
      expect(fontFeature.value.feature, 'liga');
      expect(fontFeature.value.value, 0);
    });

    test('alternative() returns correct instance', () {
      final fontFeature = utility.alternative(2);

      expect(fontFeature.value, isA<FontFeature>());
      expect(fontFeature.value, const FontFeature.alternative(2));
    });

    test('randomize() returns correct instance', () {
      final fontFeature = utility.randomize();

      expect(fontFeature.value, isA<FontFeature>());
      expect(fontFeature.value, const FontFeature.randomize());
    });

    test('swash() returns correct instance', () {
      final fontFeature = utility.swash();

      expect(fontFeature.value, isA<FontFeature>());
      expect(fontFeature.value, const FontFeature.swash());
    });

    test('alternativeFractions() returns correct instance', () {
      final fontFeature = utility.alternativeFractions();

      expect(fontFeature.value, isA<FontFeature>());
      expect(fontFeature.value, const FontFeature.alternativeFractions());
    });

    test('contextualAlternates() returns correct instance', () {
      final fontFeature = utility.contextualAlternates();

      expect(fontFeature.value, isA<FontFeature>());
      expect(fontFeature.value, const FontFeature.contextualAlternates());
    });

    test('caseSensitiveForms() returns correct instance', () {
      final fontFeature = utility.caseSensitiveForms();

      expect(fontFeature.value, isA<FontFeature>());
      expect(fontFeature.value, const FontFeature.caseSensitiveForms());
    });

    test('characterVariant() returns correct instance', () {
      final fontFeature = utility.characterVariant(5);

      expect(fontFeature.value, isA<FontFeature>());
      expect(fontFeature.value, FontFeature.characterVariant(5));
    });

    test('historicalForms() returns correct instance', () {
      final fontFeature = utility.historicalForms();

      expect(fontFeature.value, isA<FontFeature>());
      expect(fontFeature.value, const FontFeature.historicalForms());
    });

    test('historicalLigatures() returns correct instance', () {
      final fontFeature = utility.historicalLigatures();

      expect(fontFeature.value, isA<FontFeature>());
      expect(fontFeature.value, const FontFeature.historicalLigatures());
    });

    test('liningFigures() returns correct instance', () {
      final fontFeature = utility.liningFigures();

      expect(fontFeature.value, isA<FontFeature>());
      expect(fontFeature.value, const FontFeature.liningFigures());
    });

    test('localeAware() returns correct instance', () {
      final fontFeature = utility.localeAware();
      final fontFeatureEnabled = utility.localeAware(enable: true);
      final fontFeatureDisabled = utility.localeAware(enable: false);

      expect(fontFeature.value, isA<FontFeature>());
      expect(fontFeature.value, const FontFeature.localeAware());
      expect(fontFeatureEnabled.value,
          const FontFeature.localeAware(enable: true));
      expect(fontFeatureDisabled.value,
          const FontFeature.localeAware(enable: false));
    });

    test('notationalForms() returns correct instance', () {
      final fontFeature = utility.notationalForms(2);

      expect(fontFeature.value, isA<FontFeature>());
      expect(fontFeature.value, const FontFeature.notationalForms(2));
    });

    test('numerators() returns correct instance', () {
      final fontFeature = utility.numerators();

      expect(fontFeature.value, isA<FontFeature>());
      expect(fontFeature.value, const FontFeature.numerators());
    });

    test('ordinalForms() returns correct instance', () {
      final fontFeature = utility.ordinalForms();

      expect(fontFeature.value, isA<FontFeature>());
      expect(fontFeature.value, const FontFeature.ordinalForms());
    });

    test('proportionalFigures() returns correct instance', () {
      final fontFeature = utility.proportionalFigures();

      expect(fontFeature.value, isA<FontFeature>());
      expect(fontFeature.value, const FontFeature.proportionalFigures());
    });

    test('stylisticAlternates() returns correct instance', () {
      final fontFeature = utility.stylisticAlternates();

      expect(fontFeature.value, isA<FontFeature>());
      expect(fontFeature.value, const FontFeature.stylisticAlternates());
    });

    test('scientificInferiors() returns correct instance', () {
      final fontFeature = utility.scientificInferiors();

      expect(fontFeature.value, isA<FontFeature>());
      expect(fontFeature.value, const FontFeature.scientificInferiors());
    });

    test('stylisticSet() returns correct instance', () {
      final fontFeature = utility.stylisticSet(2);

      expect(fontFeature.value, isA<FontFeature>());
      expect(fontFeature.value, FontFeature.stylisticSet(2));
    });

    test('subscripts() returns correct instance', () {
      final fontFeature = utility.subscripts();

      expect(fontFeature.value, isA<FontFeature>());
      expect(fontFeature.value, const FontFeature.subscripts());
    });

    test('superscripts() returns correct instance', () {
      final fontFeature = utility.superscripts();

      expect(fontFeature.value, isA<FontFeature>());
      expect(fontFeature.value, const FontFeature.superscripts());
    });

    test('tabularFigures() returns correct instance', () {
      final fontFeature = utility.tabularFigures();

      expect(fontFeature.value, isA<FontFeature>());
      expect(fontFeature.value, const FontFeature.tabularFigures());
    });
  });

  group('AlignmentDirectionalUtility Tests', () {
    const utility = AlignmentDirectionalUtility(UtilityTestAttribute.new);

    test('only() returns correct instance with y and start values', () {
      final alignmentDirectional = utility.only(y: 5, start: 10);

      expect(alignmentDirectional.value, isA<AlignmentDirectional>());
      expect(alignmentDirectional.value,
          equals(const AlignmentDirectional(10, 5)));
    });

    test('only() returns correct instance with only y value', () {
      final alignmentDirectional = utility.only(y: 5);

      expect(alignmentDirectional.value, isA<AlignmentDirectional>());
      expect(
          alignmentDirectional.value, equals(const AlignmentDirectional(0, 5)));
    });

    test('only() returns correct instance with only start value', () {
      final alignmentDirectional = utility.only(start: 10);

      expect(alignmentDirectional.value, isA<AlignmentDirectional>());
      expect(alignmentDirectional.value,
          equals(const AlignmentDirectional(10, 0)));
    });

    test('only() returns correct instance with no values', () {
      final alignmentDirectional = utility.only(y: -1, start: -1);

      expect(alignmentDirectional.value, isA<AlignmentDirectional>());
      expect(alignmentDirectional.value, equals(AlignmentDirectional.topStart));
    });

    test('topStart() returns correct instance', () {
      final alignmentDirectional = utility.topStart();

      expect(alignmentDirectional.value, isA<AlignmentDirectional>());
      expect(alignmentDirectional.value, equals(AlignmentDirectional.topStart));
    });

    test('topCenter() returns correct instance', () {
      final alignmentDirectional = utility.topCenter();

      expect(alignmentDirectional.value, isA<AlignmentDirectional>());
      expect(
          alignmentDirectional.value, equals(AlignmentDirectional.topCenter));
    });

    test('topEnd() returns correct instance', () {
      final alignmentDirectional = utility.topEnd();

      expect(alignmentDirectional.value, isA<AlignmentDirectional>());
      expect(alignmentDirectional.value, equals(AlignmentDirectional.topEnd));
    });

    test('centerStart() returns correct instance', () {
      final alignmentDirectional = utility.centerStart();

      expect(alignmentDirectional.value, isA<AlignmentDirectional>());
      expect(
          alignmentDirectional.value, equals(AlignmentDirectional.centerStart));
    });

    test('center() returns correct instance', () {
      final alignmentDirectional = utility.center();

      expect(alignmentDirectional.value, isA<AlignmentDirectional>());
      expect(alignmentDirectional.value, equals(AlignmentDirectional.center));
    });

    test('centerEnd() returns correct instance', () {
      final alignmentDirectional = utility.centerEnd();

      expect(alignmentDirectional.value, isA<AlignmentDirectional>());
      expect(
          alignmentDirectional.value, equals(AlignmentDirectional.centerEnd));
    });

    test('bottomStart() returns correct instance', () {
      final alignmentDirectional = utility.bottomStart();

      expect(alignmentDirectional.value, isA<AlignmentDirectional>());
      expect(
          alignmentDirectional.value, equals(AlignmentDirectional.bottomStart));
    });

    test('bottomCenter() returns correct instance', () {
      final alignmentDirectional = utility.bottomCenter();

      expect(alignmentDirectional.value, isA<AlignmentDirectional>());
      expect(alignmentDirectional.value,
          equals(AlignmentDirectional.bottomCenter));
    });

    test('bottomEnd() returns correct instance', () {
      final alignmentDirectional = utility.bottomEnd();

      expect(alignmentDirectional.value, isA<AlignmentDirectional>());
      expect(
          alignmentDirectional.value, equals(AlignmentDirectional.bottomEnd));
    });

    test('call() returns correct instance', () {
      final alignmentDirectional = utility(AlignmentDirectional.topStart);

      expect(alignmentDirectional.value, isA<AlignmentDirectional>());
      expect(alignmentDirectional.value, equals(AlignmentDirectional.topStart));
    });
  });
  group('PaintUtility Tests', () {
    const utility = PaintUtility(UtilityTestAttribute.new);
    test('PaintUtility returns correct instance', () {
      final paint = utility(Paint());
      expect(paint.value, isA<Paint>());
    });
  });

  group('LocaleUtility Tests', () {
    const utility = LocaleUtility(UtilityTestAttribute.new);
    test('LocaleUtility returns correct instance', () {
      final locale = utility(const Locale('en', 'US'));
      expect(locale.value, isA<Locale>());
      expect(locale.value.languageCode, 'en');
      expect(locale.value.countryCode, 'US');
    });

    test('LocaleUtility handles locale without country code', () {
      final locale = utility(const Locale('fr'));
      expect(locale.value, isA<Locale>());
      expect(locale.value.languageCode, 'fr');
      expect(locale.value.countryCode, null);
    });
  });

  group('CurveUtility Tests', () {
    const utility = CurveUtility(UtilityTestAttribute.new);
    test('Properties are initialized correctly', () {
      expect(utility.linear().value, isA<Curve>());
      expect(utility.decelerate().value, isA<Curve>());
      expect(utility.fastOutSlowIn().value, isA<Curve>());
      expect(utility.bounceIn().value, isA<Curve>());
      expect(utility.bounceOut().value, isA<Curve>());
      expect(utility.bounceInOut().value, isA<Curve>());
      expect(utility.elasticIn().value, isA<Curve>());
      expect(utility.elasticOut().value, isA<Curve>());
      expect(utility.elasticInOut().value, isA<Curve>());
      expect(utility.linear().value, Curves.linear);
      expect(utility.decelerate().value, Curves.decelerate);
      expect(utility.fastOutSlowIn().value, Curves.fastOutSlowIn);
      expect(utility.bounceIn().value, Curves.bounceIn);
      expect(utility.bounceOut().value, Curves.bounceOut);
      expect(utility.bounceInOut().value, Curves.bounceInOut);
      expect(utility.elasticIn().value, Curves.elasticIn);
      expect(utility.elasticOut().value, Curves.elasticOut);
      expect(utility.elasticInOut().value, Curves.elasticInOut);
      expect(utility.ease().value, isA<Curve>());
    });
  });

  group('OffsetUtility Tests', () {
    const utility = OffsetUtility(UtilityTestAttribute.new);
    test('Properties are initialized correctly', () {
      expect(utility.zero().value, isA<Offset>());
      expect(utility.infinite().value, isA<Offset>());
      expect(utility.zero().value, Offset.zero);
      expect(utility.infinite().value, Offset.infinite);

      expect(utility.fromDirection(10, 20).value, isA<Offset>());
      expect(utility.fromDirection(10, 20).value, Offset.fromDirection(10, 20));
    });
  });

  group('RectUtility Tests', () {
    const utility = RectUtility(UtilityTestAttribute.new);
    test('Properties are initialized correctly', () {
      expect(utility.zero().value, isA<Rect>());
      expect(utility.fromLTRB(10, 20, 30, 40).value, isA<Rect>());
      expect(utility.fromCircle(center: const Offset(10, 20), radius: 30).value,
          isA<Rect>());
      expect(
          utility
              .fromCenter(center: const Offset(10, 20), width: 30, height: 40)
              .value,
          isA<Rect>());
      expect(utility.fromLTWH(10, 20, 30, 40).value, isA<Rect>());
      expect(utility.fromCircle(center: const Offset(10, 20), radius: 30).value,
          Rect.fromCircle(center: const Offset(10, 20), radius: 30));
      expect(
        utility
            .fromCenter(center: const Offset(10, 20), width: 30, height: 40)
            .value,
        Rect.fromCenter(center: const Offset(10, 20), width: 30, height: 40),
      );
      expect(utility.fromLTRB(10, 20, 30, 40).value,
          const Rect.fromLTRB(10, 20, 30, 40));
      expect(utility.fromLTWH(10, 20, 30, 40).value,
          const Rect.fromLTWH(10, 20, 30, 40));
      // fromPoints
      expect(
        utility
            .fromPoints(
              const Offset(10, 20),
              const Offset(30, 40),
            )
            .value,
        Rect.fromPoints(
          const Offset(10, 20),
          const Offset(30, 40),
        ),
      );

      // largest
      expect(
        utility.largest().value,
        Rect.largest,
      );
    });
  });

  group('FontFamilyUtility Tests', () {
    const utility = FontFamilyUtility(UtilityTestAttribute.new);
    test('Properties are initialized correctly', () {
      expect(utility('Roboto').value, 'Roboto');
      expect(
          utility.fromCharCodes([82, 111, 98, 111, 116, 111]).value, 'Roboto');
      expect(utility.fromCharCode(82).value, 'R');
      expect(utility.fromEnvironment('name').value, '');
      expect(utility('Roboto').value, 'Roboto');
    });
  });
}
