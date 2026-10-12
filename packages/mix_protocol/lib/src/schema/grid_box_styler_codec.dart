import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../errors/mix_protocol_error.dart';
import 'common_codecs.dart';
import 'schema_field.dart';
import 'styler_codec_helpers.dart';
import 'wire_discriminators.dart';

SchemaObject<GridBoxStyler> gridBoxStylerSchema({
  AckSchema<JsonMap, Object>? rootStyleSchema,
}) {
  final columns = directField<GridBoxStyler, List<GridTrack>>(
    'columns',
    Ack.list(_gridTrackCodec(allowAuto: false)).nonEmpty(),
    (value) => value.$columns,
  );
  final rows = directField<GridBoxStyler, List<GridTrack>>(
    'rows',
    Ack.list(_gridTrackCodec(allowAuto: true)),
    (value) => value.$rows,
  );
  final autoRows = directField<GridBoxStyler, GridTrack>(
    'autoRows',
    _gridTrackCodec(allowAuto: true),
    (value) => value.$autoRows,
  );
  final columnGap = directField<GridBoxStyler, double>(
    'columnGap',
    nonNegativeDoubleTokenCodec(),
    (value) => value.$columnGap,
  );
  final rowGap = directField<GridBoxStyler, double>(
    'rowGap',
    nonNegativeDoubleTokenCodec(),
    (value) => value.$rowGap,
  );
  final clipBehavior = directField<GridBoxStyler, Clip>(
    'clipBehavior',
    enumNameCodec(Clip.values),
    (value) => value.$clipBehavior,
  );
  final constraintBranches =
      directField<GridBoxStyler, List<GridConstraintBranch>>(
        'constraintBranches',
        Ack.list(_gridConstraintBranchCodec()),
        (value) => value.$constraintBranches,
      );

  return stylerSchemaObject<GridBoxStyler, GridBoxSpec>(
    rootStyleSchema: rootStyleSchema,
    fields: [
      columns,
      rows,
      autoRows,
      columnGap,
      rowGap,
      clipBehavior,
      constraintBranches,
    ],
    build: (data, metadata) => GridBoxStyler(
      columns: columns.value(data),
      rows: rows.value(data),
      autoRows: autoRows.value(data),
      columnGap: columnGap.value(data),
      rowGap: rowGap.value(data),
      clipBehavior: clipBehavior.value(data),
      constraintBranches: constraintBranches.value(data),
      variants: metadata.variants?.value(data),
      modifier: metadata.modifiers.value(data),
      animation: metadata.animation.value(data),
    ),
  );
}

AckSchema<JsonMap, GridTrack> _gridTrackCodec({required bool allowAuto}) {
  return Ack.discriminated<GridTrack>(
    discriminatorKey: 'type',
    schemas: {
      gridTrackTypeFixed: Ack.object({'size': nonNegativeDoubleTokenCodec()})
          .codec<GridTrack>(
            decode: (data) => GridTrack.fixed(data['size']! as double),
            encode: (track) {
              if (track is! FixedGridTrack) {
                throw UnsupportedEncodeValueError(
                  track,
                  'Expected FixedGridTrack.',
                );
              }

              return {'size': track.size};
            },
          ),
      gridTrackTypeFraction:
          Ack.object({'fraction': positiveDoubleTokenCodec()}).codec<GridTrack>(
            decode: (data) => GridTrack.fr(data['fraction']! as double),
            encode: (track) {
              if (track is! FrGridTrack) {
                throw UnsupportedEncodeValueError(
                  track,
                  'Expected FrGridTrack.',
                );
              }

              return {'fraction': track.fraction};
            },
          ),
      if (allowAuto)
        gridTrackTypeAuto: Ack.object({}).codec<GridTrack>(
          decode: (_) => const GridTrack.auto(),
          encode: (track) {
            if (track is! AutoGridTrack) {
              throw UnsupportedEncodeValueError(
                track,
                'Expected AutoGridTrack.',
              );
            }

            return const <String, Object?>{};
          },
        ),
    },
  );
}

AckSchema<JsonMap, GridConstraintBranch> _gridConstraintBranchCodec() {
  return Ack.object({
    'breakpoint': _gridBreakpointCodec(),
    'patch': _gridLayoutPatchCodec(),
  }).codec<GridConstraintBranch>(
    decode: (data) => GridConstraintBranch(
      breakpoint: data['breakpoint']! as Breakpoint,
      patch: data['patch']! as GridLayoutPatch,
    ),
    encode: (branch) => {
      'breakpoint': branch.breakpoint,
      'patch': branch.patch,
    },
  );
}

