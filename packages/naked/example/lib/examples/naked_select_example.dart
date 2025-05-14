import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:naked/naked.dart';

class NakedSelectExample extends StatefulWidget {
  const NakedSelectExample({super.key});

  @override
  State<NakedSelectExample> createState() => _NakedSelectExampleState();
}

class _NakedSelectExampleState extends State<NakedSelectExample> {
  // Basic select state
  final bool _isBasicOpen = false;
  String? _basicSelectedValue;

  // Multiple select state
  final bool _isMultipleOpen = false;
  Set<String> _multipleSelectedValues = {};

  // Disabled select state
  final bool _isDisabledOpen = false;
  String? _disabledSelectedValue;

  // Search select state
  final bool _isSearchOpen = false;
  String? _searchSelectedValue;
  late final TextEditingController _searchController;
  String _searchText = '';
  final FocusNode _searchFocusNode = FocusNode();
  int _keyboardSelectedIndex = -1;

  // State for visual feedback
  bool _isBasicTriggerHovered = false;
  bool _isBasicTriggerFocused = false;
  bool _isBasicTriggerPressed = false;

  bool _isMultipleTriggerHovered = false;
  bool _isMultipleTriggerFocused = false;
  bool _isMultipleTriggerPressed = false;

  bool _isDisabledTriggerHovered = false;
  bool _isDisabledTriggerFocused = false;
  bool _isDisabledTriggerPressed = false;

  bool _isSearchTriggerHovered = false;
  bool _isSearchTriggerFocused = false;
  bool _isSearchTriggerPressed = false;

  // Item state maps
  final Map<String, bool> _basicItemHoverStates = {};
  final Map<String, bool> _basicItemFocusStates = {};
  final Map<String, bool> _basicItemPressStates = {};

  final Map<String, bool> _multipleItemHoverStates = {};
  final Map<String, bool> _multipleItemFocusStates = {};
  final Map<String, bool> _multipleItemPressStates = {};

  final Map<String, bool> _searchItemHoverStates = {};
  final Map<String, bool> _searchItemFocusStates = {};
  final Map<String, bool> _searchItemPressStates = {};

  // Options
  final List<String> _fruitOptions = [
    'Apple',
    'Banana',
    'Cherry',
    'Dragon Fruit',
    'Elderberry',
    'Fig',
    'Grape',
    'Honeydew',
  ];

