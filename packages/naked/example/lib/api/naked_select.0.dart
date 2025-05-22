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
          child: SelectExample(),
        ),
      ),
    );
  }
}

class SelectExample extends StatefulWidget {
  const SelectExample({super.key});

  @override
  State<SelectExample> createState() => _SelectExampleState();
}

class _SelectExampleState extends State<SelectExample> with TickerProviderStateMixin {
  String? _selectedValue;
  bool _isHovered = false;
  bool _isFocused = false;

  Color get borderColor {
    if (_isFocused) return Colors.blue;
    if (_isHovered) return Colors.grey.shade400;
    return Colors.grey.shade300;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: NakedSelect<String>(
        selectedValue: _selectedValue,
        closeOnSelect: true,
        onSelectedValueChanged: (value) {
          setState(() => _selectedValue = value);
        },
        menu: Container(
          margin: const EdgeInsets.only(top: 4),
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const SizedBox(
            width: 200,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                NakedSelectItem<String>(
                  value: 'Option 1',
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text('Option 1'),
                  ),
                ),
                NakedSelectItem<String>(
                  value: 'Option 2',
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text('Option 2'),
                  ),
                ),
                NakedSelectItem<String>(
                  value: 'Option 3',
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text('Option 3'),
                  ),
                ),
              ],
            ),
          ),
        ),
        child: NakedSelectTrigger(
          onHoverState: (isHovered) => setState(() => _isHovered = isHovered),
          onFocusState: (isFocused) => setState(() => _isFocused = isFocused),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(
                color: borderColor,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_selectedValue ?? 'Select an option'),
                const Icon(Icons.arrow_drop_down, size: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
