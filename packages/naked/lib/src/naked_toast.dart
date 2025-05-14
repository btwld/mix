import 'dart:async';

import 'package:flutter/material.dart';

typedef NakedToastBuilder = Widget Function(
  BuildContext context,
  VoidCallback remove,
);

typedef NakedToastLayerBuilder = Widget Function(
  BuildContext context,
  List<NakedToastEntry> entries,
);

class NakedToastEntry {
  final BuildContext context;
  final NakedToastBuilder toast;
  final Duration duration;
  final DateTime startTime;

  NakedToastEntry({
    required this.context,
    required this.toast,
    this.duration = const Duration(seconds: 2),
  }) : startTime = DateTime.now();

  Widget build(VoidCallback remove) {
    return toast(context, remove);
  }

  @override
  bool operator ==(Object other) {
    return other is NakedToastEntry && startTime == other.startTime;
  }

  @override
  int get hashCode => startTime.hashCode;
}

extension on List<_TimerToastEntry> {
  List<NakedToastEntry> get toEntry => map((e) => e.entry).toList();
}

class _TimerToastEntry {
  final Timer timer;
  final NakedToastEntry entry;

  const _TimerToastEntry({
    required this.timer,
    required this.entry,
  });
}

class NakedToastLayer extends StatefulWidget {
  final Widget child;
  final Widget toastWidget;
  final void Function(NakedToastEntry) onRemove;

  const NakedToastLayer({
    super.key,
    required this.child,
    required this.toastWidget,
    required this.onRemove,
  });

  static NakedToastLayerState of(BuildContext context) {
    final state = context.findAncestorStateOfType<NakedToastLayerState>();

    if (state == null) {
      throw Exception('NakedToastLayer not found in context');
    }

    return state;
  }

  @override
  State<NakedToastLayer> createState() => NakedToastLayerState();
}

class NakedToastLayerState extends State<NakedToastLayer> {
  final _toastController = StreamController<List<NakedToastEntry>>();
  Stream<List<NakedToastEntry>> get toastStream => _toastController.stream;

  List<_TimerToastEntry> _toasts = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    for (final toast in _toasts) {
      toast.timer.cancel();
    }
    _toastController.close();
    super.dispose();
  }

  void addToast(NakedToastEntry toast) {
    final timer = Timer(toast.duration, () {
      widget.onRemove(toast);
    });

    _toasts = [
      ..._toasts,
      _TimerToastEntry(
        timer: timer,
        entry: toast,
      ),
    ];

    _toastController.add(_toasts.toEntry);
  }

  int? removeToast(NakedToastEntry toast) {
    final index = indexOf(toast);

    if (index == null) return null;

    _toasts[index].timer.cancel();
    _toasts.removeAt(index);
    _toastController.add(_toasts.toEntry);
    return index;
  }

  int? indexOf(NakedToastEntry toast) {
    final index = _toasts.indexWhere(
      (e) => e.entry.startTime == toast.startTime,
    );

    return index == -1 ? null : index;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        widget.toastWidget,
      ],
    );
  }
}