  final List<String> _colorOptions = [
    'Red',
    'Orange',
    'Yellow',
    'Green',
    'Blue',
    'Indigo',
    'Violet',
    'Purple',
    'Pink',
    'Brown',
    'Black',
    'White',
    'Gray',
    'Teal',
    'Cyan',
    'Magenta',
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(_onSearchChanged);
    _searchFocusNode.addListener(_onSearchFocusChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchFocusNode.removeListener(_onSearchFocusChanged);
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchText = _searchController.text;
    });
  }

  void _onSearchFocusChanged() {
    if (_searchFocusNode.hasFocus) {
      setState(() {
        _keyboardSelectedIndex = -1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredColorOptions = _colorOptions
        .where(
            (color) => color.toLowerCase().contains(_searchText.toLowerCase()))
        .toList();

    return SingleChildScrollView(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            _buildHeader('NakedSelect Examples'),
            const SizedBox(height: 24),

            // Basic single-select example
            _buildSectionTitle('Basic Single Select'),
            const SizedBox(height: 8),
            _buildBasicSelect(),
            if (_basicSelectedValue != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text('Selected fruit: $_basicSelectedValue'),
              ),
            const SizedBox(height: 32),

            // Multiple select example
            _buildSectionTitle('Multiple Select'),
            const SizedBox(height: 8),
            _buildMultipleSelect(),
            if (_multipleSelectedValues.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                    'Selected fruits: ${_multipleSelectedValues.join(", ")}'),
              ),
            const SizedBox(height: 32),

            // Disabled select example
            _buildSectionTitle('Disabled Select'),
            const SizedBox(height: 8),
            _buildDisabledSelect(),
            const SizedBox(height: 32),

            // Search/filter select example
            _buildSectionTitle('Search/Filter Select'),
            const SizedBox(height: 8),
            _buildSearchSelect(filteredColorOptions),
            if (_searchSelectedValue != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text('Selected color: $_searchSelectedValue'),
              ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildBasicSelect() {
    return NakedSelect<String>(
      selectedValue: _basicSelectedValue,
      onSelectedValueChanged: (value) =>
          setState(() => _basicSelectedValue = value),
      menu: NakedSelectMenu(
        child: _buildMenuContainer(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _fruitOptions
                .map((fruit) => _buildBasicSelectItem(fruit))
                .toList(),
          ),
          color: Colors.blue,
        ),
      ),
      child: NakedSelectTrigger(
        onHoverState: (value) => setState(() => _isBasicTriggerHovered = value),
        onFocusState: (value) => setState(() => _isBasicTriggerFocused = value),
        onPressedState: (value) =>
            setState(() => _isBasicTriggerPressed = value),
        child: _buildTrigger(
          _basicSelectedValue ?? 'Select a fruit',
          _isBasicOpen,
          _isBasicTriggerHovered,
          _isBasicTriggerFocused,
          _isBasicTriggerPressed,
          Colors.blue,
        ),
      ),
    );
  }

  Widget _buildBasicSelectItem(String fruit) {
    return NakedSelectItem<String>(
      value: fruit,
      onHoverState: (value) =>
          setState(() => _basicItemHoverStates[fruit] = value),
      onFocusState: (value) =>
          setState(() => _basicItemFocusStates[fruit] = value),
      onPressedState: (value) =>
          setState(() => _basicItemPressStates[fruit] = value),
      child: _buildMenuItem(
        fruit,
        _basicSelectedValue == fruit,
        _basicItemHoverStates[fruit] ?? false,
        _basicItemFocusStates[fruit] ?? false,
        _basicItemPressStates[fruit] ?? false,
        Colors.blue,
      ),
    );
  }

  Widget _buildMultipleSelect() {
    return NakedSelect<String>(
      allowMultiple: true,
      selectedValues: _multipleSelectedValues,
      onSelectedValuesChanged: (values) =>
          setState(() => _multipleSelectedValues = values),
      closeOnSelect: false,
      menu: NakedSelectMenu(
        child: _buildMenuContainer(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _fruitOptions
                .map((fruit) => _buildMultipleSelectItem(fruit))
                .toList(),
          ),
          color: Colors.teal,
        ),
      ),
      child: NakedSelectTrigger(
        onHoverState: (value) =>
            setState(() => _isMultipleTriggerHovered = value),
        onFocusState: (value) =>
            setState(() => _isMultipleTriggerFocused = value),
        onPressedState: (value) =>
            setState(() => _isMultipleTriggerPressed = value),
        child: _buildTrigger(
          _multipleSelectedValues.isEmpty
              ? 'Select fruits'
              : '${_multipleSelectedValues.length} fruit(s) selected',
          _isMultipleOpen,
          _isMultipleTriggerHovered,
          _isMultipleTriggerFocused,
          _isMultipleTriggerPressed,
          Colors.teal,
        ),
      ),
    );
  }

  Widget _buildMultipleSelectItem(String fruit) {
    final isSelected = _multipleSelectedValues.contains(fruit);

    return NakedSelectItem<String>(
      value: fruit,
      isSelected: isSelected,
      onHoverState: (value) =>
          setState(() => _multipleItemHoverStates[fruit] = value),
      onFocusState: (value) =>
          setState(() => _multipleItemFocusStates[fruit] = value),
      onPressedState: (value) =>
          setState(() => _multipleItemPressStates[fruit] = value),
      child: _buildMenuItem(
        fruit,
        isSelected,
        _multipleItemHoverStates[fruit] ?? false,
        _multipleItemFocusStates[fruit] ?? false,
        _multipleItemPressStates[fruit] ?? false,
        Colors.teal,
        showCheckbox: true,
      ),
    );
  }

  Widget _buildDisabledSelect() {
    return NakedSelect<String>(
      selectedValue: _disabledSelectedValue,
      onSelectedValueChanged: (value) =>
          setState(() => _disabledSelectedValue = value),
      enabled: false,
      menu: NakedSelectMenu(
        child: _buildMenuContainer(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _fruitOptions
                .map((fruit) => _buildBasicSelectItem(fruit))
                .toList(),
          ),
          color: Colors.grey,
        ),
      ),
      child: NakedSelectTrigger(
        onHoverState: (value) =>
            setState(() => _isDisabledTriggerHovered = value),
        onFocusState: (value) =>
            setState(() => _isDisabledTriggerFocused = value),
        onPressedState: (value) =>
            setState(() => _isDisabledTriggerPressed = value),
        child: _buildTrigger(
          'Disabled Select',
          _isDisabledOpen,
          _isDisabledTriggerHovered,
          _isDisabledTriggerFocused,
          _isDisabledTriggerPressed,
          Colors.grey,
          isDisabled: true,
        ),
      ),
    );
  }

  Widget _buildSearchSelect(List<String> filteredOptions) {
    return KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: (event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
            setState(() {
              if (_keyboardSelectedIndex < filteredOptions.length - 1) {
                _keyboardSelectedIndex++;
              }
            });
          } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
            setState(() {
              if (_keyboardSelectedIndex > 0) {
                _keyboardSelectedIndex--;
              }
            });
          } else if (event.logicalKey == LogicalKeyboardKey.enter &&
              _keyboardSelectedIndex >= 0 &&
              _keyboardSelectedIndex < filteredOptions.length) {
            setState(() {
              _searchSelectedValue = filteredOptions[_keyboardSelectedIndex];
            });
          }
        }
      },
      child: NakedSelect<String>(
        enableTypeAhead: false,
        onMenuClose: () {
          setState(() {
            _searchController.clear();
            _keyboardSelectedIndex = -1;
          });
        },
        selectedValue: _searchSelectedValue,
        onSelectedValueChanged: (value) =>
            setState(() => _searchSelectedValue = value),
        menu: NakedSelectMenu(
          child: _buildMenuContainer(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildSearchField(),
                const Divider(height: 1),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: filteredOptions.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text('No colors found'),
                        )
                      : SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(
                              filteredOptions.length,
                              (index) => _buildSearchSelectItem(
                                  filteredOptions[index],
                                  isKeyboardSelected:
                                      index == _keyboardSelectedIndex),
                            ),
                          ),
                        ),
                ),
              ],
            ),
            color: Colors.purple,
          ),
        ),
        child: NakedSelectTrigger(
          onHoverState: (value) =>
              setState(() => _isSearchTriggerHovered = value),
          onFocusState: (value) =>
              setState(() => _isSearchTriggerFocused = value),
          onPressedState: (value) =>
              setState(() => _isSearchTriggerPressed = value),
          child: _buildTrigger(
            _searchSelectedValue ?? 'Select a color',
            _isSearchOpen,
            _isSearchTriggerHovered,
            _isSearchTriggerFocused,
            _isSearchTriggerPressed,
            Colors.purple,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return SelectSearchField(
      controller: _searchController,
      hintText: 'Search colors...',
      autofocus: true,
      focusNode: _searchFocusNode,
      onClear: () {
        setState(() {
          _searchText = '';
          _keyboardSelectedIndex = -1;
        });
      },
    );
  }

  Widget _buildSearchSelectItem(
    String color, {
    bool isKeyboardSelected = false,
  }) {
    return NakedSelectItem<String>(
      value: color,
      onHoverState: (value) =>
          setState(() => _searchItemHoverStates[color] = value),
      onFocusState: (value) =>
          setState(() => _searchItemFocusStates[color] = value),
      onPressedState: (value) =>
          setState(() => _searchItemPressStates[color] = value),
      child: _buildSearchMenuItem(
        color,
        _searchSelectedValue == color,
        _searchItemHoverStates[color] ?? false,
        _searchItemFocusStates[color] ?? false,
        _searchItemPressStates[color] ?? false,
        Colors.purple,
        isKeyboardSelected: isKeyboardSelected,
      ),
    );
  }

  Widget _buildSearchMenuItem(
    String text,
    bool isSelected,
    bool isHovered,
    bool isFocused,
    bool isPressed,
    MaterialColor color, {
    bool isKeyboardSelected = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isKeyboardSelected
            ? color.shade200
            : isSelected
                ? color.shade100
                : isPressed
                    ? color.shade50
                    : isHovered || isFocused
                        ? Colors.grey.shade100
                        : Colors.transparent,
        border: Border(
          left: BorderSide(
            color: isKeyboardSelected || isSelected
                ? color.shade500
                : Colors.transparent,
            width: 4,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: HighlightText(
              text: text,
              searchQuery: _searchText,
              style: TextStyle(
                fontWeight: isSelected || isKeyboardSelected
                    ? FontWeight.w600
                    : FontWeight.normal,
                color: isSelected || isKeyboardSelected
                    ? color.shade800
                    : Colors.black87,
              ),
              highlightStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: color.shade900,
                backgroundColor: color.shade50,
              ),
            ),
          ),
          if (isSelected)
            Icon(
              Icons.check,
              color: color.shade500,
              size: 20,
            ),
        ],
      ),
    );
  }

  Widget _buildTrigger(
    String text,
    bool isOpen,
    bool isHovered,
    bool isFocused,
    bool isPressed,
    MaterialColor color, {
    bool isDisabled = false,
  }) {
    return Container(
      width: 300,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDisabled
            ? Colors.grey.shade300
            : isPressed
                ? color.shade700
                : isHovered
                    ? color.shade600
                    : color.shade500,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isFocused && !isDisabled ? Colors.white : Colors.transparent,
          width: 2,
        ),
        boxShadow: isDisabled
            ? null
            : [
                (isHovered || isFocused)
                    ? BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      )
                    : const BoxShadow(
                        color: Colors.transparent,
                      )
              ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: isDisabled ? Colors.grey.shade700 : Colors.white,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
            color: isDisabled ? Colors.grey.shade700 : Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuContainer(
      {required Widget child, required MaterialColor color}) {
    return Container(
      constraints: const BoxConstraints(
        minWidth: 300,
        maxWidth: 300,
      ),
      margin: const EdgeInsets.only(top: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: child,
      ),
    );
  }

  Widget _buildMenuItem(
    String text,
    bool isSelected,
    bool isHovered,
    bool isFocused,
    bool isPressed,
    MaterialColor color, {
    bool showCheckbox = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isSelected
            ? color.shade100
            : isPressed
                ? color.shade50
                : isHovered || isFocused
                    ? Colors.grey.shade100
                    : Colors.transparent,
        border: Border(
          left: BorderSide(
            color: isSelected ? color.shade500 : Colors.transparent,
            width: 4,
          ),
        ),
      ),
      child: Row(
        children: [
          if (showCheckbox) ...[
            Icon(
              isSelected ? Icons.check_box : Icons.check_box_outline_blank,
              color: color.shade500,
              size: 20,
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? color.shade800 : Colors.black87,
              ),
            ),
          ),
          if (isSelected && !showCheckbox)
            Icon(
              Icons.check,
              color: color.shade500,
              size: 20,
            ),
        ],
      ),
    );
  }
}

