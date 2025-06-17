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
          child: AnimatedSelectExample(),
        ),
      ),
    );
  }
}

class AnimatedSelectExample extends StatefulWidget {
  const AnimatedSelectExample({super.key});

  @override
  State<AnimatedSelectExample> createState() => _AnimatedSelectExampleState();
}

class _AnimatedSelectExampleState extends State<AnimatedSelectExample>
    with TickerProviderStateMixin {
  String? _selectedValue;
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
      child: NakedSelect<String>(
        selectedValue: _selectedValue,
        onSelectedValueChanged: (value) {
          setState(() => _selectedValue = value);
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
                      value: 'Option 1',
                      label: 'Option 1',
                    ),
                    SelectItem(
                      value: 'Option 2',
                      label: 'Option 2',
                    ),
                    SelectItem(
                      value: 'Option 3',
                      label: 'Option 3',
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
                Text(_selectedValue ?? 'Select your favorite fruit'),
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

  Color get backgroundColor {
    if (_isHovered) return Colors.grey.shade100;
    if (_isFocused) return Colors.grey.shade200;
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return NakedSelectItem<String>(
      value: widget.value,
      onHoverState: (isHovered) => setState(() => _isHovered = isHovered),
      onFocusState: (isFocused) => setState(() => _isFocused = isFocused),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(widget.label),
      ),
    );
  }
}
