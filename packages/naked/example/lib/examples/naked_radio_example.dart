import 'package:flutter/material.dart';
import 'package:naked/naked.dart';

/// Basic radio buttons with simple styling
class BasicRadioExample extends StatefulWidget {
  const BasicRadioExample({super.key});

  @override
  State<BasicRadioExample> createState() => _BasicRadioExampleState();
}

class _BasicRadioExampleState extends State<BasicRadioExample> {
  String? _selectedOption = 'option1';

  @override
  Widget build(BuildContext context) {
    return NakedRadioGroup<String>(
      value: _selectedOption,
      onChanged: (value) {
        setState(() {
          _selectedOption = value;
        });
      },
      child: Column(
        children: [
          _buildRadioOption('option1', 'Option 1'),
          const SizedBox(height: 8),
          _buildRadioOption('option2', 'Option 2'),
          const SizedBox(height: 8),
          _buildRadioOption('option3', 'Option 3'),
        ],
      ),
    );
  }

  Widget _buildRadioOption(String value, String label) {
    bool isHovered = false;
    bool isPressed = false;

    return StatefulBuilder(
      builder: (context, setInnerState) {
        final isSelected = _selectedOption == value;

        return Row(
          children: [
            NakedRadioButton<String>(
              value: value,
              onHoverState: (isHovered) =>
                  setInnerState(() => isHovered = isHovered),
              onPressedState: (isPressed) =>
                  setInnerState(() => isPressed = isPressed),
              onFocusState: (isFocused) => {},
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Colors.blue : Colors.grey,
                    width: 2,
                  ),
                  color: _getBackgroundColor(isPressed, isHovered),
                ),
                child: Center(
                  child: isSelected
                      ? Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                          ),
                        )
                      : null,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(label),
          ],
        );
      },
    );
  }

  // Helper method to determine background color based on state
  Color _getBackgroundColor(bool isPressed, bool isHovered) {
    if (isPressed) return Colors.grey.shade300;
    if (isHovered) return Colors.grey.shade100;
    return Colors.white;
  }
}

/// Custom styled radio buttons with animations
class StyledRadioExample extends StatefulWidget {
  const StyledRadioExample({super.key});

  @override
  State<StyledRadioExample> createState() => _StyledRadioExampleState();
}

class _StyledRadioExampleState extends State<StyledRadioExample> {
  String? _selectedOption = 'design1';

  @override
  Widget build(BuildContext context) {
    return NakedRadioGroup<String>(
      value: _selectedOption,
      onChanged: (value) {
        setState(() {
          _selectedOption = value;
        });
      },
      child: Row(
        children: [
          _buildStyleOption('design1', Colors.purple, 'Modern'),
          const SizedBox(width: 16),
          _buildStyleOption('design2', Colors.teal, 'Minimal'),
          const SizedBox(width: 16),
          _buildStyleOption('design3', Colors.orange, 'Classic'),
        ],
      ),
    );
  }

  Widget _buildStyleOption(String value, Color color, String label) {
    bool isHovered = false;
    bool isPressed = false;
    bool isFocused = false;

    return StatefulBuilder(
      builder: (context, setInnerState) {
        final isSelected = _selectedOption == value;

        return Column(
          children: [
            NakedRadioButton<String>(
              value: value,
              semanticLabel: label,
              onHoverState: (isHovered) =>
                  setInnerState(() => isHovered = isHovered),
              onPressedState: (isPressed) =>
                  setInnerState(() => isPressed = isPressed),
              onFocusState: (isFocused) =>
                  setInnerState(() => isFocused = isFocused),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 80,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: isSelected
                      ? color.withAlpha((0.8 * 255).round())
                      : Colors.grey.shade200,
                  border: Border.all(
                    color: _getBorderColor(isSelected, isFocused, color),
                    width: 1,
                  ),
                  boxShadow: _getBoxShadow(isHovered, isPressed, color),
                ),
                child: Center(
                  child: Icon(
                    isSelected ? Icons.check_circle : Icons.circle_outlined,
                    color: isSelected ? Colors.white : Colors.grey.shade600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? color : Colors.black,
              ),
            ),
          ],
        );
      },
    );
  }

