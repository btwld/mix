import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../errors/mix_protocol_error.dart';
import 'common_codecs.dart';
import 'styler_field_inventory.dart';
import 'text_styler_codec.dart';
import 'wire_discriminators.dart';

AckSchema<Object, WidgetModifierConfig> modifierConfigCodec({
  AckSchema<JsonMap, Object>? rootStyleSchema,
}) {
  final items = Ack.list(modifierCodec(rootStyleSchema: rootStyleSchema));
  final object = Ack.object({
    'order': _modifierOrderCodec().optional(),
    'items': items.optional(),
  });

  return Ack.codec<Object, Object, WidgetModifierConfig>(
    input: Ack.anyOf([items, object]),
    decode: (value) {
      if (value is List) {
        return WidgetModifierConfig.modifiers(value.cast<ModifierMix>());
      }

      final data = value as JsonMap;
      return WidgetModifierConfig(
        orderOfModifiers: data['order'] as List<Type>?,
        modifiers: (data['items'] as List?)?.cast<ModifierMix>(),
      );
    },
    encode: _encodeModifierConfig,
  );
}

AckSchema<JsonMap, ModifierMix> modifierCodec({
  AckSchema<JsonMap, Object>? rootStyleSchema,
}) {
  return Ack.discriminated<ModifierMix>(
    discriminatorKey: 'type',
    schemas: {
      modifierTypeAlign: _alignModifierCodec(),
      modifierTypeAspectRatio: _aspectRatioModifierCodec(),
      modifierTypeBlur: _blurModifierCodec(),
      modifierTypeBox: _boxModifierCodec(rootStyleSchema),
      modifierTypeClipOval: _clipOvalModifierCodec(),
      modifierTypeClipRect: _clipRectModifierCodec(),
      modifierTypeClipRRect: _clipRRectModifierCodec(),
      modifierTypeClipTriangle: _clipTriangleModifierCodec(),
      modifierTypeDefaultTextStyle: _defaultTextStyleModifierCodec(),
      modifierTypeDefaultTextStyler: _defaultTextStylerModifierCodec(
        rootStyleSchema,
      ),
      modifierTypeFlexible: _flexibleModifierCodec(),
      modifierTypeFractionallySizedBox: _fractionallySizedBoxModifierCodec(),
      modifierTypeIconTheme: _iconThemeModifierCodec(),
      modifierTypeIntrinsicHeight: _intrinsicHeightModifierCodec(),
      modifierTypeIntrinsicWidth: _intrinsicWidthModifierCodec(),
      modifierTypeOpacity: _opacityModifierCodec(),
      modifierTypePadding: _paddingModifierCodec(),
      modifierTypeRotate: _rotateModifierCodec(),
      modifierTypeRotatedBox: _rotatedBoxModifierCodec(),
      modifierTypeScale: _scaleModifierCodec(),
      modifierTypeScrollView: _scrollViewModifierCodec(),
      modifierTypeSizedBox: _sizedBoxModifierCodec(),
      modifierTypeSkew: _skewModifierCodec(),
      modifierTypeTransform: _transformModifierCodec(),
      modifierTypeTranslate: _translateModifierCodec(),
      modifierTypeVisibility: _visibilityModifierCodec(),
    },
  );
}

AckSchema<JsonMap, AlignModifierMix> _alignModifierCodec() {
  return Ack.object({
    'alignment': _alignmentProp('modifiers.align.alignment').optional(),
    'widthFactor': _doubleProp('modifiers.align.widthFactor').optional(),
    'heightFactor': _doubleProp('modifiers.align.heightFactor').optional(),
  }).codec<AlignModifierMix>(
    decode: (data) => AlignModifierMix.create(
      alignment: data['alignment'] as Prop<AlignmentGeometry>?,
      widthFactor: data['widthFactor'] as Prop<double>?,
      heightFactor: data['heightFactor'] as Prop<double>?,
    ),
    encode: (value) => _encodeKnownModifier(
      value,
      'AlignModifierMix',
      modifierAlignInventory,
      {
        'alignment': value.alignment,
        'widthFactor': value.widthFactor,
        'heightFactor': value.heightFactor,
      },
    ),
  );
}

