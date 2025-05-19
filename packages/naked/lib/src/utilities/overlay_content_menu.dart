import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// A container for menu items that handles click-outside behavior.
///
/// This component should wrap the menu content to enable closing the menu
/// when clicking outside. It also provides proper event handling and
/// positioning for the menu items.
class NakedOverlayContentMenu extends StatefulWidget {
  /// The menu content to display.
  /// This should contain the menu items and any other menu content.
  final Widget child;

  /// Whether to consume outside taps or let them pass through.
  /// When true, taps outside the menu will be consumed and trigger the onClose callback.
  final bool consumeOutsideTaps;

  /// Called when the menu should close.
  /// This is triggered by clicks outside the menu or pressing escape.
  final VoidCallback? onClose;

  /// The controller that manages the overlay visibility.
  final OverlayPortalController controller;

  /// Called when a key event is detected.
  /// Can be used to handle custom key events.
  final void Function(KeyEvent)? onKeyEvent;

  /// Creates a naked menu content container.
  ///
  /// The [child] parameter is required and should contain the menu items.
  const NakedOverlayContentMenu({
    super.key,
    required this.child,
    required this.consumeOutsideTaps,
    required this.onClose,
    required this.controller,
    this.onKeyEvent,
  });

  @override
  State<NakedOverlayContentMenu> createState() =>
      _NakedOverlayContentMenuState();
}

class _NakedOverlayContentMenuState extends State<NakedOverlayContentMenu> {
  final _focusScopeNode = FocusScopeNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _focusScopeNode.requestScopeFocus();
    });
  }

  @override
  void dispose() {
    _focusScopeNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: _kMenuTraversalShortcuts,
      child: Actions(
        actions: {
          if (widget.controller.isShowing && widget.onClose != null)
            DismissIntent: _DismissAction(onDismiss: widget.onClose),
        },
        child: TapRegion(
          consumeOutsideTaps: widget.consumeOutsideTaps,
          onTapOutside: (_) => widget.onClose?.call(),
          child: KeyboardListener(
            focusNode: _focusScopeNode,
            onKeyEvent: widget.onKeyEvent,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

const Map<ShortcutActivator, Intent> _kMenuTraversalShortcuts =
    <ShortcutActivator, Intent>{
  SingleActivator(LogicalKeyboardKey.gameButtonA): ActivateIntent(),
  SingleActivator(LogicalKeyboardKey.escape): DismissIntent(),
  SingleActivator(LogicalKeyboardKey.arrowDown):
      DirectionalFocusIntent(TraversalDirection.down),
  SingleActivator(LogicalKeyboardKey.arrowUp):
      DirectionalFocusIntent(TraversalDirection.up),
  SingleActivator(LogicalKeyboardKey.arrowLeft):
      DirectionalFocusIntent(TraversalDirection.left),
  SingleActivator(LogicalKeyboardKey.arrowRight):
      DirectionalFocusIntent(TraversalDirection.right),
};

class _DismissAction extends Action<DismissIntent> {
  final VoidCallback? onDismiss;

  _DismissAction({this.onDismiss});

  @override
  void invoke(DismissIntent intent) {
    onDismiss?.call();
  }
}