AckSchema<JsonMap, Breakpoint> _gridBreakpointCodec() {
  return Ack.object({
        'token': tokenNameCodec().optional(),
        'minWidth': nonNegativeDoubleCodec().optional(),
        'maxWidth': nonNegativeDoubleCodec().optional(),
        'minHeight': nonNegativeDoubleCodec().optional(),
        'maxHeight': nonNegativeDoubleCodec().optional(),
      })
      .constrain(const _GridBreakpointConstraint())
      .codec<Breakpoint>(
        decode: (data) {
          final token = data['token'] as String?;
          if (token != null) return BreakpointToken(token)();

          return Breakpoint(
            minWidth: data['minWidth'] as double?,
            maxWidth: data['maxWidth'] as double?,
            minHeight: data['minHeight'] as double?,
            maxHeight: data['maxHeight'] as double?,
          );
        },
        encode: _encodeGridBreakpoint,
      );
}

AckSchema<JsonMap, GridLayoutPatch> _gridLayoutPatchCodec() {
  return Ack.object({
        'columns': Ack.list(
          _gridTrackCodec(allowAuto: false),
        ).nonEmpty().optional(),
        'rows': Ack.list(_gridTrackCodec(allowAuto: true)).optional(),
        'autoRows': _gridTrackCodec(allowAuto: true).optional(),
        'columnGap': nonNegativeDoubleTokenCodec().optional(),
        'rowGap': nonNegativeDoubleTokenCodec().optional(),
      })
      .constrain(const _GridLayoutPatchConstraint())
      .codec<GridLayoutPatch>(
        decode: (data) => GridLayoutPatch(
          columns: (data['columns'] as List<GridTrack>?),
          rows: (data['rows'] as List<GridTrack>?),
          autoRows: data['autoRows'] as GridTrack?,
          columnGap: data['columnGap'] as double?,
          rowGap: data['rowGap'] as double?,
        ),
        encode: _encodeGridLayoutPatch,
      );
}

JsonMap _encodeGridBreakpoint(Breakpoint breakpoint) {
  final JsonMap wire;
  if (breakpoint is BreakpointRef) {
    final token = encodeTokenReference(
      breakpoint.token,
      'constraintBranches.breakpoint.token',
    );
    wire = {'token': token[tokenReferenceKey]};
  } else {
    wire = {
      'minWidth': breakpoint.minWidth,
      'maxWidth': breakpoint.maxWidth,
      'minHeight': breakpoint.minHeight,
      'maxHeight': breakpoint.maxHeight,
    };
  }

  const constraint = _GridBreakpointConstraint();
  if (!constraint.isValid(wire)) {
    throw UnsupportedEncodeValueError(
      breakpoint,
      constraint.buildMessage(wire),
    );
  }

  return wire;
}

JsonMap _encodeGridLayoutPatch(GridLayoutPatch patch) {
  if (patch.isEmpty) {
    throw UnsupportedEncodeValueError(
      patch,
      'A Grid layout patch must set columns, rows, autoRows, columnGap, or '
      'rowGap.',
    );
  }

  return {
    'columns': patch.columns,
    'rows': patch.rows,
    'autoRows': patch.autoRows,
    'columnGap': patch.columnGap,
    'rowGap': patch.rowGap,
  };
}

final class _GridBreakpointConstraint extends Constraint<JsonMap>
    with Validator<JsonMap> {
  const _GridBreakpointConstraint()
    : super(
        constraintKey: 'mix_protocol_grid_breakpoint',
        description:
            'Grid breakpoints require a token or a valid width/height range.',
      );

  @override
  bool isValid(JsonMap value) {
    final token = value['token'];
    final minWidth = value['minWidth'] as double?;
    final maxWidth = value['maxWidth'] as double?;
    final minHeight = value['minHeight'] as double?;
    final maxHeight = value['maxHeight'] as double?;
    final hasBounds =
        minWidth != null ||
        maxWidth != null ||
        minHeight != null ||
        maxHeight != null;

    if (token != null) return !hasBounds;
    if (!hasBounds) return false;
    if (minWidth != null && maxWidth != null && minWidth > maxWidth) {
      return false;
    }
    if (minHeight != null && maxHeight != null && minHeight > maxHeight) {
      return false;
    }

    return true;
  }

  @override
  String buildMessage(JsonMap value) {
    if (value['token'] != null) {
      return 'A Grid breakpoint token cannot be combined with size bounds.';
    }

    return 'A Grid breakpoint requires at least one valid min/max width or '
        'height bound.';
  }
}

final class _GridLayoutPatchConstraint extends Constraint<JsonMap>
    with Validator<JsonMap> {
  const _GridLayoutPatchConstraint()
    : super(
        constraintKey: 'mix_protocol_grid_layout_patch',
        description: 'Grid layout patches must set at least one field.',
      );

  @override
  bool isValid(JsonMap value) => value.isNotEmpty;

  @override
  String buildMessage(JsonMap value) {
    return 'A Grid layout patch must set columns, rows, autoRows, columnGap, '
        'or rowGap.';
  }
}