AckSchema<JsonMap, AspectRatioModifierMix> _aspectRatioModifierCodec() {
  return Ack.object({
    'aspectRatio': _positiveDoubleProp(
      'modifiers.aspectRatio.aspectRatio',
    ).optional(),
  }).codec<AspectRatioModifierMix>(
    decode: (data) => AspectRatioModifierMix.create(
      aspectRatio: data['aspectRatio'] as Prop<double>?,
    ),
    encode: (value) => _encodeKnownModifier(
      value,
      'AspectRatioModifierMix',
      modifierAspectRatioInventory,
      {'aspectRatio': value.aspectRatio},
    ),
  );
}

AckSchema<JsonMap, BlurModifierMix> _blurModifierCodec() {
  return Ack.object({
    'sigma': _doubleProp('modifiers.blur.sigma'),
  }).codec<BlurModifierMix>(
    decode: (data) =>
        BlurModifierMix.create(sigma: data['sigma'] as Prop<double>?),
    encode: (value) => _encodeKnownModifier(
      value,
      'BlurModifierMix',
      modifierBlurInventory,
      {'sigma': value.sigma},
    ),
  );
}

AckSchema<JsonMap, BoxModifierMix> _boxModifierCodec(
  AckSchema<JsonMap, Object>? rootStyleSchema,
) {
  return Ack.object({
    'style': _nestedStyleSchema(rootStyleSchema, modifierTypeBox),
  }).codec<BoxModifierMix>(
    decode: (data) => BoxModifierMix(
      _readNestedStyle<BoxStyler>(data['style'], modifierTypeBox),
    ),
    encode: (value) => _encodeKnownModifier(
      value,
      'BoxModifierMix',
      modifierBoxInventory,
      {'style': value.spec},
    ),
  );
}

AckSchema<JsonMap, ClipOvalModifierMix> _clipOvalModifierCodec() {
  return Ack.object({
    'clipBehavior': _clipProp('modifiers.clipOval.clipBehavior').optional(),
  }).codec<ClipOvalModifierMix>(
    decode: (data) => ClipOvalModifierMix.create(
      clipBehavior: data['clipBehavior'] as Prop<Clip>?,
    ),
    encode: (value) {
      checkKnownFieldInventory(
        value,
        owner: 'ClipOvalModifierMix',
        fields: modifierClipOvalInventory,
      );
      failIfPresent(value.clipper, 'modifiers.clipOval.clipper');

      return {'clipBehavior': value.clipBehavior};
    },
  );
}

AckSchema<JsonMap, ClipRectModifierMix> _clipRectModifierCodec() {
  return Ack.object({
    'clipBehavior': _clipProp('modifiers.clipRect.clipBehavior').optional(),
  }).codec<ClipRectModifierMix>(
    decode: (data) => ClipRectModifierMix.create(
      clipBehavior: data['clipBehavior'] as Prop<Clip>?,
    ),
    encode: (value) {
      checkKnownFieldInventory(
        value,
        owner: 'ClipRectModifierMix',
        fields: modifierClipRectInventory,
      );
      failIfPresent(value.clipper, 'modifiers.clipRect.clipper');

      return {'clipBehavior': value.clipBehavior};
    },
  );
}

AckSchema<JsonMap, ClipRRectModifierMix> _clipRRectModifierCodec() {
  return Ack.object({
    'borderRadius': mixPropCodec<BorderRadiusMix, BorderRadiusGeometry>(
      borderRadiusCodec(),
      fieldName: 'modifiers.clipRRect.borderRadius',
    ).optional(),
    'clipBehavior': _clipProp('modifiers.clipRRect.clipBehavior').optional(),
  }).codec<ClipRRectModifierMix>(
    decode: (data) => ClipRRectModifierMix.create(
      borderRadius: data['borderRadius'] as Prop<BorderRadiusGeometry>?,
      clipBehavior: data['clipBehavior'] as Prop<Clip>?,
    ),
    encode: (value) {
      checkKnownFieldInventory(
        value,
        owner: 'ClipRRectModifierMix',
        fields: modifierClipRRectInventory,
      );
      failIfPresent(value.clipper, 'modifiers.clipRRect.clipper');

      return {
        'borderRadius': value.borderRadius,
        'clipBehavior': value.clipBehavior,
      };
    },
  );
}

