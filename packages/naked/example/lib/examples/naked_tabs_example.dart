import 'package:flutter/material.dart';
import 'package:naked/naked.dart';

class NakedTabsExample extends StatelessWidget {
  const NakedTabsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Tabs Examples',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // Tabs with Icons
            _buildSection(
              title: 'Basic Tabs',
              child: const _BasicTabs(),
            ),
            const SizedBox(height: 48),

            // Tabs with Icons
            _buildSection(
              title: 'Tabs with Icons',
              child: const _TabsWithIcons(),
            ),
            const SizedBox(height: 48),

            // Underlined Tabs
            _buildSection(
              title: 'Underlined Tabs',
              child: const _UnderlinedTabs(),
            ),
            const SizedBox(height: 48),

            // // Vertical Tabs
            _buildSection(
              title: 'Vertical Tabs',
              child: const _VerticalTabs(),
            ),
            const SizedBox(height: 48),

            // Card Tabs
            _buildSection(
              title: 'Card Tabs',
              child: const _CardTabs(),
            ),
            const SizedBox(height: 48),

            // Button-Style Tabs
            _buildSection(
              title: 'Button-Style Tabs',
              child: const _ButtonStyleTabs(),
            ),
            const SizedBox(height: 48),

            // Responsive Tabs Grid
            _buildSection(
              title: 'Responsive Tabs Grid',
              child: const _ResponsiveTabsGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Column(
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
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: child,
        ),
      ],
    );
  }
}

// Placeholder classes for each tab variant - will implement next
class _BasicTabs extends StatefulWidget {
  const _BasicTabs();
  @override
  State<_BasicTabs> createState() => _BasicTabsState();
}

class _BasicTabsState extends State<_BasicTabs> {
  String _activeTab = 'account';
  final FocusNode _focusNode = FocusNode();
  final Map<String, bool> _hoverStates = {};
  final Map<String, bool> _focusStates = {};
  final Map<String, bool> _pressStates = {};

