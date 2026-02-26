import 'package:flutter/material.dart';

import '../ast/schema_node.dart';
import '../ast/schema_values.dart';
import '../events/schema_event.dart';
import '../tokens/schema_token_resolver.dart';
import '../trust/schema_trust.dart';
import '../validate/diagnostics.dart';
import 'schema_data_context.dart';

/// Context passed to handlers during rendering.
///
/// Provides value resolution, child building, event dispatch, and
/// render-time diagnostic collection.
final class RenderContext {
  final SchemaTokenResolver tokenResolver;
  final SchemaTrust trust;
  final SchemaDataContext? dataContext;
  final void Function(SchemaEvent)? onEvent;
  final List<SchemaDiagnostic> diagnostics; // mutable, collects render-time warnings

  // Internal: reference to the build function for recursive child rendering
  final Widget Function(SchemaNode node, RenderContext context) _buildNode;

  RenderContext({
    required this.tokenResolver,
    required this.trust,
    required Widget Function(SchemaNode, RenderContext) buildNode,
    this.dataContext,
    this.onEvent,
    List<SchemaDiagnostic>? diagnostics,
  })  : _buildNode = buildNode,
        diagnostics = diagnostics ?? [];

  /// Create a copy with overridden fields (used by RepeatHandler for scoped data).
  RenderContext copyWith({
    SchemaDataContext? dataContext,
    SchemaTrust? trust,
  }) =>
      RenderContext(
        tokenResolver: tokenResolver,
        trust: trust ?? this.trust,
        buildNode: _buildNode,
        dataContext: dataContext ?? this.dataContext,
        onEvent: onEvent,
        diagnostics: diagnostics,
      );

  /// Recursively render a child node.
  Widget buildChild(SchemaNode child) => _buildNode(child, this);

  /// Resolve a SchemaValue to a concrete Dart value.
  T? resolveValue<T>(SchemaValue? value, BuildContext context) {
    if (value == null) return null;
    return switch (value) {
      DirectValue<T>(value: final v) => v,
      DirectValue(value: final v) => v is T ? v : _tryNumConversion<T>(v),
      TokenRef() => tokenResolver.resolve<T>(value, context),
      AdaptiveValue() => _resolveAdaptive<T>(value, context),
      ResponsiveValue() => _resolveResponsive<T>(value, context),
      BindingValue() => dataContext?.lookup<T>(value.path),
      TransformValue() => _resolveTransform<T>(value, context),
    };
  }

  /// Try numeric conversion (e.g., int → double).
  T? _tryNumConversion<T>(dynamic v) {
    if (T == double && v is num) return v.toDouble() as T;
    if (T == int && v is num) return v.toInt() as T;
    return null;
  }

  T? _resolveAdaptive<T>(AdaptiveValue value, BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return resolveValue<T>(isDark ? value.dark : value.light, context);
  }

  T? _resolveResponsive<T>(ResponsiveValue value, BuildContext context) {
    if (value.breakpoints.isEmpty) return null;

    final width = MediaQuery.sizeOf(context).width;
    final key =
        width < 768 ? 'mobile' : width < 1024 ? 'tablet' : 'desktop';
    final fallback =
        value.breakpoints['default'] ?? value.breakpoints.values.first;
    final selected = value.breakpoints[key] ?? fallback;

    return resolveValue<T>(selected, context);
  }

  T? _resolveTransform<T>(TransformValue value, BuildContext context) {
    final raw = dataContext?.lookup<dynamic>(value.path);
    if (raw == null) return null;

    final transformed = SchemaTransforms.closed.apply(
      value.transformKey,
      raw,
      context,
    );
    if (transformed == null) {
      diagnostics.add(
        SchemaDiagnostic(
          code: DiagnosticCode.unknownTransformKey,
          severity: DiagnosticSeverity.warning,
          path: value.path,
          message:
              'Unknown transform "${value.transformKey}" — using raw bound value',
        ),
      );
      return raw is T ? raw : null;
    }

    return transformed is T ? transformed : null;
  }
}