AckSchema<JsonMap, ClipTriangleModifierMix> _clipTriangleModifierCodec() {
  return Ack.object({
    'clipBehavior': _clipProp('modifiers.clipTriangle.clipBehavior').optional(),
  }).codec<ClipTriangleModifierMix>(
    decode: (data) => ClipTriangleModifierMix.create(
      clipBehavior: data['clipBehavior'] as Prop<Clip>?,
    ),
    encode: (value) => _encodeKnownModifier(
      value,
      'ClipTriangleModifierMix',
      modifierClipTriangleInventory,
      {'clipBehavior': value.clipBehavior},
    ),
  );
}

AckSchema<JsonMap, DefaultTextStyleModifierMix>
_defaultTextStyleModifierCodec() {
  return Ack.object({
    'style': mixPropCodec<TextStyleMix, TextStyle>(
      textStyleMixCodec(),
      fieldName: 'modifiers.defaultTextStyle.style',
    ).optional(),
    'textAlign': valuePropCodec<TextAlign>(
      textAlignCodec(),
      fieldName: 'modifiers.defaultTextStyle.textAlign',
    ).optional(),
    'softWrap': _boolProp('modifiers.defaultTextStyle.softWrap').optional(),
    'overflow': valuePropCodec<TextOverflow>(
      textOverflowCodec(),
      fieldName: 'modifiers.defaultTextStyle.overflow',
    ).optional(),
    'maxLines': _positiveIntProp(
      'modifiers.defaultTextStyle.maxLines',
    ).optional(),
  }).codec<DefaultTextStyleModifierMix>(
    decode: (data) => DefaultTextStyleModifierMix.create(
      style: data['style'] as Prop<TextStyle>?,
      textAlign: data['textAlign'] as Prop<TextAlign>?,
      softWrap: data['softWrap'] as Prop<bool>?,
      overflow: data['overflow'] as Prop<TextOverflow>?,
      maxLines: data['maxLines'] as Prop<int>?,
    ),
    encode: _encodeDefaultTextStyleModifier,
  );
}

AckSchema<JsonMap, DefaultTextStylerModifierMix>
_defaultTextStylerModifierCodec(AckSchema<JsonMap, Object>? rootStyleSchema) {
  return Ack.object({
    'style': _nestedStyleSchema(rootStyleSchema, modifierTypeDefaultTextStyler),
  }).codec<DefaultTextStylerModifierMix>(
    decode: (data) => DefaultTextStylerModifierMix(
      _readNestedStyle<TextStyler>(
        data['style'],
        modifierTypeDefaultTextStyler,
      ),
    ),
    encode: (value) => _encodeKnownModifier(
      value,
      'DefaultTextStylerModifierMix',
      modifierDefaultTextStylerInventory,
      {'style': value.style},
    ),
  );
}

AckSchema<JsonMap, FlexibleModifierMix> _flexibleModifierCodec() {
  return Ack.object({
    'flex': _nonNegativeIntProp('modifiers.flexible.flex').optional(),
    'fit': valuePropCodec<FlexFit>(
      enumCodec({
        'tight': FlexFit.tight,
        'loose': FlexFit.loose,
      }, debugName: 'FlexFit'),
      fieldName: 'modifiers.flexible.fit',
    ).optional(),
  }).codec<FlexibleModifierMix>(
    decode: (data) => FlexibleModifierMix.create(
      flex: data['flex'] as Prop<int>?,
      fit: data['fit'] as Prop<FlexFit>?,
    ),
    encode: (value) => _encodeKnownModifier(
      value,
      'FlexibleModifierMix',
      modifierFlexibleInventory,
      {'flex': value.flex, 'fit': value.fit},
    ),
  );
}

