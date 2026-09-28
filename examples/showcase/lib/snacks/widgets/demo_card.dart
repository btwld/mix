import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mix/mix.dart';

import '../theme.dart';

class DemoCard extends StatefulWidget {
  const DemoCard({
    super.key,
    required this.title,
    required this.caption,
    required this.sourceAsset,
    required this.child,
    this.height = 220,
  });

  final String title;
  final String caption;
  final String sourceAsset;
  final Widget child;
  final double height;

  @override
  State<DemoCard> createState() => _DemoCardState();
}

class _DemoCardState extends State<DemoCard> {
  final _copyTooltipKey = GlobalKey<TooltipState>();
  Timer? _feedbackTimer;
  bool _copied = false;

  @override
  void dispose() {
    _feedbackTimer?.cancel();
    super.dispose();
  }

  Future<void> _copySource() async {
    _feedbackTimer?.cancel();
    try {
      final source = await rootBundle.loadString(widget.sourceAsset);
      await Clipboard.setData(ClipboardData(text: source));
      if (!mounted) return;
      setState(() => _copied = true);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _copyTooltipKey.currentState?.ensureTooltipVisible();
      });
      _feedbackTimer = Timer(const Duration(milliseconds: 1500), () {
        if (mounted) setState(() => _copied = false);
      });
    } on Object {
      if (!mounted) return;
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        const SnackBar(content: Text('Could not copy the DartPad snippet.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Box(
      style: BoxStyler()
          .color($card())
          .borderRadius(.all($radius2xl()))
          .padding(.all(18))
          .border(.color(const Color(0x14FFFFFF)).width(1)),
      child: ColumnBox(
        style: FlexBoxStyler()
            .spacing(6)
            .crossAxisAlignment(.start)
            .mainAxisSize(.min),
        children: [
          RowBox(
            style: FlexBoxStyler().crossAxisAlignment(.center),
            children: [
              Expanded(child: StyledText(widget.title, style: snacksTitle())),
              Tooltip(
                key: _copyTooltipKey,
                message: _copied
                    ? 'Copied'
                    : 'Copy ${widget.title} DartPad snippet',
                showDuration: const Duration(milliseconds: 1500),
                child: PressableBox(
                  key: Key('copy-${widget.title}'),
                  semanticsLabel: _copied
                      ? '${widget.title} snippet copied'
                      : 'Copy ${widget.title} DartPad snippet',
                  onPress: () => unawaited(_copySource()),
                  style: BoxStyler()
                      .size(32, 32)
                      .alignment(.center)
                      .borderRadius(.all($radiusXs()))
                      .color($track())
                      .onHovered(.color($hover()))
                      .onPressed(.scale(0.94))
                      .animate(.easeOut(160.ms)),
                  child: StyledIcon(
                    icon: _copied
                        ? Icons.check_rounded
                        : Icons.content_copy_rounded,
                    style: IconStyler()
                        .size(15)
                        .color(_copied ? $success() : $muted()),
                  ),
                ),
              ),
            ],
          ),
          StyledText(widget.caption, style: snacksMuted()),
          Box(
            style: BoxStyler()
                .margin(.top(12))
                .color($playground())
                .borderRadius(.all($radiusXl()))
                .height(widget.height)
                .alignment(.center)
                .clipBehavior(.antiAlias)
                .padding(.all(16)),
            child: LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: constraints.maxWidth < 320
                      ? 320
                      : constraints.maxWidth,
                  height: constraints.maxHeight,
                  child: Center(child: widget.child),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
