import 'package:flutter/material.dart';
import 'package:naked/naked.dart';

class NakedMenuExample extends StatefulWidget {
  const NakedMenuExample({super.key});

  @override
  State<NakedMenuExample> createState() => _NakedMenuExampleState();
}

class _NakedMenuExampleState extends State<NakedMenuExample> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'NakedMenu Examples',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            const Divider(),

            // Basic Example
            const ExampleSection(
              title: 'Basic Example',
              description: 'Simple menu with basic styling and interactions.',
              child: BasicMenuExample(),
            ),

            const Divider(),

            // Keyboard Navigation
            const ExampleSection(
              title: 'Keyboard Navigation',
              description:
                  'Focus navigation with keyboard support. Use Tab to focus, Space/Enter to open, '
                  'Arrow keys to navigate items, Space/Enter to select, and Escape to close.',
              child: KeyboardNavExample(),
            ),

            const Divider(),

            // Custom Styled Menu
            const ExampleSection(
              title: 'Custom Styling',
              description: 'Menu with custom styling and animations.',
              child: StyledMenuExample(),
            ),

            const Divider(),

            // Multi-section Menu
            const ExampleSection(
              title: 'Multi-section Menu',
              description: 'Menu with multiple sections and scrolling support.',
              child: MultiSectionMenuExample(),
            ),
          ],
        ),
      ),
    );
  }
}

class ExampleSection extends StatelessWidget {
  final String title;
  final String description;
  final Widget child;

  const ExampleSection({
    super.key,
    required this.title,
    required this.description,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 24),
        child,
        const SizedBox(height: 24),
      ],
    );
  }
}

// ===================== BASIC MENU EXAMPLE =====================

class BasicMenuExample extends StatefulWidget {
  const BasicMenuExample({super.key});

  @override
  State<BasicMenuExample> createState() => _BasicMenuExampleState();
}

class _BasicMenuExampleState extends State<BasicMenuExample> {
  bool _isMenuOpen = false;
  String _lastAction = 'None';