AckSchema<JsonMap, FractionallySizedBoxModifierMix>
_fractionallySizedBoxModifierCodec() {
  return Ack.object({
    'widthFactor': _doubleProp(
      'modifiers.fractionallySizedBox.widthFactor',
    ).optional(),
    'heightFactor': _doubleProp(
      'modifiers.fractionallySizedBox.heightFactor',
    ).optional(),
    'alignment': _alignmentProp(
      'modifiers.fractionallySizedBox.alignment',
    ).optional(),
  }).codec<FractionallySizedBoxModifierMix>(
    decode: (data) => FractionallySizedBoxModifierMix.create(
      widthFactor: data['widthFactor'] as Prop<double>?,
      heightFactor: data['heightFactor'] as Prop<double>?,
      alignment: data['alignment'] as Prop<AlignmentGeometry>?,
    ),
    encode: (value) => _encodeKnownModifier(
      value,
      'FractionallySizedBoxModifierMix',
      modifierFractionallySizedBoxInventory,
      {
        'widthFactor': value.widthFactor,
        'heightFactor': value.heightFactor,
        'alignment': value.alignment,
      },
    ),
  );
}

AckSchema<JsonMap, IconThemeModifierMix> _iconThemeModifierCodec() {
  return Ack.object({
    'color': valuePropCodec<Color>(
      colorCodec(),
      fieldName: 'modifiers.iconTheme.color',
    ).optional(),
    'size': _doubleTokenProp('modifiers.iconTheme.size').optional(),
    'fill': _doubleTokenProp('modifiers.iconTheme.fill').optional(),
    'weight': _doubleTokenProp('modifiers.iconTheme.weight').optional(),
    'grade': _doubleTokenProp('modifiers.iconTheme.grade').optional(),
    'opticalSize': _doubleTokenProp(
      'modifiers.iconTheme.opticalSize',
    ).optional(),
    'opacity': _opacityTokenProp('modifiers.iconTheme.opacity').optional(),
    'shadows': mixPropCodec<ShadowListMix, List<Shadow>>(
      _shadowListMixCodec(),
      fieldName: 'modifiers.iconTheme.shadows',
    ).optional(),
    'applyTextScaling': _boolProp(
      'modifiers.iconTheme.applyTextScaling',
    ).optional(),
  }).codec<IconThemeModifierMix>(
    decode: (data) => IconThemeModifierMix.create(
      color: data['color'] as Prop<Color>?,
      size: data['size'] as Prop<double>?,
      fill: data['fill'] as Prop<double>?,
      weight: data['weight'] as Prop<double>?,
      grade: data['grade'] as Prop<double>?,
      opticalSize: data['opticalSize'] as Prop<double>?,
      opacity: data['opacity'] as Prop<double>?,
      shadows: data['shadows'] as Prop<List<Shadow>>?,
      applyTextScaling: data['applyTextScaling'] as Prop<bool>?,
    ),
    encode: (value) => _encodeKnownModifier(
      value,
      'IconThemeModifierMix',
      modifierIconThemeInventory,
      {
        'color': value.color,
        'size': value.size,
        'fill': value.fill,
        'weight': value.weight,
        'grade': value.grade,
        'opticalSize': value.opticalSize,
        'opacity': value.opacity,
        'shadows': value.shadows,
        'applyTextScaling': value.applyTextScaling,
      },
    ),
  );
}

AckSchema<JsonMap, IntrinsicHeightModifierMix> _intrinsicHeightModifierCodec() {
  return Ack.object({}).codec<IntrinsicHeightModifierMix>(
    decode: (_) => const IntrinsicHeightModifierMix(),
    encode: (value) => _encodeKnownModifier(
      value,
      'IntrinsicHeightModifierMix',
      modifierIntrinsicHeightInventory,
      const {},
    ),
  );
}

AckSchema<JsonMap, IntrinsicWidthModifierMix> _intrinsicWidthModifierCodec() {
  return Ack.object({}).codec<IntrinsicWidthModifierMix>(
    decode: (_) => const IntrinsicWidthModifierMix(),
    encode: (value) => _encodeKnownModifier(
      value,
      'IntrinsicWidthModifierMix',
      modifierIntrinsicWidthInventory,
      const {},
    ),
  );
}

