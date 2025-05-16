import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:naked/naked.dart';

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

/// A fully customizable menu with no default styling.
///
/// NakedMenu provides interaction behavior and accessibility features
/// for a dropdown menu without imposing any visual styling,
/// giving consumers complete control over appearance through direct state callbacks.
///
/// This component uses [NakedPortal] to render menu content in the app overlay,
/// ensuring proper z-index and maintaining context inheritance across the component tree.
///
/// Example:
/// ```dart
/// final controller = OverlayPortalController();
///
/// NakedMenu(
///   builder: (_) => NakedButton(
///     onPressed: () => controller.show(),
///     child: const Text('Open Menu'),
///   ),
///   overlayBuilder: (_) => Container(
///     decoration: BoxDecoration(
///       color: Colors.white,
///       borderRadius: BorderRadius.circular(8),
///       border: Border.all(color: Colors.grey),
///     ),
///     constraints: const BoxConstraints(
///       minWidth: 100,
///     ),
///     child: Column(
///       mainAxisSize: MainAxisSize.min,
///       children: [
///         NakedMenuItem(
///           onPressed: () => print('Item 1'),
///           child: const Text('Item 1'),
///         ),
///         NakedMenuItem(
///           onPressed: () => print('Item 2'),
///           child: const Text('Item 2'),
///         ),
///       ],
///     ),
///   ),
///   controller: controller,
///   onClose: () => controller.hide(),
/// )
/// ```
///
/// The menu is controlled through the [controller] and [onClose] callback.
/// When open, the menu content will be positioned relative to the target using [menuAlignment]
/// and any offset specified in the PositionConfig. If the menu doesn't fit in the preferred position,
/// it will try the positions specified in [fallbackAlignments].
///
/// Focus management and keyboard navigation are handled automatically. The menu can be closed
/// by pressing Escape, clicking outside (if [consumeOutsideTaps] is true), or selecting an
/// item (if [closeOnSelect] is true). When opened, focus is automatically moved to the menu
/// content.
///
/// For accessibility, the menu supports screen readers and keyboard navigation.
/// Menu items should use [NakedMenuItem] which provides proper interaction states
/// and accessibility features.
class NakedMenu extends StatefulWidget {
  /// The target widget that triggers the menu.
  /// This is typically a button or other interactive element.
  final WidgetBuilder builder;

  /// The menu widget to display when open.
  /// This is the content displayed in the overlay when the menu is open.
  final WidgetBuilder overlayBuilder;

  /// Called when the menu should close.
  final VoidCallback? onClose;

  /// Whether to close the menu when an item is selected.
  final bool closeOnSelect;

  /// Whether to automatically focus the menu when opened.
  /// Note: This property is included for future implementation but currently has no effect.
  final bool autofocus;

  /// The alignment of the menu relative to its target.
  /// Specifies how the menu should be positioned.
  final PositionConfig menuAlignment;

  /// Fallback alignments to try if the menu doesn't fit in the preferred position.
  /// The menu will try each alignment in order until it finds one that fits.
  final List<PositionConfig> fallbackAlignments;

  /// The controller that manages the visibility of the menu.
  /// Use this to show, hide, or toggle the menu programmatically.
  final OverlayPortalController controller;

  /// Whether to consume outside taps.
  final bool consumeOutsideTaps;

  /// Whether to use the root overlay.
  final bool useRootOverlay;

  /// Create a naked menu.
  ///
  /// The [builder] and [overlayBuilder] parameters are required.
  /// The [builder] is the widget that triggers the menu (typically a button).
  /// The [overlayBuilder] is the content to display when open.
  const NakedMenu({
    super.key,
    required this.builder,
    required this.overlayBuilder,
    required this.controller,
    this.onClose,
    this.consumeOutsideTaps = true,
    this.useRootOverlay = false,
    this.closeOnSelect = true,
    this.autofocus = true,
    this.menuAlignment = const PositionConfig(
      target: Alignment.bottomLeft,
      follower: Alignment.topLeft,
      offset: Offset(0, 8),
    ),
    this.fallbackAlignments = const [
      PositionConfig(
        target: Alignment.topLeft,
        follower: Alignment.bottomLeft,
        offset: Offset(0, -8),
      ),
    ],
  });

