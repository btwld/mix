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
          child: AccordionExample(),
        ),
      ),
    );
  }
}

class AccordionExample extends StatefulWidget {
  const AccordionExample({super.key});

  @override
  State<AccordionExample> createState() => _AccordionExampleState();
}

class _AccordionExampleState extends State<AccordionExample>
    with TickerProviderStateMixin {
  final _controller = AccordionController<String>(max: 1, min: 1);
  late final _animationController = AnimationController(
    duration: const Duration(milliseconds: 300),
    vsync: this,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: NakedAccordion<String>(
        controller: _controller,
        initialExpandedValues: const ['1'],
        children: const [
          AccordionItem(
            value: '1',
            title: 'Section 1',
            content:
                'This is the content for section 1. You can put anything here!',
          ),
          SizedBox(height: 8),
          AccordionItem(
            value: '2',
            title: 'Section 2',
            content:
                'This is the content for section 2. You can put anything here!',
          ),
        ],
      ),
    );
  }
}

class AccordionItem extends StatelessWidget {
  const AccordionItem({
    super.key,
    required this.value,
    required this.title,
    required this.content,
  });

  final String value;
  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return NakedAccordionItem<String>(
      value: value,
      trigger: (context, isExpanded, toggle) {
        return InkWell(
          onTap: toggle,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF3D3D3D)),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3D3D3D),
                  ),
                ),
                const Spacer(),
                AnimatedRotation(
                  turns: isExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(
                    Icons.expand_more,
                    color: Color(0xFF3D3D3D),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          content,
          style: const TextStyle(color: Color(0xFF3D3D3D)),
        ),
      ),
      transitionBuilder: (child) => AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (child, animation) {
          return SizeTransition(
            axis: Axis.vertical,
            sizeFactor: animation,
            axisAlignment: 1,
            child: child,
          );
        },
        child: child,
      ),
    );
  }
}
