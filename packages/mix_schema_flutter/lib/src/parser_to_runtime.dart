/// Bridge from `mix_schema` typed model to Mix runtime objects
/// (`BoxStyler`, `TextStyler`, ...).
///
/// Two-stage parsing per IMPLEMENTATION.md:
///   1. canonical JSON → typed model (Phase 5, in `mix_schema`).
///   2. typed model → Mix runtime objects (this file).
///
/// Resolution order at runtime:
///   * Tokens via inline bundle → `MixScope` → `token.unresolved`.
///   * Host refs via [HostResolver] → `host.unresolved`.
///
/// Note: this is the foundational shape. The full runtime conversion
/// surface (per-prop styler builder, modifier ordering, variant
/// activation, animation attach) lands incrementally. The typed model
/// from `mix_schema` is the source of truth for what shapes exist.
library;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_schema/mix_schema.dart';

import 'host_resolver.dart';

/// Walks a `mix_schema` typed model and produces Mix runtime objects.
class RuntimeParser {
  RuntimeParser({required this.scope, this.hostResolver = const EmptyHostResolver()});

  /// Mix scope used for token resolution. Consumer must construct one
  /// with the appropriate token bindings.
  final MixScope scope;

  /// Resolves `HostRef` ids to runtime objects. Returns `null` for
  /// unknown ids.
  final HostResolver hostResolver;

  /// Convert a `mix_schema` [WidgetNode] into a Flutter [Widget] tree.
  ///
  /// This is the consumer-facing entry point. Walks the typed tree and
  /// dispatches to the matching Mix widget.
  Widget toWidget(WidgetNode node) {
    return switch (node) {
      WidgetBox _ => _buildBox(node),
      WidgetStyledText _ => _buildStyledText(node),
      WidgetFlexBox _ => _buildFlexBox(node),
      WidgetRowBox _ => _buildFlexBox(node, direction: Axis.horizontal),
      WidgetColumnBox _ => _buildFlexBox(node, direction: Axis.vertical),
      _ => throw UnimplementedError(
          'Runtime conversion for ${node.widget} is not yet implemented',
        ),
    };
  }

  Widget _buildBox(WidgetBox node) {
    final child = node.child == null ? null : toWidget(node.child!);
    final styler = node.style == null ? null : _toBoxStyler(node.style!);
    if (styler == null) {
      return Box(child: child);
    }
    return Box(style: styler, child: child);
  }

  Widget _buildFlexBox(WidgetNode node, {Axis? direction}) {
    final children = switch (node) {
      WidgetFlexBox n => n.children,
      WidgetRowBox n => n.children,
      WidgetColumnBox n => n.children,
      _ => const <WidgetNode>[],
    };
    // TODO(mix_schema_flutter): apply direction-specific FlexBoxStyler.
    // For now, a plain FlexBox is sufficient for the Phase 6 shape.
    return FlexBox(
      children: [for (final c in children) toWidget(c)],
    );
  }

  Widget _buildStyledText(WidgetStyledText node) =>
      StyledText(node.text);

  /// Build a `BoxStyler` from a `mix_schema` [StyleNode]. Currently a
  /// placeholder — returns the empty styler. Full per-prop conversion
  /// expands here as the bridge matures.
  BoxStyler _toBoxStyler(StyleNode node) {
    if (node is! StyleBox) {
      throw UnimplementedError(
        'Cannot convert spec=${node.spec} to BoxStyler yet',
      );
    }
    // TODO(mix_schema_flutter): per-prop dispatch using registry.
    // Currently returns an empty styler so downstream consumers see a
    // well-formed Mix runtime object.
    return BoxStyler();
  }
}
