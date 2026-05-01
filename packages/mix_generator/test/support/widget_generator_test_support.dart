import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:logging/logging.dart';
import 'package:mix_generator/mix_generator.dart';
import 'package:source_gen/source_gen.dart';

const mixWidgetInputAssetId = 'mix_generator|lib/input.dart';
final _mixWidgetOutputAsset = AssetId('mix_generator', 'lib/input.g.dart');

Builder mixWidgetPartBuilder() =>
    PartBuilder([const MixWidgetGenerator()], '.g.dart');

const mixAnnotationsStub = r'''
library mix_annotations;

export 'src/annotations.dart';
''';

const mixAnnotationsAnnotationsStub = r'''
library mix_annotations.src.annotations;

class MixWidget {
  final String? name;

  const MixWidget({this.name});
}

const mixWidget = MixWidget();

class MixWidgetRenderer {
  final Type widget;

  const MixWidgetRenderer(this.widget);
}
''';

const flutterFrameworkStub = r'''
library flutter.src.widgets.framework;

import 'package:flutter/src/foundation/key.dart';

class Widget {
  const Widget();
}

class BuildContext {
  const BuildContext();
}

abstract class StatelessWidget extends Widget {
  final Key? key;

  const StatelessWidget({this.key});

  Widget build(BuildContext context);
}
''';

const flutterFoundationKeyStub = r'''
library flutter.src.foundation.key;

class Key {
  const Key();
}
''';

const flutterWidgetsStub = r'''
library flutter.widgets;

export 'src/foundation/key.dart';
export 'src/widgets/framework.dart';

class Color {
  const Color();
}

class Colors {
  static const blue = Color();
  static const blueAccent = Color();
}

typedef VoidCallback = void Function();

class IconData {
  const IconData();
}

class ImageProvider<T extends Object> {
  const ImageProvider();
}

class ImageFrameBuilder {
  const ImageFrameBuilder();
}

class ImageLoadingBuilder {
  const ImageLoadingBuilder();
}

class ImageErrorWidgetBuilder {
  const ImageErrorWidgetBuilder();
}

class Animation<T> {
  const Animation();
}
''';

const mixStyleStub = r'''
library mix.src.core.style;

class Spec<T> {
  const Spec();
}

class StyleSpec<T> {
  const StyleSpec();
}

class Style<T> {
  const Style();
}
''';

const mixBoxSpecStub = r'''
library mix.src.specs.box.box_spec;

import 'package:mix_annotations/src/annotations.dart';
import 'package:mix/mix.dart';

@MixWidgetRenderer(Box)
class BoxSpec {
  const BoxSpec();
}
''';

const mixFlexBoxSpecStub = r'''
library mix.src.specs.flexbox.flexbox_spec;

import 'package:mix_annotations/src/annotations.dart';
import 'package:mix/mix.dart';

@MixWidgetRenderer(FlexBox)
class FlexBoxSpec {
  const FlexBoxSpec();
}
''';

const mixTextSpecStub = r'''
library mix.src.specs.text.text_spec;

import 'package:mix_annotations/src/annotations.dart';
import 'package:mix/mix.dart';

@MixWidgetRenderer(StyledText)
class TextSpec {
  const TextSpec();
}
''';

const mixIconSpecStub = r'''
library mix.src.specs.icon.icon_spec;

import 'package:mix_annotations/src/annotations.dart';
import 'package:mix/mix.dart';

@MixWidgetRenderer(StyledIcon)
class IconSpec {
  const IconSpec();
}
''';

const mixImageSpecStub = r'''
library mix.src.specs.image.image_spec;

import 'package:mix_annotations/src/annotations.dart';
import 'package:mix/mix.dart';

@MixWidgetRenderer(StyledImage)
class ImageSpec {
  const ImageSpec();
}
''';

const mixStackBoxSpecStub = r'''
library mix.src.specs.stackbox.stackbox_spec;

import 'package:mix_annotations/src/annotations.dart';
import 'package:mix/mix.dart';

@MixWidgetRenderer(StackBox)
class StackBoxSpec {
  const StackBoxSpec();
}
''';

