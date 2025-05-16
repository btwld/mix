import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:naked/naked.dart';

/// A fully customizable select/dropdown widget with no default styling.
///
/// NakedSelect provides complete control over the appearance and behavior of a dropdown menu
/// while handling all the complex interaction patterns and accessibility requirements.
///
/// Key features:
/// - Full styling control through callbacks for hover, press, and focus states
/// - Support for single and multiple selection modes
/// - Keyboard navigation and type-ahead functionality
/// - Automatic positioning with fallback alignments
/// - ARIA-compliant accessibility support
///
/// The component uses [NakedPortal] to render the dropdown content in the app overlay,
/// ensuring proper z-indexing and maintaining context inheritance.
///
/// Example usage:
/// ```dart
/// NakedSelect<String>(
///   selectedValue: selectedValue,
///   onSelectedValueChanged: (value) => setState(() => selectedValue = value),
///   child: NakedSelectTrigger(
///     child: Text(selectedValue ?? 'Select an option'),
///   ),
///   menu: NakedSelectMenu(
///     child: Column(
///       children: [
///         NakedSelectItem(
///           value: 'apple',
///           child: Text('Apple'),
///         ),
///         NakedSelectItem(
///           value: 'banana',
///           child: Text('Banana'),
///         ),
///         NakedSelectItem(
///           value: 'orange',
///           child: Text('Orange'),
///         ),
///       ],
///     ),
///   ),
///   onMenuClose: () => {},
/// )
/// ```
class NakedSelect<T> extends StatefulWidget {
  /// The target widget that triggers the select dropdown.
  /// This should typically be a [NakedSelectTrigger].
  final Widget child;

  /// The menu widget to display when the dropdown is open.
  /// This should be a [NakedSelectMenu] containing [NakedSelectItem] widgets.
  final Widget menu;

  /// Called when the menu closes, either through selection or external interaction.
  final VoidCallback? onMenuClose;

  /// The currently selected value in single selection mode.
  /// Only used when [allowMultiple] is false.
  final T? selectedValue;

  /// Called when the selected value changes in single selection mode.
  /// Only used when [allowMultiple] is false.
  final ValueChanged<T?>? onSelectedValueChanged;

  /// The set of currently selected values in multiple selection mode.
  /// Required when [allowMultiple] is true.
  final Set<T>? selectedValues;

  /// Called when selected values change in multiple selection mode.
  /// Only used when [allowMultiple] is true.
  final ValueChanged<Set<T>>? onSelectedValuesChanged;

  /// Whether to allow selecting multiple items.
  /// When true, [selectedValues] and [onSelectedValuesChanged] must be provided.
  final bool allowMultiple;

  /// Whether the select is enabled and can be interacted with.
  /// When false, all interaction is disabled and the trigger shows a forbidden cursor.
  final bool enabled;

  /// Semantic label for accessibility.
  /// Used by screen readers to identify the select component.
  final String? semanticLabel;

  /// Whether to automatically close the dropdown when an item is selected.
  /// Set to false to keep the menu open after selection, useful for multiple selection.
  final bool closeOnSelect;

  /// Whether to automatically focus the menu when opened.
  /// When true, enables immediate keyboard navigation.
  final bool autofocus;

  /// Whether to enable type-ahead selection for quick keyboard navigation.
  /// When true, typing characters will focus matching items.
  final bool enableTypeAhead;

  /// Duration before resetting the type-ahead search buffer.
  /// Controls how long to wait between keystrokes when matching items.
  final Duration typeAheadDebounceTime;

  /// The alignment of the menu relative to its trigger.
  /// Specifies how to position the menu when it opens.
  final PositionConfig menuAlignment;

  /// Alternative alignments to try if the menu doesn't fit in the preferred position.
  /// The menu will try each alignment in order until finding one that fits.
  final List<PositionConfig> fallbackAlignments;

  /// Offset from the target position.
  /// Allows fine-tuning of the menu position relative to the trigger.
  final Offset offset;

  /// Creates a naked select dropdown.
  ///
  /// The [child] and [menu] parameters are required.
  /// When [allowMultiple] is true, [selectedValues] must be provided.
  const NakedSelect({
    super.key,
    required this.child,
    required this.menu,
    this.onMenuClose,
    this.selectedValue,
    this.onSelectedValueChanged,
    this.selectedValues,
    this.onSelectedValuesChanged,
    this.allowMultiple = false,
    this.enabled = true,
    this.semanticLabel,
    this.closeOnSelect = true,
    this.autofocus = true,
    this.enableTypeAhead = true,
    this.typeAheadDebounceTime = const Duration(milliseconds: 500),
    this.offset = const Offset(0, 4),
    this.menuAlignment = const PositionConfig(
      target: Alignment.bottomLeft,
      follower: Alignment.topLeft,
    ),
    this.fallbackAlignments = const [
      PositionConfig(
        target: Alignment.topLeft,
        follower: Alignment.bottomLeft,
        offset: Offset(0, -8),
      ),
    ],
  }) : assert(
          !allowMultiple || (allowMultiple && selectedValues != null),
          'selectedValues must be provided when allowMultiple is true',
        );

