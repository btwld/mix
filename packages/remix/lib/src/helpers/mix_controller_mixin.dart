import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

abstract class Disableable {
  /// {@macro remix.component.enabled}
  final bool enabled;

  const Disableable({required this.enabled});
}

abstract class Selectable {
  /// {@macro remix.component.selected}
  final bool selected;

  const Selectable({required this.selected});
}

abstract class Errorable {
  /// {@macro remix.component.error}
  final bool error;

  const Errorable({required this.error});
}

mixin MixControllerMixin<T extends StatefulWidget> on State<T> {
  late final WidgetStatesController mixController;

  @override
  void initState() {
    super.initState();
    mixController = WidgetStatesController();
  }

  @override
  void dispose() {
    mixController.dispose();
    super.dispose();
  }
}

mixin DisableableMixin<T extends StatefulWidget> on MixControllerMixin<T> {
  Disableable get _disableable => widget as Disableable;

  @override
  void initState() {
    super.initState();
    mixController.disabled = !_disableable.enabled;
  }

  @override
  void didUpdateWidget(T oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldDisableable = oldWidget as Disableable;
    if (oldDisableable.enabled != _disableable.enabled) {
      mixController.disabled = !_disableable.enabled;
    }
  }
}

mixin SelectableMixin<T extends StatefulWidget> on MixControllerMixin<T> {
  Selectable get _selectable => widget as Selectable;

  @override
  void initState() {
    super.initState();
    mixController.selected = _selectable.selected;
  }

  @override
  void didUpdateWidget(T oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldSelectable = oldWidget as Selectable;
    if (oldSelectable.selected != _selectable.selected) {
      mixController.selected = _selectable.selected;
    }
  }
}

mixin ErrorableMixin<T extends StatefulWidget> on MixControllerMixin<T> {
  Errorable get _errorable => widget as Errorable;

  @override
  void initState() {
    super.initState();
    mixController.error = _errorable.error;
  }

  @override
  void didUpdateWidget(T oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldErrorable = oldWidget as Errorable;
    if (oldErrorable.error != _errorable.error) {
      mixController.error = _errorable.error;
    }
  }
}
