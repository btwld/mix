## 1.7.0

 - **DEPRECATED**: Styled widgets in favor of new naming conventions
   - `StyledRow` → Use `HBox` instead
   - `StyledColumn` → Use `VBox` instead
   - `StyledFlex` → Use `FlexBox` instead
   - `StyledStack` → Use `ZBox` instead
   - `Style.row()` method → Use `Style.hbox()` instead
   - `Style.column()` method → Use `Style.vbox()` instead
 - **FIX**: FlexBox children parameter is now optional for better API compatibility
 - **FEAT**: Added deprecation constants and migration examples
 - **DOCS**: Updated example projects to use new widget names

## 1.6.0

 - **REFACTOR**: Rename `MixableProperty` to `MixableType` (#574)
 - **REFACTOR**: mix generator clean up and mix semantic changes (#569)
 - **CHORE**: Update min version compatibility (#572)

## 1.5.4

 - **FEAT**: Accordion interaction based on open variable (#546).

## 1.5.3

 - **REFACTOR**: Solve dcm lint issues (#519).
 - **FIX**: Order of modifiers implementation on Box, Image and Text (#529).
 - **FIX**: reset modifiers and directives when using fluentAPI (#482).
 - **FEAT**: Add spring curve (#503).
 - **FEAT**: Create StrokeAlignUtility (#496).
 - **FEAT**: Utilities for text height behavior (#495).
 - **FEAT**: Rewrite FlexBox as a Mix's primitive component (#517).
 - **FEAT**: Add `SpecConfiguration` (#483).
 - **DOCS**: Add section for `TokenResolver` (#537).

#### `mix` - `v1.5.2`

 - **REFACTOR**: ShapeBorder merge (#490).
 - **FEAT**: Improve error messages (#491).
 - **FEAT**: add error state to MixWidgetState (#489).
 
#### `mix` - `v1.5.1`

 - **FEAT**: Add MixOutlinedBorder (#487).

## 1.5.0

 - **FIX**: Update OnBrightnessVariant to use `MediaQuery` instead of `Theme` (#471).
 - **FIX**: Style when merged with an AnimatedStyle should generate an AnimatedStyle (#472).
 - **FEAT**: Create a specific utility to Transform.translate (#484).
 - **FEAT**: Add more directives to Colors (#477).
 - **FEAT**: implement a way to clear inline modifiers (#478).
 - **FEAT**: Fluent API (#475).

## 1.4.6

 - **FIX**(docs): fix fn level docs for Style::applyVariants (#460).
 - **FIX**: Shadow list animation (#445).
 - **FIX**: SpecModifiers were taking a long time to animate. (#457).
 - **FEAT**: Create mouse cursor Decorator (#263).
 - **FEAT**: Add parameter onEnd for AnimatedStyle (#458).
 - **FEAT**: `SingleChildScrollView` widget modifier (#427).
 - **FEAT**: Remix improvements and further improvements (#410).

## 1.4.5

 - **FIX**: HitTestBehavior when there is an Interectable in the tree (#437).
 - **FEAT**: Create a specific utility to Transform.rotate (#434).
 - **FEAT**: TargetPlatform and web variants (#431).

## 1.4.4

 - **FIX**: Pressable disposes controller only if it creates it (#424).

## 1.4.3

 - **FIX**: Breakpoint utility merge exception (#421).

## 1.4.2

 - **FIX**: FlexSpecWidget prioritizes the direction in spec (#414).

## 1.4.1

 - **FIX**: Added missing widget state utilities (#411).
 - **FIX**: Correct handling of individual border sides (#408).
 - **DOCS**: improve mix theme data features explanations (#404).

## 1.4.0

 - **FEAT**: Code generation for Widget Modifiers (#396).
 - **FEAT**: Ability to pass MixWidgetStateController to SpecBuilder (#391).
 - **FEAT**: Interactive widget state by default (#384).
 - **FEAT**: MixThemeData can alter default order of modifiers (#380).
 - **FEAT**: Dto utility generation now adds constructor and static methods (#377).
 - **FEAT**: ColorSwatchToken and other token improvements (#378).
 - **REFACTOR**: Code gen more lint friendly dart code (#399).
 - **FIX**: Gestures propagation for GestureMixStateWidget (#394).
 - **FIX**: Normalization of order of modifier when applied to a Styled Widget (#389).
 - **FIX**: Animations of Stack and Flex (#388).
 - **FIX**: Review the order of modifiers adding FlexibleModifier, PaddingModifier, and RotatedModifier (#379).

## 1.3.0

 - **REFACTOR**: unpressDelay uses timer instead of future<void> now (#374).
 - **REFACTOR**: bump min flutter version to 3.19.0 (#365).
 - **FEAT**: added modifiers per spec (#333).
 - **FEAT**: add attribute to fontVariantion (#371).

## 1.2.0

 - **FIX**: Exception when there is no children on flex (#345).
 - **FIX**: Added remaining params to callable specs and modifiers (#332).
 - **FIX**: Gap resolve SpaceToken in flex attribute (#327).
 - **FIX**: mix - Improved merge behavior between ShapeDecoration and BoxDecoration (#316).
 - **FEAT**: pressable supports keyboard events (#346).

## 1.1.3

- Improved merge behavior between ShapeDecoration and BoxDecoration
- Fixed space token resolve on gap in flex attribute
- Added remaining params to callable specs and modifiers

## 1.1.2

- Chore: Changed the class modifier of the Spec class for code generation.

## 1.1.1

- Fixed some specs not respecting nested animated.
- Added call build method to specs.

## 1.1.0

- Mix now uses mix_generator for Spec and Dto generation.
- Added missing utilities for IconSpec and ImageSpec.
- Added missing ShapeBorders.
- Improved ShapeBorderDto merge behavior.
- Bumped minimum Dart SDK to 3.0.6.
- Added animated utility to Spec.

## 1.0.0

- Revamped Mix API for improved functionality and developer experience.
- Enhanced performance and system responsiveness.
- Broadened test coverage for greater reliability.
- Extensive bug fixes for increased stability.
- Too many things to list; view our docs for more info.

Visit our documentation site for more information [https://fluttermix.com](https://fluttermix.com)

## 0.0.7

- Performance improvements.
- Bug fixes [#59](https://github.com/leoafarias/mix/issues/59) by @bdlukaa.
- InheritedAttribute - Custom Mix attributes [#94](https://github.com/leoafarias/mix/pull/94) by @pbissonho.

## 0.0.6

- Refactored MixTheme & Context Tokens.
- ZBox Widget by @.
- Headless Widgets (Experimental).
- Lots of bug fixes and performance improvements.

## 0.0.5

- Adjustments on Mix helper for applying variants and attributes.

## 0.0.4

- Optimization improvements.
- Added clip decorator.
- Fixed some bugs.

## 0.0.3

- Global Mix for reusability of design tokens and mixes across DS.
- `withMix` utility to add nested mixes and combine them.
- Attribute modifiers, create attributes that modify a widget value.

## 0.0.2

- Added screen size dynamic attribute.
- Added device orientation dynamic attribute.

## 0.0.1

- Initial release.