AckSchema<JsonMap, OpacityModifierMix> _opacityModifierCodec() {
  return Ack.object({
    'opacity': _opacityProp('modifiers.opacity.opacity'),
  }).codec<OpacityModifierMix>(
    decode: (data) =>
        OpacityModifierMix.create(opacity: data['opacity'] as Prop<double>?),
    encode: (value) => _encodeKnownModifier(
      value,
      'OpacityModifierMix',
      modifierOpacityInventory,
      {'opacity': value.opacity},
    ),
  );
}

AckSchema<JsonMap, PaddingModifierMix> _paddingModifierCodec() {
  return Ack.object({
    'padding': mixPropCodec<EdgeInsetsMix, EdgeInsetsGeometry>(
      edgeInsetsCodec(),
      fieldName: 'modifiers.padding.padding',
    ),
  }).codec<PaddingModifierMix>(
    decode: (data) => PaddingModifierMix.create(
      padding: data['padding'] as Prop<EdgeInsetsGeometry>?,
    ),
    encode: (value) => _encodeKnownModifier(
      value,
      'PaddingModifierMix',
      modifierPaddingInventory,
      {'padding': value.padding},
    ),
  );
}

AckSchema<JsonMap, RotateModifierMix> _rotateModifierCodec() {
  return Ack.object({
    'radians': _doubleProp('modifiers.rotate.radians').optional(),
    'alignment': _alignmentValueProp('modifiers.rotate.alignment').optional(),
  }).codec<RotateModifierMix>(
    decode: (data) => RotateModifierMix.create(
      radians: data['radians'] as Prop<double>?,
      alignment: data['alignment'] as Prop<Alignment>?,
    ),
    encode: (value) => _encodeKnownModifier(
      value,
      'RotateModifierMix',
      modifierRotateInventory,
      {'radians': value.radians, 'alignment': value.alignment},
    ),
  );
}

AckSchema<JsonMap, RotatedBoxModifierMix> _rotatedBoxModifierCodec() {
  return Ack.object({
    'quarterTurns': _intProp('modifiers.rotatedBox.quarterTurns').optional(),
  }).codec<RotatedBoxModifierMix>(
    decode: (data) => RotatedBoxModifierMix.create(
      quarterTurns: data['quarterTurns'] as Prop<int>?,
    ),
    encode: (value) => _encodeKnownModifier(
      value,
      'RotatedBoxModifierMix',
      modifierRotatedBoxInventory,
      {'quarterTurns': value.quarterTurns},
    ),
  );
}

AckSchema<JsonMap, ScaleModifierMix> _scaleModifierCodec() {
  return Ack.object({
    'x': _doubleProp('modifiers.scale.x').optional(),
    'y': _doubleProp('modifiers.scale.y').optional(),
    'alignment': _alignmentValueProp('modifiers.scale.alignment').optional(),
  }).codec<ScaleModifierMix>(
    decode: (data) => ScaleModifierMix.create(
      x: data['x'] as Prop<double>?,
      y: data['y'] as Prop<double>?,
      alignment: data['alignment'] as Prop<Alignment>?,
    ),
    encode: (value) => _encodeKnownModifier(
      value,
      'ScaleModifierMix',
      modifierScaleInventory,
      {'x': value.x, 'y': value.y, 'alignment': value.alignment},
    ),
  );
}

AckSchema<JsonMap, ScrollViewModifierMix> _scrollViewModifierCodec() {
  return Ack.object({
    'scrollDirection': valuePropCodec<Axis>(
      enumNameCodec(Axis.values),
      fieldName: 'modifiers.scrollView.scrollDirection',
    ).optional(),
    'reverse': _boolProp('modifiers.scrollView.reverse').optional(),
    'padding': mixPropCodec<EdgeInsetsMix, EdgeInsetsGeometry>(
      edgeInsetsCodec(),
      fieldName: 'modifiers.scrollView.padding',
    ).optional(),
    'clipBehavior': _clipProp('modifiers.scrollView.clipBehavior').optional(),
  }).codec<ScrollViewModifierMix>(
    decode: (data) => ScrollViewModifierMix.create(
      scrollDirection: data['scrollDirection'] as Prop<Axis>?,
      reverse: data['reverse'] as Prop<bool>?,
      padding: data['padding'] as Prop<EdgeInsetsGeometry>?,
      clipBehavior: data['clipBehavior'] as Prop<Clip>?,
    ),
    encode: (value) {
      checkKnownFieldInventory(
        value,
        owner: 'ScrollViewModifierMix',
        fields: modifierScrollViewInventory,
      );
      failIfPresent(value.physics, 'modifiers.scrollView.physics');

      return {
        'scrollDirection': value.scrollDirection,
        'reverse': value.reverse,
        'padding': value.padding,
        'clipBehavior': value.clipBehavior,
      };
    },
  );
}

