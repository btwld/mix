# Change Log

All notable changes to this project will be documented in this file.
See [Conventional Commits](https://conventionalcommits.org) for commit guidelines.

## 2025-06-23

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`mix` - `v1.7.0-beta.0`](#mix---v170-beta0)
 - [`mix_lint` - `v1.7.0-beta.0`](#mix_lint---v170-beta0)
 - [`mix_annotations` - `v1.7.0-beta.0`](#mix_annotations---v170-beta0)
 - [`mix_generator` - `v1.7.0-beta.0`](#mix_generator---v170-beta0)
 - [`naked` - `v0.1.0-beta.0`](#naked---v010-beta0)

---

#### `mix` - `v1.7.0-beta.0`

 - **REFACTOR**: bump flutter version to 3.19.0 (#365).
 - **REFACTOR**: Simplify accordion component architecture (#661).
 - **REFACTOR**: Implement BaseStyle utility class and improve styling architecture (#659).
 - **REFACTOR**: Remove SpecConfiguration and SpecStyle from environment (#656).
 - **REFACTOR**: Move widget state handling from MixBuilder to SpecBuilder (#651).
 - **REFACTOR**: Rename WidgetModifiersData to WidgetModifiersConfig (#649).
 - **REFACTOR**: Fix deprecations and modernize codebase (#647).
 - **REFACTOR**: Remove NestedStyleAttribute and migrate to direct Style usage (#644).
 - **REFACTOR**: update outdated API (#583).
 - **REFACTOR**: Deprecate `MixWidgetStateController` (#586).
 - **REFACTOR**: Use WidgetState instead of MixWidgetState (#582).
 - **REFACTOR**: Rename `MixableProperty` to `MixableType` (#574).
 - **REFACTOR**: mix generator clean up and mix semantic changes (#569).
 - **REFACTOR**: Rewrite Fortaleza theme using the new code gen for tokens (#528).
 - **REFACTOR**: Solve dcm lint issues (#519).
 - **REFACTOR**: ShapeBorder merge (#490).
 - **REFACTOR**: Rewrite all components in the new Archtecture (#467).
 - **REFACTOR**(mix_generator): fix lints (#395).
 - **REFACTOR**: use timer instead of future<void> (#374).
 - **FIX**: reset modifiers and directives when using fluentAPI (#482).
 - **FIX**: FlexSpecWidget prioritizes the direction in spec (#414).
 - **FIX**: Add variant condition check to ContextVariantBuilder (#657).
 - **FIX**: Change Mixable to extend EqualityMixin instead of StyleElement (#648).
 - **FIX**: copyWith overriding bug (#622).
 - **FIX**: Gap resolve SpaceToken in flex attribute (#327).
 - **FIX**: Order of modifiers implementation on Box, Image and Text (#529).
 - **FIX**(docs): fix fn level docs for Style::applyVariants (#460).
 - **FIX**: animations of Stack and Flex.
 - **FIX**: order modifier (#389).
 - **FIX**: Code gen linting fixes (#399).
 - **FIX**: add flexible as the first in the order of modifiers (#379).
 - **FIX**: gestures propagation for GestureMixStateWidget (#394).
 - **FIX**: Added remaining params to callable specs and modifiers (#332).
 - **FIX**: Correct handling of individual border sides (#408).
 - **FIX**: Added missing widget state utilities (#411).
 - **FIX**: Exception when there is no children on flex (#345).
 - **FIX**: breakpoint utility merge exception (#421).
 - **FIX**: Pressable disposes controller only if it creates it (#424).
 - **FIX**: mix - Improved merge behavior between ShapeDecoration and BoxDecoration (#316).
 - **FIX**: Shadow list animation (#445).
 - **FIX**: Style when merged with an AnimatedStyle should generate an AnimatedStyle (#472).
 - **FIX**: Update OnBrightnessVariant to use `MediaQuery` instead of `Theme` (#471).
 - **FIX**: HitTestBehavior when there is a Interectable in the tree (#437).
 - **FEAT**: Refactor slider and spinner components with new architecture (#674).
 - **FEAT**: remix-styling-configuration (#483).
 - **FEAT**: Add more directives to Colors (#477).
 - **FEAT**: implement a way to clear inline modifiers (#478).
 - **FEAT**: Fluent API (#475).
 - **FEAT**: Add CustomOutlinedBorder's  (#487).
 - **FEAT**: builder optimization (#629).
 - **FEAT**: Create mouse cursor Decorator (#263).
 - **FEAT**: Create Select component (#448).
 - **FEAT**: transform.translate (#484).
 - **FEAT**: Add parameter onEnd for AnimatedStyle (#458).
 - **FEAT**: `SingleChildScrollView` widget modifier (#427).
 - **FEAT**: add error state to MixWidgetState (#489).
 - **FEAT**: Create a specific utility to Transform.rotate (#434).
 - **FEAT**: unify SpecUtility, Style, and Attributes as compatible values (#643).
 - **FEAT**: TargetPlatform and web variants (#431).
 - **FEAT**: Improve error messages (#491).
 - **FEAT**: Utilities for text height behavior (#495).
 - **FEAT**: Remix improvements and further improvements (#410).
 - **FEAT**: Create StrokeAlignUtility (#496).
 - **FEAT**: implement toast component (#503).
 - **FEAT**: Improve spring curve.
 - **FEAT**: Slider component (#509).
 - **FEAT**: Rewrite FlexBox as a Mix's primitive component (#517).
 - **FEAT**: Add focused style classes for spec utilities (#677).
 - **FEAT**: Code generation for Widget Modifiers (#396).
 - **FEAT**: deprecate styled widgets in favor of new naming conventions (#619).
 - **FEAT**: Ability to pass MixWidgetStateController to SpecBuilder (#391).
 - **FEAT**: Accordion interaction based on open variable (#546).
 - **FEAT**: Implementing new RXButton (#660).
 - **FEAT**: remix - Foundational components (#317).
 - **FEAT**: interactive widget state by default (#384).
 - **FEAT**: MixThemeData can alter default order of modifiers (#380).
 - **FEAT**: Dto utility generation now adds constructor and static methods.
 - **FEAT**: "Naked" - A Behavior-First UI Component Library for Flutter (#579).
 - **FEAT**: ColorSwatchToken and other token improvements (#378).
 - **FEAT**: Implementing duration extension for int  (#634).
 - **FEAT**: modifiers in spec (#333).
 - **FEAT**: add attribute to fontVariantion (#371).
 - **FEAT**: Create MixBuilder (#581).
 - **FEAT**: pressable supports keyboard events (#346).
 - **FEAT**: Add generated style-focused modifiers and specs (#652).
 - **FEAT**: Create code gen for design tokens (#521).
 - **DOCS**: Add section for `TokenResolver` (#537).
 - **DOCS**: improve mix theme data features explanations (#404).

#### `mix_lint` - `v1.7.0-beta.0`

 - **REFACTOR**: update outdated API (#583).
 - **FEAT**: Rewrite FlexBox as a Mix's primitive component (#517).

#### `mix_annotations` - `v1.7.0-beta.0`

 - **REFACTOR**: Rename `MixableProperty` to `MixableType` (#574).
 - **REFACTOR**: mix generator clean up and mix semantic changes (#569).
 - **FEAT**: Add focused style classes for spec utilities (#677).
 - **FEAT**: Add generated style-focused modifiers and specs (#652).
 - **FEAT**: Create code gen for design tokens (#521).

#### `mix_generator` - `v1.7.0-beta.0`

 - **REFACTOR**: Implement BaseStyle utility class and improve styling architecture (#659).
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
 - **FEAT**: Add focused style classes for spec utilities (#677).
 - **FEAT**: Add generated style-focused modifiers and specs (#652).
 - **FEAT**: unify SpecUtility, Style, and Attributes as compatible values (#643).
 - **FEAT**: builder optimization (#629).
 - **FEAT**: Create code gen for design tokens (#521).
 - **FEAT**: Rewrite FlexBox as a Mix's primitive component (#517).
 - **FEAT**: Fluent API (#475).
 - **FEAT**: Remix improvements and further improvements (#410).
 - **DOCS**: improve mix theme data features explanations (#404).

#### `naked` - `v0.1.0-beta.0`

 - **REFACTOR**: Select (#596).
 - **REFACTOR**: Tabs and Tooltip (#595).
 - **REFACTOR**: Naked Slider (#594).
 - **REFACTOR**: radio group (#593).
 - **REFACTOR**: naked menu (#592).
 - **REFACTOR**: accordion (#591).
 - **REFACTOR**: Refactor Checkbox (#590).
 - **REFACTOR**: update outdated API (#583).
 - **FIX**: Change default autofocus to false in Menu and Select (#609).
 - **FEAT**: Refactor radio and checkbox components with new architecture (#672).
 - **FEAT**: Add textStyle prop in NakedTextField  (#608).
 - **FEAT**: Implement Tooltip Lifecycle (#603).
 - **FEAT**: Add test for Hover to RadioButton (#601).
 - **FEAT**: Recreate Button using Naked (#587).
 - **FEAT**: "Naked" - A Behavior-First UI Component Library for Flutter (#579).
 - **DOCS**: organize folders and files.
 - **DOCS**: Improve accordion example.
 - **DOCS**: Remove old example app (#607).
 - **DOCS**: Document naked button (#599).


## 2025-06-17

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`mix` - `v1.7.0-beta.0`](#mix---v170)
 - [`mix_annotations` - `v0.4.1`](#mix_annotations---v041)
 - [`mix_generator` - `v0.4.1`](#mix_generator---v041)
 - [`mix_lint` - `v0.1.4`](#mix_lint---v014)
 - [`naked` - `v0.0.1-dev.1`](#naked---v001-dev1)
 - [`remix` - `v0.0.4+2`](#remix---v0042)

Packages with dependency updates only:

> Packages listed below depend on other packages in this workspace that have had changes. Their versions have been incremented to bump the minimum dependency versions of the packages they depend upon in this project.

 - `remix` - `v0.0.4+2`

---

#### `mix` - `v1.7.0-beta.0`

 - **REFACTOR**: Implement BaseStyle utility class and improve styling architecture (#659)
 - **REFACTOR**: Remove SpecConfiguration and SpecStyle from environment (#656)
 - **REFACTOR**: Move widget state handling from MixBuilder to SpecBuilder (#651).
 - **REFACTOR**: Rename WidgetModifiersData to WidgetModifiersConfig (#649).
 - **REFACTOR**: Fix deprecations and modernize codebase (#647).
 - **REFACTOR**: Remove NestedStyleAttribute and migrate to direct Style usage (#644).
 - **REFACTOR**: Deprecate `MixWidgetStateController` (#586).
 - **REFACTOR**: Use WidgetState instead of MixWidgetState (#582).
 - **FIX**: Change Mixable to extend EqualityMixin instead of StyleElement (#648).
 - **FIX**: CopyWith overriding bug (#622).
 - **FEAT**: builder optimization (#629).
 - **FEAT**: deprecate styled widgets in favor of new naming conventions (#619).
 - **FEAT**: Implementing duration extension for int  (#634).
 - **FEAT**: Create MixBuilder (#581).
 - **FEAT**: Add generated style-focused modifiers and specs (#652).
 - **FEAT**: Unify SpecUtility, Style, and Attributes as compatible values (#643).
 - **FEAT**: Add utilities for animatedData (#660).
 - **FEAT**: Add focused style classes for spec utilities (#677)

#### `mix_annotations` - `v0.4.1`

 - **FEAT**: Add generated style-focused modifiers and specs (#652).

#### `mix_generator` - `v0.4.1`

 - **REFACTOR**: Rename WidgetModifiersData to WidgetModifiersConfig (#649).
 - **REFACTOR**: Fix deprecations and modernize codebase (#647).
 - **FIX**: update animated property handling to use null coalescing (#637).
 - **FEAT**: Add generated style-focused modifiers and specs (#652).
 - **FEAT**: unify SpecUtility, Style, and Attributes as compatible values (#643).
 - **FEAT**: builder optimization (#629).

#### `mix_lint` - `v0.1.4`

 - No changes in this release.

#### `naked` - `v0.0.1-dev.1`

 - **REFACTOR**: Select (#596).
 - **REFACTOR**: Tabs and Tooltip (#595).
 - **REFACTOR**: Naked Slider (#594).
 - **REFACTOR**: radio group (#593).
 - **REFACTOR**: naked menu (#592).
 - **REFACTOR**: accordion (#591).
 - **REFACTOR**: Refactor Checkbox (#590).
 - **FIX**: Change default autofocus to false in Menu and Select (#609).
 - **FEAT**: Add textStyle prop in NakedTextField  (#608).
 - **FEAT**: Implement Tooltip Lifecycle (#603).
 - **FEAT**: Add test for Hover to RadioButton (#601).
 - **FEAT**: Recreate Button using Naked (#587).
 - **FEAT**: "Naked" - A Behavior-First UI Component Library for Flutter (#579).
 - **DOCS**: organize folders and files.
 - **DOCS**: Improve accordion example.
 - **DOCS**: Remove old example app (#607).
 - **DOCS**: Document naked button (#599).


## 2025-03-31

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`mix` - `v1.6.0`](#mix---v160)
 - [`mix_annotations` - `v0.4.0`](#mix_annotations---v032)
 - [`mix_generator` - `v0.4.0`](#mix_generator---v033)
 - [`mix_lint` - `v0.1.3`](#mix_lint---v013)
 - [`remix` - `v0.0.4+1`](#remix---v0041)

Packages with dependency updates only:

> Packages listed below depend on other packages in this workspace that have had changes. Their versions have been incremented to bump the minimum dependency versions of the packages they depend upon in this project.

 - `remix` - `v0.0.4+1`

---

#### `mix` - `v1.6.0`

 - **REFACTOR**: Rename `MixableProperty` to `MixableType` (#574)
 - **REFACTOR**: mix generator clean up and mix semantic changes (#569)
 - **CHORE**: Update min version compatibility (#572)

#### `mix_annotations` - `v0.4.0`

 - **REFACTOR**: Rename `MixableProperty` to `MixableType` (#574).
 - **REFACTOR**: mix generator clean up and mix semantic changes (#569).

#### `mix_generator` - `v0.4.0`

 - **REFACTOR**: Rename `MixableProperty` to `MixableType` (#574)
 - **REFACTOR**: mix generator clean up and mix semantic changes (#569)
 - **CHORE**: Update min version compatibility (#572)

#### `mix_lint` - `v0.1.3`

 - **CHORE**: Update min version compatibility (#572)


## 2025-02-07

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`mix` - `v1.5.4`](#mix---v154)
 - [`remix` - `v0.0.4`](#remix---v004)

---

#### `mix` - `v1.5.4`

 - **FEAT**: Accordion interaction based on open variable (#546).

#### `remix` - `v0.0.4`

 - **FEAT**: Support header on scaffold (#554).
 - **FEAT**: Accordion interaction based on open variable (#546).


## 2024-12-06

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`mix` - `v1.5.3`](#mix---v153)
 - [`remix` - `v0.0.3`](#remix---v003)
 - [`mix_annotations` - `v0.3.1`](#mix_annotations---v031)
 - [`mix_generator` - `v0.3.2`](#mix_generator---v032)
 - [`mix_lint` - `v0.1.2`](#mix_lint---v012)

---

#### `mix` - `v1.5.3`

 - **REFACTOR**: Solve dcm lint issues (#519).
 - **FIX**: Order of modifiers implementation on Box, Image and Text (#529).
 - **FIX**: reset modifiers and directives when using fluentAPI (#482).
 - **FEAT**: Add spring curve (#503).
 - **FEAT**: Create StrokeAlignUtility (#496).
 - **FEAT**: Utilities for text height behavior (#495).
 - **FEAT**: Rewrite FlexBox as a Mix's primitive component (#517).
 - **FEAT**: Add `SpecConfiguration` (#483).
 - **DOCS**: Add section for `TokenResolver` (#537).

#### `remix` - `v0.0.3`

 - **REFACTOR**: Create a new Architecture for remix's components (#446).
 - **REFACTOR**(remix): improve widgetbook navigation (#524).
 - **REFACTOR**: Add in code documentation and rename params for each component (#514).
 - **REFACTOR**: Remix progress (#429).
 - **REFACTOR**: small fixes on remix (#512).
 - **REFACTOR**: Rewrite Fortaleza theme using the new code gen for tokens (#528).
 - **REFACTOR**: Remix was rewritten using Fluent API (#476).
 - **REFACTOR**: Rewrite all components in the new Archtecture (#467).
 - **FIX**: Textfield helper Text (#531).
 - **FIX**: Toast animation trigger (#530).
 - **FEAT**: Create Textfield (#511).
 - **FEAT**: Chip component (#504).
 - **FEAT**: implement toast component (#503).
 - **FEAT**: Card has child instead of children parameter (#499).
 - **FEAT**: Create dark base theme for Remix (#498).
 - **FEAT**: remix-styling-configuration (#483).
 - **FEAT**: Segmented control (#479).
 - **FEAT**: Accordion component (#433).
 - **FEAT**: Slider component (#509).
 - **FEAT**: Add more directives to Colors (#477).
 - **FEAT**: Menu Item Component (#508).
 - **FEAT**: Add group feature to Radio (#435).
 - **FEAT**: Create Select component (#448).
 - **FEAT**: Add parameter onEnd for AnimatedStyle (#458).
 - **FEAT**: button supports component builder (#444).
 - **FEAT**: Create a theme for Remix (#470).
 - **FEAT**: Refactor Remix components (#428).
 - **FEAT**: Remix improvements and further improvements (#410).
 - **FEAT**: Rewrite FlexBox as a Mix's primitive component (#517).

#### `mix_annotations` - `v0.3.1`

 - **FEAT**: Create code gen for design tokens (#521).

#### `mix_generator` - `v0.3.2`

 - **REFACTOR**: Rewrite Fortaleza theme using the new code gen for tokens (#528).
 - **FIX**: Shadow list animation (#445).
 - **FEAT**: Create code gen for design tokens (#521).
 - **FEAT**: Rewrite FlexBox as a Mix's primitive component (#517).
 - **FEAT**: Fluent API (#475).
 - **FEAT**: Remix improvements and further improvements (#410).

#### `mix_lint` - `v0.1.2`

 - **FEAT**: Rewrite FlexBox as a Mix's primitive component (#517).


## 2024-09-27

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`mix` - `v1.5.2`](#mix---v152)
 - [`remix` - `v0.0.2-alpha.3`](#remix---v002-alpha3)

Packages with dependency updates only:

> Packages listed below depend on other packages in this workspace that have had changes. Their versions have been incremented to bump the minimum dependency versions of the packages they depend upon in this project.

 - `remix` - `v0.0.2-alpha.3`

---

#### `mix` - `v1.5.2`

 - **REFACTOR**: ShapeBorder merge (#490).
 - **FEAT**: Improve error messages (#491).
 - **FEAT**: add error state to MixWidgetState (#489).


## 2024-09-25

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`mix` - `v1.5.1`](#mix---v151)
 - [`remix` - `v0.0.2-alpha.2`](#remix---v002-alpha2)

Packages with dependency updates only:

> Packages listed below depend on other packages in this workspace that have had changes. Their versions have been incremented to bump the minimum dependency versions of the packages they depend upon in this project.

 - `remix` - `v0.0.2-alpha.2`

---

#### `mix` - `v1.5.1`

 - **FEAT**: Add MixOutlinedBorder (#487).


## 2024-09-16

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`remix` - `v0.0.2-alpha.1`](#remix---v002-alpha1)

---

#### `remix` - `v0.0.2-alpha.1`

 - **REFACTOR**: Remix was rewritten using Fluent API (#476).
 - **REFACTOR**: Rewrite all components in the new Archtecture (#467).
 - **REFACTOR**: Create a new Architecture for remix's components (#446).
 - **REFACTOR**: Remix progress (#429).
 - **FEAT**: remix-styling-configuration (#483).
 - **FEAT**: Segmented control (#479).
 - **FEAT**: Accordion component (#433).
 - **FEAT**: Add more directives to Colors (#477).
 - **FEAT**: Create a theme for Remix (#470).
 - **FEAT**: Add group feature to Radio (#435).
 - **FEAT**: Create Select component (#448).
 - **FEAT**: Add parameter onEnd for AnimatedStyle (#458).
 - **FEAT**: button supports component builder (#444).
 - **FEAT**: Refactor Remix components (#428).
 - **FEAT**: Remix improvements and further improvements (#410).
 - **FEAT**: Ability to pass MixWidgetStateController to SpecBuilder (#391).
 - **FEAT**: remix - Foundational components (#317).


## 2024-09-16

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`remix` - `v0.0.2-alpha.1`](#remix---v002-alpha1)

---

#### `remix` - `v0.0.2-alpha.1`

 - Increasing the version


## 2024-09-16

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`mix` - `v1.5.0`](#mix---v150)
 - [`remix` - `v0.0.1-alpha.1`](#remix---v001-alpha1)
 - [`mix_generator` - `v0.3.1`](#mix_generator---v031)

---

#### `mix` - `v1.5.0`

 - **FIX**: Update OnBrightnessVariant to use `MediaQuery` instead of `Theme` (#471).
 - **FIX**: Style when merged with an AnimatedStyle should generate an AnimatedStyle (#472).
 - **FEAT**: Create a specific utility to Transform.translate (#484).
 - **FEAT**: Add more directives to Colors (#477).
 - **FEAT**: implement a way to clear inline modifiers (#478).
 - **FEAT**: Fluent API (#475).

#### `remix` - `v0.0.1-alpha.1`

 - **REFACTOR**: Remix was rewritten using Fluent API (#476).
 - **REFACTOR**: Rewrite all components in the new Archtecture (#467).
 - **REFACTOR**: Create a new Architecture for remix's components (#446).
 - **REFACTOR**: Remix progress (#429).
 - **FEAT**: Segmented control (#479).
 - **FEAT**: Accordion component (#433).
 - **FEAT**: Add more directives to Colors (#477).
 - **FEAT**: Create a theme for Remix (#470).
 - **FEAT**: Add group feature to Radio (#435).
 - **FEAT**: Create Select component (#448).
 - **FEAT**: Add parameter onEnd for AnimatedStyle (#458).
 - **FEAT**: button supports component builder (#444).
 - **FEAT**: Refactor Remix components (#428).
 - **FEAT**: Remix improvements and further improvements (#410).

#### `mix_generator` - `v0.3.1`

 - **FEAT**: Fluent API (#475).


## 2024-08-22

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`mix` - `v1.4.6`](#mix---v146)
 - [`mix_annotations` - `v0.3.0`](#mix_annotations---v030)
 - [`mix_generator` - `v0.3.0`](#mix_generator---v030)
 - [`remix` - `v0.0.2+6`](#remix---v0026)

Packages with dependency updates only:

> Packages listed below depend on other packages in this workspace that have had changes. Their versions have been incremented to bump the minimum dependency versions of the packages they depend upon in this project.

 - `remix` - `v0.0.2+6`

---

#### `mix` - `v1.4.6`

 - **FIX**(docs): fix fn level docs for Style::applyVariants (#460).
 - **FIX**: Shadow list animation (#445).
 - **FIX**: SpecModifiers were taking a long time to animate. (#457).
 - **FEAT**: Create mouse cursor Decorator (#263).
 - **FEAT**: Add parameter onEnd for AnimatedStyle (#458).
 - **FEAT**: `SingleChildScrollView` widget modifier (#427).
 - **FEAT**: Remix improvements and further improvements (#410).

#### `mix_annotations` - `v0.3.0`

 - **FIX**: SpecModifiers were taking a long time to animate. (#457).

#### `mix_generator` - `v0.3.0`

 - **FIX**: SpecModifiers were taking a long time to animate. (#457).
 - **FIX**: Shadow list animation (#445).


## 2024-08-08

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`mix` - `v1.4.5`](#mix---v145)
 - [`remix` - `v0.0.2+5`](#remix---v0025)

Packages with dependency updates only:

> Packages listed below depend on other packages in this workspace that have had changes. Their versions have been incremented to bump the minimum dependency versions of the packages they depend upon in this project.

 - `remix` - `v0.0.2+5`

---

#### `mix` - `v1.4.5`

 - **FIX**: HitTestBehavior when there is an Interectable in the tree (#437).
 - **FEAT**: Create a specific utility to Transform.rotate (#434).
 - **FEAT**: TargetPlatform and web variants (#431).

## 2024-08-02

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`mix` - `v1.4.4`](#mix---v144)
 - [`remix` - `v0.0.2+4`](#remix---v0024)

Packages with dependency updates only:

> Packages listed below depend on other packages in this workspace that have had changes. Their versions have been incremented to bump the minimum dependency versions of the packages they depend upon in this project.

 - `remix` - `v0.0.2+4`

---

#### `mix` - `v1.4.4`

 - **FIX**: Pressable disposes controller only if it creates it (#424).

## 2024-08-01

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`mix` - `v1.4.3`](#mix---v143)
 - [`remix` - `v0.0.2+3`](#remix---v0023)

Packages with dependency updates only:

> Packages listed below depend on other packages in this workspace that have had changes. Their versions have been incremented to bump the minimum dependency versions of the packages they depend upon in this project.

 - `remix` - `v0.0.2+3`

---

#### `mix` - `v1.4.3`

 - **FIX**: Breakpoint utility merge exception (#421).


## 2024-07-31

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`mix` - `v1.4.2`](#mix---v142)
 - [`remix` - `v0.0.2+2`](#remix---v0022)

Packages with dependency updates only:

> Packages listed below depend on other packages in this workspace that have had changes. Their versions have been incremented to bump the minimum dependency versions of the packages they depend upon in this project.

 - `remix` - `v0.0.2+2`

---

#### `mix` - `v1.4.2`

 - **FIX**: FlexSpecWidget prioritizes the direction in spec (#414).

## 2024-07-30

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`mix` - `v1.4.1`](#mix---v141)
 - [`mix_generator` - `v0.2.2+1`](#mix_generator---v0221)
 - [`remix` - `v0.0.2+1`](#remix---v0021)

---

#### `mix` - `v1.4.1`

 - **FIX**: Added missing widget state utilities (#411).
 - **FIX**: Correct handling of individual border sides (#408).
 - **DOCS**: improve mix theme data features explanations (#404).

#### `mix_generator` - `v0.2.2+1`

 - **DOCS**: improve mix theme data features explanations (#404).

#### `remix` - `v0.0.2+1`

 - **DOCS**: improve mix theme data features explanations (#404).


## 2024-07-25

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`mix` - `v1.4.0`](#mix---v140)
 - [`mix_annotations` - `v0.2.1`](#mix_annotations---v021)
 - [`mix_generator` - `v0.2.2`](#mix_generator---v022)
 - [`mix_lint` - `v0.1.1`](#mix_lint---v011)
 - [`remix` - `v0.0.2`](#remix---v002)

---

#### `mix` - `v1.4.0`

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

#### `mix_annotations` - `v0.2.1`

 - **FEAT**: MixableSpec now supports `withCopyWith`, `withEquality`, `withLerp`, and `skipUtility` (#396).

#### `mix_generator` - `v0.2.2`

 - **FEAT**: Code generation for Widget Modifiers (#396).
 - **FEAT**: Dto utility generation now adds constructor and static methods (#377).
 - **FEAT**: ColorSwatchToken and other token improvements (#378).
 - **REFACTOR**: Code gen more lint friendly dart code (#399) and (#395).
 - **FIX**: Nullable merge expressions and updates debug properties (#392).

#### `mix_lint` - `v0.1.1`

 - **FEAT**: Improvements for the "extract attributes" assist (#387).
 - **FEAT**: implement quick fix for mix_attributes_ordering rule (#381).
 - **FEAT**: ColorSwatchToken and other token improvements (#378).

#### `remix` - `v0.0.2`

 - **FEAT**: Ability to pass MixWidgetStateController to SpecBuilder (#391).
 - **FEAT**: Foundational components (#317).


## 2024-07-12

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`mix` - `v1.3.0`](#mix---v130)
 - [`mix_annotations` - `v0.2.0+1`](#mix_annotations---v0201)
 - [`mix_generator` - `v0.2.1`](#mix_generator---v021)
 - [`mix_lint` - `v0.1.0+1`](#mix_lint---v0101)

---

#### `mix` - `v1.3.0`

 - **REFACTOR**: use timer instead of future<void> (#374).
 - **REFACTOR**: bump flutter version to 3.19.0 (#365).
 - **FEAT**: modifiers in spec (#333).
 - **FEAT**: add attribute to fontVariantion (#371).

#### `mix_annotations` - `v0.2.0+1`

 - **REFACTOR**: bump flutter version to 3.19.0 (#365).

#### `mix_generator` - `v0.2.1`

 - **REFACTOR**: bump flutter version to 3.19.0 (#365).
 - **FEAT**: modifiers in spec (#333).

#### `mix_lint` - `v0.1.0+1`

 - **REFACTOR**: bump flutter version to 3.19.0 (#365).


## 2024-07-03

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`mix` - `v1.2.0`](#mix---v120)

---

#### `mix` - `v1.2.0`

 - **FIX**: Exception when there is no children on flex (#345).
 - **FIX**: Added remaining params to callable specs and modifiers (#332).
 - **FIX**: Gap resolve SpaceToken in flex attribute (#327).
 - **FIX**: mix - Improved merge behavior between ShapeDecoration and BoxDecoration (#316).
 - **FEAT**: pressable supports keyboard events (#346).