// Custom search field widget
class SelectSearchField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final VoidCallback? onClear;
  final bool autofocus;
  final FocusNode? focusNode;

  const SelectSearchField({
    super.key,
    required this.controller,
    this.hintText = 'Search...',
    this.onClear,
    this.autofocus = false,
    this.focusNode,
  });

  @override
  State<SelectSearchField> createState() => _SelectSearchFieldState();
}

class _SelectSearchFieldState extends State<SelectSearchField> {
  bool _hasFocus = false;

  @override
  Widget build(BuildContext context) {
    final hasText = widget.controller.text.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Focus(
        onFocusChange: (hasFocus) {
          setState(() {
            _hasFocus = hasFocus;
          });
        },
        child: TextField(
          controller: widget.controller,
          decoration: InputDecoration(
            hintText: widget.hintText,
            prefixIcon: const Icon(Icons.search),
            suffixIcon: hasText
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 18),
                    onPressed: () {
                      widget.controller.clear();
                      if (widget.onClear != null) {
                        widget.onClear!();
                      }
                    },
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.purple.shade300, width: 2),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            fillColor: _hasFocus ? Colors.purple.shade50 : Colors.grey.shade50,
            filled: true,
          ),
          autofocus: widget.autofocus,
          textInputAction: TextInputAction.done,
          focusNode: widget.focusNode,
        ),
      ),
    );
  }
}