  Color _getBorderColor(bool isSelected, bool isFocused, Color color) {
    if (isFocused) return Colors.black;
    if (isSelected) return color;
    return Colors.grey.shade400;
  }

  List<BoxShadow> _getBoxShadow(bool isHovered, bool isPressed, Color color) {
    if (isHovered && !isPressed) {
      return [
        BoxShadow(
          color: color.withAlpha((0.3 * 255).round()),
          blurRadius: 8,
          offset: const Offset(0, 2),
        )
      ];
    }
    return [];
  }
}

/// Form integration example
class FormRadioExample extends StatefulWidget {
  const FormRadioExample({super.key});

  @override
  State<FormRadioExample> createState() => _FormRadioExampleState();
}

class _FormRadioExampleState extends State<FormRadioExample> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedPriority = 'medium';

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Process form data
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Task Priority:'),
          const SizedBox(height: 8),
          FormField<String>(
            initialValue: _selectedPriority,
            validator: (value) {
              if (value == null) {
                return 'Please select a priority';
              }
              return null;
            },
            builder: (FormFieldState<String> state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NakedRadioGroup<String>(
                    value: state.value,
                    onChanged: (value) {
                      state.didChange(value);
                      setState(() {
                        _selectedPriority = value;
                      });
                    },
                    child: Column(
                      children: [
                        _buildPriorityOption(
                            state, 'high', 'High', Colors.red.shade700),
                        const SizedBox(height: 8),
                        _buildPriorityOption(
                            state, 'medium', 'Medium', Colors.orange.shade700),
                        const SizedBox(height: 8),
                        _buildPriorityOption(
                            state, 'low', 'Low', Colors.green.shade700),
                      ],
                    ),
                  ),
                  if (state.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        state.errorText!,
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _submitForm,
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityOption(
      FormFieldState<String> state, String value, String label, Color color) {
    bool isHovered = false;
    bool isPressed = false;

    return StatefulBuilder(
      builder: (context, setInnerState) {
        final isSelected = state.value == value;

        return Row(
          children: [
            NakedRadioButton<String>(
              value: value,
              semanticLabel: label,
              onHoverState: (isHovered) =>
                  setInnerState(() => isHovered = isHovered),
              onPressedState: (isPressed) =>
                  setInnerState(() => isPressed = isPressed),
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? color : Colors.grey.shade500,
                    width: 2,
                  ),
                  color: _getBackgroundColor(isPressed, isHovered),
                ),
                child: Center(
                  child: isSelected
                      ? Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: color,
                          ),
                        )
                      : null,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? color : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        );
      },
    );
  }

  // Helper method to determine background color based on state
  Color _getBackgroundColor(bool isPressed, bool isHovered) {
    if (isPressed) return Colors.grey.shade300;
    if (isHovered) return Colors.grey.shade100;
    return Colors.white;
  }
}

/// Disabled radio buttons example
class DisabledRadioExample extends StatefulWidget {
  const DisabledRadioExample({super.key});

  @override
  State<DisabledRadioExample> createState() => _DisabledRadioExampleState();
}

class _DisabledRadioExampleState extends State<DisabledRadioExample> {
  String? _selectedOption = 'option2';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Entire group disabled
        const Text('Disabled Group:'),
        const SizedBox(height: 8),
        NakedRadioGroup<String>(
          value: _selectedOption,
          onChanged: (value) {
            setState(() {
              _selectedOption = value;
            });
          },
          enabled: true,
          child: Column(
            children: [
              _buildRadioOption('option1', 'Option 1', false),
              const SizedBox(height: 8),
              _buildRadioOption('option2', 'Option 2', false),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Individual buttons disabled
        const Text('Individual Disabled Buttons:'),
        const SizedBox(height: 8),
        NakedRadioGroup<String>(
          value: _selectedOption,
          onChanged: (value) {
            setState(() {
              _selectedOption = value;
            });
          },
          child: Column(
            children: [
              _buildRadioOption('option3', 'Option 3', false),
              const SizedBox(height: 8),
              _buildRadioOption('option4', 'Option 4 (disabled)', true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRadioOption(String value, String label, bool isOptionDisabled) {
    return Row(
      children: [
        NakedRadioButton<String>(
          value: value,
          enabled: isOptionDisabled,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: _getBorderColor(value, isOptionDisabled),
                width: 2,
              ),
              color: isOptionDisabled ? Colors.grey.shade100 : Colors.white,
            ),
            child: Center(
              child: _selectedOption == value
                  ? Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isOptionDisabled
                            ? Colors.grey.shade300
                            : Colors.blue,
                      ),
                    )
                  : null,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: isOptionDisabled ? Colors.grey.shade400 : Colors.black,
          ),
        ),
      ],
    );
  }

  // Helper method to determine border color based on state
  Color _getBorderColor(String value, bool isDisabled) {
    if (isDisabled) return Colors.grey.shade300;
    if (_selectedOption == value) return Colors.blue;
    return Colors.grey;
  }
}

class NakedRadioExample extends StatefulWidget {
  const NakedRadioExample({super.key});

  @override
  State<NakedRadioExample> createState() => _NakedRadioExampleState();
}

class _NakedRadioExampleState extends State<NakedRadioExample> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Radio Button Examples',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937), // text-gray-800
              ),
            ),
            const SizedBox(height: 32),

            // Basic Radio Buttons
            _buildSection(
              title: 'Basic Radio Buttons',
              child: const BasicRadioButtons(),
            ),

            // Radio Button Variants
            _buildSection(
              title: 'Radio Button Variants',
              child: const RadioButtonVariants(),
            ),

            // Focus Management Example
            _buildSection(
              title: 'Focus and Keyboard Navigation',
              child: const FocusRadioExample(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 48.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151), // text-gray-700
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}

// Basic Radio Buttons
class BasicRadioButtons extends StatefulWidget {
  const BasicRadioButtons({super.key});

  @override
  State<BasicRadioButtons> createState() => _BasicRadioButtonsState();
}

class _BasicRadioButtonsState extends State<BasicRadioButtons> {
  String _selected = 'option1';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'A simple radio button group with default styling',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF4B5563), // text-gray-600
          ),
        ),
        const SizedBox(height: 16),
        NakedRadioGroup<String>(
          value: _selected,
          onChanged: (value) {
            if (value != null) {
              setState(() => _selected = value);
            }
          },
          child: Column(
            children: [
              for (final option in [
                {'id': 'option1', 'label': 'Option 1'},
                {'id': 'option2', 'label': 'Option 2'},
                {'id': 'option3', 'label': 'Option 3'},
              ])
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: NakedRadioButton<String>(
                    value: option['id']!,
                    child: Builder(
                      builder: (context) {
                        final isSelected = _selected == option['id'];

                        return Row(
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(
                                          0xFF3B82F6) // border-blue-500
                                      : const Color(
                                          0xFFD1D5DB), // border-gray-300
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isSelected
                                        ? const Color(0xFF3B82F6) // bg-blue-500
                                        : Colors.transparent,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              option['label']!,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF374151), // text-gray-700
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

// Placeholder classes - to be implemented
class RadioButtonVariants extends StatefulWidget {
  const RadioButtonVariants({super.key});

  @override
  State<RadioButtonVariants> createState() => _RadioButtonVariantsState();
}

class _RadioButtonVariantsState extends State<RadioButtonVariants> {
  final Map<String, String> _variants = {
    'primary': 'medium',
    'outline': 'weekly',
    'colored': 'green',
    'disabled': 'option1'
  };

  void _handleChange(String group, String value) {
    setState(() {
      _variants[group] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        // Primary Variant
        Container(
          width: 300,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Primary',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF374151), // text-gray-700
                ),
              ),
              const SizedBox(height: 16),
              NakedRadioGroup<String>(
                value: _variants['primary'],
                onChanged: (value) {
                  if (value != null) {
                    _handleChange('primary', value);
                  }
                },
                child: Column(
                  children: [
                    for (final size in ['small', 'medium', 'large'])
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: NakedRadioButton<String>(
                          value: size,
                          child: Builder(
                            builder: (context) {
                              final isSelected = _variants['primary'] == size;
                              return Row(
                                children: [
                                  Container(
                                    width: 16,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isSelected
                                            ? const Color(
                                                0xFF3B82F6) // blue-500
                                            : const Color(
                                                0xFFD1D5DB), // gray-300
                                        width: 2,
                                      ),
                                    ),
                                    child: Center(
                                      child: Container(
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: isSelected
                                              ? const Color(
                                                  0xFF3B82F6) // blue-500
                                              : Colors.transparent,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    size[0].toUpperCase() + size.substring(1),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF374151), // text-gray-700
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Outline Variant
        Container(
          width: 300,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Outline',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF374151), // text-gray-700
                ),
              ),
              const SizedBox(height: 16),
              NakedRadioGroup<String>(
                value: _variants['outline'],
                onChanged: (value) {
                  if (value != null) {
                    _handleChange('outline', value);
                  }
                },
                child: Column(
                  children: [
                    for (final period in ['daily', 'weekly', 'monthly'])
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: NakedRadioButton<String>(
                          value: period,
                          child: Builder(
                            builder: (context) {
                              final isSelected = _variants['outline'] == period;
                              return Row(
                                children: [
                                  Container(
                                    width: 16,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isSelected
                                            ? const Color(
                                                0xFF6366F1) // indigo-500
                                            : const Color(
                                                0xFF9CA3AF), // gray-400
                                        width: 2,
                                      ),
                                    ),
                                    child: Center(
                                      child: Container(
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: isSelected
                                              ? const Color(
                                                  0xFF6366F1) // indigo-500
                                              : Colors.transparent,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    period[0].toUpperCase() +
                                        period.substring(1),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF374151), // text-gray-700
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Colored Variant
        Container(
          width: 300,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Colored',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF374151), // text-gray-700
                ),
              ),
              const SizedBox(height: 16),
              NakedRadioGroup<String>(
                value: _variants['colored'],
                onChanged: (value) {
                  if (value != null) {
                    _handleChange('colored', value);
                  }
                },
                child: Column(
                  children: [
                    for (final color in [
                      {
                        'id': 'red',
                        'color': const Color(0xFFEF4444), // red-500
                      },
                      {
                        'id': 'green',
                        'color': const Color(0xFF22C55E), // green-500
                      },
                      {
                        'id': 'purple',
                        'color': const Color(0xFF8B5CF6), // purple-500
                      },
                    ])
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: NakedRadioButton<String>(
                          value: color['id'] as String,
                          child: Builder(
                            builder: (context) {
                              final isSelected =
                                  _variants['colored'] == color['id'];
                              return Row(
                                children: [
                                  Container(
                                    width: 16,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isSelected
                                            ? color['color'] as Color
                                            : const Color(
                                                0xFFD1D5DB), // gray-300
                                        width: 2,
                                      ),
                                    ),
                                    child: Center(
                                      child: Container(
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: isSelected
                                              ? color['color'] as Color
                                              : Colors.transparent,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    color['id'].toString()[0].toUpperCase() +
                                        color['id'].toString().substring(1),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF374151), // text-gray-700
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Disabled Variant
        Container(
          width: 300,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Disabled',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF374151), // text-gray-700
                ),
              ),
              const SizedBox(height: 16),
              NakedRadioGroup<String>(
                value: _variants['disabled'],
                onChanged: (value) {
                  if (value != null) {
                    _handleChange('disabled', value);
                  }
                },
                child: Column(
                  children: [
                    for (final option in [
                      {
                        'id': 'option1',
                        'label': 'Enabled Option',
                        'enabled': true
                      },
                      {
                        'id': 'option2',
                        'label': 'Disabled Option',
                        'enabled': false
                      },
                    ])
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: NakedRadioButton<String>(
                          value: option['id'] as String,
                          enabled: option['enabled'] as bool,
                          child: Builder(
                            builder: (context) {
                              final isSelected =
                                  _variants['disabled'] == option['id'];
                              final isEnabled = option['enabled'] as bool;
                              return Row(
                                children: [
                                  Container(
                                    width: 16,
                                    height: 16,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: isEnabled
                                              ? const Color(
                                                  0xFF3B82F6) // gray-200
                                              : isSelected
                                                  ? const Color(
                                                      0xFFE5E7EB) // blue-500
                                                  : const Color(
                                                      0xFFD1D5DB), // gray-300
                                          width: 2,
                                        ),
                                        color: isEnabled
                                            ? Colors.white
                                            : const Color(
                                                0xFFF3F4F6) // gray-100,
                                        ),
                                    child: Center(
                                      child: Container(
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: !isEnabled
                                              ? isSelected
                                                  ? const Color(
                                                      0xFFD1D5DB) // gray-300
                                                  : Colors.transparent
                                              : isSelected
                                                  ? const Color(
                                                      0xFF3B82F6) // blue-500
                                                  : Colors.transparent,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    option['label'] as String,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: !isEnabled
                                          ? const Color(0xFF9CA3AF) // gray-400
                                          : const Color(
                                              0xFF374151), // text-gray-700
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Radio example demonstrating focus management and keyboard navigation
class FocusRadioExample extends StatefulWidget {
  const FocusRadioExample({super.key});

  @override
  State<FocusRadioExample> createState() => _FocusRadioExampleState();
}

class _FocusRadioExampleState extends State<FocusRadioExample> {
  String? _selectedOption = 'option1';
  String _lastAction = 'None';

  final Map<String, bool> _hoverStates = {};
  final Map<String, bool> _focusStates = {};
  final Map<String, bool> _pressStates = {};

  final List<Map<String, dynamic>> _options = [
    {'id': 'option1', 'label': 'Option 1', 'color': Colors.blue},
    {'id': 'option2', 'label': 'Option 2', 'color': Colors.green},
    {'id': 'option3', 'label': 'Option 3', 'color': Colors.orange},
    {'id': 'option4', 'label': 'Option 4', 'color': Colors.purple},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Keyboard instructions card
        Container(
          padding: const EdgeInsets.all(16),
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
                  Text('• Tab: Navigate to group'),
                  Text('• ↑/↓: Previous/Next option'),
                  Text('• Space: Select option'),
                  Text('• Esc: Clear selection'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Status display
        Container(
          padding: const EdgeInsets.all(12),
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
              Text(_lastAction),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Radio group with focus management
        NakedRadioGroup<String>(
          value: _selectedOption,
          onChanged: (value) {
            setState(() {
              _selectedOption = value;
              _lastAction = 'Selected: ${_getLabelById(value)}';
            });
          },
          onEscapePressed: () {
            setState(() {
              _selectedOption = null;
              _lastAction = 'Selection cleared with Escape key';
            });
          },
          child: Column(
            children: _options.map((option) {
              final String id = option['id']!;
              final String label = option['label']!;
              final Color color = option['color']!;

              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: _buildFocusableRadioOption(id, label, color),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildFocusableRadioOption(String id, String label, Color color) {
    final bool isSelected = _selectedOption == id;
    final bool isHovered = _hoverStates[id] ?? false;
    final bool isFocused = _focusStates[id] ?? false;
    final bool isPressed = _pressStates[id] ?? false;

    return NakedRadioButton<String>(
      value: id,
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
          color: isSelected
              ? color.withValues(alpha: 0.1)
              : isPressed
                  ? const Color(0xFFE5E7EB)
                  : isHovered
                      ? const Color(0xFFF9FAFB)
                      : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
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
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? color : Colors.grey.shade400,
                  width: 2,
                ),
                color: Colors.white,
              ),
              child: Center(
                child: isSelected
                    ? Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color,
                        ),
                      )
                    : null,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? color : Colors.grey.shade800,
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

  String _getLabelById(String? id) {
    if (id == null) return 'None';
    final option = _options.firstWhere(
      (opt) => opt['id'] == id,
      orElse: () => {'label': 'Unknown'},
    );
    return option['label'] as String;
  }
}
