# Creating a Custom Context Variant

Mix allows developers to create custom `ContextVariants` to apply styles conditionally based on specific conditions. The provided example demonstrates how to create a `ContextVariant` for web detection using the `kIsWeb` constant.

## Creating a Web-Specific ContextVariant

Here's an example of creating the `OnWebVariant` class:

```dart
class OnWebVariant extends ContextVariant {
  const OnWebVariant();

  @override
  bool when(BuildContext context) => kIsWeb;
}
```

The `OnWebVariant` class extends `ContextVariant` and applies the variant when the application is running on the web platform. The `when` method uses the `kIsWeb` constant to determine if the current platform is web.

## Extending the OnContextVariantUtility

You can extend the `OnContextVariantUtility` using an extension:

```dart
extension OnContextVariantUtilityX on OnContextVariantUtility {
  OnWebVariant get web => OnWebVariant();
}
```

This extension adds a convenience getter to the `OnContextVariantUtility` class. The `web` getter returns an instance of the `OnWebVariant`.

## Using the Custom Web ContextVariant

Here's how you can use the custom web ContextVariant in a Mix style:

```dart
final style = Style(
  $box.color.black(),
  $text.style.color.white(),
  $on.web(
    $box.color.blue(),
    $text.style.color.white(),
  ),
);
```

The `$on.web` variant is used to conditionally apply styles when the application is running on the web platform. The web-specific styles will only be applied when the `kIsWeb` constant is true.

## Using BuildContext for Custom Conditions

In addition to using platform-specific constants like `kIsWeb`, you can also leverage the `BuildContext` passed during the build of the style to check for custom conditions. This allows you to create more flexible and dynamic `ContextVariants` based on the state of your application.

For example, you can create a `ContextVariant` that checks for a specific condition in the `BuildContext`:

```dart
class CustomConditionVariant extends ContextVariant {
  const CustomConditionVariant();

  @override
  bool when(BuildContext context) {
    // Check for a custom condition using the BuildContext
    // MediaQuery.of, Theme.of, and other context-based methods can be used here
    return context.findAncestorWidgetOfExactType<MyInheritedWidget>();
  }
}
```

By utilizing the `BuildContext`, you can create more sophisticated and context-aware `ContextVariants` that adapt to the state and structure of your application.
