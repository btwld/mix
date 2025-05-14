import 'package:flutter/material.dart';
import 'package:naked/naked.dart';

class NakedAccordionExample extends StatelessWidget {
  const NakedAccordionExample({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Beautiful Accordion Examples',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937), // text-gray-800
              ),
            ),
            const SizedBox(height: 48),

            // Basic Accordion
            _buildSection(
              'Simple Accordion',
              const _BasicAccordion(),
            ),
            const SizedBox(height: 48),

            // Styled Variations
            _buildSection(
              'Styled Variations',
              const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _ColoredAccordion()),
                  SizedBox(width: 24),
                  Expanded(child: _BorderedAccordion()),
                ],
              ),
            ),
            const SizedBox(height: 48),

            // Accordion Group
            _buildSection(
              'Accordion Group (Only one open at a time)',
              const _AccordionGroup(),
            ),
            const SizedBox(height: 48),

            // Nested Accordions
            _buildSection(
              'Nested Accordions',
              const _NestedAccordion(),
            ),
            const SizedBox(height: 48),

            // Icon Accordions
            _buildSection(
              'Accordion with Icons',
              const _IconAccordion(),
            ),
            const SizedBox(height: 48),

            // Card Style Accordions
            _buildSection(
              'Card Style Accordion',
              const _CardAccordion(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151), // text-gray-700
          ),
        ),
        const SizedBox(height: 16),
        content,
      ],
    );
  }
}

class _BasicAccordion extends StatefulWidget {
  const _BasicAccordion();

  @override
  State<_BasicAccordion> createState() => _BasicAccordionState();
}

class _BasicAccordionState extends State<_BasicAccordion> {
  final AccordionController<String> _controller = AccordionController<String>();
  final Map<String, bool> _hoveredItems = {};
  final Map<String, bool> _focusedItems = {};

