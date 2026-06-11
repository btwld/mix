import 'tw_semantic.dart';

enum TwSchemaPayloadDecision { schema, widgetLayer, directOnly, unsupported }

final class TwSchemaPayloadPolicy {
  const TwSchemaPayloadPolicy(this.decision, this.reason);

  final TwSchemaPayloadDecision decision;
  final String reason;
}

const Map<TwProperty, TwSchemaPayloadPolicy> twSchemaPayloadPolicy = {
  TwProperty.padding: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.schema,
    'Box and flex padding payload.',
  ),
  TwProperty.paddingX: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.schema,
    'Box and flex horizontal padding payload.',
  ),
  TwProperty.paddingY: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.schema,
    'Box and flex vertical padding payload.',
  ),
  TwProperty.paddingTop: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.schema,
    'Box and flex top padding payload.',
  ),
  TwProperty.paddingRight: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.schema,
    'Box and flex right padding payload.',
  ),
  TwProperty.paddingBottom: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.schema,
    'Box and flex bottom padding payload.',
  ),
  TwProperty.paddingLeft: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.schema,
    'Box and flex left padding payload.',
  ),
  TwProperty.margin: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.schema,
    'Box and flex margin payload.',
  ),
  TwProperty.marginX: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.schema,
    'Box and flex horizontal margin payload.',
  ),
  TwProperty.marginY: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.schema,
    'Box and flex vertical margin payload.',
  ),
  TwProperty.marginTop: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.schema,
    'Box and flex top margin payload.',
  ),
  TwProperty.marginRight: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.schema,
    'Box and flex right margin payload.',
  ),
  TwProperty.marginBottom: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.schema,
    'Box and flex bottom margin payload.',
  ),
  TwProperty.marginLeft: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.schema,
    'Box and flex left margin payload.',
  ),
  TwProperty.gap: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.schema,
    'Flex main-axis spacing payload.',
  ),
  TwProperty.gapX: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.widgetLayer,
    'Cross-axis gap depends on resolved flex axis.',
  ),
  TwProperty.gapY: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.widgetLayer,
    'Cross-axis gap depends on resolved flex axis.',
  ),
  TwProperty.width: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.schema,
    'Pixel constraints are schema-backed; full, screen, and percent stay widget-layer.',
  ),
  TwProperty.height: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.schema,
    'Pixel constraints are schema-backed; full, screen, and percent stay widget-layer.',
  ),
  TwProperty.minWidth: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.schema,
    'Pixel constraints are schema-backed; screen stays widget-layer.',
  ),
  TwProperty.minHeight: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.schema,
    'Pixel constraints are schema-backed; screen stays widget-layer.',
  ),
  TwProperty.maxWidth: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.schema,
    'Box and flex max width constraint payload.',
  ),
  TwProperty.maxHeight: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.schema,
    'Box and flex max height constraint payload.',
  ),
  TwProperty.display: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.schema,
    'Flex direction is schema-backed; Div layout selection stays widget-layer.',
  ),
  TwProperty.flexDirection: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.schema,
    'Flex direction payload with widget-layer responsive axis handling.',
  ),
  TwProperty.flexWrap: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.directOnly,
    'No current Mix flex-wrap schema target.',
  ),
  TwProperty.alignItems: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.schema,
    'Flex cross-axis alignment payload.',
  ),
  TwProperty.justifyContent: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.schema,
    'Flex main-axis alignment payload.',
  ),
  TwProperty.alignSelf: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.widgetLayer,
    'Flex parent-data and alignment decorator.',
  ),
  TwProperty.flexGrow: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.widgetLayer,
    'Flex parent-data decorator.',
  ),
  TwProperty.flexShrink: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.widgetLayer,
    'Flex parent-data decorator.',
  ),
  TwProperty.flexBasis: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.widgetLayer,
    'Axis-dependent SizedBox decorator.',
  ),
  TwProperty.backgroundColor: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.schema,
    'Schema-backed when the color is wire-stable.',
  ),
  TwProperty.backgroundGradient: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.directOnly,
    'Tailwinds gradient accumulators and custom transforms.',
  ),
  TwProperty.borderWidth: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.directOnly,
    'Border accumulator preserves Tailwinds side and color defaults.',
  ),
  TwProperty.borderTopWidth: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.directOnly,
    'Border accumulator preserves Tailwinds side and color defaults.',
  ),
  TwProperty.borderRightWidth: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.directOnly,
    'Border accumulator preserves Tailwinds side and color defaults.',
  ),
  TwProperty.borderBottomWidth: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.directOnly,
    'Border accumulator preserves Tailwinds side and color defaults.',
  ),
  TwProperty.borderLeftWidth: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.directOnly,
    'Border accumulator preserves Tailwinds side and color defaults.',
  ),
  TwProperty.borderXWidth: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.directOnly,
    'Border accumulator preserves Tailwinds side and color defaults.',
  ),
  TwProperty.borderYWidth: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.directOnly,
    'Border accumulator preserves Tailwinds side and color defaults.',
  ),
  TwProperty.borderColor: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.directOnly,
    'Border accumulator preserves Tailwinds side and color defaults.',
  ),
  TwProperty.borderRadius: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.schema,
    'Decoration borderRadius payload.',
  ),
  TwProperty.borderRadiusTop: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.schema,
    'Decoration top borderRadius payload.',
  ),
  TwProperty.borderRadiusBottom: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.schema,
    'Decoration bottom borderRadius payload.',
  ),
  TwProperty.borderRadiusLeft: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.schema,
    'Decoration left borderRadius payload.',
  ),
  TwProperty.borderRadiusRight: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.schema,
    'Decoration right borderRadius payload.',
  ),
  TwProperty.borderRadiusTopLeft: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.schema,
    'Decoration top-left borderRadius payload.',
  ),
  TwProperty.borderRadiusTopRight: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.schema,
    'Decoration top-right borderRadius payload.',
  ),
  TwProperty.borderRadiusBottomLeft: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.schema,
    'Decoration bottom-left borderRadius payload.',
  ),
  TwProperty.borderRadiusBottomRight: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.schema,
    'Decoration bottom-right borderRadius payload.',
  ),
  TwProperty.fontSize: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.schema,
    'Text and default text style fontSize payload.',
  ),
  TwProperty.fontWeight: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.schema,
    'Text and default text style fontWeight payload.',
  ),
  TwProperty.textColor: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.schema,
    'Schema-backed when the color is wire-stable.',
  ),
  TwProperty.textAlign: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.schema,
    'TextAlign payload.',
  ),
  TwProperty.lineHeight: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.schema,
    'Text and default text style height payload.',
  ),
  TwProperty.letterSpacing: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.schema,
    'Text letterSpacing payload.',
  ),
  TwProperty.textTransform: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.schema,
    'Text directives payload.',
  ),
  TwProperty.textOverflow: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.schema,
    'Overflow, maxLines, and softWrap payload.',
  ),
  TwProperty.textDecoration: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.directOnly,
    'No Tailwinds plugin mapping yet.',
  ),
  TwProperty.textShadow: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.schema,
    'Text and default text style shadows payload.',
  ),
  TwProperty.boxShadow: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.schema,
    'Decoration boxShadow payload.',
  ),
  TwProperty.opacity: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.unsupported,
    'Parser does not implement opacity yet.',
  ),
  TwProperty.blur: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.schema,
    'Blur modifier payload.',
  ),
  TwProperty.scale: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.directOnly,
    'Transform accumulator composes Tailwinds transform tokens.',
  ),
  TwProperty.rotate: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.directOnly,
    'Transform accumulator composes Tailwinds transform tokens.',
  ),
  TwProperty.translateX: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.directOnly,
    'Transform accumulator composes Tailwinds transform tokens.',
  ),
  TwProperty.translateY: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.directOnly,
    'Transform accumulator composes Tailwinds transform tokens.',
  ),
  TwProperty.transition: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.widgetLayer,
    'Animation is applied after parser output.',
  ),
  TwProperty.transitionDuration: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.widgetLayer,
    'Animation is applied after parser output.',
  ),
  TwProperty.transitionCurve: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.widgetLayer,
    'Animation is applied after parser output.',
  ),
  TwProperty.transitionDelay: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.widgetLayer,
    'Animation is applied after parser output.',
  ),
  TwProperty.clipBehavior: TwSchemaPayloadPolicy(
    TwSchemaPayloadDecision.schema,
    'ClipBehavior payload.',
  ),
};
