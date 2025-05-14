import 'package:flutter/material.dart';
import 'package:naked/naked.dart';

class NakedCheckboxExample extends StatefulWidget {
  const NakedCheckboxExample({super.key});

  @override
  State<NakedCheckboxExample> createState() => _NakedCheckboxExampleState();
}

class _NakedCheckboxExampleState extends State<NakedCheckboxExample> {
  @override
  Widget build(BuildContext context) {
    // Determine column count based on screen width for responsive layout
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 600 ? 2 : 1; // Example breakpoint

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Center(
              child: Text(
                'Checkbox Examples',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
              ),
            ),
            const SizedBox(height: 24),

            // --- Basic Checkbox States Section ---
            _buildSectionTitle('Basic Checkbox States'),
            _buildSectionContainer(
              child: const BasicCheckboxStates(),
            ),
            const SizedBox(height: 40),

            // --- Parent-Child Checkboxes Section ---
            _buildSectionTitle(
                'Parent-Child Checkboxes with Indeterminate State'),
            _buildSectionContainer(
              child: const ParentChildCheckboxes(),
            ),
            const SizedBox(height: 40),

            // --- Custom Styled Checkboxes Section ---
            _buildSectionTitle('Custom Styled Checkboxes'),
            _buildSectionContainer(
              child: GridView.count(
                crossAxisCount: crossAxisCount,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                // Adjust aspect ratio for better layout, especially on mobile
                childAspectRatio: (screenWidth / crossAxisCount) /
                    (crossAxisCount == 1 ? 120 : 150),
                children: const [
                  // Replace placeholders with the actual StyledCheckboxes component
                  // We'll wrap each style in its own state management widget
                  StyledCheckboxVariant(style: CheckboxStyle.primary),
                  StyledCheckboxVariant(style: CheckboxStyle.customWithIcon),
                  StyledCheckboxVariant(style: CheckboxStyle.rounded),
                  StyledCheckboxVariant(style: CheckboxStyle.squared),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // --- Focus and Keyboard Navigation Example ---
            _buildSectionTitle('Focus and Keyboard Navigation'),
            _buildSectionContainer(
              child: const FocusCheckboxExample(),
            ),
            const SizedBox(height: 40),

            // --- Advanced Selection Example Section ---
            _buildSectionTitle('Advanced Selection Example'),
            _buildSectionContainer(
              child: const SelectionExample(),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Helper to build section titles
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Color(0xFF374151), // text-gray-700
        ),
      ),
    );
  }

  // Helper to build container for each section (matches reference style)
  Widget _buildSectionContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1), // subtle shadow
          ),
        ],
      ),
      child: child,
    );
  }
}

// --- Basic Checkbox States Component ---
class BasicCheckboxStates extends StatefulWidget {
  const BasicCheckboxStates({super.key});

  @override
  State<BasicCheckboxStates> createState() => _BasicCheckboxStatesState();
}

class _BasicCheckboxStatesState extends State<BasicCheckboxStates> {
  bool _isChecked = false;
  bool _isIndeterminate = false;

  // State trackers for visual feedback (optional, but good for debugging/learning)
  bool _isHovered = false;
  bool _isPressed = false;
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    // Web Reference (React/Tailwind): BasicCheckboxStates component

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- States Demonstration ---
        _buildSubsectionTitle('States Demonstration'),
        // Unchecked
        _buildCheckboxRow(
          label: 'Unchecked (initial state)',
          isChecked: false,
          isDisabled: true, // Make it read-only for demonstration
        ),
        // Checked
        _buildCheckboxRow(
          label: 'Checked state',
          isChecked: true,
          isDisabled: true,
        ),
        // Indeterminate
        _buildCheckboxRow(
          label: 'Indeterminate state',
          isChecked: false, // When indeterminate, isChecked is usually false
          isIndeterminate: true,
          isDisabled: true,
        ),
        const SizedBox(height: 24),

