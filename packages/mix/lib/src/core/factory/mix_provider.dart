import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'mix_context.dart';
import 'style_mix.dart';

/// Provides [MixContext] to the widget tree.
class Mix extends InheritedWidget {
  /// Stores [MixContext] and wraps a [child] widget.
  const Mix({required this.data, required super.child, super.key});

  /// Retrieves the nearest [MixContext] from the widget tree. Returns null if not found.
  static MixContext? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Mix>()?.data;
  }

  static MixContext? maybeOfInherited(BuildContext context) {
    return maybeOf(context)?.toInheritable();
  }

  /// Retrieves the nearest [MixContext] from the widget tree. Throws if not found.
  static MixContext of(BuildContext context) {
    final mixData = maybeOf(context);
    assert(mixData != null, 'Mix not found in widget tree.');

    return mixData!;
  }

  final MixContext? data;

  @override
  bool updateShouldNotify(Mix oldWidget) => data != oldWidget.data;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);

    properties.add(DiagnosticsProperty<MixContext>(
      'attributes',
      data,
      expandableValue: true,
    ));
  }

  /// Builds a [Mix] widget.
  ///
  /// The [context] and [style] are used to create a [MixContext] instance.
  /// The [builder] is a function that takes the created [MixContext] and returns a widget.
  ///
  /// If [inherit] is set to true (default is false), the method will attempt to find the nearest
  /// [Mix] widget up the tree from the provided [context] and merge its [MixContext] with the newly created one.
  /// This allows the new [Mix] widget to inherit styles from its ancestors.
  ///
  /// Returns a [Mix] widget with the given [MixContext] and child widget built by the [builder].
  /// If [inherit] is true and a [Mix] widget is found up the tree, the returned [Mix] widget's
  /// [MixContext] will be a merge of the ancestor's and the newly created one.
  static Mix build(
    BuildContext context, {
    required Style style,
    required Widget Function(MixContext mix) builder,
  }) {
    MixContext mixData = MixContext.create(context, style);

    // Returns a Mix widget with the given data and child.
    // If `inherit` is true, the data from the nearest Mix widget in the widget tree
    // (if any) is merged with the provided data.
    return Mix(data: mixData, child: builder(mixData));
  }
}
