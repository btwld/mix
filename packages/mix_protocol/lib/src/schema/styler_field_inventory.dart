import 'package:mix/mix.dart' show Equatable;

import 'schema_field.dart';

const boxStylerInventory = {
  'alignment',
  'animation',
  'clipBehavior',
  'constraints',
  'decoration',
  'foregroundDecoration',
  'margin',
  'modifier',
  'padding',
  'transform',
  'transformAlignment',
  'variants',
};

const flexStylerInventory = {
  'animation',
  'clipBehavior',
  'crossAxisAlignment',
  'direction',
  'mainAxisAlignment',
  'mainAxisSize',
  'modifier',
  'spacing',
  'textBaseline',
  'textDirection',
  'variants',
  'verticalDirection',
};

const stackStylerInventory = {
  'alignment',
  'animation',
  'clipBehavior',
  'fit',
  'modifier',
  'textDirection',
  'variants',
};

const textStylerInventory = {
  'animation',
  'locale',
  'maxLines',
  'modifier',
  'overflow',
  'selectionColor',
  'semanticsLabel',
  'softWrap',
  'strutStyle',
  'style',
  'textAlign',
  'textDirection',
  'textDirectives',
  'textHeightBehavior',
  'textScaler',
  'textWidthBasis',
  'variants',
};

const iconStylerInventory = {
  'animation',
  'applyTextScaling',
  'blendMode',
  'color',
  'fill',
  'grade',
  'icon',
  'modifier',
  'opacity',
  'opticalSize',
  'semanticsLabel',
  'shadows',
  'size',
  'textDirection',
  'variants',
  'weight',
};

const imageStylerInventory = {
  'alignment',
  'animation',
  'centerSlice',
  'color',
  'colorBlendMode',
  'excludeFromSemantics',
  'filterQuality',
  'fit',
  'gaplessPlayback',
  'height',
  'image',
  'isAntiAlias',
  'matchTextDirection',
  'modifier',
  'repeat',
  'semanticLabel',
  'variants',
  'width',
};

const flexBoxStylerInventory = {
  'animation',
  'box',
  'flex',
  'modifier',
  'variants',
};

const stackBoxStylerInventory = {
  'animation',
  'box',
  'modifier',
  'stack',
  'variants',
};

int stylerFieldCount(Equatable value) => value.props.length;

void checkKnownFieldInventory(
  Equatable value, {
  required String owner,
  required Set<String> fields,
}) {
  checkSchemaFieldInventory(
    owner: owner,
    ownerFieldInventory: fields,
    consumedFieldInventory: fields,
    actualFieldCount: value.props.length,
  );
}

const widgetModifierConfigInventory = {'orderOfModifiers', 'modifiers'};

const boxDecorationMixInventory = {
  'backgroundBlendMode',
  'border',
  'borderRadius',
  'boxShadow',
  'color',
  'gradient',
  'image',
  'shape',
};

const linearGradientMixInventory = {
  'begin',
  'colors',
  'end',
  'stops',
  'tileMode',
  'transform',
};

const radialGradientMixInventory = {
  'center',
  'colors',
  'focal',
  'focalRadius',
  'radius',
  'stops',
  'tileMode',
  'transform',
};

const sweepGradientMixInventory = {
  'center',
  'colors',
  'endAngle',
  'startAngle',
  'stops',
  'tileMode',
  'transform',
};

const textStyleMixInventory = {
  'background',
  'backgroundColor',
  'color',
  'debugLabel',
  'decoration',
  'decorationColor',
  'decorationStyle',
  'decorationThickness',
  'fontFamily',
  'fontFamilyFallback',
  'fontFeatures',
  'fontSize',
  'fontStyle',
  'fontVariations',
  'fontWeight',
  'foreground',
  'height',
  'inherit',
  'letterSpacing',
  'shadows',
  'textBaseline',
  'wordSpacing',
};

const strutStyleMixInventory = {
  'fontFamily',
  'fontFamilyFallback',
  'fontSize',
  'fontStyle',
  'fontWeight',
  'forceStrutHeight',
  'height',
  'leading',
};

const modifierAlignInventory = {'alignment', 'widthFactor', 'heightFactor'};
const modifierAspectRatioInventory = {'aspectRatio'};
const modifierBlurInventory = {'sigma'};
const modifierBoxInventory = {'spec'};
const modifierClipOvalInventory = {'clipper', 'clipBehavior'};
const modifierClipRectInventory = {'clipper', 'clipBehavior'};
const modifierClipRRectInventory = {'borderRadius', 'clipper', 'clipBehavior'};
const modifierClipTriangleInventory = {'clipBehavior'};
const modifierDefaultTextStyleInventory = {
  'style',
  'textAlign',
  'softWrap',
  'overflow',
  'maxLines',
  'textWidthBasis',
  'textHeightBehavior',
};
const modifierDefaultTextStylerInventory = {'style'};
const modifierFlexibleInventory = {'flex', 'fit'};
const modifierFractionallySizedBoxInventory = {
  'widthFactor',
  'heightFactor',
  'alignment',
};
const modifierIconThemeInventory = {
  'color',
  'size',
  'fill',
  'weight',
  'grade',
  'opticalSize',
  'opacity',
  'shadows',
  'applyTextScaling',
};
const modifierIntrinsicHeightInventory = <String>{};
const modifierIntrinsicWidthInventory = <String>{};
const modifierOpacityInventory = {'opacity'};
const modifierPaddingInventory = {'padding'};
const modifierRotateInventory = {'radians', 'alignment'};
const modifierRotatedBoxInventory = {'quarterTurns'};
const modifierScaleInventory = {'x', 'y', 'alignment'};
const modifierScrollViewInventory = {
  'scrollDirection',
  'reverse',
  'padding',
  'physics',
  'clipBehavior',
};
const modifierSizedBoxInventory = {'width', 'height'};
const modifierSkewInventory = {'skewX', 'skewY', 'alignment'};
const modifierTransformInventory = {'transform', 'alignment'};
const modifierTranslateInventory = {'x', 'y'};
const modifierVisibilityInventory = {'visible'};
