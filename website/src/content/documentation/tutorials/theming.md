# Theming

## Introduction

Mix offers a robust theming system that enables you to style your application consistently and efficiently, providing both scalability and flexibility. The theming system is built on the concept of design tokens, which are key-value pairs defining visual properties such as colors, text styles, and more. These tokens can be uniformly applied across all your widgets, ensuring a consistent aesthetic throughout your application. Consequently, you can easily alter the appearance of your application by updating the design tokens, eliminating the need to modify each individual widget.

## Getting Started

In this guide, we will create a single-screen, multi-theme application to demonstrate the power of Mix's theming system. The final result will look like this:

![images](./images/two-themed-app.png)

As depicted in the image above, we have two different themes for the same screen, each using distinct colors, text styles, fonts, and border radii. The left one employs a light theme with blue as the primary color, hence it will be referred to as `lightBlueTheme`. The right one utilizes a dark theme with purple as the primary color, and will therefore be named `darkPurpleTheme`.

## Setting Up MixTheme

Before we start styling our application with these themes, the initial step is to configure the `MixTheme`. `MixTheme` acts as an ancestor widget that passes down the defined tokens to all its child widgets, ensuring they can access and utilize the same styling information. Properly setting up MixTheme is crucial to harnessing the full potential of the Mix package for your application's theming needs.

Here's how you can initialize and implement `MixTheme`:

### Wrapping the Root Widget

To apply your theme globally, you'll want to wrap your application's root widget with the `MixTheme` widget.

```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MixTheme(
      data: lightBlueTheme, // <- MixThemeData (In this guide we are using the lightBlueTheme or darkPurpleTheme)
      child: const MaterialApp(
        home: ProfilePage(),
      ),
    );
  }
}
```

### Creating Design Tokens

The next crucial step is creating a `MixThemeData` instance. But before we do that, you need to understand how to create your own design tokens. In Mix, there are five types of design tokens: `ColorToken`, `TextStyleToken`, `SpaceToken`, `RadiusToken`, and `BreakpointToken`. Each of these tokens represents a different type of design property, such as colors, text styles, spacing, border radii, and breakpoints. Defining these is quite simple; you just need to instantiate the token with a unique name.

```dart
const primary = ColorToken('primary');
```

To create any other token, you can use the same pattern, just use the class that best represents the token you want to create. Following we create an example of how you can declare it.

```dart
const $token = MyThemeToken();

class MyThemeToken {
  const MyThemeToken();

  final color = const MyThemeColorToken();
  final textStyle = const MyThemeTextStyleToken();
}

class MyThemeColorToken {
  const MyThemeColorToken();

  ColorToken get primary => const ColorToken('primary-color');
  ColorToken get onPrimary => const ColorToken('on-primary-color');
  ColorToken get surface => const ColorToken('surface-color');
  ColorToken get onSurface => const ColorToken('on-surface-color');
  ColorToken get onSurfaceVariant =>
      const ColorToken('on-surface-variant-color');
}

class MyThemeTextStyleToken {
  const MyThemeTextStyleToken();

  TextStyleToken get headline1 => const TextStyleToken('headline1');
  TextStyleToken get headline2 => const TextStyleToken('headline2');
  TextStyleToken get headline3 => const TextStyleToken('headline3');
  TextStyleToken get body => const TextStyleToken('body');
  TextStyleToken get callout => const TextStyleToken('callout');
}
```

After that, you simply need to use the property `$token.{tokenCategory}` to access the design tokens.

```dart
final primaryColorToken = $token.color.primary;
final headline1TextStyleToken = $token.textStyle.headline1;
```

### Creating MixThemeData

This object defines the values for the design tokens that will be used throughout your application. As mentioned before, the `themeData` is a set of key-value pairs where the key is the design token and the value is the actual value of the token. To define a `MixThemeData` instance, you can use the following code:

```dart
final lightBlueTheme = MixThemeData(
  colors: {
    $token.color.primary: const Color(0xFF0093B9),
    $token.color.onPrimary: const Color(0xFFFAFAFA),
    $token.color.surface: const Color(0xFFFAFAFA),
    $token.color.onSurface: const Color(0xFF141C24),
    $token.color.onSurfaceVariant: const Color(0xFF405473),
  },
  textStyles: {
    $token.textStyle.headline1: GoogleFonts.plusJakartaSans(
      fontSize: 22,
      fontWeight: FontWeight.bold,
    ),
    $token.textStyle.headline2: GoogleFonts.plusJakartaSans(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
    $token.textStyle.headline3: GoogleFonts.plusJakartaSans(
      fontSize: 14,
      fontWeight: FontWeight.bold,
    ),
    $token.textStyle.body: GoogleFonts.plusJakartaSans(
      fontSize: 16,
      fontWeight: FontWeight.normal,
    ),
    $token.textStyle.callout: GoogleFonts.plusJakartaSans(
      fontSize: 14,
      fontWeight: FontWeight.normal,
    ),
  },
  radii: {
    $token.radius.large: const Radius.circular(100),
    $token.radius.medium: const Radius.circular(12),
  },
  spaces: {
    $token.space.medium: 16,
    $token.space.large: 24,
  },
);
```

