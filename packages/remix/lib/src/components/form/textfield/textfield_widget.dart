part of 'textfield.dart';

/// A customizable text field component that supports various input types, styles, and behaviors.
/// The text field integrates with the Mix styling system and follows Remix design patterns.
///
/// ## Example
///
/// ```dart
/// RxTextField(
///   placeholderText: 'Enter your text',
///   onChanged: (value) {
///     print('Text changed: $value');
///   },
///   maxLength: 100,
///   style: RxTextFieldStyle(),
/// )
/// ```
///

class RxTextField extends StatefulWidget implements Disableable, Errorable {
  const RxTextField({
    super.key,
    this.controller,
    this.maxLength,
    this.focusNode,
    this.enabled = true,
    this.ignorePointers,
    this.onPressed,
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
    this.smartDashesType,
    this.smartQuotesType,
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
    this.prefix,
    this.suffix,
  })  : assert(maxLength == null ||
            maxLength == RxTextField.noMaxLength ||
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
  @override
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
  @override
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
  /// to [RxTextField.noMaxLength] then only the current character count is displayed.
  ///
  /// After [maxLength] characters have been input, additional input
  /// is ignored, unless [maxLengthEnforcement] is set to
  /// [MaxLengthEnforcement.none].
  ///
  /// The text field enforces the length with a [LengthLimitingTextInputFormatter],
  /// which is evaluated after the supplied [inputFormatters], if any.
  ///
  /// This value must be either null, [RxTextField.noMaxLength], or greater than 0.
  /// If null (the default) then there is no limit to the number of characters
  /// that can be entered. If set to [RxTextField.noMaxLength], then no limit will
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
  final Widget? prefix;
  final Widget? suffix;

  /// Determine whether this text field can request the primary focus.
  ///
  /// Defaults to true. If false, the text field will not request focus
  /// when tapped, or when its context menu is displayed. If false it will not
  /// be possible to move the focus to the text field with tab key.
  final bool canRequestFocus;

  /// Whether [onPressed] should be called for every tap.
  ///
  /// Defaults to false, so [onPressed] is only called for each distinct tap. When
  /// enabled, [onPressed] is called for every tap including consecutive taps.
  final bool onTapAlwaysCalled;

  /// {@macro flutter.material.textfield.onTap}
  ///  If [onTapAlwaysCalled] is enabled, this will also be called for consecutive
  /// taps.
  final GestureTapCallback? onPressed;

  final bool enableInteractiveSelection;
  final TextSelectionControls? selectionControls;
  final ScrollController? scrollController;
  final ScrollPhysics? scrollPhysics;
  final Clip clipBehavior;
  final String? restorationId;
  final bool scribbleEnabled;
  final bool enableIMEPersonalizedLearning;

  final Iterable<String>? autofillHints;
  final ContentInsertionConfiguration? contentInsertionConfiguration;

  final DragStartBehavior dragStartBehavior;
  final Object groupId;
  final AppPrivateCommandCallback? onAppPrivateCommand;

  final TapRegionCallback? onTapOutside;
  final TextMagnifierConfiguration? magnifierConfiguration;
  final SpellCheckConfiguration? spellCheckConfiguration;

  final UndoHistoryController? undoController;
  final RxTextFieldStyle? style;
  final List<Variant> variants;

  final Widget Function(BuildContext, EditableTextState)? contextMenuBuilder;

  /// {@macro flutter.widgets.editableText.selectionEnabled}
  bool get selectionEnabled => enableInteractiveSelection;

  @override
  State<RxTextField> createState() => _RxTextFieldState();
}

class _RxTextFieldState extends State<RxTextField>
    with MixControllerMixin, DisableableMixin, ErrorableMixin {
  RxTextFieldStyle get _style =>
      RxTextFieldStyle._default().merge(widget.style ?? RxTextFieldStyle());

  @override
  Widget build(BuildContext context) {
    return RemixBuilder(
      builder: (context) {
        final spec = TextFieldSpec.of(context);

        return NakedTextField(
          groupId: widget.groupId,
          controller: widget.controller,
          focusNode: widget.focusNode,
          undoController: widget.undoController,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          textCapitalization: widget.textCapitalization,
          textAlign: spec.textAlign,
          textDirection: widget.textDirection,
          readOnly: widget.readOnly,
          showCursor: widget.showCursor,
          autofocus: widget.autofocus,
          obscuringCharacter: widget.obscuringCharacter,
          obscureText: widget.obscureText,
          autocorrect: widget.autocorrect,
          smartDashesType: widget.smartDashesType,
          smartQuotesType: widget.smartQuotesType,
          enableSuggestions: widget.enableSuggestions,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          expands: widget.expands,
          maxLength: widget.maxLength,
          maxLengthEnforcement: widget.maxLengthEnforcement,
          onChanged: widget.onChanged,
          onEditingComplete: widget.onEditingComplete,
          onSubmitted: widget.onSubmitted,
          onAppPrivateCommand: widget.onAppPrivateCommand,
          inputFormatters: widget.inputFormatters,
          enabled: widget.enabled,
          cursorWidth: spec.cursorWidth,
          cursorHeight: spec.cursorHeight,
          cursorRadius: spec.cursorRadius,
          cursorOpacityAnimates: spec.cursorOpacityAnimates,
          cursorColor: spec.cursorColor,
          selectionHeightStyle: spec.selectionHeightStyle,
          selectionWidthStyle: spec.selectionWidthStyle,
          keyboardAppearance: spec.keyboardAppearance,
          scrollPadding: spec.scrollPadding,
          dragStartBehavior: widget.dragStartBehavior,
          enableInteractiveSelection: widget.enableInteractiveSelection,
          selectionControls: widget.selectionControls,
          onPressed: widget.onPressed,
          onTapAlwaysCalled: widget.onTapAlwaysCalled,
          onPressedState: (state) {
            mixController.pressed = state;
          },
          onTapOutside: widget.onTapOutside,
          scrollController: widget.scrollController,
          scrollPhysics: widget.scrollPhysics,
          autofillHints: widget.autofillHints,
          contentInsertionConfiguration: widget.contentInsertionConfiguration,
          clipBehavior: widget.clipBehavior,
          restorationId: widget.restorationId,
          scribbleEnabled: widget.scribbleEnabled,
          enableIMEPersonalizedLearning: widget.enableIMEPersonalizedLearning,
          contextMenuBuilder: widget.contextMenuBuilder,
          canRequestFocus: widget.canRequestFocus,
          spellCheckConfiguration: widget.spellCheckConfiguration,
          magnifierConfiguration: widget.magnifierConfiguration,
          onHoverState: (state) {
            mixController.hovered = state;
          },
          onFocusState: (state) {
            mixController.focused = state;
          },
          style: spec.style,
          builder: (context, textArea) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: spec.spacing,
              children: [
                if (widget.label case final String label) Text(label),
                spec.container(
                  direction: Axis.horizontal,
                  children: [
                    if (widget.prefix != null) widget.prefix!,
                    Expanded(
                      child: widget.controller != null
                          ? ListenableBuilder(
                              listenable: widget.controller!,
                              builder: (context, child) {
                                final isEmpty = widget.controller!.text.isEmpty;

                                return CustomPaint(
                                  painter: _PlaceholderPainter(
                                    text: widget.hintText ?? '',
                                    textStyle: spec.style.copyWith(
                                      color: spec.hintTextColor,
                                    ),
                                    textDirection: Directionality.of(context),
                                    showPlaceholder: isEmpty,
                                  ),
                                  child: textArea,
                                );
                              },
                            )
                          : textArea,
                    ),
                    if (widget.suffix != null) widget.suffix!,
                  ],
                ),
                if (widget.helperText case final String helperText)
                  spec.helperText(helperText),
              ],
            );
          },
          ignorePointers: widget.ignorePointers,
        );
      },
      style: Style(_style).applyVariants(widget.variants),
      controller: mixController,
    );
  }
}

class _PlaceholderPainter extends CustomPainter {
  final String text;
  final TextStyle textStyle;
  final TextDirection textDirection;
  final bool showPlaceholder;

  const _PlaceholderPainter({
    required this.text,
    required this.textStyle,
    required this.textDirection,
    this.showPlaceholder = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final textSpan = TextSpan(text: text, style: textStyle);

    if (!showPlaceholder) return;

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: textDirection,
    );

    textPainter.layout(maxWidth: size.width);

    textPainter.paint(canvas, Offset.zero);
  }

  @override
  bool shouldRepaint(covariant _PlaceholderPainter oldDelegate) {
    return text != oldDelegate.text &&
        textStyle != oldDelegate.textStyle &&
        textDirection != oldDelegate.textDirection &&
        showPlaceholder != oldDelegate.showPlaceholder;
  }
}
