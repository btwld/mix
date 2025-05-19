import 'package:flutter/material.dart';
import 'package:naked/naked.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Naked Select Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Naked Select Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? selectedValue;
  Set<String> selectedValues = {};
  bool isHovered = false;
  bool isPressed = false;
  bool isFocused = false;

  final _singleSelectController = OverlayPortalController();
  final _multiSelectController = OverlayPortalController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Single selection example
            Text('Single Selection: $selectedValue'),
            const SizedBox(height: 16),
            NakedSelect<String>(
              selectedValue: selectedValue,
              onSelectedValueChanged: (value) =>
                  setState(() => selectedValue = value),
              controller: _singleSelectController,
              onClose: () => _singleSelectController.hide(),
              onOpen: () {
                _singleSelectController.show();
              },
              menu: Container(
                constraints: const BoxConstraints(maxWidth: 200),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SelectOption(value: 'Apple'),
                    SelectOption(value: 'Banana'),
                    SelectOption(value: 'Orange'),
                  ],
                ),
              ),
              child: NakedSelectTrigger(
                onHoverState: (value) => setState(() => isHovered = value),
                onPressedState: (value) => setState(() => isPressed = value),
                onFocusState: (value) => setState(() => isFocused = value),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isPressed
                        ? Colors.blue[200]
                        : isHovered
                            ? Colors.blue[100]
                            : Colors.white,
                    border: Border.all(
                      color: isFocused ? Colors.blue : Colors.grey,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(selectedValue ?? 'Select a fruit'),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Multiple selection example
            Text('Multiple Selection: ${selectedValues.join(", ")}'),
            const SizedBox(height: 16),
            NakedSelect<String>(
              allowMultiple: true,
              selectedValues: selectedValues,
              onSelectedValuesChanged: (values) =>
                  setState(() => selectedValues = values),
              closeOnSelect: false,
              controller: _multiSelectController,
              onClose: () => _multiSelectController.hide(),
              onOpen: () => _multiSelectController.show(),
              menu: Container(
                constraints: const BoxConstraints(maxWidth: 200),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SelectOption(value: 'Apple'),
                    SelectOption(value: 'Banana'),
                    SelectOption(value: 'Orange'),
                    SelectOption(value: 'Mango'),
                    SelectOption(value: 'Pear'),
                  ],
                ),
              ),
              child: NakedSelectTrigger(
                onHoverState: (value) => setState(() => isHovered = value),
                onPressedState: (value) => setState(() => isPressed = value),
                onFocusState: (value) => setState(() => isFocused = value),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isPressed
                        ? Colors.green[200]
                        : isHovered
                            ? Colors.green[100]
                            : Colors.white,
                    border: Border.all(
                      color: isFocused ? Colors.green : Colors.grey,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(selectedValues.isEmpty
                      ? 'Select fruits'
                      : selectedValues.join(', ')),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SelectOption extends StatefulWidget {
  final String value;

  const SelectOption({super.key, required this.value});

  @override
  State<SelectOption> createState() => _SelectOptionState();
}

class _SelectOptionState extends State<SelectOption> {
  bool isHovered = false;
  bool isPressed = false;
  bool isFocused = false;

  @override
  Widget build(BuildContext context) {
    return NakedSelectItem<String>(
      value: widget.value,
      onHoverState: (value) => setState(() => isHovered = value),
      onPressedState: (value) => setState(() => isPressed = value),
      onFocusState: (value) {
        setState(() => isFocused = value);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isPressed
              ? Colors.blue[200]
              : isHovered
                  ? Colors.blue[100]
                  : Colors.white,
          border: Border(
            bottom: BorderSide(color: Colors.grey[300]!),
          ),
        ),
        child: Row(
          children: [
            Text(widget.value),
            if (isFocused) ...[
              const Spacer(),
              const Icon(Icons.keyboard_arrow_right, size: 16),
            ],
          ],
        ),
      ),
    );
  }
}