  @override
  State<NakedSelect<T>> createState() => _NakedSelectState<T>();
}

class _NakedSelectState<T> extends State<NakedSelect<T>> {
  final _overlayController = OverlayPortalController();
  final _focusScopeNode = FocusScopeNode();
  late final _isMultipleSelection =
      widget.allowMultiple && widget.selectedValues != null;
  bool _isOpen = false;

  // For type-ahead functionality
  String _typeAheadBuffer = '';
  Timer? _typeAheadResetTimer;
  final List<_SelectItemInfo<T>> _selectableItems = [];

  @override
  void dispose() {
    _cancelTypeAheadTimer();
    _focusScopeNode.dispose();
    super.dispose();
  }

  void toggleMenu() {
    setState(() {
      _isOpen = !_isOpen;
      handleOpenState();
    });
  }

  void openMenu() {
    if (!_isOpen) {
      setState(() {
        _isOpen = true;
        handleOpenState();
      });
    }
  }

  void closeMenu() {
    if (_isOpen) {
      setState(() {
        _isOpen = false;
        handleOpenState();
      });
      widget.onMenuClose?.call();
    }
  }

  void handleOpenState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_isOpen) {
        _overlayController.show();
        _selectableItems.clear();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _focusScopeNode.requestFocus();
        });
      } else {
        _overlayController.hide();
      }
    });
  }

  void _cancelTypeAheadTimer() {
    _typeAheadResetTimer?.cancel();
    _typeAheadResetTimer = null;
  }

  void _resetTypeAheadBuffer() {
    _cancelTypeAheadTimer();
    _typeAheadBuffer = '';
  }

  void _handleTypeAhead(String character) {
    if (!widget.enableTypeAhead) return;

    _cancelTypeAheadTimer();
    _typeAheadBuffer += character.toLowerCase();

    // Find the first matching item
    for (final item in _selectableItems) {
      final stringValue = item.value.toString().toLowerCase();
      if (stringValue.startsWith(_typeAheadBuffer)) {
        // Focus this item
        if (item.focusNode.canRequestFocus) {
          item.focusNode.requestFocus();
        }
        break;
      }
    }

    // Reset the buffer after a delay
    _typeAheadResetTimer =
        Timer(widget.typeAheadDebounceTime, _resetTypeAheadBuffer);
  }

  void _registerSelectableItem(T value, FocusNode focusNode) {
    if (!_selectableItems.any((item) => item.value == value)) {
      _selectableItems.add(_SelectItemInfo(value: value, focusNode: focusNode));
    }
  }

  void _selectValue(T value) {
    if (!widget.enabled) return;

    if (_isMultipleSelection) {
      final newValues = Set<T>.from(widget.selectedValues!);
      newValues.contains(value)
          ? newValues.remove(value)
          : newValues.add(value);

      widget.onSelectedValuesChanged?.call(newValues);
    } else {
      widget.onSelectedValueChanged?.call(value);
    }

    if (widget.closeOnSelect) {
      closeMenu();
    }
  }

  bool _isItemSelected(T value) {
    if (widget.allowMultiple) {
      return widget.selectedValues?.contains(value) ?? false;
    } else {
      return widget.selectedValue == value;
    }
  }

  bool get isOpen => _isOpen;
  bool get isEnabled => widget.enabled;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      explicitChildNodes: true,
      container: true,
      label: widget.semanticLabel,
      child: NakedPortal(
        alignment: PositionConfig(
          target: widget.menuAlignment.target,
          follower: widget.menuAlignment.follower,
          offset: widget.offset,
        ),
        fallbackAlignments: widget.fallbackAlignments,
        controller: _overlayController,
        overlayChildBuilder: (context) {
          return FocusScope(
            onKeyEvent: (node, event) {
              if (event is KeyUpEvent) {
                return KeyEventResult.ignored;
              }

              if (event.logicalKey == LogicalKeyboardKey.escape) {
                closeMenu();
                return KeyEventResult.handled;
              }

              // Home and End keys for first and last items
              if (event.logicalKey == LogicalKeyboardKey.home) {
                if (_selectableItems.isNotEmpty) {
                  _selectableItems.first.focusNode.requestFocus();
                  return KeyEventResult.handled;
                }
              } else if (event.logicalKey == LogicalKeyboardKey.end) {
                if (_selectableItems.isNotEmpty) {
                  _selectableItems.last.focusNode.requestFocus();
                  return KeyEventResult.handled;
                }
              }
              // Type-ahead with character keys
              final character = event.character;
              if (character != null &&
                  character.isNotEmpty &&
                  widget.enableTypeAhead) {
                _handleTypeAhead(character);
                return KeyEventResult.handled;
              }

              return KeyEventResult.ignored;
            },
            autofocus: widget.autofocus,
            node: _focusScopeNode,
            child: widget.menu,
          );
        },
        child: widget.child,
      ),
    );
  }
}