const mixStub = r'''
library mix;

import 'package:flutter/widgets.dart';

export 'src/core/style.dart';
export 'src/specs/box/box_spec.dart';
export 'src/specs/flexbox/flexbox_spec.dart';
export 'src/specs/icon/icon_spec.dart';
export 'src/specs/image/image_spec.dart';
export 'src/specs/stackbox/stackbox_spec.dart';
export 'src/specs/text/text_spec.dart';

import 'src/core/style.dart';
import 'src/specs/box/box_spec.dart';
import 'src/specs/flexbox/flexbox_spec.dart';
import 'src/specs/icon/icon_spec.dart';
import 'src/specs/image/image_spec.dart';
import 'src/specs/stackbox/stackbox_spec.dart';
import 'src/specs/text/text_spec.dart';

class BoxStyler extends Style<BoxSpec> {
  const BoxStyler();

  factory BoxStyler.color(Color value) => const BoxStyler();

  BoxStyler merge(BoxStyler? other) => this;

  Box call({Key? key, Widget? child}) {
    return Box(key: key, style: this, child: child);
  }
}

class TextStyler extends Style<TextSpec> {
  const TextStyler();

  TextStyler merge(TextStyler? other) => this;

  StyledText call(String text) {
    return StyledText(text, style: this);
  }
}

class FlexBoxStyler extends Style<FlexBoxSpec> {
  const FlexBoxStyler();

  FlexBoxStyler merge(FlexBoxStyler? other) => this;

  FlexBox call({Key? key, required List<Widget> children}) {
    return FlexBox(key: key, style: this, children: children);
  }
}

class IconStyler extends Style<IconSpec> {
  const IconStyler();

  IconStyler merge(IconStyler? other) => this;

  StyledIcon call({Key? key, IconData? icon, String? semanticLabel}) {
    return StyledIcon(
      key: key,
      icon: icon,
      semanticLabel: semanticLabel,
      style: this,
    );
  }
}

class ImageStyler extends Style<ImageSpec> {
  const ImageStyler();

  ImageStyler merge(ImageStyler? other) => this;

  StyledImage call({
    ImageProvider<Object>? image,
    ImageFrameBuilder? frameBuilder,
    ImageLoadingBuilder? loadingBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    Animation<double>? opacity,
  }) {
    return StyledImage(
      style: this,
      image: image,
      frameBuilder: frameBuilder,
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
      opacity: opacity,
    );
  }
}

class StackBoxStyler extends Style<StackBoxSpec> {
  const StackBoxStyler();

  StackBoxStyler merge(StackBoxStyler? other) => this;

  StackBox call({Key? key, required List<Widget> children}) {
    return StackBox(key: key, style: this, children: children);
  }
}

class Box extends Widget {
  final Key? key;
  final Style<BoxSpec> style;
  final StyleSpec<BoxSpec>? styleSpec;
  final Widget? child;

  const Box({
    this.key,
    this.style = const BoxStyler(),
    this.styleSpec,
    this.child,
  });
}

class StyledText extends Widget {
  final String text;
  final Key? key;
  final Style<TextSpec> style;
  final StyleSpec<TextSpec>? styleSpec;

  const StyledText(
    this.text, {
    this.key,
    this.style = const TextStyler(),
    this.styleSpec,
  });
}

class FlexBox extends Widget {
  final Key? key;
  final Style<FlexBoxSpec> style;
  final StyleSpec<FlexBoxSpec>? styleSpec;
  final List<Widget> children;

  const FlexBox({
    this.key,
    this.style = const FlexBoxStyler(),
    this.styleSpec,
    this.children = const <Widget>[],
  });
}

class RowBox extends FlexBox {
  const RowBox({
    super.key,
    super.style = const FlexBoxStyler(),
    super.styleSpec,
    super.children = const <Widget>[],
  });
}

class ColumnBox extends FlexBox {
  const ColumnBox({
    super.key,
    super.style = const FlexBoxStyler(),
    super.styleSpec,
    super.children = const <Widget>[],
  });
}

class StyledIcon extends Widget {
  final IconData? icon;
  final String? semanticLabel;
  final Key? key;
  final Style<IconSpec> style;
  final StyleSpec<IconSpec>? styleSpec;

  const StyledIcon({
    this.icon,
    this.semanticLabel,
    this.key,
    this.style = const IconStyler(),
    this.styleSpec,
  });
}

class StyledImage extends Widget {
  final ImageProvider<Object>? image;
  final ImageFrameBuilder? frameBuilder;
  final ImageLoadingBuilder? loadingBuilder;
  final ImageErrorWidgetBuilder? errorBuilder;
  final Animation<double>? opacity;
  final Key? key;
  final Style<ImageSpec> style;
  final StyleSpec<ImageSpec>? styleSpec;

  const StyledImage({
    this.image,
    this.frameBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    this.opacity,
    this.key,
    this.style = const ImageStyler(),
    this.styleSpec,
  });
}

class StackBox extends Widget {
  final Key? key;
  final Style<StackBoxSpec> style;
  final StyleSpec<StackBoxSpec>? styleSpec;
  final List<Widget> children;

  const StackBox({
    this.key,
    this.style = const StackBoxStyler(),
    this.styleSpec,
    this.children = const <Widget>[],
  });
}

''';

