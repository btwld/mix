/// Naked widgets for Flutter.
///
/// This library provides a collection of non-styled, customizable widgets
/// that handle state and interaction logic without imposing visual styling.
///
/// Naked components use a callback-driven approach where:
/// 1. Components provide callbacks for state changes (hover, focus, press)
/// 2. Consumers manage their own state using these callbacks
/// 3. Consumers have full control over visual styling
///
/// For detailed implementation patterns, examples, and best practices,
/// see the Naked Component Development Guide at:
/// .context/plan/naked_component_development_guide.md
library naked;

// Components
export 'src/naked_accordion.dart';
export 'src/naked_avatar.dart';
export 'src/naked_button.dart';
export 'src/naked_checkbox.dart';
export 'src/naked_dialog.dart';
export 'src/naked_menu.dart';
export 'src/naked_radio_button.dart';
export 'src/naked_radio_group.dart';
export 'src/naked_select.dart';
export 'src/naked_slider.dart';
export 'src/naked_tabs.dart';
export 'src/naked_textfield.dart';
export 'src/naked_toast.dart';
export 'src/naked_tooltip.dart';
// Export utilities
export 'src/utilities/utilities.dart';

// Future components (coming soon):
// - NakedToggle
// - NakedCombobox
// - NakedDialog

// Core - removed core export as we're now just using common directly
// export 'src/core/core.dart';
// export 'src/slider/headless_slider.dart'
//     hide InteractiveStateSetStringExtension;
