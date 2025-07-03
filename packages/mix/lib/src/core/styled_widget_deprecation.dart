// Deprecation constants for styled widgets
// This file contains constants used for deprecating styled widgets in favor of new naming conventions

/// The version in which deprecated styled widgets will be removed
const String deprecationVersion = 'v2.0.0';

/// Base deprecation message template
const String deprecationMessage = 'will be removed in $deprecationVersion';

/// Deprecation messages for styled widgets
class StyledWidgetDeprecationMessages {
  static const String styledRowMessage = 'Use HBox instead. '
      'StyledRow has been replaced with HBox for better naming consistency. '
      'This widget $deprecationMessage.';

  static const String styledColumnMessage = 'Use VBox instead. '
      'StyledColumn has been replaced with VBox for better naming consistency. '
      'This widget $deprecationMessage.';

  static const String styledFlexMessage = 'Use FlexBox instead. '
      'StyledFlex has been replaced with FlexBox for better naming consistency. '
      'This widget $deprecationMessage.';

  static const String styledStackMessage = 'Use ZBox instead. '
      'StyledStack has been replaced with ZBox which combines Box and Stack functionality. '
      'This widget $deprecationMessage.';

  static const String rowMethodMessage = 'Use hbox() instead. '
      'The row() method has been replaced with hbox() for better naming consistency. '
      'This method $deprecationMessage.';

  static const String columnMethodMessage = 'Use vbox() instead. '
      'The column() method has been replaced with vbox() for better naming consistency. '
      'This method $deprecationMessage.';
}

/// Migration examples for deprecated widgets
class StyledWidgetMigrationExamples {
  static const String styledRowToHBox = '''
// Before
StyledRow(
  style: myStyle,
  children: [widget1, widget2],
)

// After
HBox(
  style: myStyle,
  children: [widget1, widget2],
)''';

  static const String styledColumnToVBox = '''
// Before
StyledColumn(
  style: myStyle,
  children: [widget1, widget2],
)

// After
VBox(
  style: myStyle,
  children: [widget1, widget2],
)''';

  static const String styledFlexToFlexBox = '''
// Before
StyledFlex(
  direction: Axis.horizontal,
  style: myStyle,
  children: [widget1, widget2],
)

// After
FlexBox(
  direction: Axis.horizontal,
  style: myStyle,
  children: [widget1, widget2],
)''';

  static const String styledStackToZBox = '''
// Before
StyledStack(
  style: myStyle,
  children: [widget1, widget2],
)

// After
ZBox(
  style: myStyle,
  children: [widget1, widget2],
)''';

  static const String rowMethodToHBox = '''
// Before
style.row(children: [widget1, widget2])

// After
style.hbox(children: [widget1, widget2])''';

  static const String columnMethodToVBox = '''
// Before
style.column(children: [widget1, widget2])

// After
style.vbox(children: [widget1, widget2])''';
}