AckSchema<JsonMap, SizedBoxModifierMix> _sizedBoxModifierCodec() {
  return Ack.object({
    'width': _doubleTokenProp('modifiers.sizedBox.width').optional(),
    'height': _doubleTokenProp('modifiers.sizedBox.height').optional(),
  }).codec<SizedBoxModifierMix>(
    decode: (data) => SizedBoxModifierMix.create(
      width: data['width'] as Prop<double>?,
      height: data['height'] as Prop<double>?,
    ),
    encode: (value) => _encodeKnownModifier(
      value,
      'SizedBoxModifierMix',
      modifierSizedBoxInventory,
      {'width': value.width, 'height': value.height},
    ),
  );
}

AckSchema<JsonMap, SkewModifierMix> _skewModifierCodec() {
  return Ack.object({
    'skewX': _doubleProp('modifiers.skew.skewX').optional(),
    'skewY': _doubleProp('modifiers.skew.skewY').optional(),
    'alignment': _alignmentValueProp('modifiers.skew.alignment').optional(),
  }).codec<SkewModifierMix>(
    decode: (data) => SkewModifierMix.create(
      skewX: data['skewX'] as Prop<double>?,
      skewY: data['skewY'] as Prop<double>?,
      alignment: data['alignment'] as Prop<Alignment>?,
    ),
    encode: (value) =>
        _encodeKnownModifier(value, 'SkewModifierMix', modifierSkewInventory, {
          'skewX': value.skewX,
          'skewY': value.skewY,
          'alignment': value.alignment,
        }),
  );
}

AckSchema<JsonMap, TransformModifierMix> _transformModifierCodec() {
  return Ack.object({
    'transform': valuePropCodec<Matrix4>(
      matrix4Codec(),
      fieldName: 'modifiers.transform.transform',
    ).optional(),
    'alignment': _alignmentValueProp(
      'modifiers.transform.alignment',
    ).optional(),
  }).codec<TransformModifierMix>(
    decode: (data) => TransformModifierMix.create(
      transform: data['transform'] as Prop<Matrix4>?,
      alignment: data['alignment'] as Prop<Alignment>?,
    ),
    encode: (value) => _encodeKnownModifier(
      value,
      'TransformModifierMix',
      modifierTransformInventory,
      {'transform': value.transform, 'alignment': value.alignment},
    ),
  );
}

AckSchema<JsonMap, TranslateModifierMix> _translateModifierCodec() {
  return Ack.object({
    'x': _doubleProp('modifiers.translate.x').optional(),
    'y': _doubleProp('modifiers.translate.y').optional(),
  }).codec<TranslateModifierMix>(
    decode: (data) => TranslateModifierMix.create(
      x: data['x'] as Prop<double>?,
      y: data['y'] as Prop<double>?,
    ),
    encode: (value) => _encodeKnownModifier(
      value,
      'TranslateModifierMix',
      modifierTranslateInventory,
      {'x': value.x, 'y': value.y},
    ),
  );
}

AckSchema<JsonMap, VisibilityModifierMix> _visibilityModifierCodec() {
  return Ack.object({
    'visible': _boolProp('modifiers.visibility.visible').optional(),
  }).codec<VisibilityModifierMix>(
    decode: (data) =>
        VisibilityModifierMix.create(visible: data['visible'] as Prop<bool>?),
    encode: (value) => _encodeKnownModifier(
      value,
      'VisibilityModifierMix',
      modifierVisibilityInventory,
      {'visible': value.visible},
    ),
  );
}

