/// Descriptor registry for Mix widget wrapper generation.
library;

import 'package:mix_annotations/mix_annotations.dart';

class MixWidgetDescriptor {
  final MixWidgetBuilderKind kind;
  final String widgetTypeName;
  final String widgetTypeUrl;
  final String specTypeName;
  final String specTypeUrl;
  final List<String> allowedStylerTypeUrls;
  final bool allowDefaultResolution;

  const MixWidgetDescriptor({
    required this.kind,
    required this.widgetTypeName,
    required this.widgetTypeUrl,
    required this.specTypeName,
    required this.specTypeUrl,
    required this.allowedStylerTypeUrls,
    this.allowDefaultResolution = true,
  });
}

class MixWidgetDescriptorRegistry {
  const MixWidgetDescriptorRegistry();

  static const descriptors = <MixWidgetDescriptor>[
    MixWidgetDescriptor(
      kind: MixWidgetBuilderKind.box,
      widgetTypeName: 'Box',
      widgetTypeUrl: 'package:mix/mix.dart#Box',
      specTypeName: 'BoxSpec',
      specTypeUrl: 'package:mix/mix.dart#BoxSpec',
      allowedStylerTypeUrls: ['package:mix/mix.dart#BoxStyler'],
    ),
    MixWidgetDescriptor(
      kind: MixWidgetBuilderKind.text,
      widgetTypeName: 'StyledText',
      widgetTypeUrl: 'package:mix/mix.dart#StyledText',
      specTypeName: 'TextSpec',
      specTypeUrl: 'package:mix/mix.dart#TextSpec',
      allowedStylerTypeUrls: ['package:mix/mix.dart#TextStyler'],
    ),
    MixWidgetDescriptor(
      kind: MixWidgetBuilderKind.flexBox,
      widgetTypeName: 'FlexBox',
      widgetTypeUrl: 'package:mix/mix.dart#FlexBox',
      specTypeName: 'FlexBoxSpec',
      specTypeUrl: 'package:mix/mix.dart#FlexBoxSpec',
      allowedStylerTypeUrls: ['package:mix/mix.dart#FlexBoxStyler'],
    ),
    MixWidgetDescriptor(
      kind: MixWidgetBuilderKind.rowBox,
      widgetTypeName: 'RowBox',
      widgetTypeUrl: 'package:mix/mix.dart#RowBox',
      specTypeName: 'FlexBoxSpec',
      specTypeUrl: 'package:mix/mix.dart#FlexBoxSpec',
      allowedStylerTypeUrls: ['package:mix/mix.dart#FlexBoxStyler'],
      allowDefaultResolution: false,
    ),
    MixWidgetDescriptor(
      kind: MixWidgetBuilderKind.columnBox,
      widgetTypeName: 'ColumnBox',
      widgetTypeUrl: 'package:mix/mix.dart#ColumnBox',
      specTypeName: 'FlexBoxSpec',
      specTypeUrl: 'package:mix/mix.dart#FlexBoxSpec',
      allowedStylerTypeUrls: ['package:mix/mix.dart#FlexBoxStyler'],
      allowDefaultResolution: false,
    ),
    MixWidgetDescriptor(
      kind: MixWidgetBuilderKind.icon,
      widgetTypeName: 'StyledIcon',
      widgetTypeUrl: 'package:mix/mix.dart#StyledIcon',
      specTypeName: 'IconSpec',
      specTypeUrl: 'package:mix/mix.dart#IconSpec',
      allowedStylerTypeUrls: ['package:mix/mix.dart#IconStyler'],
    ),
    MixWidgetDescriptor(
      kind: MixWidgetBuilderKind.image,
      widgetTypeName: 'StyledImage',
      widgetTypeUrl: 'package:mix/mix.dart#StyledImage',
      specTypeName: 'ImageSpec',
      specTypeUrl: 'package:mix/mix.dart#ImageSpec',
      allowedStylerTypeUrls: ['package:mix/mix.dart#ImageStyler'],
    ),
    MixWidgetDescriptor(
      kind: MixWidgetBuilderKind.stackBox,
      widgetTypeName: 'StackBox',
      widgetTypeUrl: 'package:mix/mix.dart#StackBox',
      specTypeName: 'StackBoxSpec',
      specTypeUrl: 'package:mix/mix.dart#StackBoxSpec',
      allowedStylerTypeUrls: ['package:mix/mix.dart#StackBoxStyler'],
    ),
  ];

  MixWidgetDescriptor? descriptorForKind(MixWidgetBuilderKind kind) {
    for (final descriptor in descriptors) {
      if (descriptor.kind == kind) {
        return descriptor;
      }
    }

    return null;
  }

  Iterable<MixWidgetDescriptor> get defaultDescriptors sync* {
    for (final descriptor in descriptors) {
      if (descriptor.allowDefaultResolution) {
        yield descriptor;
      }
    }
  }
}

const mixWidgetDescriptorRegistry = MixWidgetDescriptorRegistry();
