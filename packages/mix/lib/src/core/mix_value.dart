import 'package:flutter/foundation.dart';

import '../theme/tokens/mix_token.dart';
import 'factory/mix_context.dart';
import 'mix_element.dart';

/// Property for simple Mix values and tokens.
///
/// Merge behavior:
/// - Mix + Mix = override (last wins)
/// - Token + Token = override (last wins)
/// - Token + Mix = override (last wins)
/// - Mix + Token = override (last wins)
@immutable
final class MixValue<T> {
  final List<MixDirective<T>> directives;
  final List<MixPropItem<T>> items;

  const MixValue._({this.items = const [], this.directives = const []});

  factory MixValue({Mix<T>? mix, List<MixDirective<T>>? directives}) {
    return MixValue._(
      items: [if (mix != null) MixPropItem(mix)],
      directives: directives ?? const [],
    );
  }

  // Convenience constructor for just a mix value
  factory MixValue.mix(Mix<T> mix) {
    return MixValue._(items: [MixPropItem(mix)], directives: const []);
  }

  factory MixValue.token(MixableToken<T>? token) {
    return MixValue._(
      items: [if (token != null) MixPropItem.token(token)],
      directives: const [],
    );
  }

  // directives can be applied to the MixProp
  factory MixValue.withDirectives(
    Mix<T>? mix, {
    List<MixDirective<T>>? directives,
  }) {
    return MixValue._(
      items: [if (mix != null) MixPropItem(mix)],
      directives: directives ?? const [],
    );
  }

  // Factory constructor for list types: MixProp<List<String>> accepts List<Mix<String>>
  factory MixValue.fromList(
    List<Mix<Object>>? mixes, {
    List<MixDirective<T>>? directives,
  }) {
    return MixValue._(
      items: [if (mixes != null) MixPropItem.fromList(mixes)],
      directives: directives ?? const [],
    );
  }

  // Empty constructor for default values
  const MixValue.empty() : this._();

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

  MixValue<T> merge(MixValue<T>? other) {
    if (other == null) return this;

    // For simple MixProp, other always wins (override behavior)
    return MixValue._(
      items: [...items, ...other.items],
      directives: mergeDirectives(other.directives),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MixValue<T> &&
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

  const factory MixPropItem.token(MixableToken<T> token) = _TokenItem<T>;

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
  final MixableToken<T> token;

  const _TokenItem(this.token) : super._();

  @override
  T resolve(MixContext mix) {
    return mix.scope.getToken(token, mix.context);
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
