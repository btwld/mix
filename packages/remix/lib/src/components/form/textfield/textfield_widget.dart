part of 'textfield.dart';

class TextField extends StatefulWidget {
  const TextField({
    super.key,
    this.controller,
    this.maxLength,
    this.focusNode,
    this.enabled = true,
    this.ignorePointers,
    this.onTap,
    this.maxLengthEnforcement,
    TextInputType? keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
    this.textDirection,
    this.autofocus = false,
    this.readOnly = false,
    this.showCursor,
    this.obscuringCharacter = '•',
    this.obscureText = false,
    this.hintText,
    this.autocorrect = true,
    SmartDashesType? smartDashesType,
    SmartQuotesType? smartQuotesType,
    this.enableSuggestions = true,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.inputFormatters,
    bool? enableInteractiveSelection,
    this.selectionControls,
    this.scrollController,
    this.scrollPhysics,
    this.clipBehavior = Clip.hardEdge,
    this.restorationId,
    this.scribbleEnabled = true,
    this.enableIMEPersonalizedLearning = true,
    this.showSelectionHandles = false,
    this.autofillClient,
    this.autofillHints = const <String>[],
    this.contentInsertionConfiguration,
    this.dragStartBehavior = DragStartBehavior.start,
    this.groupId = EditableText,
    this.onAppPrivateCommand,
    this.onTapOutside,
    this.canRequestFocus = true,
    this.onTapAlwaysCalled = false,
    this.undoController,
    this.magnifierConfiguration,
    this.spellCheckConfiguration,
    this.contextMenuBuilder,
    this.style,
    this.variants = const [],
    this.error = false,
    this.label,
    this.helperText,
    this.prefixBuilder,
    this.suffix,
  })  : assert(obscuringCharacter.length == 1),
        smartDashesType = smartDashesType ??
            (obscureText ? SmartDashesType.disabled : SmartDashesType.enabled),
        smartQuotesType = smartQuotesType ??
            (obscureText ? SmartQuotesType.disabled : SmartQuotesType.enabled),
        assert(maxLines == null || maxLines > 0),
        assert(minLines == null || minLines > 0),
        assert(
          (maxLines == null) || (minLines == null) || (maxLines >= minLines),
          "minLines can't be greater than maxLines",
        ),
        assert(
          !expands || (maxLines == null && minLines == null),
          'minLines and maxLines must be null when expands is true.',
        ),
        assert(!obscureText || maxLines == 1,
            'Obscured fields cannot be multiline.'),
        assert(maxLength == null ||
            maxLength == TextField.noMaxLength ||
            maxLength > 0),
        // Assert the following instead of setting it directly to avoid surprising the user by silently changing the value they set.
        assert(
          !identical(textInputAction, TextInputAction.newline) ||
              maxLines == 1 ||
              !identical(keyboardType, TextInputType.text),
          'Use keyboardType TextInputType.multiline when using TextInputAction.newline on a multiline TextField.',
        ),
        keyboardType = keyboardType ??
            (maxLines == 1 ? TextInputType.text : TextInputType.multiline),
        enableInteractiveSelection =
            enableInteractiveSelection ?? (!readOnly || !obscureText);

  /// If [maxLength] is set to this value, only the "current input length"
  /// part of the character counter is shown.
  static const int noMaxLength = -1;

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final TextDirection? textDirection;
  final bool enabled;
  final bool autofocus;
  final bool readOnly;
  final bool? showCursor;
  final String obscuringCharacter;
  final String? label;
  final bool obscureText;
  final bool autocorrect;
  final SmartDashesType? smartDashesType;
  final SmartQuotesType? smartQuotesType;
  final bool enableSuggestions;
  final int? maxLines;
  final int? minLines;
  final bool expands;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final bool error;

  /// Determines whether this widget ignores pointer events.
  ///
  /// Defaults to null, and when null, does nothing.
  final bool? ignorePointers;

  /// Determines how the [maxLength] limit should be enforced.
  ///
  /// {@macro flutter.services.textFormatter.effectiveMaxLengthEnforcement}
  ///
  /// {@macro flutter.services.textFormatter.maxLengthEnforcement}
  final MaxLengthEnforcement? maxLengthEnforcement;

