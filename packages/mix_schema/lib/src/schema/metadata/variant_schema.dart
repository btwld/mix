import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../../core/mix_schema_scope.dart';
import '../../core/schema_wire_types.dart';
import '../../registry/registry_catalog.dart';
import '../discriminated_branch_registry.dart';
import '../shared/enum_schemas.dart';

AckSchema<VariantStyle<S>>
buildVariantSchema<S extends Spec<S>, T extends Style<S>>({
  required AckSchema<T> styleSchema,
  required T emptyStyle,
  required RegistryCatalog registries,
}) {
  final registry = DiscriminatedBranchRegistry<VariantStyle<S>>(
    discriminatorKey: 'type',
  );

  for (final type in SchemaVariant.values) {
    final AckSchema<VariantStyle<S>> branch = _buildVariantBranch(
      type: type,
      styleSchema: styleSchema,
      emptyStyle: emptyStyle,
      registries: registries,
    );

    registry.register(type.wireValue, branch);
  }

  return registry.freeze();
}

AckSchema<VariantStyle<S>>
_buildVariantBranch<S extends Spec<S>, T extends Style<S>>({
  required SchemaVariant type,
  required AckSchema<T> styleSchema,
  required T emptyStyle,
  required RegistryCatalog registries,
}) {
  switch (type) {
    case .named:
      return Ack.object({
        'name': Ack.string(),
        'style': styleSchema,
      }).transform<VariantStyle<S>>((data) {
        final map = data!;

        return VariantStyle<S>(
          Variant.named(map['name'] as String),
          map['style'] as T,
        );
      });
    case .widgetState:
      return Ack.object({
        'state': widgetStateSchema,
        'style': styleSchema,
      }).transform<VariantStyle<S>>((data) {
        final map = data!;

        return VariantStyle<S>(
          ContextVariant.widgetState(map['state'] as WidgetState),
          map['style'] as T,
        );
      });
    case .enabled:
      return Ack.object({'style': styleSchema}).transform<VariantStyle<S>>((
        data,
      ) {
        final map = data!;

        return VariantStyle<S>(
          ContextVariant.not(ContextVariant.widgetState(.disabled)),
          map['style'] as T,
        );
      });
    case .brightness:
      return Ack.object({
        'brightness': brightnessSchema,
        'style': styleSchema,
      }).transform<VariantStyle<S>>((data) {
        final map = data!;

        return VariantStyle<S>(
          ContextVariant.brightness(map['brightness'] as Brightness),
          map['style'] as T,
        );
      });
    case .breakpoint:
      return Ack.object({
            'minWidth': Ack.double().nullable(),
            'maxWidth': Ack.double().nullable(),
            'minHeight': Ack.double().nullable(),
            'maxHeight': Ack.double().nullable(),
            'style': styleSchema,
          })
          .refine((data) {
            return data['minWidth'] != null ||
                data['maxWidth'] != null ||
                data['minHeight'] != null ||
                data['maxHeight'] != null;
          }, message: 'At least one dimension constraint required.')
          .transform<VariantStyle<S>>((data) {
            final map = data!;

            return VariantStyle<S>(
              ContextVariant.breakpoint(
                Breakpoint(
                  minWidth: map['minWidth'] as double?,
                  maxWidth: map['maxWidth'] as double?,
                  minHeight: map['minHeight'] as double?,
                  maxHeight: map['maxHeight'] as double?,
                ),
              ),
              map['style'] as T,
            );
          });
    case .notWidgetState:
      return Ack.object({'state': widgetStateSchema, 'style': styleSchema})
          .refine((data) {
            return data['state'] != WidgetState.disabled;
          }, message: 'Use enabled for not(disabled).')
          .transform<VariantStyle<S>>((data) {
            final map = data!;

            return VariantStyle<S>(
              ContextVariant.not(
                ContextVariant.widgetState(map['state'] as WidgetState),
              ),
              map['style'] as T,
            );
          });
    case .contextBuilder:
      return Ack.object({'id': Ack.string()}).transform<VariantStyle<S>>((
        data,
      ) {
        final map = data!;
        final fn = registries.lookup<T Function(BuildContext)>(
          MixSchemaScope.contextVariantBuilder.wireValue,
          map['id'] as String,
        );

        return VariantStyle<S>(ContextVariantBuilder<T>(fn), emptyStyle);
      });
  }
}