        // --- Interactive Example ---
        _buildSubsectionTitle('Interactive Example'),
        const Text(
          'Click the buttons to change the state:',
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            NakedCheckbox(
              checked: _isChecked,
              indeterminate: _isIndeterminate,
              onChanged: (value) {
                setState(() {
                  _isChecked = value;
                  _isIndeterminate =
                      false; // Clicking resolves indeterminate state
                });
              },
              // Optional state tracking for visual feedback
              onHoverState: (value) => setState(() => _isHovered = value),
              onPressedState: (value) => setState(() => _isPressed = value),
              onFocusState: (value) => setState(() => _isFocused = value),
              // Web Reference (React/Tailwind): input element with ref/checked/onChange
              // className="w-5 h-5 rounded text-blue-500 focus:ring-blue-500"
              child: _buildDefaultCheckboxVisual(
                isChecked: _isChecked,
                isIndeterminate: _isIndeterminate,
                isHovered: _isHovered,
                isPressed: _isPressed,
                isFocused: _isFocused,
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 8),
            // Make label tappable to toggle checkbox
            GestureDetector(
              onTap: () {
                setState(() {
                  if (_isIndeterminate) {
                    _isChecked = true; // Indeterminate -> Checked
                    _isIndeterminate = false;
                  } else {
                    _isChecked = !_isChecked; // Toggle Checked/Unchecked
                  }
                });
              },
              child: const Text('Interactive checkbox'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Buttons to control state
        Wrap(
          // Use Wrap for better responsiveness
          spacing: 8.0,
          runSpacing: 8.0,
          children: [
            // Web Reference (React/Tailwind): Button elements with onClick handlers
            // className="bg-blue-500 hover:bg-blue-600 text-white font-medium py-1 px-3 rounded text-sm"
            _buildControlButton(
              label: 'Set Unchecked',
              color: Colors.blue,
              onPressed: () => setState(() {
                _isChecked = false;
                _isIndeterminate = false;
              }),
            ),
            _buildControlButton(
              label: 'Set Checked',
              color: Colors.green,
              onPressed: () => setState(() {
                _isChecked = true;
                _isIndeterminate = false;
              }),
            ),
            _buildControlButton(
              label: 'Set Indeterminate',
              color: Colors.purple,
              onPressed: () => setState(() {
                _isChecked =
                    false; // Indeterminate visually means neither fully checked nor unchecked
                _isIndeterminate = true;
              }),
            ),
          ],
        ),
      ],
    );
  }

  // Helper for subsection titles
  Widget _buildSubsectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, top: 8.0),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF4B5563)), // text-gray-600
      ),
    );
  }

  // Helper to build a row with a checkbox and label (used for demonstration)
  Widget _buildCheckboxRow({
    required String label,
    required bool isChecked,
    bool isIndeterminate = false,
    bool isDisabled = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          NakedCheckbox(
            checked: isChecked,
            indeterminate: isIndeterminate,
            enabled: isDisabled,
            onChanged: isDisabled ? null : (v) {}, // No-op for demo
            // Web Reference (React/Tailwind): input element
            child: _buildDefaultCheckboxVisual(
              isChecked: isChecked,
              isIndeterminate: isIndeterminate,
              isDisabled: isDisabled,
              color: Colors.blue,
            ),
          ),
          const SizedBox(width: 8),
          Text(label,
              style: TextStyle(color: isDisabled ? Colors.grey : Colors.black)),
        ],
      ),
    );
  }

  // Default visual representation of the checkbox (Updated)
  Widget _buildDefaultCheckboxVisual({
    required bool isChecked,
    bool isIndeterminate = false,
    bool isHovered = false,
    bool isPressed = false,
    bool isFocused = false,
    bool isDisabled = false,
    required Color color, // Base color (e.g., Colors.blue)
  }) {
    // Determine colors based on state - mimicking Tailwind focus:ring, text-blue-500 etc.
    Color effectiveBorderColor = isDisabled ? Colors.grey.shade300 : color;
    Color effectiveBgColor = isDisabled
        ? Colors.grey.shade200
        : (isChecked || isIndeterminate)
            ? color
            : Colors.white;
    Color checkIconColor = isDisabled ? Colors.grey.shade500 : Colors.white;
    Color? focusRingColor;

    // Adjust colors for enabled states using alphaBlend for darkening/lightening
    if (!isDisabled) {
      // --- Focus State --- (Mimics focus ring)
      if (isFocused) {
        // Darken border slightly for focus
        effectiveBorderColor =
            Color.alphaBlend(Colors.black.withValues(alpha: 0.3), color);
        // Create a semi-transparent outer ring color
        focusRingColor = color.withValues(alpha: 0.3);
      }

      // --- Hover State --- (Subtle background/border change)
      if (isHovered) {
        effectiveBorderColor =
            Color.alphaBlend(Colors.black.withValues(alpha: 0.2), color);
        if (!isChecked && !isIndeterminate) {
          // Light background tint on hover when unchecked
          effectiveBgColor =
              Color.alphaBlend(color.withValues(alpha: 0.05), Colors.white);
        }
      }

      // --- Pressed State --- (More noticeable background/border change)
      if (isPressed) {
        effectiveBorderColor =
            Color.alphaBlend(Colors.black.withValues(alpha: 0.4), color);
        if (!isChecked && !isIndeterminate) {
          // Darker background tint on press when unchecked
          effectiveBgColor =
              Color.alphaBlend(color.withValues(alpha: 0.1), Colors.white);
        } else {
          // Darken the main color slightly when pressed & checked/indeterminate
          effectiveBgColor =
              Color.alphaBlend(Colors.black.withValues(alpha: 0.2), color);
        }
      }
    }

    // Icon for checkmark or indeterminate state (Using Material Icons)
    Widget? checkMark;
    if (isIndeterminate) {
      // Web Reference: <Minus className="w-4 h-4 text-white" />
      // Use Material Icons.remove for the minus symbol
      checkMark = Icon(Icons.remove, size: 16, color: checkIconColor);
    } else if (isChecked) {
      // Web Reference: <Check className="w-4 h-4 text-white" />
      // Use Material Icons.check for the check symbol
      checkMark = Icon(Icons.check, size: 16, color: checkIconColor);
    }

    // Base container with border and background
    Widget checkboxVisual = Container(
      width: 20, // w-5
      height: 20, // h-5
      decoration: BoxDecoration(
        color: effectiveBgColor,
        // Web Reference: rounded
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: effectiveBorderColor,
          width: 1.5, // Slightly thicker border
        ),
      ),
      child: checkMark, // Place the icon inside
    );

    // Add focus ring effect using an outer container if focused
    if (focusRingColor != null) {
      checkboxVisual = Container(
        // Apply padding to create space for the ring
        padding: const EdgeInsets.all(2.0),
        decoration: BoxDecoration(
          // Match the checkbox shape or make slightly larger if needed
          borderRadius: BorderRadius.circular(6),
          border:
              Border.all(color: focusRingColor, width: 1.5), // The focus ring
        ),
        // The actual checkbox visual goes inside the ring container
        child: checkboxVisual,
      );
    }

    // Use AnimatedContainer for smooth transitions between states
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100), // Quick transition
      // The decoration is now applied to the inner container(s)
      // so the AnimatedContainer just handles the smooth transition.
      child: checkboxVisual,
    );
  }

  // Helper for control buttons
  Widget _buildControlButton({
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        textStyle: const TextStyle(fontSize: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}

// --- Parent-Child Checkboxes Component ---
class ParentChildCheckboxes extends StatefulWidget {
  const ParentChildCheckboxes({super.key});

  @override
  State<ParentChildCheckboxes> createState() => _ParentChildCheckboxesState();
}

// Helper class to hold item state
class _ItemState {
  final int id;
  final String name;
  bool isChecked = false;

  _ItemState({required this.id, required this.name});
}

class _ParentChildCheckboxesState extends State<ParentChildCheckboxes> {
  // Initialize the list of items
  final List<_ItemState> _items = List.generate(
    4,
    (index) => _ItemState(id: index + 1, name: 'Item ${index + 1}'),
  );

  // Calculate parent state based on children
  bool get _allChecked => _items.every((item) => item.isChecked);
  bool get _someChecked => _items.any((item) => item.isChecked);
  bool get _isParentIndeterminate => _someChecked && !_allChecked;
  bool get _parentCheckedValue =>
      _allChecked; // Parent is checked only if ALL children are

  // State trackers for parent checkbox visuals (optional)
  bool _isParentHovered = false;
  bool _isParentPressed = false;
  bool _isParentFocused = false;

  // Handle parent checkbox change
  void _handleParentChange(bool? newValue) {
    // newValue is null if clicked while indeterminate, treat as checking all
    final bool checkAll = newValue ?? true;
    setState(() {
      for (var item in _items) {
        item.isChecked = checkAll;
      }
    });
  }

  // Handle child checkbox change
  void _handleChildChange(int id, bool newValue) {
    setState(() {
      final item = _items.firstWhere((item) => item.id == id);
      item.isChecked = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Web Reference (React/Tailwind): ParentChildCheckboxes component
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'The parent checkbox becomes indeterminate when some (but not all) children are selected.',
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 16),

        // --- Parent Checkbox ---
        // Web Reference: Parent input checkbox with ref/checked/onChange
        Container(
          padding: const EdgeInsets.only(bottom: 8.0),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
          ),
          child: Row(
            children: [
              NakedCheckbox(
                checked: _parentCheckedValue,
                indeterminate: _isParentIndeterminate,
                onChanged: (value) => _handleParentChange(value),
                onHoverState: (value) =>
                    setState(() => _isParentHovered = value),
                onPressedState: (value) =>
                    setState(() => _isParentPressed = value),
                onFocusState: (value) =>
                    setState(() => _isParentFocused = value),
                child: _buildDefaultCheckboxVisual(
                  isChecked: _parentCheckedValue,
                  isIndeterminate: _isParentIndeterminate,
                  isHovered: _isParentHovered,
                  isPressed: _isParentPressed,
                  isFocused: _isParentFocused,
                  color: Colors.blue.shade600, // Example using a shade
                ),
              ),
              const SizedBox(width: 8),
              // Make label tappable
              GestureDetector(
                onTap: () =>
                    _handleParentChange(null), // Treat tap as toggle all
                child: const Text(
                  'Select All Items',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // --- Child Checkboxes ---
        // Web Reference: Child input checkboxes mapped from items state
        Padding(
          padding: const EdgeInsets.only(left: 28.0), // Indent children
          child: Column(
            children: _items.map((item) {
              // State trackers for child visuals (can be managed per item if needed)
              // For simplicity, we won't track hover/press/focus per child here,
              // but you could by adding more state variables or a Map.
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    NakedCheckbox(
                      checked: item.isChecked,
                      // Children are never indeterminate themselves
                      onChanged: (value) => _handleChildChange(item.id, value),
                      child: _buildDefaultCheckboxVisual(
                        isChecked: item.isChecked,
                        // Pass base color, visual builder handles states
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Make label tappable
                    GestureDetector(
                      onTap: () => _handleChildChange(item.id, !item.isChecked),
                      child: Text(item.name),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // Re-use the visual builder from BasicCheckboxStates (or move it to a common place)
  // For now, copying it here for encapsulation. Consider refactoring later.
  Widget _buildDefaultCheckboxVisual({
    required bool isChecked,
    bool isIndeterminate = false,
    bool isHovered = false,
    bool isPressed = false,
    bool isFocused = false,
    bool isDisabled = false,
    required Color color,
  }) {
    Color effectiveBorderColor = isDisabled ? Colors.grey.shade300 : color;
    Color effectiveBgColor = isDisabled
        ? Colors.grey.shade200
        : (isChecked || isIndeterminate)
            ? color
            : Colors.white;
    Color checkIconColor = isDisabled ? Colors.grey.shade500 : Colors.white;
    Color? focusRingColor;

    if (!isDisabled) {
      if (isFocused) {
        effectiveBorderColor =
            Color.alphaBlend(Colors.black.withValues(alpha: 0.3), color);
        focusRingColor = color.withValues(alpha: 0.3);
      }
      if (isHovered) {
        effectiveBorderColor =
            Color.alphaBlend(Colors.black.withValues(alpha: 0.2), color);
        if (!isChecked && !isIndeterminate) {
          effectiveBgColor =
              Color.alphaBlend(color.withValues(alpha: 0.05), Colors.white);
        }
      }
      if (isPressed) {
        effectiveBorderColor =
            Color.alphaBlend(Colors.black.withValues(alpha: 0.4), color);
        if (!isChecked && !isIndeterminate) {
          effectiveBgColor =
              Color.alphaBlend(color.withValues(alpha: 0.1), Colors.white);
        } else {
          effectiveBgColor =
              Color.alphaBlend(Colors.black.withValues(alpha: 0.2), color);
        }
      }
    }

    Widget? checkMark;
    if (isIndeterminate) {
      checkMark = Icon(Icons.remove, size: 16, color: checkIconColor);
    } else if (isChecked) {
      checkMark = Icon(Icons.check, size: 16, color: checkIconColor);
    }

    Widget checkboxVisual = Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: effectiveBgColor,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: effectiveBorderColor, width: 1.5),
      ),
      child: checkMark,
    );

    if (focusRingColor != null) {
      checkboxVisual = Container(
        padding: const EdgeInsets.all(2.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: focusRingColor, width: 1.5),
        ),
        child: checkboxVisual,
      );
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      child: checkboxVisual,
    );
  }
}

// --- Custom Styled Checkboxes ---

enum CheckboxStyle { primary, rounded, squared, customWithIcon }

// A stateful widget to manage the state for a single styled checkbox variant
class StyledCheckboxVariant extends StatefulWidget {
  final CheckboxStyle style;

  const StyledCheckboxVariant({required this.style, super.key});

  @override
  State<StyledCheckboxVariant> createState() => _StyledCheckboxVariantState();
}

class _StyledCheckboxVariantState extends State<StyledCheckboxVariant> {
  bool _isChecked = false;
  bool _isIndeterminate = false;
  bool _isHovered = false;
  bool _isPressed = false;
  bool _isFocused = false;

  void _toggleChecked() {
    setState(() {
      if (_isIndeterminate) {
        _isChecked = true;
        _isIndeterminate = false;
      } else {
        _isChecked = !_isChecked;
      }
    });
  }

  void _toggleIndeterminate() {
    setState(() {
      if (_isIndeterminate) {
        _isIndeterminate = false;
        _isChecked = false;
      } else {
        _isIndeterminate = true;
        _isChecked = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String title;
    Color baseColor;
    Widget checkboxVisual;

    switch (widget.style) {
      case CheckboxStyle.primary:
        // Web Reference: Primary Style input + label
        title = 'Primary Style';
        baseColor = Colors.blue;
        checkboxVisual = _buildDefaultCheckboxVisual(
          isChecked: _isChecked,
          isIndeterminate: _isIndeterminate,
          isHovered: _isHovered,
          isPressed: _isPressed,
          isFocused: _isFocused,
          color: baseColor,
        );
        break;
      case CheckboxStyle.rounded:
        // Web Reference: Rounded Style input + label
        title = 'Rounded Style';
        baseColor = Colors.green;
        checkboxVisual = _buildStyledCheckboxVisual(
          style: widget.style,
          isChecked: _isChecked,
          isIndeterminate: _isIndeterminate,
          isHovered: _isHovered,
          isPressed: _isPressed,
          isFocused: _isFocused,
          color: baseColor,
        );
        break;
      case CheckboxStyle.squared:
        // Web Reference: Squared Style input + label
        title = 'Squared Style';
        baseColor = Colors.red;
        checkboxVisual = _buildStyledCheckboxVisual(
          style: widget.style,
          isChecked: _isChecked,
          isIndeterminate: _isIndeterminate,
          isHovered: _isHovered,
          isPressed: _isPressed,
          isFocused: _isFocused,
          color: baseColor,
        );
        break;
      case CheckboxStyle.customWithIcon:
        // Web Reference: Custom With Icons div structure
        title = 'Custom With Icons';
        baseColor = Colors.purple;
        checkboxVisual = _buildStyledCheckboxVisual(
          style: widget.style,
          isChecked: _isChecked,
          isIndeterminate: _isIndeterminate,
          isHovered: _isHovered,
          isPressed: _isPressed,
          isFocused: _isFocused,
          color: baseColor,
        );
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min, // Important for GridView layout
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Text(
            title,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF4B5563)),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            NakedCheckbox(
              checked: _isChecked,
              indeterminate: _isIndeterminate,
              onChanged: (value) => _toggleChecked(), // Simplified toggle
              onHoverState: (value) => setState(() => _isHovered = value),
              onPressedState: (value) => setState(() => _isPressed = value),
              onFocusState: (value) => setState(() => _isFocused = value),
              child: checkboxVisual,
            ),
            const SizedBox(width: 8),
            // Make label tappable
            Flexible(
              // Use Flexible for text wrapping if needed
              child: GestureDetector(
                onTap: _toggleChecked,
                child: Text(title), // Use title as label for simplicity
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Button to toggle indeterminate state (matches reference)
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: baseColor.withValues(alpha: 0.1),
            foregroundColor: Color.alphaBlend(
                Colors.black.withValues(alpha: 0.7), baseColor),
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            textStyle: const TextStyle(fontSize: 11),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
          onPressed: _toggleIndeterminate,
          child: const Text('Toggle Indeterminate'),
        ),
      ],
    );
  }

  // --- Visual Builders for Styled Checkboxes ---

  // Using the existing default visual for Primary style
  Widget _buildDefaultCheckboxVisual({
    required bool isChecked,
    bool isIndeterminate = false,
    bool isHovered = false,
    bool isPressed = false,
    bool isFocused = false,
    bool isDisabled = false,
    required Color color,
  }) {
    Color effectiveBorderColor = isDisabled ? Colors.grey.shade300 : color;
    Color effectiveBgColor = isDisabled
        ? Colors.grey.shade200
        : (isChecked || isIndeterminate)
            ? color
            : Colors.white;
    Color checkIconColor = isDisabled ? Colors.grey.shade500 : Colors.white;
    Color? focusRingColor;

    if (!isDisabled) {
      if (isFocused) {
        effectiveBorderColor =
            Color.alphaBlend(Colors.black.withValues(alpha: 0.3), color);
        focusRingColor = color.withValues(alpha: 0.3);
      }
      if (isHovered) {
        effectiveBorderColor =
            Color.alphaBlend(Colors.black.withValues(alpha: 0.2), color);
        if (!isChecked && !isIndeterminate) {
          effectiveBgColor =
              Color.alphaBlend(color.withValues(alpha: 0.05), Colors.white);
        }
      }
      if (isPressed) {
        effectiveBorderColor =
            Color.alphaBlend(Colors.black.withValues(alpha: 0.4), color);
        if (!isChecked && !isIndeterminate) {
          effectiveBgColor =
              Color.alphaBlend(color.withValues(alpha: 0.1), Colors.white);
        } else {
          effectiveBgColor =
              Color.alphaBlend(Colors.black.withValues(alpha: 0.2), color);
        }
      }
    }

    Widget? checkMark;
    if (isIndeterminate) {
      checkMark = Icon(Icons.remove, size: 16, color: checkIconColor);
    } else if (isChecked) {
      checkMark = Icon(Icons.check, size: 16, color: checkIconColor);
    }

    Widget checkboxVisual = Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: effectiveBgColor,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: effectiveBorderColor, width: 1.5),
      ),
      child: checkMark,
    );

    if (focusRingColor != null) {
      checkboxVisual = Container(
        padding: const EdgeInsets.all(2.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: focusRingColor, width: 1.5),
        ),
        child: checkboxVisual,
      );
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      child: checkboxVisual,
    );
  }

  // Builder for other styles (Rounded, Squared, CustomIcon)
  Widget _buildStyledCheckboxVisual({
    required CheckboxStyle style,
    required bool isChecked,
    bool isIndeterminate = false,
    bool isHovered = false,
    bool isPressed = false,
    bool isFocused = false,
    bool isDisabled = false,
    required Color color,
  }) {
    // State-based color calculation (similar to _buildDefaultCheckboxVisual)
    Color effectiveBorderColor = isDisabled ? Colors.grey.shade300 : color;
    Color effectiveBgColor = isDisabled
        ? Colors.grey.shade200
        : (isChecked || isIndeterminate)
            ? color
            : Colors.white;
    Color checkIconColor = isDisabled ? Colors.grey.shade500 : Colors.white;
    Color? focusRingColor;

    if (!isDisabled) {
      if (isFocused) {
        effectiveBorderColor =
            Color.alphaBlend(Colors.black.withValues(alpha: 0.3), color);
        focusRingColor = color.withValues(alpha: 0.3);
      }
      if (isHovered) {
        effectiveBorderColor =
            Color.alphaBlend(Colors.black.withValues(alpha: 0.2), color);
        if (!isChecked && !isIndeterminate) {
          effectiveBgColor =
              Color.alphaBlend(color.withValues(alpha: 0.05), Colors.white);
        }
      }
      if (isPressed) {
        effectiveBorderColor =
            Color.alphaBlend(Colors.black.withValues(alpha: 0.4), color);
        if (!isChecked && !isIndeterminate) {
          effectiveBgColor =
              Color.alphaBlend(color.withValues(alpha: 0.1), Colors.white);
        } else {
          effectiveBgColor =
              Color.alphaBlend(Colors.black.withValues(alpha: 0.2), color);
        }
      }
    }

    // Determine shape based on style
    BorderRadius borderRadius;
    switch (style) {
      case CheckboxStyle.rounded:
        // Web Reference: rounded-full
        borderRadius = BorderRadius.circular(10); // Make it circular (w/h=20)
        break;
      case CheckboxStyle.squared:
        // Web Reference: rounded-none
        borderRadius = BorderRadius.zero;
        break;
      default:
        // Web Reference: rounded
        borderRadius = BorderRadius.circular(4);
        break;
    }

    // Icon for checkmark or indeterminate state
    Widget? checkMark;
    if (isIndeterminate) {
      checkMark = Icon(Icons.remove, size: 16, color: checkIconColor);
    } else if (isChecked) {
      checkMark = Icon(Icons.check, size: 16, color: checkIconColor);
    }

    // Base container
    Widget checkboxVisual = Container(
      width: 20, // w-5
      height: 20, // h-5
      decoration: BoxDecoration(
        color: effectiveBgColor,
        borderRadius: borderRadius, // Apply dynamic border radius
        border: Border.all(
          color: effectiveBorderColor,
          // Use thicker border for custom icon style (matches reference)
          width: style == CheckboxStyle.customWithIcon ? 2.0 : 1.5,
        ),
      ),
      // For custom icon, the icon is the content
      child: style == CheckboxStyle.customWithIcon
          ? checkMark
          : Center(child: checkMark),
    );

    // Add focus ring
    if (focusRingColor != null) {
      checkboxVisual = Container(
        padding: const EdgeInsets.all(2.0),
        decoration: BoxDecoration(
          // Adjust ring shape based on style
          borderRadius: style == CheckboxStyle.rounded
              ? BorderRadius.circular(12)
              : style == CheckboxStyle.squared
                  ? BorderRadius.zero
                  : BorderRadius.circular(6),
          border: Border.all(color: focusRingColor, width: 1.5),
        ),
        child: checkboxVisual,
      );
    }

    // Use AnimatedContainer for transitions
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      child: checkboxVisual,
    );
  }
}

// --- Advanced Selection Example Component ---
// Web Reference (React/Tailwind): SelectionExample component

// Data models for categories and items
class _ShoppingItem {
  final String id;
  final String name;
  bool isChecked = false;

  _ShoppingItem({required this.id, required this.name});
}

class _ShoppingCategory {
  final String id;
  final String name;
  final List<_ShoppingItem> items;
  _ShoppingCategory(
      {required this.id, required this.name, required this.items});

  // Calculated properties for category state
  bool get allItemsChecked => items.every((item) => item.isChecked);
  bool get someItemsChecked => items.any((item) => item.isChecked);
  bool get isIndeterminate => someItemsChecked && !allItemsChecked;
}

class SelectionExample extends StatefulWidget {
  const SelectionExample({super.key});

  @override
  State<SelectionExample> createState() => _SelectionExampleState();
}

class _SelectionExampleState extends State<SelectionExample> {
  // Initialize the shopping list data
  late List<_ShoppingCategory> _categories;

  @override
  void initState() {
    super.initState();
    _categories = _initializeShoppingData();
  }

  List<_ShoppingCategory> _initializeShoppingData() {
    return [
      _ShoppingCategory(id: 'fruits', name: 'Fruits', items: [
        _ShoppingItem(id: 'apple', name: 'Apple'),
        _ShoppingItem(id: 'banana', name: 'Banana'),
        _ShoppingItem(id: 'orange', name: 'Orange'),
        _ShoppingItem(id: 'strawberry', name: 'Strawberry'),
      ]),
      _ShoppingCategory(id: 'vegetables', name: 'Vegetables', items: [
        _ShoppingItem(id: 'carrot', name: 'Carrot'),
        _ShoppingItem(id: 'broccoli', name: 'Broccoli'),
        _ShoppingItem(id: 'cucumber', name: 'Cucumber'),
      ]),
      _ShoppingCategory(id: 'dairy', name: 'Dairy', items: [
        _ShoppingItem(id: 'milk', name: 'Milk'),
        _ShoppingItem(id: 'cheese', name: 'Cheese'),
        _ShoppingItem(id: 'yogurt', name: 'Yogurt'),
        _ShoppingItem(id: 'butter', name: 'Butter'),
      ])
    ];
  }

  // Handle category (parent) checkbox change
  void _handleCategoryChange(_ShoppingCategory category, bool? newValue) {
    // newValue is null if clicked while indeterminate, treat as checking all
    final bool checkAll = newValue ?? true;
    setState(() {
      for (var item in category.items) {
        item.isChecked = checkAll;
      }
    });
  }

  // Handle item (child) checkbox change
  void _handleItemChange(
      _ShoppingCategory category, _ShoppingItem item, bool newValue) {
    setState(() {
      item.isChecked = newValue;
    });
  }

  // Calculate total selected items
  int get _selectedCount {
    return _categories.fold<int>(
      0,
      (count, category) =>
          count + category.items.where((item) => item.isChecked).length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header showing selected count
        // Web Reference: bg-blue-50 p-4 rounded-lg flex justify-between items-center
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Shopping List',
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
              ),
              // Web Reference: bg-blue-500 text-white text-sm font-medium py-1 px-3 rounded-full
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$_selectedCount items selected',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // List of categories
        // Web Reference: space-y-6, border rounded-lg overflow-hidden
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _categories.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final category = _categories[index];
            return Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                children: [
                  // Category Header (Parent Checkbox)
                  // Web Reference: bg-gray-50 p-3 border-b
                  Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      border: Border(
                          bottom: BorderSide(color: Colors.grey.shade200)),
                      // Apply top border radius only
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        topRight: Radius.circular(8.0),
                      ),
                    ),
                    child: Row(
                      children: [
                        NakedCheckbox(
                          checked: category.allItemsChecked,
                          indeterminate: category.isIndeterminate,
                          onChanged: (value) =>
                              _handleCategoryChange(category, value),
                          // Web Reference: w-5 h-5 rounded text-blue-600 focus:ring-blue-500
                          child: _buildDefaultCheckboxVisual(
                            isChecked: category.allItemsChecked,
                            isIndeterminate: category.isIndeterminate,
                            color: Colors.blue.shade600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => _handleCategoryChange(category, null),
                          child: Text(
                            category.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black87),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Items within the category
                  // Web Reference: divide-y, p-3 pl-6
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: category.items.length,
                    separatorBuilder: (context, itemIndex) => Divider(
                        height: 1, color: Colors.grey.shade200, indent: 40),
                    itemBuilder: (context, itemIndex) {
                      final item = category.items[itemIndex];
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(
                            12.0, 8.0, 12.0, 8.0), // Consistent padding
                        child: Row(
                          children: [
                            const SizedBox(
                                width: 28), // Indentation like the pl-6
                            NakedCheckbox(
                              checked: item.isChecked,
                              onChanged: (value) =>
                                  _handleItemChange(category, item, value),
                              // Web Reference: w-5 h-5 rounded text-blue-500 focus:ring-blue-500
                              child: _buildDefaultCheckboxVisual(
                                isChecked: item.isChecked,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () => _handleItemChange(
                                  category, item, !item.isChecked),
                              child: Text(item.name,
                                  style:
                                      const TextStyle(color: Colors.black54)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // Re-use the visual builder. Consider moving to a shared utility file.
  Widget _buildDefaultCheckboxVisual({
    required bool isChecked,
    bool isIndeterminate = false,
    bool isHovered = false,
    bool isPressed = false,
    bool isFocused = false,
    bool isDisabled = false,
    required Color color,
  }) {
    Color effectiveBorderColor = isDisabled ? Colors.grey.shade300 : color;
    Color effectiveBgColor = isDisabled
        ? Colors.grey.shade200
        : (isChecked || isIndeterminate)
            ? color
            : Colors.white;
    Color checkIconColor = isDisabled ? Colors.grey.shade500 : Colors.white;
    Color? focusRingColor;

    if (!isDisabled) {
      if (isFocused) {
        effectiveBorderColor =
            Color.alphaBlend(Colors.black.withValues(alpha: 0.3), color);
        focusRingColor = color.withValues(alpha: 0.3);
      }
      if (isHovered) {
        effectiveBorderColor =
            Color.alphaBlend(Colors.black.withValues(alpha: 0.2), color);
        if (!isChecked && !isIndeterminate) {
          effectiveBgColor =
              Color.alphaBlend(color.withValues(alpha: 0.05), Colors.white);
        }
      }
      if (isPressed) {
        effectiveBorderColor =
            Color.alphaBlend(Colors.black.withValues(alpha: 0.4), color);
        if (!isChecked && !isIndeterminate) {
          effectiveBgColor =
              Color.alphaBlend(color.withValues(alpha: 0.1), Colors.white);
        } else {
          effectiveBgColor =
              Color.alphaBlend(Colors.black.withValues(alpha: 0.2), color);
        }
      }
    }

    Widget? checkMark;
    if (isIndeterminate) {
      checkMark = Icon(Icons.remove, size: 16, color: checkIconColor);
    } else if (isChecked) {
      checkMark = Icon(Icons.check, size: 16, color: checkIconColor);
    }

    Widget checkboxVisual = Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: effectiveBgColor,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: effectiveBorderColor, width: 1.5),
      ),
      child: checkMark,
    );

    if (focusRingColor != null) {
      checkboxVisual = Container(
        padding: const EdgeInsets.all(2.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: focusRingColor, width: 1.5),
        ),
        child: checkboxVisual,
      );
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      child: checkboxVisual,
    );
  }
}

// Focus and Keyboard Navigation Example
class FocusCheckboxExample extends StatefulWidget {
  const FocusCheckboxExample({super.key});

  @override
  State<FocusCheckboxExample> createState() => _FocusCheckboxExampleState();
}

class _FocusCheckboxExampleState extends State<FocusCheckboxExample> {
  bool _checkboxValue1 = false;
  bool _checkboxValue2 = false;
  bool _checkboxValue3 = false;
  String _lastAction = 'No action yet';

  // Manage focus states
  final Map<String, bool> _focusStates = {};
  final Map<String, bool> _hoverStates = {};
  final Map<String, bool> _pressStates = {};

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Keyboard navigation instructions
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.keyboard, color: Colors.blue.shade700),
                  const SizedBox(width: 8),
                  Text(
                    'Keyboard Navigation',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Wrap(
                spacing: 16,
                runSpacing: 8,
                children: [
                  Text('• Tab: Move between checkboxes'),
                  Text('• Space: Toggle checkbox'),
                  Text('• Esc: Clear focus'),
                ],
              ),
            ],
          ),
        ),

        // Status display
        Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              const Text(
                'Last Action:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              Expanded(child: Text(_lastAction)),
            ],
          ),
        ),

        // Checkboxes with focus management
        FocusTraversalGroup(
          child: Column(
            children: [
              _buildFocusableCheckbox(
                id: 'option1',
                label: 'Option 1',
                value: _checkboxValue1,
                onChanged: (value) {
                  setState(() {
                    _checkboxValue1 = value ?? false;
                    _lastAction =
                        'Option 1 toggled to ${value == true ? "checked" : "unchecked"}';
                  });
                },
                color: Colors.blue,
              ),
              const SizedBox(height: 16),
              _buildFocusableCheckbox(
                id: 'option2',
                label: 'Option 2',
                value: _checkboxValue2,
                onChanged: (value) {
                  setState(() {
                    _checkboxValue2 = value ?? false;
                    _lastAction =
                        'Option 2 toggled to ${value == true ? "checked" : "unchecked"}';
                  });
                },
                color: Colors.green,
              ),
              const SizedBox(height: 16),
              _buildFocusableCheckbox(
                id: 'option3',
                label: 'Option 3',
                value: _checkboxValue3,
                onChanged: (value) {
                  setState(() {
                    _checkboxValue3 = value ?? false;
                    _lastAction =
                        'Option 3 toggled to ${value == true ? "checked" : "unchecked"}';
                  });
                },
                color: Colors.purple,
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Controls
        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _checkboxValue1 = false;
                  _checkboxValue2 = false;
                  _checkboxValue3 = false;
                  _lastAction = 'All checkboxes reset';
                });
              },
              child: const Text('Reset All'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFocusableCheckbox({
    required String id,
    required String label,
    required bool value,
    required ValueChanged<bool?> onChanged,
    required Color color,
  }) {
    final bool isHovered = _hoverStates[id] ?? false;
    final bool isFocused = _focusStates[id] ?? false;
    final bool isPressed = _pressStates[id] ?? false;

    return NakedCheckbox(
      checked: value,
      onChanged: onChanged,
      onEscapePressed: () {
        setState(() {
          _lastAction = 'Escape pressed on $label';
        });
      },
      onHoverState: (hover) {
        setState(() {
          _hoverStates[id] = hover;
          if (hover) {
            _lastAction = 'Hovering: $label';
          }
        });
      },
      onFocusState: (focus) {
        setState(() {
          _focusStates[id] = focus;
          if (focus) {
            _lastAction = 'Focused: $label';
          }
        });
      },
      onPressedState: (press) {
        setState(() {
          _pressStates[id] = press;
          if (press) {
            _lastAction = 'Pressed: $label';
          }
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: value
              ? color.withValues(alpha: 0.1)
              : isPressed
                  ? const Color(0xFFE5E7EB)
                  : isHovered
                      ? const Color(0xFFF9FAFB)
                      : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: value
                ? color
                : isFocused
                    ? Colors.black
                    : const Color(0xFFD1D5DB),
            width: isFocused ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: value ? color : Colors.grey.shade400,
                  width: 2,
                ),
                color: value ? color : Colors.white,
              ),
              child: value
                  ? const Icon(
                      Icons.check,
                      size: 18,
                      color: Colors.white,
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: value ? FontWeight.bold : FontWeight.normal,
                color: value ? color : Colors.grey.shade800,
              ),
            ),
            const Spacer(),
            if (isFocused)
              Icon(
                Icons.keyboard_tab,
                size: 16,
                color: color.withValues(alpha: 0.5),
              ),
          ],
        ),
      ),
    );
  }
}