You could do the same for the `darkPurpleTheme`:

```dart
final darkPurpleTheme = MixThemeData(
  colors: {
    $token.color.primary: const Color(0xFF617AFA),
    $token.color.onPrimary: const Color(0xFFFAFAFA),
    $token.color.surface: const Color(0xFF1C1C21),
    $token.color.onSurface: const Color(0xFFFAFAFA),
    $token.color.onSurfaceVariant: const Color(0xFFD6D6DE),
  },
  textStyles: {
    $token.textStyle.headline1: GoogleFonts.spaceGrotesk(
      fontSize: 22,
      fontWeight: FontWeight.bold,
    ),
    $token.textStyle.headline2: GoogleFonts.spaceGrotesk(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
    $token.textStyle.headline3: GoogleFonts.spaceGrotesk(
      fontSize: 14,
      fontWeight: FontWeight.bold,
    ),
    $token.textStyle.body: GoogleFonts.spaceGrotesk(
      fontSize: 16,
      fontWeight: FontWeight.normal,
    ),
    $token.textStyle.callout: GoogleFonts.spaceGrotesk(
      fontSize: 14,
      fontWeight: FontWeight.normal,
    ),
  },
  radii: {
    $token.radius.large: const Radius.circular(12),
    $token.radius.medium: const Radius.circular(8),
  },
  spaces: {
    $token.space.medium: 16,
    $token.space.large: 24,
  },
);
```

## Creating the UI

Now that we have defined our themes, we can start creating the UI for our application. We will create a simple profile page with an image and some text, and then apply the themes to the UI.

### Creating the Components

The interface chosen for this guide is quite simple. The only custom component is a button, so let's create that first.

```dart
class ProfileButton extends StatelessWidget {
  const ProfileButton({
    super.key,
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Box(
      style: Style(
        $box.height(50),
        $box.width(double.infinity),
        $box.color.ref($token.color.primary),
        $box.alignment.center(),
        $box.borderRadius.all.ref($token.radius.large),
        $text.style.ref($token.textStyle.headline3),
        $text.style.color.ref($token.color.onPrimary),
      ),
      child: StyledText(
        label,
      ),
    );
  }
}
```

The code above illustrates a simple button created with Mix primitive widgets and previously defined tokens for styling. If you are already familiar with building components using Mix, there is only one thing you need to pay attention to: the attributes ending with the `ref` method, which are used to access the token values.

### Creating the ProfilePage

Now that we have built the `ProfileButton`, we can create the `ProfilePage` widget.

```dart
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: $token.color.surface.resolve(context),
        title: Text(
          'Profile',
          style: $token.textStyle.headline2.resolve(context).copyWith(
                color: $token.color.onSurface.resolve(context),
              ),
        ),
      ),
      backgroundColor: $token.color.surface.resolve(context),
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(
                $token.radius.medium.resolve(context),
              ),
              child: Image.network(
                'https://placehold.co/358x292@2x.png',
              ),
            ),
            SizedBox(height: $token.space.large.resolve(context)),
            Text(
              'Hollywood Academy',
              style: $token.textStyle.headline1.resolve(context).copyWith(
                    color: $token.color.onSurface.resolve(context),
                  ),
            ),
            SizedBox(height: $token.space.medium.resolve(context)),
            Text(
              'Education · Los Angeles, California',
              style: $token.textStyle.callout.resolve(context).copyWith(
                    color: $token.color.onSurfaceVariant.resolve(context),
                  ),
            ),
            SizedBox(height: $token.space.medium.resolve(context)),
            Text(
              'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry`s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.',
              style: $token.textStyle.body.resolve(context).copyWith(
                    color: $token.color.onSurfaceVariant.resolve(context),
                  ),
            ),
            const Spacer(),
            const ProfileButton(
              label: 'Add to your contacts',
            ),
          ],
        ),
      ),
    );
  }
}
```

The `ProfilePage` is not part of the design system, which is why I'm not using the Mix primitive widgets to build it. This will likely be the case for you as well. Mix is an excellent tool for styling your components, making them more flexible, scalable, and maintainable, but our goal is not to replace Flutter widgets. It's important to mention this because it creates a scenario where we need to use design tokens and transform them into values that can be used by Flutter widgets. That's why we are using the `resolve` method.

Now that everything is set up, we can use the `ProfilePage` in our `MyApp` widget and see the result.

![images](./images/light-themed-app.png)

## One more thing... Material Design Tokens in Mix

You can also use Material Design Tokens in Mix. They are already implemented and you can use them in your application. However, be aware that they only cover ColorScheme and TextTheme tokens.

To use the Material Design Tokens in Mix, you need to implement the following `MixThemeData`:

#### Configure Material tokens

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mix App',
      home: MixTheme(
        data: MixThemeData.withMaterial(),
        child: ProfilePage(),
      ),
    );
  }
}
```

#### Using Material tokens

Mix provides an easy utility that you can use called `$md`, this is a namespace for all the Material Design tokens.

```dart
Box(
  style: Style(
    $text.style.ref($material.textTheme.headline1),
    $box.color.ref($material.colorScheme.primary),
  ),
  child: Text('Hello World'),
);
```
