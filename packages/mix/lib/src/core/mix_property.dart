import 'package:flutter/foundation.dart';

import '../theme/tokens/mix_token.dart';
import 'factory/mix_context.dart';
import 'mix_element.dart';

// Base interface for all mix properties
@immutable
abstract class BaseMixProp<T extends Object> {
  final List<MixDirective<T>>? directives;

  const BaseMixProp({this.directives});

  // Common interface methods
  T? resolve(MixContext context);
  BaseMixProp<T> merge(covariant BaseMixProp<T>? other);

  // Helper to merge directive lists
  List<MixDirective<T>>? mergeDirectives(List<MixDirective<T>>? other) {
    if (directives == null && other == null) return null;
    if (directives == null) return other;
    if (other == null) return directives;

    return [...?directives, ...other];
  }

  // Protected helper to apply directives
  @protected
  T applyDirectives(T value) {
    if (directives == null) return value;

    var result = value;
    for (final directive in directives!) {
      result = directive.modify(result);
    }

    return result;
  }
}

/// Property for simple Mix values and tokens.
///
/// Merge behavior:
/// - Mix + Mix = override (last wins)
/// - Token + Token = override (last wins)
/// - Token + Mix = override (last wins)
/// - Mix + Token = override (last wins)
@immutable
class MixProp<T extends Object> {
  final List<MixDirective<T>> directives;
  final List<MixPropItem<T>> items;

  const MixProp._({this.items = const [], this.directives = const []});

  factory MixProp(Mix<T>? mix, {List<MixDirective<T>>? directives}) {
    return MixProp._(
      items: [if (mix != null) MixPropItem(mix)],
      directives: directives ?? const [],
    );
  }

  // Factory constructor for list types: MixProp<List<String>> accepts List<Mix<String>>
  factory MixProp.fromList(
    List<Mix<Object>>? mixes, {
    List<MixDirective<T>>? directives,
  }) {
    return MixProp._(
      items: [if (mixes != null) MixPropItem.fromList(mixes)],
      directives: directives ?? const [],
    );
  }

  // Empty constructor for default values
  const MixProp.empty() : this._();

  @visibleForTesting
  List<MixDirective<T>> mergeDirectives(List<MixDirective<T>>? other) {
    return [...directives, ...?other];
  }

  @visibleForTesting
  T applyDirectives(List<T> values) {
    if (directives.isEmpty) {
      return values.first;
    }

    var result = values.first;
    for (final directive in directives) {
      result = directive.modify(result);
    }

    return result;
  }

  T? resolve(MixContext context) {
    final resolvedValues = items.map((item) => item.resolve(context)).toList();
    if (resolvedValues.contains(null)) return null;

    return applyDirectives(resolvedValues);
  }

  MixProp<T> merge(MixProp<T>? other) {
    if (other == null) return this;

    // For simple MixProp, other always wins (override behavior)
    return MixProp._(
      items: [...items, ...other.items],
      directives: mergeDirectives(other.directives),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MixProp<T> &&
          runtimeType == other.runtimeType &&
          listEquals(directives, other.directives) &&
          listEquals(items, other.items);

  @override
  int get hashCode => items.hashCode ^ directives.hashCode;
}

// Sealed class for items in composite
@immutable
sealed class MixPropItem<T> {
  const MixPropItem._();

  factory MixPropItem(Mix<T> mix) {
    return _MixItem(mix);
  }

  factory MixPropItem.fromList(List<Mix<Object>> mixes) {
    return _ListMixItem(mixes);
  }

  const factory MixPropItem.token(MixableToken<Mix<T>> token) = _TokenItem<T>;

  T resolve(MixContext mix);
}

// Private mix item
@immutable
class _MixItem<T> extends MixPropItem<T> {
  final Mix<T> mix;

  const _MixItem(this.mix) : super._();

  @override
  T resolve(MixContext context) => mix.resolve(context);
}

// Private token item
@immutable
class _TokenItem<T> extends MixPropItem<T> {
  final MixableToken<Mix<T>> token;

  const _TokenItem(this.token) : super._();

  @override
  T resolve(MixContext mix) {
    final mixValue = mix.scope.getToken(token, mix.context);

    return mixValue.resolve(mix);
  }
}

// Private list mix item for handling List<Mix<ElementType>> -> List<ElementType>
@immutable
class _ListMixItem<T> extends MixPropItem<T> {
  final List<Mix<Object>> mixes;

  const _ListMixItem(this.mixes) : super._();

  @override
  T resolve(MixContext context) {
    // Resolve each Mix<ElementType> and collect into List<ElementType>
    final resolved = mixes.map((mix) => mix.resolve(context)).toList();

    return resolved as T; // T should be List<ElementType>
  }
}