  @override
  State<NakedMenu> createState() => _NakedMenuState();
}

class _NakedMenuState extends State<NakedMenu> {
  final _focusScopeNode = FocusScopeNode();

  @override
  void dispose() {
    _focusScopeNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NakedPortal(
      useRootOverlay: widget.useRootOverlay,
      alignment: widget.menuAlignment,
      fallbackAlignments: widget.fallbackAlignments,
      controller: widget.controller,
      overlayChildBuilder: (context) {
        return _NakedMenuContent(
          consumeOutsideTaps: widget.consumeOutsideTaps,
          onClose: widget.onClose,
          controller: widget.controller,
          child: widget.overlayBuilder(context),
        );
      },
      child: widget.builder(context),
    );
  }
}

/// A container for menu items that handles click-outside behavior.
///
/// This component should wrap the menu content to enable closing the menu
/// when clicking outside. It also provides proper event handling and
/// positioning for the menu items.
class _NakedMenuContent extends StatefulWidget {
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

  /// Creates a naked menu content container.
  ///
  /// The [child] parameter is required and should contain the menu items.
  const _NakedMenuContent({
    required this.child,
    required this.consumeOutsideTaps,
    required this.onClose,
    required this.controller,
  });

  @override
  State<_NakedMenuContent> createState() => _NakedMenuContentState();
}

class _NakedMenuContentState extends State<_NakedMenuContent> {
  late final _NakedMenuState? menuState =
      context.findAncestorStateOfType<_NakedMenuState>();

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
          child: FocusScope(
            node: _focusScopeNode,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

/// An individual menu item that can be selected.
///
/// This component provides interaction states (hover, press, focus) and
/// accessibility features for menu items. It handles keyboard navigation
/// and screen reader support.
class NakedMenuItem extends StatelessWidget {
  /// The content to display in the menu item.
  final Widget child;

  /// Called when the hover state changes.
  /// Can be used to update visual feedback.
  final ValueChanged<bool>? onHoverState;

  /// Called when the pressed state changes.
  /// Can be used to update visual feedback.
  final ValueChanged<bool>? onPressedState;

  /// Called when the focus state changes.
  /// Can be used to update visual feedback.
  final ValueChanged<bool>? onFocusState;

  /// Called when the item is selected.
  final VoidCallback? onPressed;

  /// Whether the item is enabled and can be selected.
  final bool enabled;

  /// Optional semantic label for accessibility.
  /// Provides a description of the item's purpose for screen readers.
  final String? semanticLabel;

  /// The cursor to show when hovering over the item.
  final MouseCursor cursor;

  /// Whether to provide haptic feedback when selecting the item.
  final bool enableHapticFeedback;

  /// Optional focus node to control focus behavior.
  final FocusNode? focusNode;

  /// Called when the disabled state changes.
  /// Can be used to update visual feedback when the item is disabled.
  final ValueChanged<bool>? onDisabledState;

  /// Creates a naked menu item.
  ///
  /// The [child] parameter is required and represents the item's content.
  /// Use [onPressed] to handle selection, and the state callbacks
  /// ([onHoverState], [onPressedState], [onFocusState]) to customize appearance.
  const NakedMenuItem({
    super.key,
    required this.child,
    this.onHoverState,
    this.onPressedState,
    this.onFocusState,
    this.onPressed,
    this.enabled = true,
    this.onDisabledState,
    this.semanticLabel,
    this.cursor = SystemMouseCursors.click,
    this.enableHapticFeedback = true,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final menuState = context.findAncestorStateOfType<_NakedMenuState>();

    void onPress() {
      if (!enabled) return;
      if (enableHapticFeedback) {
        HapticFeedback.lightImpact();
      }
      onPressed?.call();
      if (menuState != null && menuState.widget.closeOnSelect) {
        menuState.widget.onClose?.call();
      }
    }

    return NakedButton(
      onPressed: onPressed != null ? onPress : null,
      onHoverState: onHoverState,
      onPressedState: onPressedState,
      onFocusState: onFocusState,
      enabled: enabled,
      semanticLabel: semanticLabel,
      cursor: cursor,
      enableHapticFeedback: enableHapticFeedback,
      focusNode: focusNode,
      onDisabledState: onDisabledState,
      child: child,
    );
  }
}
