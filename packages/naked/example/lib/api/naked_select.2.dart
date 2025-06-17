import 'package:flutter/material.dart';
import 'package:naked/naked.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: AnimatedMultiSelectExample(),
        ),
      ),
    );
  }
}

class AnimatedMultiSelectExample extends StatefulWidget {
  const AnimatedMultiSelectExample({super.key});

  @override
  State<AnimatedMultiSelectExample> createState() =>
      _AnimatedMultiSelectExampleState();
}

class _AnimatedMultiSelectExampleState extends State<AnimatedMultiSelectExample>
    with TickerProviderStateMixin {
  final Set<String> _selectedValues = {};
  bool _isHovered = false;
  bool _isFocused = false;

  late final _animationController = AnimationController(
    duration: const Duration(milliseconds: 200),
    vsync: this,
  );

  late final _animation = CurvedAnimation(
    parent: _animationController,
    curve: Curves.easeOut,
  );

  Color get borderColor {
    if (_isFocused) return Colors.grey.shade800;
    if (_isHovered) return Colors.grey.shade100;
    return Colors.grey.shade300;
  }

  Color get backgroundColor {
    if (_isHovered) return Colors.grey.shade100;
    return Colors.white;
  }

  List<BoxShadow> get boxShadow {
    if (_isFocused) {
      return [
        BoxShadow(
          color: Colors.grey.shade300,
          blurRadius: 0,
          spreadRadius: 4,
          offset: Offset.zero,
        ),
        const BoxShadow(
          color: Colors.white,
          blurRadius: 0,
          spreadRadius: 2,
          offset: Offset.zero,
        ),
      ];
    }
    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.02),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ];
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: NakedSelect<String>.multiple(
        selectedValues: _selectedValues,
        closeOnSelect: false,
        onSelectedValuesChanged: (values) {
          if (values.length >= 3) {
            return;
          }
          setState(() => _selectedValues.clear());
          setState(() => _selectedValues.addAll(values));
        },
        removalDelay: const Duration(milliseconds: 200),
        onStateChange: (state) {
          state == OverlayChildLifecycleState.present
              ? _animationController.forward()
              : _animationController.reverse();
        },
        menu: SlideTransition(
          position: _animationController.drive(Tween<Offset>(
            begin: const Offset(0, -0.05),
            end: Offset.zero,
          )),
          child: FadeTransition(
            opacity: _animation,
            child: SizedBox(
              width: 250,
              child: Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SelectItem(
                      value: 'Apple',
                      label: 'Apple',
                    ),
                    SelectItem(
                      value: 'Banana',
                      label: 'Banana',
                    ),
                    SelectItem(
                      value: 'Orange',
                      label: 'Orange',
                    ),
                    SelectItem(
                      value: 'Mango',
                      label: 'Mango',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        child: NakedSelectTrigger(
          onHoverState: (isHovered) => setState(() => _isHovered = isHovered),
          onFocusState: (isFocused) => setState(() => _isFocused = isFocused),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: backgroundColor,
              boxShadow: boxShadow,
              border: Border.all(
                color: borderColor,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _selectedValues.isEmpty
                      ? const Text('Select 2 of your favorites fruits')
                      : Row(
                          spacing: 6,
                          children: _selectedValues
                              .map(
                                (e) => SelectedItem(value: e, label: e),
                              )
                              .toList(),
                        ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 24,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SelectedItem extends StatefulWidget {
  const SelectedItem({
    super.key,
    required this.value,
    required this.label,
  });

  final String value;
  final String label;

  @override
  State<SelectedItem> createState() => _SelectedItemState();
}

class _SelectedItemState extends State<SelectedItem> {
  @override
  Widget build(BuildContext context) {
    return NakedSelectItem<String>(
      value: widget.value,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 4,
          children: [
            Text(widget.label,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
            const Icon(
              Icons.close_rounded,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}

class SelectItem extends StatefulWidget {
  const SelectItem({
    super.key,
    required this.value,
    required this.label,
  });

  final String value;
  final String label;

  @override
  State<SelectItem> createState() => _SelectItemState();
}

class _SelectItemState extends State<SelectItem> {
  bool _isHovered = false;
  bool _isFocused = false;
  bool _isSelected = false;

  Color get backgroundColor {
    if (_isHovered || _isSelected) return Colors.grey.shade100;
    if (_isFocused) return Colors.grey.shade200;
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return NakedSelectItem<String>(
      value: widget.value,
      onHoverState: (isHovered) => setState(() => _isHovered = isHovered),
      onFocusState: (isFocused) => setState(() => _isFocused = isFocused),
      onSelectState: (isSelected) => setState(() => _isSelected = isSelected),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(child: Text(widget.label)),
            if (_isSelected)
              const Icon(
                Icons.check_rounded,
                size: 16,
                color: Colors.grey,
              ),
          ],
        ),
      ),
    );
  }
}