  void _handleAction(String action) {
    setState(() {
      _lastAction = action;
      _isMenuOpen = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Selected: $action')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Last selected: $_lastAction'),
        const SizedBox(height: 16),
        NakedMenu(
          open: _isMenuOpen,
          onMenuClose: () => setState(() => _isMenuOpen = false),
          offset: const Offset(0, 4),
          menuAlignment: const AlignmentPair(
            target: Alignment.bottomLeft,
            follower: Alignment.topLeft,
          ),
          menu: _buildMenuContent(),
          child: ElevatedButton.icon(
            onPressed: () => setState(() => _isMenuOpen = !_isMenuOpen),
            icon: const Icon(Icons.menu, color: Colors.white),
            label: const Text('Open Menu'),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuContent() {
    return NakedMenuContent(
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildMenuItem(
              'Edit',
              Icons.edit_outlined,
              () => _handleAction('Edit'),
            ),
            _buildMenuItem(
              'Duplicate',
              Icons.copy_outlined,
              () => _handleAction('Duplicate'),
            ),
            _buildMenuItem(
              'Share',
              Icons.share_outlined,
              () => _handleAction('Share'),
            ),
            _buildDivider(),
            _buildMenuItem(
              'Delete',
              Icons.delete_outline,
              () => _handleAction('Delete'),
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    String label,
    IconData icon,
    VoidCallback onPressed, {
    Color? color,
  }) {
    return NakedMenuItem(
      onPressed: onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(color: color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, thickness: 1);
  }
}

// ===================== KEYBOARD NAVIGATION EXAMPLE =====================

class KeyboardNavExample extends StatefulWidget {
  const KeyboardNavExample({super.key});

  @override
  State<KeyboardNavExample> createState() => _KeyboardNavExampleState();
}

class _KeyboardNavExampleState extends State<KeyboardNavExample> {
  bool _isMenuOpen = false;
  String _lastAction = 'None';
  final Map<String, bool> _itemFocusStates = {};

  void _handleAction(String action) {
    setState(() {
      _lastAction = action;
      _isMenuOpen = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Selected: $action')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Last selected: $_lastAction'),
        const SizedBox(height: 8),
        Text(
          'Focus state: ${_itemFocusStates.entries.where((e) => e.value).map((e) => e.key).join(', ')}',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        NakedMenu(
          open: _isMenuOpen,
          onMenuClose: () => setState(() => _isMenuOpen = false),
          menu: _buildMenuContent(),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
            ),
            onPressed: () => setState(() => _isMenuOpen = !_isMenuOpen),
            icon: const Icon(Icons.keyboard, color: Colors.white),
            label: const Text('Press Tab to Focus'),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuContent() {
    return NakedMenuContent(
      child: Container(
        width: 240,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildKeyboardItem(
              'profile',
              'View Profile',
              Icons.person_outline,
              () => _handleAction('View Profile'),
            ),
            _buildKeyboardItem(
              'settings',
              'Settings',
              Icons.settings_outlined,
              () => _handleAction('Settings'),
            ),
            _buildKeyboardItem(
              'help',
              'Help & Support',
              Icons.help_outline,
              () => _handleAction('Help & Support'),
            ),
            _buildDivider(),
            _buildKeyboardItem(
              'logout',
              'Logout',
              Icons.logout,
              () => _handleAction('Logout'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeyboardItem(
    String id,
    String label,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return NakedMenuItem(
      onPressed: onPressed,
      onFocusState: (isFocused) =>
          setState(() => _itemFocusStates[id] = isFocused),
      child: Builder(
        builder: (context) {
          final bool isFocused = _itemFocusStates[id] ?? false;

          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: isFocused
                  ? Theme.of(context)
                      .colorScheme
                      .primaryContainer
                      .withValues(alpha: 0.4)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: isFocused
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey.shade700,
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: isFocused ? FontWeight.bold : FontWeight.normal,
                    color: isFocused
                        ? Theme.of(context).colorScheme.primary
                        : Colors.black87,
                  ),
                ),
                const Spacer(),
                if (isFocused)
                  Icon(
                    Icons.keyboard_return,
                    size: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Divider(height: 1, thickness: 1, color: Colors.grey.shade200),
    );
  }
}

// ===================== STYLED MENU EXAMPLE =====================

class StyledMenuExample extends StatefulWidget {
  const StyledMenuExample({super.key});

  @override
  State<StyledMenuExample> createState() => _StyledMenuExampleState();
}

class _StyledMenuExampleState extends State<StyledMenuExample> {
  bool _isMenuOpen = false;
  String _lastAction = 'None';

  final Map<String, bool> _hoverStates = {};

  void _handleAction(String action) {
    setState(() {
      _lastAction = action;
      _isMenuOpen = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Selected: $action')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Last selected: $_lastAction'),
        const SizedBox(height: 16),
        NakedMenu(
          open: _isMenuOpen,
          onMenuClose: () => setState(() => _isMenuOpen = false),
          offset: const Offset(0, 8),
          menuAlignment: const AlignmentPair(
            target: Alignment.bottomLeft,
            follower: Alignment.topLeft,
          ),
          menu: _buildStyledMenuContent(),
          child: _buildTriggerButton(),
        ),
      ],
    );
  }

  Widget _buildTriggerButton() {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: () => setState(() => _isMenuOpen = !_isMenuOpen),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 14,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.secondary,
              ],
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.palette_outlined,
                color: Colors.white,
              ),
              const SizedBox(width: 12),
              const Text(
                'Styled Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                _isMenuOpen
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStyledMenuContent() {
    return NakedMenuContent(
      child: Container(
        width: 260,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Choose Theme',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            _buildStyledMenuItem(
              'light',
              'Light Theme',
              Icons.light_mode,
              () => _handleAction('Light Theme'),
              Colors.amber,
            ),
            _buildStyledMenuItem(
              'dark',
              'Dark Theme',
              Icons.dark_mode,
              () => _handleAction('Dark Theme'),
              Colors.indigo,
            ),
            _buildStyledMenuItem(
              'system',
              'System Default',
              Icons.settings_outlined,
              () => _handleAction('System Default'),
              Colors.blueGrey,
            ),
            _buildStyledMenuItem(
              'custom',
              'Custom Theme',
              Icons.color_lens_outlined,
              () => _handleAction('Custom Theme'),
              Colors.deepPurple,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStyledMenuItem(
    String id,
    String label,
    IconData icon,
    VoidCallback onPressed,
    Color accentColor,
  ) {
    return NakedMenuItem(
      onPressed: onPressed,
      onFocusState: (isFocused) => setState(() => _hoverStates[id] = isFocused),
      onHoverState: (isHovered) => setState(() => _hoverStates[id] = isHovered),
      child: Builder(
        builder: (context) {
          final bool isHovered = _hoverStates[id] ?? false;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity,
            margin: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: isHovered
                  ? accentColor.withValues(alpha: 0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isHovered
                        ? accentColor
                        : accentColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color: isHovered ? Colors.white : accentColor,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: isHovered ? accentColor : Colors.black87,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ===================== MULTI-SECTION MENU EXAMPLE =====================

class MultiSectionMenuExample extends StatefulWidget {
  const MultiSectionMenuExample({super.key});

  @override
  State<MultiSectionMenuExample> createState() =>
      _MultiSectionMenuExampleState();
}

class _MultiSectionMenuExampleState extends State<MultiSectionMenuExample> {
  bool _isMenuOpen = false;
  String _lastAction = 'None';
  final Map<String, bool> _hoverStates = {};

  void _handleAction(String action) {
    setState(() {
      _lastAction = action;
      _isMenuOpen = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Selected: $action')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Last selected: $_lastAction'),
        const SizedBox(height: 16),
        NakedMenu(
          open: _isMenuOpen,
          onMenuClose: () => setState(() => _isMenuOpen = false),
          offset: const Offset(0, 4),
          menu: _buildMultiSectionMenu(),
          child: OutlinedButton.icon(
            onPressed: () => setState(() => _isMenuOpen = !_isMenuOpen),
            icon: const Icon(Icons.format_list_bulleted),
            label: const Text('Multi-section Menu'),
          ),
        ),
      ],
    );
  }

  Widget _buildMultiSectionMenu() {
    return NakedMenuContent(
      child: Container(
        width: 280,
        constraints: const BoxConstraints(maxHeight: 400),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader('File Operations'),
              _buildSectionItem(
                'New File',
                Icons.note_add,
                () => _handleAction('New File'),
              ),
              _buildSectionItem(
                'Open Recent',
                Icons.history,
                () => _handleAction('Open Recent'),
              ),
              _buildSectionItem(
                'Save',
                Icons.save,
                () => _handleAction('Save'),
              ),
              _buildSectionItem(
                'Save As',
                Icons.save_as,
                () => _handleAction('Save As'),
              ),
              const Divider(),
              _buildSectionHeader('Edit Operations'),
              _buildSectionItem(
                'Undo',
                Icons.undo,
                () => _handleAction('Undo'),
              ),
              _buildSectionItem(
                'Redo',
                Icons.redo,
                () => _handleAction('Redo'),
              ),
              _buildSectionItem(
                'Find',
                Icons.search,
                () => _handleAction('Find'),
              ),
              _buildSectionItem(
                'Replace',
                Icons.find_replace,
                () => _handleAction('Replace'),
              ),
              const Divider(),
              _buildSectionHeader('View'),
              _buildSectionItem(
                'Toggle Sidebar',
                Icons.vertical_split,
                () => _handleAction('Toggle Sidebar'),
              ),
              _buildSectionItem(
                'Toggle Terminal',
                Icons.terminal,
                () => _handleAction('Toggle Terminal'),
              ),
              _buildSectionItem(
                'Toggle Full Screen',
                Icons.fullscreen,
                () => _handleAction('Toggle Full Screen'),
              ),
              const Divider(),
              _buildSectionHeader('Account'),
              _buildSectionItem(
                'Profile',
                Icons.account_circle,
                () => _handleAction('Profile'),
              ),
              _buildSectionItem(
                'Settings',
                Icons.settings,
                () => _handleAction('Settings'),
              ),
              _buildSectionItem(
                'Logout',
                Icons.logout,
                () => _handleAction('Logout'),
                color: Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildSectionItem(
    String label,
    IconData icon,
    VoidCallback onPressed, {
    Color? color,
  }) {
    final bool isHovered = _hoverStates[label] ?? false;
    final Color itemColor = color ?? Theme.of(context).colorScheme.primary;

    return NakedMenuItem(
      onPressed: onPressed,
      onHoverState: (hover) => setState(() => _hoverStates[label] = hover),
      onFocusState: (focus) => setState(() => _hoverStates[label] = focus),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color:
              isHovered ? itemColor.withValues(alpha: 0.1) : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(icon,
                size: 18,
                color: isHovered ? itemColor : color ?? Colors.black54),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: isHovered ? itemColor : color ?? Colors.black87,
                fontWeight: isHovered ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