  final List<Map<String, dynamic>> items = [
    {
      'id': 'item1',
      'title': 'What is an accordion component?',
      'content':
          'An accordion is a UI element consisting of vertically stacked headers that can be clicked to reveal or hide content associated with them. They\'re commonly used to toggle between hiding and showing large amounts of content.',
    },
    {
      'id': 'item2',
      'title': 'When should I use accordions?',
      'content':
          'Accordions are useful when you want to display a large amount of content in a limited space. They allow users to focus on specific sections without overwhelming them with all content at once. They\'re particularly helpful for FAQs, product details, and navigation menus.',
    },
    {
      'id': 'item3',
      'title': 'Are accordions good for mobile interfaces?',
      'content':
          'Yes, accordions are excellent for mobile interfaces as they help conserve screen space. They allow users to see all available sections at once and expand only what they\'re interested in, creating a more efficient browsing experience on smaller screens.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: NakedAccordion<String>(
        controller: _controller,
        onTriggerPressed: (value) {
          setState(() {
            if (_controller.values.contains(value)) {
              _controller.close(value);
            } else {
              // Close all other items when opening a new one (single mode)
              _controller.clear();
              _controller.open(value);
            }
          });
        },
        children: items.map((item) {
          final String id = item['id'] as String;
          final bool isExpanded = _controller.values.contains(id);
          final bool isHovered = _hoveredItems[id] ?? false;

          return NakedAccordionItem<String>(
            value: id,
            trigger: NakedAccordionTrigger<String>(
              onHoverState: (hovered) =>
                  setState(() => _hoveredItems[id] = hovered),
              onFocusState: (focused) =>
                  setState(() => _focusedItems[id] = focused),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isExpanded
                      ? Colors.blue.shade100
                      : isHovered
                          ? Colors.grey.shade300
                          : Colors.grey.shade200,
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        item['title'] as String,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: isExpanded
                              ? Colors.blue.shade800
                              : Colors.grey.shade800,
                        ),
                      ),
                    ),
                    Icon(
                      isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: isExpanded ? Colors.blue : Colors.grey.shade600,
                    ),
                  ],
                ),
              ),
            ),
            content: Container(
              padding: const EdgeInsets.all(16),
              color: Colors.blue.shade50,
              child: Text(
                item['content'] as String,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  height: 1.5,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ColoredAccordion extends StatefulWidget {
  const _ColoredAccordion();

  @override
  State<_ColoredAccordion> createState() => _ColoredAccordionState();
}

class _ColoredAccordionState extends State<_ColoredAccordion> {
  final AccordionController<String> _controller = AccordionController<String>();
  final Map<String, bool> _hoverStates = {};
  final Map<String, bool> _focusStates = {};
  final List<Map<String, dynamic>> items = [
    {
      'id': 'item1',
      'title': 'What is Naked UI?',
      'content':
          'Naked UI is a minimalist Flutter UI library that provides unstyled, accessible components for building custom interfaces.',
      'color': Colors.blue,
    },
    {
      'id': 'item2',
      'title': 'Why use Naked UI?',
      'content':
          'Naked UI gives you complete control over styling while handling complex interaction patterns, accessibility, and state management.',
      'color': Colors.green,
    },
    {
      'id': 'item3',
      'title': 'How to get started?',
      'content':
          'Add the naked package to your pubspec.yaml, import it, and start using the components. Each component is unstyled by default.',
      'color': Colors.purple,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return NakedAccordion<String>(
      controller: _controller,
      onTriggerPressed: (value) {
        setState(() {
          // Allow multiple items to be expanded
          _controller.toggle(value);
        });
      },
      children: items.map((item) {
        final String id = item['id'] as String;
        final Color color = item['color'] as Color;
        final bool isExpanded = _controller.values.contains(id);
        final bool isHovered = _hoverStates[id] ?? false;
        final bool isFocused = _focusStates[id] ?? false;

        return NakedAccordionItem<String>(
          value: id,
          trigger: NakedAccordionTrigger<String>(
            onHoverState: (isHovered) =>
                setState(() => _hoverStates[id] = isHovered),
            onFocusState: (isFocused) =>
                setState(() => _focusStates[id] = isFocused),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                border: Border.all(
                  color: color.withValues(
                    alpha: isHovered
                        ? 0.8
                        : isFocused
                            ? 0.6
                            : 0.3,
                  ),
                ),
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      item['title'] as String,
                      style: TextStyle(
                        color: color.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: color.withValues(alpha: 0.6),
                  ),
                ],
              ),
            ),
          ),
          content: Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
            child: Text(
              item['content'] as String,
              style: TextStyle(
                color: color.withValues(alpha: 0.7),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _BorderedAccordion extends StatefulWidget {
  const _BorderedAccordion();

  @override
  State<_BorderedAccordion> createState() => _BorderedAccordionState();
}

class _BorderedAccordionState extends State<_BorderedAccordion> {
  final AccordionController<String> _controller = AccordionController<String>();
  final Map<String, bool> _hoverStates = {};
  final Map<String, bool> _focusStates = {};

  final List<Map<String, dynamic>> items = [
    {
      'id': 'design',
      'title': 'Design Principles',
      'content':
          'Focus on simplicity, consistency, and user-centered design to create intuitive and accessible interfaces.',
    },
    {
      'id': 'color',
      'title': 'Color Theory',
      'content':
          'Understanding color relationships helps create visually appealing designs with proper contrast and harmony.',
    },
    {
      'id': 'typography',
      'title': 'Typography Guidelines',
      'content':
          'Select appropriate fonts, establish hierarchy, and ensure readability across different devices and contexts.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return NakedAccordion<String>(
      controller: _controller,
      onTriggerPressed: (value) {
        setState(() {
          if (_controller.values.contains(value)) {
            _controller.close(value);
          } else {
            // Single mode - close other items
            _controller.clear();
            _controller.open(value);
          }
        });
      },
      children: items.map((item) {
        final String id = item['id'] as String;
        final bool isExpanded = _controller.values.contains(id);

        return NakedAccordionItem<String>(
          value: id,
          trigger: NakedAccordionTrigger<String>(
            onHoverState: (isHovered) =>
                setState(() => _hoverStates[id] = isHovered),
            onFocusState: (isFocused) =>
                setState(() => _focusStates[id] = isFocused),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isExpanded
                      ? const Color(0xFF8B5CF6) // purple-500
                      : _hoverStates[id] == true
                          ? const Color(0xFFA78BFA) // purple-400
                          : _focusStates[id] == true
                              ? const Color(0xFFC4B5FD) // purple-300
                              : Colors.grey.shade300,
                  width: isExpanded ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      item['title'] as String,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: isExpanded
                            ? const Color(0xFF6D28D9) // purple-700
                            : Colors.grey.shade800,
                      ),
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: isExpanded
                        ? const Color(0xFF8B5CF6) // purple-500
                        : Colors.grey.shade500,
                  ),
                ],
              ),
            ),
          ),
          content: Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFFE9D5FF), // purple-200
                width: 1,
              ),
            ),
            child: Text(
              item['content'] as String,
              style: TextStyle(
                color: Colors.grey.shade700,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _AccordionGroup extends StatefulWidget {
  const _AccordionGroup();

  @override
  State<_AccordionGroup> createState() => _AccordionGroupState();
}

class _AccordionGroupState extends State<_AccordionGroup> {
  final AccordionController<String> _controller = AccordionController<String>();

  final List<Map<String, dynamic>> items = [
    {
      'id': 'ui',
      'title': 'User Interface Design',
      'content':
          'The process of building interfaces with a focus on looks and style, ensuring an aesthetically pleasing experience.',
    },
    {
      'id': 'ux',
      'title': 'User Experience Design',
      'content':
          'Enhancing user satisfaction by improving usability, accessibility, and pleasure provided in the interaction with a product.',
    },
    {
      'id': 'interaction',
      'title': 'Interaction Design',
      'content':
          'Focused on creating engaging interfaces with well-thought-out behaviors that facilitate effective communication between users and products.',
    },
    {
      'id': 'visual',
      'title': 'Visual Design',
      'content':
          'Using illustrations, photography, typography, space, layouts, and color to enhance user experience and build brand recognition.',
    },
  ];

  @override
  void initState() {
    super.initState();
    // First one open by default
    _controller.open('ui');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.white,
      ),
      clipBehavior: Clip.antiAlias,
      child: NakedAccordion<String>(
        controller: _controller,
        onTriggerPressed: (value) {
          setState(() {
            if (_controller.values.contains(value)) {
              // Don't allow closing the active item
              return;
            } else {
              // Single mode - close other items
              _controller.clear();
              _controller.open(value);
            }
          });
        },
        children: items.map((item) {
          final String id = item['id'] as String;
          final bool isActive = _controller.values.contains(id);

          return NakedAccordionItem<String>(
            value: id,
            trigger: NakedAccordionTrigger<String>(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: isActive ? const Color(0xFFF9FAFB) : Colors.white,
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        item['title'] as String,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: isActive
                              ? Colors.blue.shade600
                              : Colors.grey.shade700,
                        ),
                      ),
                    ),
                    AnimatedRotation(
                      turns: isActive ? 0.25 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.arrow_forward,
                        size: 20,
                        color: isActive
                            ? Colors.blue.shade500
                            : Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            content: Container(
              padding: const EdgeInsets.all(16),
              color: const Color(0xFFF9FAFB),
              child: Text(
                item['content'] as String,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _NestedAccordion extends StatefulWidget {
  const _NestedAccordion();

  @override
  State<_NestedAccordion> createState() => _NestedAccordionState();
}

class _NestedAccordionState extends State<_NestedAccordion> {
  final AccordionController<String> _parentController =
      AccordionController<String>();
  final Map<String, AccordionController<String>> _childControllers = {};

  final List<Map<String, dynamic>> items = [
    {
      'id': 'frontend',
      'title': 'Front-end Development',
      'content':
          'Creating the visible parts of a website or application that users interact with.',
      'children': [
        {
          'id': 'html',
          'title': 'HTML',
          'content':
              'The standard markup language for documents designed to be displayed in a web browser.'
        },
        {
          'id': 'css',
          'title': 'CSS',
          'content':
              'A style sheet language used for describing the presentation of a document written in HTML.'
        },
        {
          'id': 'javascript',
          'title': 'JavaScript',
          'content':
              'A programming language that enables interactive web pages and is an essential part of web applications.'
        }
      ]
    },
    {
      'id': 'backend',
      'title': 'Back-end Development',
      'content':
          'Focusing on databases, scripting, and the architecture of websites.',
      'children': [
        {
          'id': 'server',
          'title': 'Server Management',
          'content':
              'Maintaining computer servers with configurations, updates, and monitoring for optimal performance.'
        },
        {
          'id': 'database',
          'title': 'Database Administration',
          'content':
              'Responsible for the design, implementation, maintenance, and operational activities of database systems.'
        }
      ]
    }
  ];

  @override
  void initState() {
    super.initState();
    // Initialize controllers for each parent item
    for (final item in items) {
      final String id = item['id'] as String;
      _childControllers[id] = AccordionController<String>();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.white,
      ),
      child: NakedAccordion<String>(
        controller: _parentController,
        onTriggerPressed: (value) {
          setState(() {
            _parentController.toggle(value);
          });
        },
        children: items.map((item) {
          final String id = item['id'] as String;
          final List<Map<String, dynamic>> children =
              (item['children'] as List<dynamic>).cast<Map<String, dynamic>>();
          final bool isExpanded = _parentController.values.contains(id);
          final childController = _childControllers[id]!;

          return NakedAccordionItem<String>(
            value: id,
            trigger: NakedAccordionTrigger<String>(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isExpanded
                      ? const Color(0xFFEEF2FF) // indigo-50
                      : Colors.white,
                  borderRadius: isExpanded
                      ? const BorderRadius.vertical(top: Radius.circular(12))
                      : BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        item['title'] as String,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isExpanded
                              ? const Color(0xFF4F46E5) // indigo-600
                              : Colors.grey.shade800,
                        ),
                      ),
                    ),
                    Icon(
                      isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: isExpanded
                          ? const Color(0xFF4F46E5) // indigo-600
                          : Colors.grey.shade500,
                    ),
                  ],
                ),
              ),
            ),
            content: Container(
              padding: const EdgeInsets.all(16),
              color: const Color(0xFFEEF2FF), // indigo-50
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      item['content'] as String,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        height: 1.5,
                      ),
                    ),
                  ),
                  // Child accordions
                  Container(
                    padding: const EdgeInsets.only(left: 16),
                    decoration: const BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color: Color(0xFFC7D2FE), // indigo-200
                          width: 2,
                        ),
                      ),
                    ),
                    child: NakedAccordion<String>(
                      controller: childController,
                      onTriggerPressed: (childId) {
                        setState(() {
                          childController.toggle(childId);
                        });
                      },
                      children: children.map((child) {
                        final String childId = child['id'] as String;
                        final bool isChildExpanded =
                            childController.values.contains(childId);

                        return NakedAccordionItem<String>(
                          value: childId,
                          trigger: NakedAccordionTrigger<String>(
                            child: Container(
                              margin: const EdgeInsets.only(top: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isChildExpanded
                                    ? const Color(0xFFE0E7FF) // indigo-100
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 2,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      child['title'] as String,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: isChildExpanded
                                            ? const Color(
                                                0xFF4338CA) // indigo-700
                                            : Colors.grey.shade700,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    isChildExpanded ? Icons.remove : Icons.add,
                                    size: 18,
                                    color: isChildExpanded
                                        ? const Color(0xFF4338CA) // indigo-700
                                        : Colors.grey.shade500,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          content: Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(top: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              child['content'] as String,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                                height: 1.4,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _IconAccordion extends StatefulWidget {
  const _IconAccordion();

  @override
  State<_IconAccordion> createState() => _IconAccordionState();
}

class _IconAccordionState extends State<_IconAccordion> {
  final Map<String, AccordionController<String>> _controllers = {};

  final List<Map<String, dynamic>> items = [
    {
      'id': 'about',
      'title': 'About Us',
      'content':
          'Learn about our company\'s mission, vision, and the team behind our products and services.',
      'icon': Icons.info_outline,
      'iconColor': Colors.blue,
    },
    {
      'id': 'services',
      'title': 'Services',
      'content':
          'Explore our comprehensive range of services designed to meet your specific needs and requirements.',
      'icon': Icons.settings,
      'iconColor': Colors.green,
    },
    {
      'id': 'testimonials',
      'title': 'Testimonials',
      'content':
          'Read what our clients have to say about their experiences working with us and using our products.',
      'icon': Icons.person_outline,
      'iconColor': Colors.purple,
    },
    {
      'id': 'support',
      'title': 'Support',
      'content':
          'Get the help you need through our dedicated support channels available 24/7 for your convenience.',
      'icon': Icons.help_outline,
      'iconColor': Colors.red,
    },
  ];

  @override
  void initState() {
    super.initState();
    // Initialize a controller for each accordion item
    for (final item in items) {
      final String id = item['id'] as String;
      _controllers[id] = AccordionController<String>();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items.map((item) {
        final String id = item['id'] as String;
        final IconData icon = item['icon'] as IconData;
        final Color iconColor = item['iconColor'] as Color;
        final controller = _controllers[id]!;
        final bool isExpanded = controller.values.contains(id);

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: NakedAccordion<String>(
            controller: controller,
            onTriggerPressed: (value) {
              setState(() {
                controller.toggle(value);
              });
            },
            children: [
              NakedAccordionItem<String>(
                value: id,
                trigger: NakedAccordionTrigger<String>(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: iconColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Icon(
                              icon,
                              color: iconColor,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            item['title'] as String,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Icon(
                          isExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: Colors.grey.shade500,
                        ),
                      ],
                    ),
                  ),
                ),
                content: Container(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 56),
                    child: Text(
                      item['content'] as String,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _CardAccordion extends StatefulWidget {
  const _CardAccordion();

  @override
  State<_CardAccordion> createState() => _CardAccordionState();
}

class _CardAccordionState extends State<_CardAccordion> {
  final AccordionController<String> _controller = AccordionController<String>();

  final List<Map<String, dynamic>> items = [
    {
      'id': 'premium',
      'title': 'Premium Plan',
      'price': '\$49',
      'period': 'monthly',
      'content':
          'Access to all premium features including priority support, advanced analytics, and customization options.',
      'gradient': [
        const Color(0xFF6366F1),
        const Color(0xFF8B5CF6)
      ], // indigo to purple
    },
    {
      'id': 'standard',
      'title': 'Standard Plan',
      'price': '\$29',
      'period': 'monthly',
      'content':
          'Includes essential features suitable for small to medium-sized projects with regular updates and standard support.',
      'gradient': [
        const Color(0xFF10B981),
        const Color(0xFF3B82F6)
      ], // emerald to blue
    },
    {
      'id': 'basic',
      'title': 'Basic Plan',
      'price': '\$19',
      'period': 'monthly',
      'content':
          'Perfect for beginners with core functionality and limited features to get you started on your journey.',
      'gradient': [
        const Color(0xFFF97316),
        const Color(0xFFEC4899)
      ], // orange to pink
    },
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Use a grid layout for wider screens, column for narrower screens
        final bool isWideScreen = constraints.maxWidth > 600;

        final cardWidgets = items.map((item) {
          final String id = item['id'] as String;
          final List<Color> gradient = item['gradient'] as List<Color>;
          final bool isExpanded = _controller.values.contains(id);

          Widget cardContent = AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: isExpanded
                      ? gradient[0].withValues(alpha: 0.3)
                      : Colors.grey.withValues(alpha: 0.1),
                  blurRadius: isExpanded ? 15 : 5,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: NakedAccordion<String>(
              controller: _controller,
              onTriggerPressed: (value) {
                setState(() {
                  if (_controller.values.contains(value)) {
                    _controller.close(value);
                  } else {
                    // Single mode - close others when opening this one
                    _controller.clear();
                    _controller.open(value);
                  }
                });
              },
              children: [
                NakedAccordionItem<String>(
                  value: id,
                  trigger: NakedAccordionTrigger<String>(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: gradient,
                        ),
                        borderRadius: BorderRadius.vertical(
                          top: const Radius.circular(16),
                          bottom: isExpanded
                              ? Radius.zero
                              : const Radius.circular(16),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title'] as String,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                item['price'] as String,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '/${item['period']}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withValues(alpha: 0.8),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                isExpanded
                                    ? Icons.expand_less
                                    : Icons.expand_more,
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  content: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(16),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.05),
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      border: Border.all(
                        color: Colors.grey.shade100,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['content'] as String,
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: gradient[0],
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 24,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Choose Plan'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );

          return isWideScreen ? Expanded(child: cardContent) : cardContent;
        }).toList();

        return isWideScreen
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: cardWidgets,
              )
            : Column(
                children: cardWidgets,
              );
      },
    );
  }
}
