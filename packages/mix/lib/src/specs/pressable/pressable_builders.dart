import 'package:flutter/widgets.dart';

import '../../core/style.dart';
import '../box/box_spec.dart';
import '../box/box_widget.dart';
import '../icon/icon_spec.dart';
import '../icon/icon_widget.dart';
import '../image/image_spec.dart';
import '../image/image_widget.dart';
import '../pressable/pressable_widget.dart';
import '../text/text_spec.dart';
import '../text/text_widget.dart';

/// A terminal builder for an interactive styled box.
///
/// Builders are immutable and contain only the composed style. Interaction
/// callbacks and focus state are supplied each time the builder is called.
@immutable
final class PressableBoxBuilder {
  final Style<BoxSpec> _style;

  const PressableBoxBuilder(this._style);

  Pressable call({
    Key? key,
    Widget? child,
    VoidCallback? onPress,
    VoidCallback? onLongPress,
    FocusNode? focusNode,
    bool autofocus = false,
    bool enableFeedback = false,
    ValueChanged<bool>? onFocusChange,
    MouseCursor? mouseCursor,
    bool canRequestFocus = true,
    bool excludeFromSemantics = false,
    String? semanticsLabel,
    PressableSemanticsRole semanticsRole = .button,
    FocusOnKeyEventCallback? onKeyEvent,
    WidgetStatesController? controller,
    Map<Type, Action<Intent>>? actions,
    HitTestBehavior hitTestBehavior = .opaque,
    bool enabled = true,
  }) {
    return Pressable(
      key: key,
      enabled: enabled,
      enableFeedback: enableFeedback,
      onPress: onPress,
      hitTestBehavior: hitTestBehavior,
      onLongPress: onLongPress,
      onFocusChange: onFocusChange,
      autofocus: autofocus,
      focusNode: focusNode,
      mouseCursor: mouseCursor,
      canRequestFocus: canRequestFocus,
      excludeFromSemantics: excludeFromSemantics,
      semanticsLabel: semanticsLabel,
      semanticsRole: semanticsRole,
      onKeyEvent: onKeyEvent,
      controller: controller,
      actions: actions,
      child: Box(style: _style, child: child),
    );
  }
}

/// A terminal builder for an interactive styled text widget.
@immutable
final class PressableTextBuilder {
  final Style<TextSpec> _style;

  const PressableTextBuilder(this._style);

  Pressable call(
    String text, {
    Key? key,
    VoidCallback? onPress,
    VoidCallback? onLongPress,
    FocusNode? focusNode,
    bool autofocus = false,
    bool enableFeedback = false,
    ValueChanged<bool>? onFocusChange,
    MouseCursor? mouseCursor,
    bool canRequestFocus = true,
    bool excludeFromSemantics = false,
    String? semanticsLabel,
    PressableSemanticsRole semanticsRole = .button,
    FocusOnKeyEventCallback? onKeyEvent,
    WidgetStatesController? controller,
    Map<Type, Action<Intent>>? actions,
    HitTestBehavior hitTestBehavior = .opaque,
    bool enabled = true,
  }) {
    return Pressable(
      key: key,
      enabled: enabled,
      enableFeedback: enableFeedback,
      onPress: onPress,
      hitTestBehavior: hitTestBehavior,
      onLongPress: onLongPress,
      onFocusChange: onFocusChange,
      autofocus: autofocus,
      focusNode: focusNode,
      mouseCursor: mouseCursor,
      canRequestFocus: canRequestFocus,
      excludeFromSemantics: excludeFromSemantics,
      semanticsLabel: semanticsLabel,
      semanticsRole: semanticsRole,
      onKeyEvent: onKeyEvent,
      controller: controller,
      actions: actions,
      child: StyledText(text, style: _style),
    );
  }
}

/// A terminal builder for an interactive styled icon widget.
@immutable
final class PressableIconBuilder {
  final Style<IconSpec> _style;

  const PressableIconBuilder(this._style);