  /// The maximum number of characters (Unicode grapheme clusters) to allow in
  /// the text field.
  ///
  /// If set, a character counter will be displayed below the
  /// field showing how many characters have been entered. If set to a number
  /// greater than 0, it will also display the maximum number allowed. If set
  /// to [TextField.noMaxLength] then only the current character count is displayed.
  ///
  /// After [maxLength] characters have been input, additional input
  /// is ignored, unless [maxLengthEnforcement] is set to
  /// [MaxLengthEnforcement.none].
  ///
  /// The text field enforces the length with a [LengthLimitingTextInputFormatter],
  /// which is evaluated after the supplied [inputFormatters], if any.
  ///
  /// This value must be either null, [TextField.noMaxLength], or greater than 0.
  /// If null (the default) then there is no limit to the number of characters
  /// that can be entered. If set to [TextField.noMaxLength], then no limit will
  /// be enforced, but the number of characters entered will still be displayed.
  ///
  /// Whitespace characters (e.g. newline, space, tab) are included in the
  /// character count.
  ///
  /// If [maxLengthEnforcement] is [MaxLengthEnforcement.none], then more than
  /// [maxLength] characters may be entered, but the error counter and divider
  /// will switch to the [decoration]'s [InputDecoration.errorStyle] when the
  /// limit is exceeded.
  ///
  /// {@macro flutter.services.lengthLimitingTextInputFormatter.maxLength}
  final int? maxLength;

  final String? hintText;
  final String? helperText;
  final WidgetSpecBuilder<IconSpec>? prefixBuilder;
  final Widget? suffix;

  /// Determine whether this text field can request the primary focus.
  ///
  /// Defaults to true. If false, the text field will not request focus
  /// when tapped, or when its context menu is displayed. If false it will not
  /// be possible to move the focus to the text field with tab key.
  final bool canRequestFocus;

  /// Whether [onTap] should be called for every tap.
  ///
  /// Defaults to false, so [onTap] is only called for each distinct tap. When
  /// enabled, [onTap] is called for every tap including consecutive taps.
  final bool onTapAlwaysCalled;

  /// {@macro flutter.material.textfield.onTap}
  ///  If [onTapAlwaysCalled] is enabled, this will also be called for consecutive
  /// taps.
  final GestureTapCallback? onTap;

  final bool enableInteractiveSelection;
  final TextSelectionControls? selectionControls;
  final ScrollController? scrollController;
  final ScrollPhysics? scrollPhysics;
  final Clip clipBehavior;
  final String? restorationId;
  final bool scribbleEnabled;
  final bool enableIMEPersonalizedLearning;

  final bool showSelectionHandles;

  final AutofillClient? autofillClient;
  final Iterable<String>? autofillHints;
  final ContentInsertionConfiguration? contentInsertionConfiguration;

  final DragStartBehavior dragStartBehavior;
  final Object groupId;
  final AppPrivateCommandCallback? onAppPrivateCommand;

  final TapRegionCallback? onTapOutside;
  final TextMagnifierConfiguration? magnifierConfiguration;
  final SpellCheckConfiguration? spellCheckConfiguration;

  final UndoHistoryController? undoController;
  final TextFieldStyle? style;
  final List<Variant> variants;

  final Widget Function(BuildContext, EditableTextState)? contextMenuBuilder;

  /// {@macro flutter.widgets.editableText.selectionEnabled}
  bool get selectionEnabled => enableInteractiveSelection;

  @override
  State<TextField> createState() => _TextFieldState();
}

