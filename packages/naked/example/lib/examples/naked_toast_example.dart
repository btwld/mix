import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:naked/naked.dart';

class NakedToastExample extends StatefulWidget {
  const NakedToastExample({super.key});

  @override
  State<NakedToastExample> createState() => _NakedToastExampleState();
}

class _NakedToastExampleState extends State<NakedToastExample> {
  Alignment? alignment = Alignment.topRight;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          spacing: 8,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: ClipRRect(
                // borderRadius: BorderRadius.circular(16),
                child: ToastLayer(
                  alignment: alignment!,
                  child: Container(
                    color: Colors.blueGrey.shade50,
                    child: Center(
                      child: Builder(builder: (context) {
                        void addToast(NakedToastEntry toast) {
                          NakedToastLayer.of(context).addToast(toast);
                        }

                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 24,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent.shade400,
                              ),
                              onPressed: () {
                                addToast(
                                  NakedToastEntry(
                                    context: context,
                                    toast: (context, remove) =>
                                        buildToastContainer(
                                      remove,
                                      'Alert',
                                      Icons.error,
                                      Colors.redAccent.shade700,
                                    ),
                                  ),
                                );
                              },
                              child: const Text('Alert'),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent.shade400,
                              ),
                              onPressed: () {
                                // _insertItem();
                                addToast(
                                  NakedToastEntry(
                                    context: context,
                                    toast: (context, remove) =>
                                        buildToastContainer(
                                      remove,
                                      'Info',
                                      Icons.info,
                                      Colors.blueAccent.shade700,
                                    ),
                                  ),
                                );
                              },
                              child: const Text('Info'),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.greenAccent.shade700,
                              ),
                              onPressed: () {
                                addToast(
                                  NakedToastEntry(
                                    context: context,
                                    toast: (context, remove) =>
                                        buildToastContainer(
                                      remove,
                                      'Success',
                                      Icons.check_circle,
                                      Colors.greenAccent.shade700,
                                    ),
                                  ),
                                );
                              },
                              child: const Text('Success'),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                DropdownButton(
                  value: alignment,
                  items: const [
                    DropdownMenuItem(
                      value: Alignment.topLeft,
                      child: Text('Top Left'),
                    ),
                    DropdownMenuItem(
                      value: Alignment.topRight,
                      child: Text('Top Right'),
                    ),
                    DropdownMenuItem(
                      value: Alignment.bottomLeft,
                      child: Text('Bottom Left'),
                    ),
                    DropdownMenuItem(
                      value: Alignment.bottomRight,
                      child: Text('Bottom Right'),
                    ),
                  ],
                  onChanged: (a) {
                    setState(() {
                      alignment = a;
                    });
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildToastContainer(void Function() remove, String label,
      IconData icon, Color backgroundColor) {
    return ToastContainer(
      label: label,
      icon: icon,
      onClose: remove,
      backgroundColor: backgroundColor,
    );
  }
}

class ToastContainer extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onClose;
  final Color? backgroundColor;
  const ToastContainer({
    super.key,
    required this.label,
    required this.icon,
    required this.onClose,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
          const Spacer(),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: const Icon(
              Icons.close,
              color: Colors.white,
              size: 20,
            ),
            onPressed: onClose,
          ),
        ],
      ),
    );
  }
}

class ToastLayer extends StatefulWidget {
  final Widget child;
  final Alignment alignment;

  const ToastLayer({
    super.key,
    required this.child,
    required this.alignment,
  });

  @override
  State<ToastLayer> createState() => _ToastLayerState();
}

class _ToastLayerState extends State<ToastLayer> {
  static final listKey = GlobalKey<AnimatedListState>();

  void removeAnimatedToast(NakedToastEntry entry) {
    final index = NakedToastLayer.of(entry.context).removeToast(entry);

    if (index == null) return;

    _ToastLayerState.listKey.currentState?.removeItem(
      index,
      (context, animation) => _AnimationTransformer(
        animation: animation,
        alignment: Alignment.topLeft,
        child: entry.build(
          () => (),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return NakedToastLayer(
      onRemove: (entry) => removeAnimatedToast(entry),
      toastWidget: Align(
        alignment: widget.alignment,
        child: SizedBox(
          width: 200,
          child: ToastEntries(
            listKey: listKey,
            onRemove: removeAnimatedToast,
          ),
        ),
      ),
      child: widget.child,
    );
  }
}

class ToastEntries extends StatefulWidget {
  const ToastEntries({
    super.key,
    required this.listKey,
    required this.onRemove,
  });

  final GlobalKey<AnimatedListState> listKey;
  final void Function(NakedToastEntry) onRemove;

  @override
  State<ToastEntries> createState() => _ToastEntriesState();
}

class _ToastEntriesState extends State<ToastEntries> {
  List<NakedToastEntry> entries = [];
  List<NakedToastEntry> oldEntries = [];

  @override
  void initState() {
    super.initState();
    final toastStream = NakedToastLayer.of(context).toastStream;
    toastStream.listen(_listenEntries);
  }

  void _listenEntries(newEntries) {
    oldEntries = entries;
    entries = newEntries;

    if (oldEntries.length > entries.length) return;

    widget.listKey.currentState?.insertItem(entries.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      shrinkWrap: true,
      key: widget.listKey,
      initialItemCount: entries.length,
      itemBuilder: (context, index, animation) {
        return _AnimationTransformer(
          animation: animation,
          alignment: Alignment.topLeft,
          child: entries[index].build(
            () => widget.onRemove(entries[index]),
          ),
        );
      },
    );
  }
}

class _AnimationTransformer extends AnimatedWidget {
  const _AnimationTransformer({
    required Animation<double> animation,
    required this.alignment,
    required this.child,
  }) : super(listenable: animation);

  Animation<double> get animation => listenable as Animation<double>;

  final AlignmentGeometry alignment;

  final Widget child;
  @override
  Widget build(BuildContext context) {
    final alignment = this.alignment.resolve(Directionality.of(context));

    final slideInAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: animation,
        curve: const Interval(
          0,
          0.6,
          curve: Curves.easeInOut,
        ),
      ),
    );

    final targetAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: animation,
        curve: const Interval(
          0.3,
          1,
          curve: Curves.easeInOut,
        ),
      ),
    );

    return Align(
      heightFactor: math.max(slideInAnimation.value, 0.0),
      alignment: alignment,
      child: DefaultToastificationTransition(
        animation: targetAnimation,
        alignment: Alignment.topLeft,
        child: child,
      ),
    );
  }
}

class DefaultToastificationTransition extends AnimatedWidget {
  const DefaultToastificationTransition({
    super.key,
    required Animation<double> animation,
    required this.alignment,
    this.child,
  }) : super(listenable: animation);

  Animation<double> get animation => listenable as Animation<double>;

  final AlignmentGeometry alignment;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final alignment = this.alignment.resolve(Directionality.of(context));

    final isCenter = alignment.x == 0;

    final slideOffset = isCenter
        ? alignment.y >= 0
            ? const Offset(0, 1)
            : const Offset(0, -1)
        : alignment.x >= 0
            ? const Offset(1, 0)
            : const Offset(-1, 0);

    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: slideOffset,
          end: const Offset(0, 0),
        ).animate(animation),
        child: child,
      ),
    );
  }
}