  Pressable call({
    Key? key,
    IconData? icon,
    String? semanticLabel,
    VoidCallback? onPress,
    VoidCallback? onLongPress,
    FocusNode? focusNode,
    bool autofocus = false,
    bool enableFeedback = false,
    ValueChanged<bool>? onFocusChange,
    MouseCursor? mouseCursor,
    bool canRequestFocus = true,
    bool excludeFromSemantics = false,
    String? semanticsLabel,
    PressableSemanticsRole semanticsRole = .button,
    FocusOnKeyEventCallback? onKeyEvent,
    WidgetStatesController? controller,
    Map<Type, Action<Intent>>? actions,
    HitTestBehavior hitTestBehavior = .opaque,
    bool enabled = true,
  }) {
    return Pressable(
      key: key,
      enabled: enabled,
      enableFeedback: enableFeedback,
      onPress: onPress,
      hitTestBehavior: hitTestBehavior,
      onLongPress: onLongPress,
      onFocusChange: onFocusChange,
      autofocus: autofocus,
      focusNode: focusNode,
      mouseCursor: mouseCursor,
      canRequestFocus: canRequestFocus,
      excludeFromSemantics: excludeFromSemantics,
      semanticsLabel: semanticsLabel,
      semanticsRole: semanticsRole,
      onKeyEvent: onKeyEvent,
      controller: controller,
      actions: actions,
      child: StyledIcon(
        icon: icon,
        semanticLabel: semanticLabel,
        style: _style,
      ),
    );
  }
}

/// A terminal builder for an interactive styled image widget.
@immutable
final class PressableImageBuilder {
  final Style<ImageSpec> _style;

  const PressableImageBuilder(this._style);

  Pressable call({
    Key? key,
    ImageProvider<Object>? image,
    ImageFrameBuilder? frameBuilder,
    ImageLoadingBuilder? loadingBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    Animation<double>? opacity,
    VoidCallback? onPress,
    VoidCallback? onLongPress,
    FocusNode? focusNode,
    bool autofocus = false,
    bool enableFeedback = false,
    ValueChanged<bool>? onFocusChange,
    MouseCursor? mouseCursor,
    bool canRequestFocus = true,
    bool excludeFromSemantics = false,
    String? semanticsLabel,
    PressableSemanticsRole semanticsRole = .button,
    FocusOnKeyEventCallback? onKeyEvent,
    WidgetStatesController? controller,
    Map<Type, Action<Intent>>? actions,
    HitTestBehavior hitTestBehavior = .opaque,
    bool enabled = true,
  }) {
    return Pressable(
      key: key,
      enabled: enabled,
      enableFeedback: enableFeedback,
      onPress: onPress,
      hitTestBehavior: hitTestBehavior,
      onLongPress: onLongPress,
      onFocusChange: onFocusChange,
      autofocus: autofocus,
      focusNode: focusNode,
      mouseCursor: mouseCursor,
      canRequestFocus: canRequestFocus,
      excludeFromSemantics: excludeFromSemantics,
      semanticsLabel: semanticsLabel,
      semanticsRole: semanticsRole,
      onKeyEvent: onKeyEvent,
      controller: controller,
      actions: actions,
      child: StyledImage(
        style: _style,
        image: image,
        frameBuilder: frameBuilder,
        loadingBuilder: loadingBuilder,
        errorBuilder: errorBuilder,
        opacity: opacity,
      ),
    );
  }
}

/// A terminal builder for an interactive styled multi-child layout.
@immutable
final class PressableChildrenBuilder {
  final Widget Function(List<Widget> children) _builder;

  const PressableChildrenBuilder(this._builder);

  Pressable call({
    Key? key,
    List<Widget> children = const <Widget>[],
    VoidCallback? onPress,
    VoidCallback? onLongPress,
    FocusNode? focusNode,
    bool autofocus = false,
    bool enableFeedback = false,
    ValueChanged<bool>? onFocusChange,
    MouseCursor? mouseCursor,
    bool canRequestFocus = true,
    bool excludeFromSemantics = false,
    String? semanticsLabel,
    PressableSemanticsRole semanticsRole = .button,
    FocusOnKeyEventCallback? onKeyEvent,
    WidgetStatesController? controller,
    Map<Type, Action<Intent>>? actions,
    HitTestBehavior hitTestBehavior = .opaque,
    bool enabled = true,
  }) {
    return Pressable(
      key: key,
      enabled: enabled,
      enableFeedback: enableFeedback,
      onPress: onPress,
      hitTestBehavior: hitTestBehavior,
      onLongPress: onLongPress,
      onFocusChange: onFocusChange,
      autofocus: autofocus,
      focusNode: focusNode,
      mouseCursor: mouseCursor,
      canRequestFocus: canRequestFocus,
      excludeFromSemantics: excludeFromSemantics,
      semanticsLabel: semanticsLabel,
      semanticsRole: semanticsRole,
      onKeyEvent: onKeyEvent,
      controller: controller,
      actions: actions,
      child: _builder(children),
    );
  }
}
