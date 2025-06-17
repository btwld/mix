## 0.4.1

 - **REFACTOR**: Move widget state handling from MixBuilder to SpecBuilder (#651).
 - **REFACTOR**: Rename WidgetModifiersData to WidgetModifiersConfig (#649).
 - **REFACTOR**: Fix deprecations and modernize codebase (#647).
 - **REFACTOR**: update outdated API (#583).
 - **REFACTOR**: Use WidgetState instead of MixWidgetState (#582).
 - **REFACTOR**: Rename `MixableProperty` to `MixableType` (#574).
 - **REFACTOR**: mix generator clean up and mix semantic changes (#569).
 - **REFACTOR**: Rewrite Fortaleza theme using the new code gen for tokens (#528).
 - **FIX**: update animated property handling to use null coalescing (#637).
 - **FIX**: Shadow list animation (#445).
 - **FEAT**: Add generated style-focused modifiers and specs (#652).
 - **FEAT**: unify SpecUtility, Style, and Attributes as compatible values (#643).
 - **FEAT**: builder optimization (#629).
 - **FEAT**: Create code gen for design tokens (#521).
 - **FEAT**: Rewrite FlexBox as a Mix's primitive component (#517).
 - **FEAT**: Fluent API (#475).
 - **FEAT**: Remix improvements and further improvements (#410).
 - **DOCS**: improve mix theme data features explanations (#404).

## 0.4.0

 - **REFACTOR**: Rename `MixableProperty` to `MixableType` (#574)
 - **REFACTOR**: mix generator clean up and mix semantic changes (#569)
 - **CHORE**: Update min version compatibility (#572)

## 0.3.2

 - **REFACTOR**: Rewrite Fortaleza theme using the new code gen for tokens (#528).
 - **FIX**: Shadow list animation (#445).
 - **FEAT**: Create code gen for design tokens (#521).
 - **FEAT**: Rewrite FlexBox as a Mix's primitive component (#517).
 - **FEAT**: Fluent API (#475).
 - **FEAT**: Remix improvements and further improvements (#410).
 - **DOCS**: improve mix theme data features explanations (#404).

## 0.3.1

 - **FEAT**: Fluent API (#475).

## 0.3.0

 - **FIX**: SpecModifiers were taking a long time to animate. (#457).
 - **FIX**: Shadow list animation (#445).

## 0.2.2+1

 - **DOCS**: improve mix theme data features explanations (#404).

## 0.2.2

 - **FEAT**: Code generation for Widget Modifiers (#396).
 - **FEAT**: Dto utility generation now adds constructor and static methods (#377).
 - **FEAT**: ColorSwatchToken and other token improvements (#378).
 - **REFACTOR**: Code gen more lint friendly dart code (#399) and (#395).
 - **FIX**: Nullable merge expressions and updates debug properties (#392).

## 0.2.1

 - **REFACTOR**: bump flutter version to 3.19.0 (#365).
 - **FEAT**: modifiers in spec (#333).


## 0.2.0

- Fixed: issue with getting correct type override from MixableDto
- Improved: Dto resolved type look up logic
- Added: generation List of value extension of a Dto
- Added: Class and Enum utility generation

## 0.1.2

- Fixed: Resolved conflict on generators when not configured on build.yaml

## 0.1.1

- Added: Support for Spec Attributes

## 0.1.0

- Initial release.
