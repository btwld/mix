import 'package:flutter/foundation.dart';

/// Variant identity recorded on a built style spec for transition selection.
///
/// [animationOwner] is the path of the active variant that set the resolved
/// animation config, if any. [active] holds the paths of every active variant.
@internal
typedef VariantActivation = ({Object? animationOwner, Set<Object> active});

// Keyed by spec instance so activation never takes part in spec equality.
final _activations = Expando<VariantActivation>('variant activation');

/// Returns the variant activation attached to [spec], if any.
@internal
VariantActivation? readVariantActivation(Object spec) => _activations[spec];

/// Attaches [activation] to [spec].
///
/// Only attach to an instance created for this purpose, never to a shared or
/// const instance.
@internal
void attachVariantActivation(Object spec, VariantActivation activation) {
  _activations[spec] = activation;
}

/// Copies the variant activation of [from], if any, onto [to].
@internal
void copyVariantActivation(Object from, Object to) {
  final activation = _activations[from];
  if (activation != null) _activations[to] = activation;
}