  final List<Map<String, String>> _tabs = [
    {'id': 'account', 'label': 'Account'},
    {'id': 'password', 'label': 'Password'},
    {'id': 'settings', 'label': 'Settings'},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: NakedTabGroup(
          selectedTabId: _activeTab,
          onSelectedTabIdChanged: (id) => setState(() => _activeTab = id),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6), // bg-gray-100
                  borderRadius: BorderRadius.circular(8),
                ),
                child: NakedTabList(
                  child: Row(
                    children: _tabs.map((tab) {
                      final String id = tab['id']!;
                      final bool isActive = _activeTab == id;
                      final bool isHovered = _hoverStates[id] ?? false;
                      final bool isFocused = _focusStates[id] ?? false;
                      final bool isPressed = _pressStates[id] ?? false;

                      return Expanded(
                        child: NakedTab(
                          tabId: id,
                          onHoverState: (hover) =>
                              setState(() => _hoverStates[id] = hover),
                          onFocusState: (focus) => setState(() {
                            _focusStates[id] = focus;
                          }),
                          onPressedState: (press) =>
                              setState(() => _pressStates[id] = press),
                          focusNode: id == 'password' ? _focusNode : null,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? Colors.white
                                  : isPressed
                                      ? const Color(0xFFE5E7EB)
                                      : isHovered || isFocused
                                          ? const Color(0xFFE5E7EB)
                                              .withValues(alpha: 0.5)
                                          : Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: isActive
                                  ? [
                                      BoxShadow(
                                        color: Colors.black
                                            .withValues(alpha: 0.05),
                                        blurRadius: 4,
                                        offset: const Offset(0, 1),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Text(
                              tab['label']!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: isActive
                                    ? const Color(0xFF111827)
                                    : const Color(0xFF4B5563),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ..._tabs.map(
                (tab) => NakedTabPanel(
                  tabId: tab['id']!,
                  child: Container(
                    height: 150,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            _focusNode.requestFocus();
                          },
                          child: const Text('object'),
                        ),
                        Text(
                          '${tab['label']} Content',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF2563EB), // text-blue-600
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'This tab shows the ${tab['id']} panel',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF4B5563), // text-gray-600
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabsWithIcons extends StatefulWidget {
  const _TabsWithIcons();
  @override
  State<_TabsWithIcons> createState() => _TabsWithIconsState();
}

class _TabsWithIconsState extends State<_TabsWithIcons> {
  String _activeTab = 'profile';
  final Map<String, bool> _hoverStates = {};
  final Map<String, bool> _focusStates = {};
  final Map<String, bool> _pressStates = {};

  final List<Map<String, dynamic>> _tabs = [
    {'id': 'profile', 'label': 'Profile', 'icon': Icons.person},
    {'id': 'security', 'label': 'Security', 'icon': Icons.lock},
    {
      'id': 'notifications',
      'label': 'Notifications',
      'icon': Icons.notifications
    },
    {'id': 'billing', 'label': 'Billing', 'icon': Icons.credit_card},
  ];

  Color _getIconColor(String id) {
    switch (id) {
      case 'profile':
        return Colors.blue;
      case 'security':
        return Colors.green;
      case 'notifications':
        return Colors.amber;
      case 'billing':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: NakedTabGroup(
          selectedTabId: _activeTab,
          onSelectedTabIdChanged: (id) => setState(() => _activeTab = id),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6), // bg-gray-100
                  borderRadius: BorderRadius.circular(8),
                ),
                child: NakedTabList(
                  child: Row(
                    children: _tabs.map((tab) {
                      final String id = tab['id']!;
                      final bool isActive = _activeTab == id;
                      final bool isHovered = _hoverStates[id] ?? false;
                      final bool isFocused = _focusStates[id] ?? false;
                      final bool isPressed = _pressStates[id] ?? false;

                      return Expanded(
                        child: NakedTab(
                          tabId: id,
                          onHoverState: (hover) =>
                              setState(() => _hoverStates[id] = hover),
                          onFocusState: (focus) =>
                              setState(() => _focusStates[id] = focus),
                          onPressedState: (press) =>
                              setState(() => _pressStates[id] = press),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? Colors.white
                                  : isPressed
                                      ? const Color(0xFFE5E7EB)
                                      : isHovered || isFocused
                                          ? const Color(0xFFE5E7EB)
                                              .withValues(alpha: 0.5)
                                          : Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: isActive
                                  ? [
                                      BoxShadow(
                                        color: Colors.black
                                            .withValues(alpha: 0.05),
                                        blurRadius: 4,
                                        offset: const Offset(0, 1),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  tab['icon'] as IconData,
                                  size: 16,
                                  color: isActive
                                      ? const Color(0xFF2563EB)
                                      : const Color(0xFF4B5563),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  tab['label']!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: isActive
                                        ? const Color(0xFF2563EB)
                                        : const Color(0xFF4B5563),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ..._tabs.map((tab) => NakedTabPanel(
                    tabId: tab['id']!,
                    child: Container(
                      height: 150,
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            tab['icon'] as IconData,
                            size: 32,
                            color: _getIconColor(tab['id']!),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '${tab['label']} Tab Content',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF111827),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class _UnderlinedTabs extends StatefulWidget {
  const _UnderlinedTabs();
  @override
  State<_UnderlinedTabs> createState() => _UnderlinedTabsState();
}

class _UnderlinedTabsState extends State<_UnderlinedTabs> {
  String _activeTab = 'overview';
  final Map<String, bool> _hoverStates = {};
  final Map<String, bool> _focusStates = {};
  final Map<String, bool> _pressStates = {};

  final List<Map<String, String>> _tabs = [
    {'id': 'overview', 'label': 'Overview'},
    {'id': 'analytics', 'label': 'Analytics'},
    {'id': 'reports', 'label': 'Reports'},
    {'id': 'settings', 'label': 'Settings'},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: NakedTabGroup(
          selectedTabId: _activeTab,
          onSelectedTabIdChanged: (id) => setState(() => _activeTab = id),
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Color(0xFFE5E7EB), // border-gray-200
                    ),
                  ),
                ),
                child: NakedTabList(
                  child: Row(
                    children: _tabs.map((tab) {
                      final String id = tab['id']!;
                      final bool isActive = _activeTab == id;
                      final bool isHovered = _hoverStates[id] ?? false;
                      final bool isFocused = _focusStates[id] ?? false;

                      return NakedTab(
                        tabId: id,
                        onHoverState: (hover) =>
                            setState(() => _hoverStates[id] = hover),
                        onFocusState: (focus) =>
                            setState(() => _focusStates[id] = focus),
                        onPressedState: (press) =>
                            setState(() => _pressStates[id] = press),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: isActive
                                    ? const Color(0xFF3B82F6) // border-blue-500
                                    : isHovered || isFocused
                                        ? const Color(
                                            0xFFD1D5DB) // border-gray-300
                                        : Colors.transparent,
                                width: 2,
                              ),
                            ),
                          ),
                          child: Text(
                            tab['label']!,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: isActive
                                  ? const Color(0xFF3B82F6) // text-blue-600
                                  : isHovered || isFocused
                                      ? const Color(0xFF374151) // text-gray-700
                                      : const Color(
                                          0xFF6B7280), // text-gray-500
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ..._tabs.map((tab) => NakedTabPanel(
                    tabId: tab['id']!,
                    child: Container(
                      height: 150,
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            tab['label']!,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF3B82F6), // text-blue-600
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'You are viewing the ${tab['id']} tab content',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF6B7280), // text-gray-600
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class _VerticalTabs extends StatefulWidget {
  const _VerticalTabs();
  @override
  State<_VerticalTabs> createState() => _VerticalTabsState();
}

class _VerticalTabsState extends State<_VerticalTabs> {
  String _activeTab = 'general';
  final Map<String, bool> _hoverStates = {};
  final Map<String, bool> _focusStates = {};
  final Map<String, bool> _pressStates = {};

  final List<Map<String, dynamic>> _tabs = [
    {'id': 'general', 'label': 'General', 'icon': Icons.home},
    {'id': 'profile', 'label': 'Profile', 'icon': Icons.person},
    {
      'id': 'notifications',
      'label': 'Notifications',
      'icon': Icons.notifications
    },
    {'id': 'billing', 'label': 'Billing', 'icon': Icons.credit_card},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: NakedTabGroup(
        selectedTabId: _activeTab,
        onSelectedTabIdChanged: (id) => setState(() => _activeTab = id),
        orientation: Axis.vertical,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 200,
              padding: const EdgeInsets.only(right: 16),
              decoration: const BoxDecoration(
                border: Border(
                  right: BorderSide(
                    color: Color(0xFFE5E7EB), // border-gray-200
                  ),
                ),
              ),
              child: NakedTabList(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: _tabs.map((tab) {
                    final String id = tab['id']!;
                    final bool isActive = _activeTab == id;
                    final bool isHovered = _hoverStates[id] ?? false;
                    final bool isFocused = _focusStates[id] ?? false;
                    final bool isPressed = _pressStates[id] ?? false;

                    return NakedTab(
                      tabId: id,
                      onHoverState: (hover) =>
                          setState(() => _hoverStates[id] = hover),
                      onFocusState: (focus) =>
                          setState(() => _focusStates[id] = focus),
                      onPressedState: (press) =>
                          setState(() => _pressStates[id] = press),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        margin: const EdgeInsets.only(bottom: 4),
                        decoration: BoxDecoration(
                          color: isActive
                              ? const Color(0xFFEFF6FF) // bg-blue-50
                              : isPressed
                                  ? const Color(0xFFF3F4F6) // bg-gray-100
                                  : isHovered || isFocused
                                      ? const Color(0xFFF9FAFB) // bg-gray-50
                                      : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              tab['icon'] as IconData,
                              size: 18,
                              color: isActive
                                  ? const Color(0xFF2563EB) // text-blue-600
                                  : const Color(0xFF6B7280), // text-gray-500
                            ),
                            const SizedBox(width: 8),
                            Text(
                              tab['label']!,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: isActive
                                    ? const Color(0xFF2563EB) // text-blue-600
                                    : const Color(0xFF6B7280), // text-gray-500
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Column(
                  children: _tabs
                      .map((tab) => NakedTabPanel(
                            tabId: tab['id']!,
                            child: Container(
                              height: 200,
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    tab['icon'] as IconData,
                                    size: 24,
                                    color: const Color(
                                        0xFF111827), // text-gray-900
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    '${tab['label']} Content',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF111827), // text-gray-900
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'This is the ${tab['id']} tab panel',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF6B7280), // text-gray-500
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardTabs extends StatefulWidget {
  const _CardTabs();
  @override
  State<_CardTabs> createState() => _CardTabsState();
}

class _CardTabsState extends State<_CardTabs> {
  String _activeTab = 'devices';
  final Map<String, bool> _hoverStates = {};
  final Map<String, bool> _focusStates = {};
  final Map<String, bool> _pressStates = {};

  final List<Map<String, dynamic>> _tabs = [
    {'id': 'devices', 'label': 'Devices', 'count': 3},
    {'id': 'connected', 'label': 'Connected Apps', 'count': 7},
    {'id': 'sessions', 'label': 'Active Sessions', 'count': 2},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: NakedTabGroup(
          selectedTabId: _activeTab,
          onSelectedTabIdChanged: (id) => setState(() => _activeTab = id),
          child: Column(
            children: [
              NakedTabList(
                child: Row(
                  children: _tabs.map((tab) {
                    final String id = tab['id']!;
                    final bool isActive = _activeTab == id;
                    final bool isHovered = _hoverStates[id] ?? false;
                    final bool isFocused = _focusStates[id] ?? false;
                    final bool isPressed = _pressStates[id] ?? false;

                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: NakedTab(
                          tabId: id,
                          onHoverState: (hover) =>
                              setState(() => _hoverStates[id] = hover),
                          onFocusState: (focus) =>
                              setState(() => _focusStates[id] = focus),
                          onPressedState: (press) =>
                              setState(() => _pressStates[id] = press),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? Colors.white
                                  : isPressed
                                      ? const Color(0xFFF3F4F6) // bg-gray-100
                                      : isHovered || isFocused
                                          ? const Color(
                                              0xFFF9FAFB) // bg-gray-50
                                          : const Color(
                                              0xFFF3F4F6), // bg-gray-100
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isActive
                                    ? const Color(0xFFBFDBFE) // border-blue-200
                                    : const Color(
                                        0xFFE5E7EB), // border-gray-200
                              ),
                              boxShadow: isActive
                                  ? [
                                      BoxShadow(
                                        color: const Color(0xFF3B82F6)
                                            .withValues(alpha: 0.05),
                                        blurRadius: 4,
                                        offset: const Offset(0, 1),
                                      ),
                                      BoxShadow(
                                        color: const Color(0xFF3B82F6)
                                            .withValues(alpha: 0.1),
                                        blurRadius: 1,
                                        offset: const Offset(0, 0),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tab['label']!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF6B7280), // text-gray-500
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${tab['count']}',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: isActive
                                        ? const Color(
                                            0xFF2563EB) // text-blue-600
                                        : const Color(
                                            0xFF374151), // text-gray-700
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 24),
              ..._tabs.map((tab) => NakedTabPanel(
                    tabId: tab['id']!,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFFE5E7EB), // border-gray-200
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            tab['id'] == 'devices'
                                ? 'Devices Panel'
                                : tab['id'] == 'connected'
                                    ? 'Connected Apps Panel'
                                    : 'Active Sessions Panel',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF111827), // text-gray-900
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'This panel shows your ${tab['id']} information',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF6B7280), // text-gray-600
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class _ButtonStyleTabs extends StatefulWidget {
  const _ButtonStyleTabs();
  @override
  State<_ButtonStyleTabs> createState() => _ButtonStyleTabsState();
}

class _ButtonStyleTabsState extends State<_ButtonStyleTabs> {
  String _activeTab = 'mobile';

  final Map<String, bool> _hoverStates = {};
  final Map<String, bool> _focusStates = {};
  final Map<String, bool> _pressStates = {};

  final List<Map<String, dynamic>> _tabs = [
    {'id': 'mobile', 'label': 'Mobile', 'icon': Icons.smartphone},
    {'id': 'desktop', 'label': 'Desktop', 'icon': Icons.laptop},
    {'id': 'tablet', 'label': 'Tablet', 'icon': Icons.tablet},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          // Tabs as regular items instead of buttons
          NakedTabGroup(
            selectedTabId: _activeTab,
            onSelectedTabIdChanged: (id) => setState(() => _activeTab = id),
            child: Column(
              children: [
                NakedTabList(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: _tabs.map((tab) {
                        final String id = tab['id']!;
                        final bool isActive = _activeTab == id;
                        final bool isHovered = _hoverStates[id] ?? false;
                        final bool isFocused = _focusStates[id] ?? false;
                        final bool isPressed = _pressStates[id] ?? false;

                        // Get the index for border radius calculations
                        final int index =
                            _tabs.indexWhere((t) => t['id'] == id);
                        final bool isFirst = index == 0;
                        final bool isLast = index == _tabs.length - 1;

                        return NakedTab(
                          tabId: id,
                          onHoverState: (hover) =>
                              setState(() => _hoverStates[id] = hover),
                          onFocusState: (focus) =>
                              setState(() => _focusStates[id] = focus),
                          onPressedState: (press) =>
                              setState(() => _pressStates[id] = press),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? const Color(0xFFEFF6FF) // bg-blue-50
                                  : isPressed
                                      ? const Color(0xFFF9FAFB) // bg-gray-50
                                      : isHovered || isFocused
                                          ? const Color(
                                              0xFFF9FAFB) // bg-gray-50
                                          : Colors.white,
                              borderRadius: BorderRadius.horizontal(
                                left: isFirst
                                    ? const Radius.circular(8)
                                    : Radius.zero,
                                right: isLast
                                    ? const Radius.circular(8)
                                    : Radius.zero,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  tab['icon'] as IconData,
                                  size: 16,
                                  color: isActive
                                      ? const Color(0xFF1D4ED8) // text-blue-700
                                      : const Color(
                                          0xFF4B5563), // text-gray-600
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  tab['label']!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: isActive
                                        ? const Color(
                                            0xFF1D4ED8) // text-blue-700
                                        : const Color(
                                            0xFF4B5563), // text-gray-600
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ..._tabs.map((tab) => NakedTabPanel(
                      tabId: tab['id']!,
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xFFE5E7EB), // border-gray-200
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${tab['label']} View',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF111827), // text-gray-900
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Content optimized for ${tab['id']} devices',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF6B7280), // text-gray-500
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ResponsiveTabsGrid extends StatefulWidget {
  const _ResponsiveTabsGrid();
  @override
  State<_ResponsiveTabsGrid> createState() => _ResponsiveTabsGridState();
}

class _ResponsiveTabsGridState extends State<_ResponsiveTabsGrid> {
  String _activeTab = 'all';
  final Map<String, bool> _hoverStates = {};
  final Map<String, bool> _focusStates = {};
  final Map<String, bool> _pressStates = {};

  final List<Map<String, dynamic>> _tabs = [
    {'id': 'all', 'label': 'All Products'},
    {'id': 'electronics', 'label': 'Electronics'},
    {'id': 'clothing', 'label': 'Clothing'},
    {'id': 'home', 'label': 'Home & Kitchen'},
    {'id': 'books', 'label': 'Books'},
    {'id': 'toys', 'label': 'Toys & Games'},
  ];

  // Sample product data for demonstration
  List<Map<String, dynamic>> _getProductsForCategory(String category) {
    final List<Map<String, dynamic>> allProducts = [
      {
        'id': 'p1',
        'name': 'Smartphone',
        'price': '\$499',
        'category': 'electronics',
        'image': Icons.smartphone
      },
      {
        'id': 'p2',
        'name': 'Laptop',
        'price': '\$999',
        'category': 'electronics',
        'image': Icons.laptop
      },
      {
        'id': 'p3',
        'name': 'T-shirt',
        'price': '\$29',
        'category': 'clothing',
        'image': Icons.checkroom
      },
      {
        'id': 'p4',
        'name': 'Jeans',
        'price': '\$59',
        'category': 'clothing',
        'image': Icons.checkroom
      },
      {
        'id': 'p5',
        'name': 'Coffee Maker',
        'price': '\$89',
        'category': 'home',
        'image': Icons.coffee
      },
      {
        'id': 'p6',
        'name': 'Blender',
        'price': '\$49',
        'category': 'home',
        'image': Icons.blender
      },
      {
        'id': 'p7',
        'name': 'Novel',
        'price': '\$15',
        'category': 'books',
        'image': Icons.book
      },
      {
        'id': 'p8',
        'name': 'Cookbook',
        'price': '\$25',
        'category': 'books',
        'image': Icons.menu_book
      },
      {
        'id': 'p9',
        'name': 'Board Game',
        'price': '\$35',
        'category': 'toys',
        'image': Icons.casino
      },
      {
        'id': 'p10',
        'name': 'Action Figure',
        'price': '\$19',
        'category': 'toys',
        'image': Icons.toys
      },
    ];

    if (category == 'all') {
      return allProducts;
    }
    return allProducts
        .where((product) => product['category'] == category)
        .toList();
  }

  Widget _buildProductGrid(String category) {
    final products = _getProductsForCategory(category);

    return products.isEmpty
        ? const Center(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Text(
                'No products found in this category',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
          )
        : GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Icon(
                        product['image'],
                        size: 48,
                        color: const Color(0xFF3B82F6),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              product['name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              product['price'],
                              style: const TextStyle(
                                color: Color(0xFF6B7280),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: NakedTabGroup(
        selectedTabId: _activeTab,
        onSelectedTabIdChanged: (id) => setState(() => _activeTab = id),
        child: Column(
          children: [
            // Responsive tab list that wraps on smaller screens
            NakedTabList(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _tabs.map((tab) {
                  final String id = tab['id']!;
                  final bool isActive = _activeTab == id;
                  final bool isHovered = _hoverStates[id] ?? false;
                  final bool isFocused = _focusStates[id] ?? false;
                  final bool isPressed = _pressStates[id] ?? false;

                  return NakedTab(
                    tabId: id,
                    onHoverState: (hover) =>
                        setState(() => _hoverStates[id] = hover),
                    onFocusState: (focus) =>
                        setState(() => _focusStates[id] = focus),
                    onPressedState: (press) =>
                        setState(() => _pressStates[id] = press),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isActive
                            ? const Color(0xFF3B82F6) // bg-blue-500
                            : isPressed
                                ? const Color(0xFFE5E7EB) // bg-gray-200
                                : isHovered || isFocused
                                    ? const Color(0xFFF3F4F6) // bg-gray-100
                                    : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isActive
                              ? const Color(0xFF3B82F6) // border-blue-500
                              : const Color(0xFFE5E7EB), // border-gray-200
                        ),
                      ),
                      child: Text(
                        tab['label']!,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight:
                              isActive ? FontWeight.bold : FontWeight.normal,
                          color: isActive
                              ? Colors.white
                              : const Color(0xFF4B5563), // text-gray-600
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
            // Tab panels showing product grids
            ..._tabs.map((tab) => NakedTabPanel(
                  tabId: tab['id']!,
                  child: _buildProductGrid(tab['id']!),
                )),
          ],
        ),
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String selectedTabId = 'tab1';
  String selectedTabId2 = 'tab2';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NakedTabGroup(
        orientation: Axis.vertical,
        selectedTabId: selectedTabId,
        onSelectedTabIdChanged: (id) => setState(() => selectedTabId = id),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const NakedTabList(
              child: Row(
                children: [
                  Tab(
                    tabId: 'tab1',
                    label: 'Tab 1',
                  ),
                  Tab(
                    tabId: 'tab2',
                    label: 'Tab 2',
                  ),
                  Tab(
                    tabId: 'tab3',
                    label: 'Tab 3',
                  ),
                ],
              ),
            ),
            NakedTabPanel(
              tabId: 'tab1',
              child: TextButton(
                onFocusChange: (isFocused) {},
                child: const Text('Panel 1'),
                onPressed: () {},
              ),
            ),
            NakedTabPanel(
              tabId: 'tab2',
              child: TextButton(
                child: const Text('Panel 2'),
                onFocusChange: (isFocused) {},
                onPressed: () {},
              ),
            ),
            NakedTabPanel(
              tabId: 'tab3',
              child: TextButton(
                child: const Text('Panel 3'),
                onFocusChange: (isFocused) {},
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Tab extends StatefulWidget {
  const Tab({
    super.key,
    required this.tabId,
    required this.label,
  });

  final String tabId;
  final String label;

  @override
  State<Tab> createState() => _TabState();
}

class _TabState extends State<Tab> {
  bool isSelected = false;
  bool isSemiSelected = false;

  @override
  Widget build(BuildContext context) {
    return NakedTab(
      onFocusState: (isFocused) => setState(() {
        isSemiSelected = isFocused;
      }),
      onHoverState: (isHovered) => setState(() {
        isSemiSelected = isHovered;
      }),
      tabId: widget.tabId,
      child: Container(
        decoration: BoxDecoration(
          color: isSemiSelected
              ? Colors.red.withAlpha(100)
              : isSelected
                  ? Colors.blue.withAlpha(100)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(100),
        ),
        padding: const EdgeInsets.all(10),
        child: Text(
          widget.label,
        ),
      ),
    );
  }
}