class _TextFieldState extends State<TextField>
    with RestorationMixin
    implements TextSelectionGestureDetectorBuilderDelegate, AutofillClient {
  late WidgetStatesController _statesController;

  late _TextFieldSelectionGestureDetectorBuilder
      _selectionGestureDetectorBuilder;

  RestorableTextEditingController? _controller;
  TextEditingController get _effectiveController =>
      widget.controller ?? _controller!.value;

  FocusNode? _focusNode;
  FocusNode get _effectiveFocusNode =>
      widget.focusNode ?? (_focusNode ??= FocusNode());

  @override
  String? get restorationId => widget.restorationId;

  bool get _hasError => widget.error || _hasIntrinsicError;

  @override
  final GlobalKey<EditableTextState> editableTextKey =
      GlobalKey<EditableTextState>();

  @override
  void initState() {
    super.initState();
    _statesController = WidgetStatesController();

    _selectionGestureDetectorBuilder =
        _TextFieldSelectionGestureDetectorBuilder(state: this);
    if (widget.controller == null) {
      _createLocalController();
    }
    _effectiveFocusNode.canRequestFocus =
        widget.canRequestFocus && widget.enabled;
    _effectiveFocusNode.addListener(_handleFocusChanged);
    _initStatesController();
  }

  void _registerController() {
    assert(_controller != null);
    registerForRestoration(_controller!, 'controller');
  }

  void _createLocalController([TextEditingValue? value]) {
    assert(_controller == null);
    _controller = value == null
        // ignore: avoid-undisposed-instances
        ? RestorableTextEditingController()
        // ignore: avoid-undisposed-instances
        : RestorableTextEditingController.fromValue(value);
    if (!restorePending) {
      _registerController();
    }
  }

  /// Toggle the toolbar when a selection handle is tapped.
  void _handleSelectionHandleTapped() {
    if (_effectiveController.selection.isCollapsed) {
      _editableText!.toggleToolbar();
    }
  }

  void _handleSelectionChanged(
    TextSelection selection,
    SelectionChangedCause? cause,
  ) {
    final bool willShowSelectionHandles = _shouldShowSelectionHandles(cause);
    if (willShowSelectionHandles != _showSelectionHandles) {
      setState(() {
        _showSelectionHandles = willShowSelectionHandles;
      });
    }

    switch (m.Theme.of(context).platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
      case TargetPlatform.fuchsia:
      case TargetPlatform.android:
        if (cause == SelectionChangedCause.longPress) {
          _editableText?.bringIntoView(selection.extent);
        }
    }

    switch (m.Theme.of(context).platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.fuchsia:
      case TargetPlatform.android:
        break;
      case TargetPlatform.macOS:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        if (cause == SelectionChangedCause.drag) {
          _editableText?.hideToolbar();
        }
    }
  }

  bool _shouldShowSelectionHandles(SelectionChangedCause? cause) {
    // When the text field is activated by something that doesn't trigger the
    // selection overlay, we shouldn't show the handles either.
    if (!_selectionGestureDetectorBuilder.shouldShowSelectionToolbar) {
      return false;
    }

    if (cause == SelectionChangedCause.keyboard) {
      return false;
    }

    if (widget.readOnly && _effectiveController.selection.isCollapsed) {
      return false;
    }

    if (!widget.enabled) {
      return false;
    }

    // ignore: prefer-switch-with-enums
    if (cause == SelectionChangedCause.longPress ||
        cause == SelectionChangedCause.scribble) {
      return true;
    }

    if (_effectiveController.text.isNotEmpty) {
      return true;
    }

    return false;
  }

  void _initStatesController() {
    _statesController.disabled = !widget.enabled;
    _statesController.focused = _effectiveFocusNode.hasFocus;
    _statesController.error = _hasError;
  }

  void _handleFocusChanged() {
    // ignore: avoid-empty-setstate, no-empty-block
    setState(() {
      // Rebuild the widget on focus change to show/hide the text selection
      // highlight.
    });
    _statesController.focused = _effectiveFocusNode.hasFocus;
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    if (_controller != null) {
      _registerController();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _effectiveFocusNode.canRequestFocus = _canRequestFocus;
  }

  @override
  void didUpdateWidget(TextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller == null && oldWidget.controller != null) {
      _createLocalController(oldWidget.controller!.value);
    } else if (widget.controller != null && oldWidget.controller == null) {
      unregisterFromRestoration(_controller!);
      _controller!.dispose();
      _controller = null;
    }

    if (widget.focusNode != oldWidget.focusNode) {
      (oldWidget.focusNode ?? _focusNode)?.removeListener(_handleFocusChanged);
      (widget.focusNode ?? _focusNode)?.addListener(_handleFocusChanged);
    }

    _effectiveFocusNode.canRequestFocus = _canRequestFocus;

    if (_effectiveFocusNode.hasFocus &&
        widget.readOnly != oldWidget.readOnly &&
        widget.enabled) {
      if (_effectiveController.selection.isCollapsed) {
        _showSelectionHandles = !widget.readOnly;
      }
    }

    _statesController.error = _hasError;
    _statesController.focused = _effectiveFocusNode.hasFocus;
    _statesController.disabled = !widget.enabled;
  }

  @override
  void dispose() {
    _effectiveFocusNode.removeListener(_handleFocusChanged);
    _focusNode?.dispose();
    _controller?.dispose();
    _statesController.dispose();
    // _statesController.removeListener(_handleStatesControllerChange);
    // _internalStatesController?.dispose();
    super.dispose();
  }

  @override
  late bool forcePressEnabled;

  @override
  void autofill(TextEditingValue newEditingValue) =>
      _editableText!.autofill(newEditingValue);

  EditableTextState? get _editableText => editableTextKey.currentState;
  bool _showSelectionHandles = false;
  MaxLengthEnforcement get _effectiveMaxLengthEnforcement =>
      widget.maxLengthEnforcement ??
      LengthLimitingTextInputFormatter.getDefaultMaxLengthEnforcement(
        m.Theme.of(context).platform,
      );

  bool get _hasIntrinsicError =>
      widget.maxLength != null &&
      widget.maxLength! > 0 &&
      (widget.controller == null
          ? !restorePending &&
              _effectiveController.value.text.characters.length >
                  widget.maxLength!
          : _effectiveController.value.text.characters.length >
              widget.maxLength!);

  bool get _canRequestFocus {
    final NavigationMode mode =
        MediaQuery.maybeNavigationModeOf(context) ?? NavigationMode.traditional;

    return switch (mode) {
      NavigationMode.traditional => widget.canRequestFocus && widget.enabled,
      NavigationMode.directional => true,
    };
  }

  @override
  Widget build(BuildContext context) {
    TextSelectionControls? textSelectionControls = widget.selectionControls;

    switch (MixHelpers.targetPlatform) {
      case TargetPlatform.iOS:
        forcePressEnabled = true;
        textSelectionControls ??= cupertinoTextSelectionHandleControls;

      case TargetPlatform.macOS:
        forcePressEnabled = false;
        textSelectionControls ??= cupertinoDesktopTextSelectionHandleControls;

      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        forcePressEnabled = false;
        textSelectionControls ??= m.materialTextSelectionHandleControls;

      case TargetPlatform.windows:
      case TargetPlatform.linux:
        forcePressEnabled = false;
        textSelectionControls ??= m.desktopTextSelectionHandleControls;
    }

    final List<TextInputFormatter> formatters = <TextInputFormatter>[
      ...?widget.inputFormatters,
      if (widget.maxLength != null)
        LengthLimitingTextInputFormatter(
          widget.maxLength,
          maxLengthEnforcement: _effectiveMaxLengthEnforcement,
        ),
    ];

    // Olhar quando for implementar o semantics
    // final int? semanticsMaxValueLength;
    // if (_effectiveMaxLengthEnforcement != MaxLengthEnforcement.none &&
    //     widget.maxLength != null &&
    //     widget.maxLength! > 0) {
    //   semanticsMaxValueLength = widget.maxLength;
    // } else {
    //   semanticsMaxValueLength = null;
    // }

    final style = widget.style ?? context.remix.components.textField;
    final configuration = TextFieldSpecConfiguration(
      context,
      TextFieldSpecUtility.self,
    );

    final child = SpecBuilder(
      controller: _statesController,
      style: style.makeStyle(configuration).applyVariants(widget.variants),
      builder: (context) {
        final spec = TextFieldSpec.of(context);
        final isFloating = spec.floatingLabel &
            (_effectiveFocusNode.hasFocus ||
                _effectiveController.value.text.isNotEmpty);

        return spec.outerContainer(
          direction: Axis.vertical,
          children: [
            spec.container(
              direction: Axis.horizontal,
              children: [
                if (widget.prefixBuilder != null)
                  widget.prefixBuilder!(spec.icon),
                Expanded(
                  child: AnimatedBuilder(
                    animation: _effectiveController,
                    builder: (context, child) => _HintLabel(
                      text: widget.hintText ?? '',
                      style: spec.hintTextStyle ?? spec.style,
                      float: isFloating,
                      show: spec.floatingLabel
                          ? true
                          : _effectiveController.value.text.isEmpty,
                      floatingLabelHeight:
                          spec.floatingLabel ? spec.floatingLabelHeight : 0,
                      floatingLabelStyle: spec.floatingLabelStyle ?? spec.style,
                      child: EditableText(
                        key: editableTextKey,
                        controller: _effectiveController,
                        focusNode: _effectiveFocusNode,
                        readOnly: widget.readOnly || !widget.enabled,
                        obscuringCharacter: widget.obscuringCharacter,
                        obscureText: widget.obscureText,
                        autocorrect: widget.autocorrect,
                        smartDashesType: widget.smartDashesType,
                        smartQuotesType: widget.smartQuotesType,
                        enableSuggestions: widget.enableSuggestions,
                        style: spec.style,
                        strutStyle: spec.strutStyle,
                        cursorColor: spec.cursorColor,
                        backgroundCursorColor: spec.backgroundCursorColor,
                        textAlign: spec.textAlign,
                        textDirection: widget.textDirection,
                        maxLines: widget.maxLines,
                        minLines: widget.minLines,
                        expands: widget.expands,
                        textHeightBehavior: spec.textHeightBehavior,
                        textWidthBasis: spec.textWidthBasis,
                        autofocus: widget.autofocus,
                        showCursor: widget.showCursor,
                        showSelectionHandles: _showSelectionHandles,
                        selectionColor: spec.selectionColor,
                        selectionControls: textSelectionControls,
                        keyboardType: widget.keyboardType,
                        textInputAction: widget.textInputAction,
                        textCapitalization: widget.textCapitalization,
                        onChanged: widget.onChanged,
                        onEditingComplete: widget.onEditingComplete,
                        onSubmitted: widget.onSubmitted,
                        onAppPrivateCommand: widget.onAppPrivateCommand,
                        onSelectionChanged: _handleSelectionChanged,
                        onSelectionHandleTapped: _handleSelectionHandleTapped,
                        onTapOutside: widget.onTapOutside,
                        inputFormatters: formatters,
                        mouseCursor: MouseCursor
                            .defer, // TextField will handle the cursor
                        rendererIgnoresPointer: true,
                        cursorWidth: spec.cursorWidth,
                        cursorHeight: spec.cursorHeight,
                        cursorRadius: spec.cursorRadius,
                        cursorOpacityAnimates: spec.cursorOpacityAnimates,
                        cursorOffset: spec.cursorOffset,
                        paintCursorAboveText: spec.paintCursorAboveText,
                        selectionHeightStyle: spec.selectionHeightStyle,
                        selectionWidthStyle: spec.selectionWidthStyle,
                        scrollPadding: spec.scrollPadding,
                        keyboardAppearance: spec.keyboardAppearance,
                        dragStartBehavior: widget.dragStartBehavior,
                        enableInteractiveSelection:
                            widget.enableInteractiveSelection,
                        scrollController: widget.scrollController,
                        scrollPhysics: widget.scrollPhysics,
                        autocorrectionTextRectColor:
                            spec.autocorrectionTextRectColor,
                        autofillClient: this,
                        clipBehavior: widget.clipBehavior,
                        restorationId: 'editable',
                        scribbleEnabled: widget.scribbleEnabled,
                        enableIMEPersonalizedLearning:
                            widget.enableIMEPersonalizedLearning,
                        contentInsertionConfiguration:
                            widget.contentInsertionConfiguration,
                        contextMenuBuilder: widget.contextMenuBuilder,
                        spellCheckConfiguration: widget.spellCheckConfiguration,
                        magnifierConfiguration: widget.magnifierConfiguration ??
                            m.TextMagnifier.adaptiveMagnifierConfiguration,
                        undoController: widget.undoController,
                      ),
                    ),
                  ),
                ),
                if (widget.suffix != null) widget.suffix!,
              ],
            ),
            if (widget.helperText != null)
              spec.helperText(widget.helperText ?? ''),
          ],
        );
      },
    );

    return Interactable(
      mouseCursor: SystemMouseCursors.text,
      controller: _statesController,
      child: TextFieldTapRegion(
        child: IgnorePointer(
          ignoring: widget.ignorePointers ?? !widget.enabled,
          child: AnimatedBuilder(
            animation: _effectiveController,
            builder: (context, child) => _TextFieldContext(
              isEmpty: _effectiveController.value.text.isEmpty,
              child: child!,
            ),
            child: _selectionGestureDetectorBuilder.buildGestureDetector(
              behavior: HitTestBehavior.translucent,
              child: child,
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get selectionEnabled => widget.selectionEnabled && widget.enabled;

  // AutofillClient implementation start.
  @override
  String get autofillId => _editableText!.autofillId;

  @override
  TextInputConfiguration get textInputConfiguration {
    final List<String>? autofillHints =
        widget.autofillHints?.toList(growable: false);
    final AutofillConfiguration autofillConfiguration = autofillHints != null
        ? AutofillConfiguration(
            uniqueIdentifier: autofillId,
            autofillHints: autofillHints,
            currentEditingValue: _effectiveController.value,
            hintText: widget.hintText,
          )
        : AutofillConfiguration.disabled;

    return _editableText!.textInputConfiguration
        .copyWith(autofillConfiguration: autofillConfiguration);
  }
  // AutofillClient implementation end.
}

class _TextFieldSelectionGestureDetectorBuilder
    extends TextSelectionGestureDetectorBuilder {
  final _TextFieldState _state;

  _TextFieldSelectionGestureDetectorBuilder({
    required _TextFieldState state,
  })  : _state = state,
        super(delegate: state);

  @override
  void onForcePressStart(ForcePressDetails details) {
    super.onForcePressStart(details);
    if (delegate.selectionEnabled && shouldShowSelectionToolbar) {
      editableText.showToolbar();
    }
  }

  @override
  // ignore: no-empty-block
  void onForcePressEnd(ForcePressDetails details) {
    // Not required.
  }

  @override
  void onUserTap() {
    _state.widget.onTap?.call();
  }

  @override
  void onSingleLongTapStart(LongPressStartDetails details) {
    super.onSingleLongTapStart(details);
    if (delegate.selectionEnabled) {
      switch (m.Theme.of(_state.context).platform) {
        case TargetPlatform.iOS:
        case TargetPlatform.macOS:
          break;
        case TargetPlatform.android:
        case TargetPlatform.fuchsia:
        case TargetPlatform.linux:
        case TargetPlatform.windows:
        // Feedback.forLongPress(_state.context);
      }
    }
  }

  @override
  bool get onUserTapAlwaysCalled => _state.widget.onTapAlwaysCalled;
}

class _TextFieldContext extends InheritedWidget {
  const _TextFieldContext({required super.child, required this.isEmpty});

  final bool isEmpty;

  @override
  bool updateShouldNotify(_TextFieldContext oldWidget) =>
      isEmpty != oldWidget.isEmpty;
}

class _HintLabel extends StatefulWidget {
  const _HintLabel({
    required this.text,
    required this.style,
    required this.float,
    required this.show,
    required this.floatingLabelHeight,
    required this.floatingLabelStyle,
    this.child,
  });

  final String text;
  final TextStyle style;
  final bool float;
  final bool show;
  final double floatingLabelHeight;
  final TextStyle floatingLabelStyle;
  final Widget? child;

  @override
  State<_HintLabel> createState() => _HintLabelState();
}

class _HintLabelState extends State<_HintLabel>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(_HintLabel oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.float != oldWidget.float) {
      if (widget.float) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => CustomPaint(
        painter: _FloatingLabelPainter(
          text: widget.text,
          style: widget.style,
          floatingProgress: _controller.value,
          show: widget.show,
          floatingLabelStyle: widget.floatingLabelStyle,
        ),
        child: Padding(
          padding: EdgeInsets.only(top: widget.floatingLabelHeight),
          child: widget.child,
        ),
      ),
    );
  }
}

class _FloatingLabelPainter extends CustomPainter {
  final String text;
  final TextStyle style;
  final double floatingProgress;
  final TextStyle floatingLabelStyle;
  final bool show;

  const _FloatingLabelPainter({
    required this.text,
    required this.style,
    required this.floatingProgress,
    required this.show,
    required this.floatingLabelStyle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (!show) return;
    final style = TextStyle.lerp(
      this.style,
      floatingLabelStyle,
      floatingProgress,
    );

    TextSpan span = TextSpan(text: text, style: style);

    TextPainter tp = TextPainter(
      text: span,
      textDirection: TextDirection.ltr,
    );
    tp.layout();

    final yCenter = Offset(0, (size.height - tp.height) / 2);

    const floatingPosition = Offset(0.0, -2);

    final offset = Offset.lerp(yCenter, floatingPosition, floatingProgress);
    tp.paint(canvas, offset!);
  }

  @override
  bool shouldRepaint(_FloatingLabelPainter oldDelegate) {
    return text != oldDelegate.text ||
        style != oldDelegate.style ||
        floatingProgress != oldDelegate.floatingProgress ||
        show != oldDelegate.show ||
        floatingLabelStyle != oldDelegate.floatingLabelStyle;
  }
}