class _SelectItemInfo<T> {
  final T value;
  final FocusNode focusNode;

  _SelectItemInfo({required this.value, required this.focusNode});
}

/// A customizable trigger button that controls the select dropdown.
///
/// The trigger handles user interaction through mouse, keyboard, and touch events,
/// providing callbacks for hover, press, and focus states to enable complete styling control.
///
/// Key features:
/// - Customizable cursor and interaction states
/// - Keyboard navigation support (Space, Enter, Arrow keys)
/// - Optional haptic feedback
/// - Accessibility support with ARIA attributes
///
/// Example:
/// ```dart
/// NakedSelectTrigger(
///   onHoverState: (isHovered) => setState(() => _isHovered = isHovered),
///   onPressedState: (isPressed) => setState(() => _isPressed = isPressed),
///   child: Container(
///     color: _isHovered ? Colors.blue[100] : Colors.white,
///     child: Text('Select an option'),
///   ),
/// )
/// ```
class NakedSelectTrigger extends StatefulWidget {
  /// The child widget to display.
  /// This widget will be wrapped with interaction handlers.
  final Widget child;

  /// Called when the hover state changes.
  /// Use this to update the visual appearance on hover.
  final ValueChanged<bool>? onHoverState;

  /// Called when the pressed state changes.
  /// Use this to update the visual appearance while pressed.
  final ValueChanged<bool>? onPressedState;

  /// Called when the focus state changes.
  /// Use this to update the visual appearance when focused.
  final ValueChanged<bool>? onFocusState;

  /// Whether the trigger is enabled and can be interacted with.
  /// When false, all interaction is disabled.
  final bool enabled;

  /// Semantic label for accessibility.
  /// Used by screen readers to identify the trigger.
  final String? semanticLabel;

  /// The cursor to show when hovering over the trigger.
  /// Defaults to [SystemMouseCursors.click].
  final MouseCursor cursor;

  /// Whether to provide haptic feedback when tapped.
  /// Defaults to true.
  final bool enableHapticFeedback;

  /// Optional focus node to control focus behavior.
  /// If not provided, a new focus node will be created.
  final FocusNode? focusNode;

  const NakedSelectTrigger({
    super.key,
    required this.child,
    this.onHoverState,
    this.onPressedState,
    this.onFocusState,
    this.enabled = true,
    this.semanticLabel,
    this.cursor = SystemMouseCursors.click,
    this.enableHapticFeedback = true,
    this.focusNode,
  });

  @override
  State<NakedSelectTrigger> createState() => _NakedSelectTriggerState();
}

class _NakedSelectTriggerState extends State<NakedSelectTrigger> {
  FocusNode? _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.findAncestorStateOfType<_NakedSelectState>();
    final isSelectEnabled = state?.isEnabled ?? true;
    final isEffectivelyEnabled = widget.enabled && isSelectEnabled;

    void handleTap() {
      if (!isEffectivelyEnabled) return;

      if (widget.enableHapticFeedback) {
        HapticFeedback.lightImpact();
      }

      final state = context.findAncestorStateOfType<_NakedSelectState>();
      state?.toggleMenu();
    }