Object _encodeModifierConfig(WidgetModifierConfig value) {
  checkKnownFieldInventory(
    value,
    owner: 'WidgetModifierConfig',
    fields: widgetModifierConfigInventory,
  );

  final order = value.$orderOfModifiers;
  final modifiers = value.$modifiers;

  if (order == null || order.isEmpty) return modifiers ?? const <ModifierMix>[];

  return {
    'order': order,
    if (modifiers != null && modifiers.isNotEmpty) 'items': modifiers,
  };
}

JsonMap _encodeKnownModifier(
  ModifierMix value,
  String owner,
  Set<String> fields,
  JsonMap wire,
) {
  checkKnownFieldInventory(value, owner: owner, fields: fields);

  return wire;
}

JsonMap _encodeDefaultTextStyleModifier(DefaultTextStyleModifierMix value) {
  checkKnownFieldInventory(
    value,
    owner: 'DefaultTextStyleModifierMix',
    fields: modifierDefaultTextStyleInventory,
  );

  failIfPresent(
    value.textWidthBasis,
    'modifiers.defaultTextStyle.textWidthBasis',
  );
  failIfPresent(
    value.textHeightBehavior,
    'modifiers.defaultTextStyle.textHeightBehavior',
  );

  return {
    'style': value.style,
    'textAlign': value.textAlign,
    'softWrap': value.softWrap,
    'overflow': value.overflow,
    'maxLines': value.maxLines,
  };
}

CodecSchema<Object, Prop<double>> _doubleProp(String fieldName) {
  return valuePropCodec<double>(numberAsDoubleCodec(), fieldName: fieldName);
}

CodecSchema<Object, Prop<double>> _positiveDoubleProp(String fieldName) {
  return valuePropCodec<double>(positiveDoubleCodec(), fieldName: fieldName);
}

CodecSchema<Object, Prop<double>> _doubleTokenProp(String fieldName) {
  return valuePropCodec<double>(doubleTokenCodec(), fieldName: fieldName);
}

CodecSchema<Object, Prop<double>> _opacityProp(String fieldName) {
  return valuePropCodec<double>(unitDoubleCodec(), fieldName: fieldName);
}

CodecSchema<Object, Prop<double>> _opacityTokenProp(String fieldName) {
  return valuePropCodec<double>(unitDoubleTokenCodec(), fieldName: fieldName);
}

CodecSchema<Object, Prop<int>> _intProp(String fieldName) {
  return valuePropCodec<int>(Ack.integer(), fieldName: fieldName);
}

CodecSchema<Object, Prop<int>> _positiveIntProp(String fieldName) {
  return valuePropCodec<int>(Ack.integer().min(1), fieldName: fieldName);
}

CodecSchema<Object, Prop<int>> _nonNegativeIntProp(String fieldName) {
  return valuePropCodec<int>(Ack.integer().min(0), fieldName: fieldName);
}

CodecSchema<Object, Prop<bool>> _boolProp(String fieldName) {
  return valuePropCodec<bool>(Ack.boolean(), fieldName: fieldName);
}

CodecSchema<Object, Prop<Clip>> _clipProp(String fieldName) {
  return valuePropCodec<Clip>(enumNameCodec(Clip.values), fieldName: fieldName);
}

CodecSchema<Object, Prop<AlignmentGeometry>> _alignmentProp(String fieldName) {
  return valueAsPropCodec<Alignment, AlignmentGeometry>(
    alignmentCodec(),
    fieldName: fieldName,
  );
}

CodecSchema<Object, Prop<Alignment>> _alignmentValueProp(String fieldName) {
  return valuePropCodec<Alignment>(alignmentCodec(), fieldName: fieldName);
}

AckSchema<JsonMap, Object> _nestedStyleSchema(
  AckSchema<JsonMap, Object>? rootStyleSchema,
  String modifierType,
) {
  if (rootStyleSchema != null) return rootStyleSchema;

  return Ack.object({}).codec<Object>(
    decode: (_) => throw UnsupportedEncodeValueError(
      modifierType,
      'Modifier "$modifierType" requires the root style schema.',
    ),
    encode: (_) => throw UnsupportedEncodeValueError(
      modifierType,
      'Modifier "$modifierType" requires the root style schema.',
    ),
  );
}