Map<String, String> mixWidgetBaseSources({
  required String inputSource,
  Map<String, String>? extraSources,
  String? mixSourceOverride,
}) {
  return mixWidgetBaseSourcesFromPackageSources({
    mixWidgetInputAssetId: inputSource,
    ...?extraSources,
  }, mixSourceOverride: mixSourceOverride);
}

Map<String, String> mixWidgetBaseSourcesFromPackageSources(
  Map<String, String> packageSources, {
  String? mixSourceOverride,
}) {
  return {
    'flutter|lib/src/foundation/key.dart': flutterFoundationKeyStub,
    'flutter|lib/src/widgets/framework.dart': flutterFrameworkStub,
    'flutter|lib/widgets.dart': flutterWidgetsStub,
    'mix|lib/src/core/style.dart': mixStyleStub,
    'mix|lib/src/specs/box/box_spec.dart': mixBoxSpecStub,
    'mix|lib/src/specs/flexbox/flexbox_spec.dart': mixFlexBoxSpecStub,
    'mix|lib/src/specs/text/text_spec.dart': mixTextSpecStub,
    'mix|lib/src/specs/icon/icon_spec.dart': mixIconSpecStub,
    'mix|lib/src/specs/image/image_spec.dart': mixImageSpecStub,
    'mix|lib/src/specs/stackbox/stackbox_spec.dart': mixStackBoxSpecStub,
    'mix|lib/mix.dart': mixSourceOverride ?? mixStub,
    'mix_annotations|lib/mix_annotations.dart': mixAnnotationsStub,
    'mix_annotations|lib/src/annotations.dart': mixAnnotationsAnnotationsStub,
    ...packageSources,
  };
}

Future<List<LogRecord>> runMixWidgetWithLogs(
  String inputSource, {
  Map<String, String>? extraSources,
  String? mixSourceOverride,
}) async {
  final logs = <LogRecord>[];

  await testBuilder(
    mixWidgetPartBuilder(),
    mixWidgetBaseSources(
      inputSource: inputSource,
      extraSources: extraSources,
      mixSourceOverride: mixSourceOverride,
    ),
    generateFor: {mixWidgetInputAssetId},
    rootPackage: 'mix_generator',
    onLog: logs.add,
  );

  return logs;
}

Future<String> generateMixWidgetOutput({
  required String inputSource,
  Map<String, String>? extraSources,
  String? mixSourceOverride,
  void Function(LogRecord log)? onLog,
}) {
  return generateMixWidgetOutputFromPackageSources(
    mixWidgetBaseSources(
      inputSource: inputSource,
      extraSources: extraSources,
      mixSourceOverride: mixSourceOverride,
    ),
    onLog: onLog,
  );
}

Future<String> generateMixWidgetOutputFromPackageSources(
  Map<String, String> packageSources, {
  void Function(LogRecord log)? onLog,
}) async {
  final readerWriter = TestReaderWriter(rootPackage: 'mix_generator');

  await testBuilder(
    mixWidgetPartBuilder(),
    packageSources,
    generateFor: {mixWidgetInputAssetId},
    rootPackage: 'mix_generator',
    readerWriter: readerWriter,
    flattenOutput: true,
    onLog: onLog,
  );

  if (!readerWriter.testing.exists(_mixWidgetOutputAsset)) {
    throw StateError(
      'MixWidget generator did not produce `${_mixWidgetOutputAsset.path}`.',
    );
  }

  return normalizeGoldenText(
    readerWriter.testing.readString(_mixWidgetOutputAsset),
  );
}

String normalizeGoldenText(String text) {
  final normalized = text.replaceAll('\r\n', '\n');
  return normalized.endsWith('\n') ? normalized : '$normalized\n';
}