    return Semantics(
      button: true,
      enabled: isEffectivelyEnabled,
      label: widget.semanticLabel ?? 'Select button',
      onTap: isEffectivelyEnabled ? handleTap : null,
      excludeSemantics: true,
      child: Focus(
        focusNode: _focusNode,
        onFocusChange: widget.onFocusState,
        onKeyEvent: (node, event) {
          if (!isEffectivelyEnabled) return KeyEventResult.ignored;

          if (event is KeyDownEvent) {
            if (event.logicalKey == LogicalKeyboardKey.space ||
                event.logicalKey == LogicalKeyboardKey.enter) {
              widget.onPressedState?.call(true);
              return KeyEventResult.handled;
            } else if (event.logicalKey == LogicalKeyboardKey.arrowDown ||
                event.logicalKey == LogicalKeyboardKey.arrowUp) {
              // Open dropdown on arrow keys
              if (state != null && !state.isOpen) {
                state.openMenu();
              }
              return KeyEventResult.handled;
            }
          } else if (event is KeyUpEvent) {
            if (event.logicalKey == LogicalKeyboardKey.space ||
                event.logicalKey == LogicalKeyboardKey.enter) {
              widget.onPressedState?.call(false);
              handleTap();
              return KeyEventResult.handled;
            }
          }
          return KeyEventResult.ignored;
        },
        child: MouseRegion(
          cursor: isEffectivelyEnabled
              ? widget.cursor
              : SystemMouseCursors.forbidden,
          onEnter: isEffectivelyEnabled
              ? (_) => widget.onHoverState?.call(true)
              : null,
          onExit: isEffectivelyEnabled
              ? (_) => widget.onHoverState?.call(false)
              : null,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: isEffectivelyEnabled
                ? (_) => widget.onPressedState?.call(true)
                : null,
            onTapUp: isEffectivelyEnabled
                ? (_) => widget.onPressedState?.call(false)
                : null,
            onTapCancel: isEffectivelyEnabled
                ? () => widget.onPressedState?.call(false)
                : null,
            onTap: isEffectivelyEnabled ? handleTap : null,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

/// A container for the dropdown menu content.
///
/// This component provides the structure for the dropdown menu and handles
/// click-outside behavior for closing the menu.
///
/// Example:
/// ```dart
/// NakedSelectMenu(
///   child: Column(
///     children: [
///       NakedSelectItem(value: 1, child: Text('Option 1')),
///       NakedSelectItem(value: 2, child: Text('Option 2')),
///     ],
///   ),
/// )
/// ```
class NakedSelectMenu extends StatefulWidget {
  /// The menu content to display.
  /// This should contain the menu items and any other menu content.
  final Widget child;

  /// Whether to close the menu when clicking outside.
  final bool closeOnClickOutside;

  /// Creates a naked menu content container.
  ///
  /// The [child] parameter is required and should contain the menu items.
  const NakedSelectMenu({
    super.key,
    required this.child,
    this.closeOnClickOutside = true,
  });

  @override
  State<NakedSelectMenu> createState() => _NakedSelectMenuState();
}

enum _GlobalRouteEvent {
  add,
  remove;
}

class _NakedSelectMenuState extends State<NakedSelectMenu> {
  late final _NakedSelectState? menuState =
      context.findAncestorStateOfType<_NakedSelectState>();

  @override
  void initState() {
    super.initState();
    _handlePointerDown(_GlobalRouteEvent.add);
  }

  @override
  void dispose() {
    _handlePointerDown(_GlobalRouteEvent.remove);
    super.dispose();
  }

  void _handlePointerDown(
    _GlobalRouteEvent eventType,
  ) {
    if (!widget.closeOnClickOutside) return;

    if (eventType == _GlobalRouteEvent.add) {
      WidgetsBinding.instance.pointerRouter.addGlobalRoute(handlePointerDown);
    } else {
      WidgetsBinding.instance.pointerRouter
          .removeGlobalRoute(handlePointerDown);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void handlePointerDown(PointerEvent event) {
    if (event is! PointerDownEvent) return;

    final contentRenderBox = context.findRenderObject() as RenderBox?;
    if (contentRenderBox == null) return;

    final menuPosition = contentRenderBox.localToGlobal(Offset.zero);
    final menuSize = contentRenderBox.size;
    final menuRect = menuPosition & menuSize;

    if (menuRect.contains(event.position)) return;
    menuState?.toggleMenu();
  }
}

/// A selectable item within the dropdown menu.
///
/// This component handles the interaction and selection state for individual menu items,
/// providing callbacks for hover, press, and focus states to enable complete styling control.
///
/// Key features:
/// - Customizable cursor and interaction states
/// - Keyboard selection support
/// - Optional haptic feedback
/// - Accessibility support with ARIA attributes
///
/// Example:
/// ```dart
/// NakedSelectItem<int>(
///   value: 1,
///   onHoverState: (isHovered) => setState(() => _isHovered = isHovered),
///   child: Container(
///     color: _isHovered ? Colors.blue[100] : Colors.white,
///     child: Text('Option 1'),
///   ),
/// )
/// ```
class NakedSelectItem<T> extends StatefulWidget {
  /// The child widget to display.
  /// This widget will be wrapped with interaction handlers.
  final Widget child;

  /// The value associated with this item.
  /// This value will be passed to the select's onChange callback when selected.
  final T value;

  /// Called when the hover state changes.
  /// Use this to update the visual appearance on hover.
  final ValueChanged<bool>? onHoverState;

  /// Called when the pressed state changes.
  /// Use this to update the visual appearance while pressed.
  final ValueChanged<bool>? onPressedState;

  /// Called when the focus state changes.
  /// Use this to update the visual appearance when focused.
  final ValueChanged<bool>? onFocusState;

  /// Whether this item is enabled and can be selected.
  /// When false, all interaction is disabled.
  final bool enabled;

  /// Semantic label for accessibility.
  /// Used by screen readers to identify the item.
  final String? semanticLabel;

  /// The cursor to show when hovering over this item.
  /// Defaults to [SystemMouseCursors.click].
  final MouseCursor cursor;

  /// Whether to provide haptic feedback when selected.
  /// Defaults to true.
  final bool enableHapticFeedback;

  /// Optional focus node to control focus behavior.
  /// If not provided, a new focus node will be created.
  final FocusNode? focusNode;

  /// Whether this item is currently selected.
  /// This can be used to override the internal selection state.
  final bool isSelected;

  const NakedSelectItem({
    super.key,
    required this.child,
    required this.value,
    this.onHoverState,
    this.onPressedState,
    this.onFocusState,
    this.enabled = true,
    this.semanticLabel,
    this.cursor = SystemMouseCursors.click,
    this.enableHapticFeedback = true,
    this.focusNode,
    this.isSelected = false,
  });

  @override
  State<NakedSelectItem<T>> createState() => _NakedSelectItemState<T>();
}

class _NakedSelectItemState<T> extends State<NakedSelectItem<T>> {
  late FocusNode _focusNode;
  bool _isRegistered = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _registerWithSelect();
    });
  }

  @override
  void didUpdateWidget(NakedSelectItem<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.focusNode != oldWidget.focusNode) {
      if (oldWidget.focusNode == null) {
        _focusNode.dispose();
      }
      _focusNode = widget.focusNode ?? FocusNode();
    }

    if (widget.value != oldWidget.value) {
      _registerWithSelect();
    }
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _registerWithSelect() {
    if (_isRegistered) return;

    final state = context.findAncestorStateOfType<_NakedSelectState<T>>();
    if (state != null) {
      state._registerSelectableItem(widget.value, _focusNode);
      _isRegistered = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.findAncestorStateOfType<_NakedSelectState<T>>();
    final isSelectEnabled = state?.isEnabled ?? true;
    final isEffectivelySelected =
        widget.isSelected || (state?._isItemSelected(widget.value) ?? false);
    final isEffectivelyEnabled = widget.enabled && isSelectEnabled;

    void handleSelect() {
      if (!isEffectivelyEnabled) return;

      if (widget.enableHapticFeedback) {
        HapticFeedback.lightImpact();
      }

      state?._selectValue(widget.value);
    }

    return Semantics(
      button: true,
      enabled: isEffectivelyEnabled,
      label: widget.semanticLabel ?? widget.value.toString(),
      onTap: isEffectivelyEnabled ? handleSelect : null,
      selected: isEffectivelySelected,
      excludeSemantics: true,
      child: Focus(
        focusNode: _focusNode,
        onFocusChange: widget.onFocusState,
        onKeyEvent: (node, event) {
          if (!isEffectivelyEnabled) return KeyEventResult.ignored;

          if (event is KeyDownEvent &&
              (event.logicalKey == LogicalKeyboardKey.space ||
                  event.logicalKey == LogicalKeyboardKey.enter)) {
            widget.onPressedState?.call(true);
            return KeyEventResult.handled;
          } else if (event is KeyUpEvent &&
              (event.logicalKey == LogicalKeyboardKey.space ||
                  event.logicalKey == LogicalKeyboardKey.enter)) {
            widget.onPressedState?.call(false);
            handleSelect();
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        child: MouseRegion(
          cursor: isEffectivelyEnabled
              ? widget.cursor
              : SystemMouseCursors.forbidden,
          onEnter: isEffectivelyEnabled
              ? (_) => widget.onHoverState?.call(true)
              : null,
          onExit: isEffectivelyEnabled
              ? (_) => widget.onHoverState?.call(false)
              : null,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: isEffectivelyEnabled
                ? (_) => widget.onPressedState?.call(true)
                : null,
            onTapUp: isEffectivelyEnabled
                ? (_) => widget.onPressedState?.call(false)
                : null,
            onTapCancel: isEffectivelyEnabled
                ? () => widget.onPressedState?.call(false)
                : null,
            onTap: isEffectivelyEnabled ? handleSelect : null,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