// Highlight text widget to show matching search text
class HighlightText extends StatelessWidget {
  final String text;
  final String searchQuery;
  final TextStyle style;
  final TextStyle highlightStyle;

  const HighlightText({
    super.key,
    required this.text,
    required this.searchQuery,
    this.style = const TextStyle(color: Colors.black87),
    this.highlightStyle = const TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      backgroundColor: Colors.yellow,
    ),
  });

  @override
  Widget build(BuildContext context) {
    if (searchQuery.isEmpty) {
      return Text(text, style: style);
    }

    final matches = <int>[];
    final lowerCaseText = text.toLowerCase();
    final lowerCaseQuery = searchQuery.toLowerCase();

    int startIndex = 0;
    while (true) {
      final index = lowerCaseText.indexOf(lowerCaseQuery, startIndex);
      if (index == -1) break;
      matches.add(index);
      startIndex = index + lowerCaseQuery.length;
    }

    if (matches.isEmpty) {
      return Text(text, style: style);
    }

    final spans = <TextSpan>[];
    int lastMatchEnd = 0;

    for (final index in matches) {
      if (index > lastMatchEnd) {
        spans.add(TextSpan(
          text: text.substring(lastMatchEnd, index),
          style: style,
        ));
      }

      spans.add(TextSpan(
        text: text.substring(index, index + lowerCaseQuery.length),
        style: highlightStyle,
      ));

      lastMatchEnd = index + lowerCaseQuery.length;
    }

    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastMatchEnd),
        style: style,
      ));
    }

    return RichText(text: TextSpan(children: spans));
  }
}