T _readNestedStyle<T extends Object>(Object? value, String modifierType) {
  if (value is T) return value;

  throw UnsupportedEncodeValueError(
    value,
    'Modifier "$modifierType" expected nested ${T.toString()} style.',
  );
}

CodecSchema<Object, ShadowListMix> _shadowListMixCodec() {
  final tokenWireSchema = tokenReferenceWireSchema();
  final tokenCodec = tokenReferenceCodec<List<Shadow>, ShadowListMix>(
    decodeToken: (data) => ShadowToken(data[tokenReferenceKey]! as String),
    reference: (token) => (token as ShadowToken).mix(),
  );

  return Ack.codec<Object, Object, ShadowListMix>(
    input: Ack.anyOf([Ack.list(shadowCodec()), tokenWireSchema]),
    decode: (wire) {
      if (wire is List) {
        if (wire.every((item) => item is ShadowMix)) {
          return ShadowListMix(wire.cast<ShadowMix>().toList(growable: false));
        }

        return ShadowListMix([
          for (final item in wire)
            shadowCodec().safeParse(item as JsonMap).getOrThrow()!,
        ]);
      }
      if (wire is JsonMap && wire.containsKey(tokenReferenceKey)) {
        return tokenCodec.safeParse(wire).getOrThrow()!;
      }

      throw UnsupportedEncodeValueError(
        wire,
        'Icon theme shadows must be a shadow list or ShadowToken reference.',
      );
    },
    encode: (value) {
      final tokenResult = tokenCodec.safeEncode(value);
      if (tokenResult.isOk) return tokenResult.getOrNull()!;

      return value.items;
    },
  );
}

CodecSchema<List<String>, List<Type>> _modifierOrderCodec() {
  return Ack.list(
    Ack.enumString(_modifierWireByType.values.toList(growable: false)),
  ).codec<List<Type>>(
    decode: (values) => [
      for (final value in values) _modifierTypeByWire[value]!,
    ],
    encode: (types) => [for (final type in types) _wireForModifierType(type)],
  );
}

String _wireForModifierType(Type type) {
  final wire = _modifierWireByType[type];
  if (wire != null) return wire;

  throw UnsupportedEncodeValueError(
    type,
    'Modifier order contains unsupported modifier type "$type".',
  );
}

final _modifierTypeByWire = {
  for (final entry in _modifierWireByType.entries) entry.value: entry.key,
};

const _modifierWireByType = <Type, String>{
  AlignModifier: modifierTypeAlign,
  AspectRatioModifier: modifierTypeAspectRatio,
  BlurModifier: modifierTypeBlur,
  BoxModifier: modifierTypeBox,
  ClipOvalModifier: modifierTypeClipOval,
  ClipRectModifier: modifierTypeClipRect,
  ClipRRectModifier: modifierTypeClipRRect,
  ClipTriangleModifier: modifierTypeClipTriangle,
  DefaultTextStyleModifier: modifierTypeDefaultTextStyle,
  DefaultTextStylerModifier: modifierTypeDefaultTextStyler,
  FlexibleModifier: modifierTypeFlexible,
  FractionallySizedBoxModifier: modifierTypeFractionallySizedBox,
  IconThemeModifier: modifierTypeIconTheme,
  IntrinsicHeightModifier: modifierTypeIntrinsicHeight,
  IntrinsicWidthModifier: modifierTypeIntrinsicWidth,
  OpacityModifier: modifierTypeOpacity,
  PaddingModifier: modifierTypePadding,
  RotateModifier: modifierTypeRotate,
  RotatedBoxModifier: modifierTypeRotatedBox,
  ScaleModifier: modifierTypeScale,
  ScrollViewModifier: modifierTypeScrollView,
  SizedBoxModifier: modifierTypeSizedBox,
  SkewModifier: modifierTypeSkew,
  TransformModifier: modifierTypeTransform,
  TranslateModifier: modifierTypeTranslate,
  VisibilityModifier: modifierTypeVisibility,
};
