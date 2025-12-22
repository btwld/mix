/// AI Slop Detector - A collection of lint rules to detect common
/// AI-generated code quality issues.
///
/// These rules identify patterns that AI coding assistants commonly produce
/// that look correct but cause problems in production:
///
/// - **Hallucinations**: APIs, packages, or patterns that don't exist
/// - **Test Theater**: Tests that pass but verify nothing meaningful
/// - **Comment Anti-patterns**: Obvious, hedging, or placeholder comments
/// - **Over-engineering**: Excessive abstraction for simple problems
/// - **Dead Code**: Unreachable code, commented code, unused parameters
/// - **Error Handling Theater**: Silent failures and generic error messages
/// - **Structural Issues**: Deep nesting, god classes, long functions
library ai_slop;

export 'ai_slop_parameters.dart';

// Comment Anti-patterns (Medium Severity)
export 'detect_obvious_comments.dart';
export 'detect_hedging_comments.dart';
export 'detect_placeholder_comments.dart';
export 'detect_over_documentation.dart';

// Test Theater (Critical Severity)
export 'detect_empty_test_body.dart';
export 'detect_tautological_assertions.dart';

// Error Handling Theater (High Severity)
export 'detect_silent_catch.dart';
export 'detect_generic_exception.dart';
export 'detect_overbroad_catch.dart';

// Dead Code (Medium Severity)
export 'detect_unreachable_code.dart';
export 'detect_commented_code.dart';
export 'detect_unused_parameter.dart';

// Over-engineering / Structural Issues (High/Medium Severity)
export 'detect_god_class.dart';
export 'detect_long_function.dart';
export 'detect_deep_nesting.dart';
