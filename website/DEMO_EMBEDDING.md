# Embedding Flutter Demos in Documentation

This guide explains how to embed interactive Flutter demos in the Mix documentation website.

## Important: Build Before Testing

The Flutter demos are **not committed to git** (they're gitignored). You must build them before testing locally:

```bash
# From project root
bash examples/scripts/build_web_demos.sh

# Or manually:
cd examples
flutter build web --release
cp -r build/web/* ../website/public/demos/
```

This builds the Flutter examples and copies them to `website/public/demos/`.

## Available Components

Three React components are available for use in MDX files:

| Component | Best For | Features |
|-----------|----------|----------|
| `<Demo>` | Most use cases | Unified wrapper, auto-selects approach |
| `<DartPadEmbed>` | Quick examples | Editable code, hosted on DartPad |
| `<FlutterEmbed>` | Complex demos | Full Flutter, animations, shaders |

## Quick Start

### Using DartPad (Recommended for tutorials)

Create a GitHub Gist with your Dart code, then embed it:

```mdx
<Demo
  title="Simple Box Example"
  gistId="your-gist-id-here"
  description="A basic box with color and rounded corners"
/>
```

Or embed inline code directly:

```mdx
<DartPadEmbed
  code={`
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

void main() => runApp(MaterialApp(home: Example()));

class Example extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final style = BoxStyler()
        .color(Colors.purple)
        .size(100, 100)
        .borderRounded(12);

    return Center(child: Box(style: style));
  }
}
  `}
  theme="dark"
  height={400}
/>
```

### Using Flutter Element Embedding (For complex demos)

For demos requiring full Flutter fidelity (animations, shaders, complex interactions):

```mdx
<FlutterEmbed
  src="/demos/animation-showcase"
  title="Animation Demo"
  height={500}
/>
```

Or use iframe mode for external hosted demos:

```mdx
<FlutterEmbed
  src="https://mix-demos.web.app/hover-example"
  useIframe
  height={400}
/>
```

## Component Reference

### `<Demo>` - Unified Wrapper

The recommended component for most use cases. Automatically chooses between DartPad and Flutter embedding.

```tsx
<Demo
  // Display
  title="Demo Title"
  description="What this demo shows"
  height={450}

  // DartPad mode (use ONE of these)
  gistId="abc123"        // GitHub Gist ID
  code={`...`}           // Inline Dart code

  // Flutter Embed mode
  flutterSrc="/demos/x"  // Path to Flutter web build

  // Options
  theme="dark"           // "dark" (editable) or "light" (read-only)
  showTabs={true}        // Show preview/code/both tabs
  defaultMode="preview"  // Initial view mode
/>
```

### `<DartPadEmbed>` - Interactive Code Editor

Embeds DartPad for editable, runnable code examples.

```tsx
<DartPadEmbed
  // Content (use ONE)
  gistId="abc123"        // GitHub Gist ID
  code={`...`}           // Inline code

  // Display
  theme="dark"           // "dark" or "light"
  height={500}           // Height in pixels
  title="Example"        // Title above embed

  // Behavior
  flutter={true}         // Flutter mode (vs pure Dart)
  run={true}             // Auto-run on load
  split={50}             // Code/output split (0-100)
/>
```

**Best Practices for DartPad:**
- Use **dark theme** for exercises (user should modify code)
- Use **light theme** for demos (read-only examples)
- Keep examples focused and minimal
- Include necessary imports in the code

### `<FlutterEmbed>` - Full Flutter Web

Embeds a compiled Flutter web application for full-fidelity demos.

```tsx
<FlutterEmbed
  src="/demos/my-demo"   // Path to Flutter web build
  height={400}           // Height in pixels
  width="100%"           // Width (number or string)
  title="Demo Name"      // Display title
  bordered={true}        // Show border
  background="#1a1a2e"   // Background color
  useIframe={false}      // Use iframe instead of element embedding
/>
```

## Building Flutter Web Demos

### Setup

1. Navigate to the examples directory:
   ```bash
   cd examples
   ```

2. Build for web:
   ```bash
   flutter build web --release --web-renderer canvaskit
   ```

3. The output will be in `examples/build/web/`

### Deployment Options

**Option A: Same domain (recommended)**
- Copy build output to `website/public/demos/`
- Reference with `src="/demos/"`

**Option B: CDN/External hosting**
- Deploy to Firebase Hosting, Vercel, or CDN
- Reference with full URL

**Option C: GitHub Pages**
- Deploy to `gh-pages` branch of a demo repo
- Reference with GitHub Pages URL

## Creating DartPad Gists

1. Go to [gist.github.com](https://gist.github.com)
2. Create a new gist with filename `main.dart`
3. Paste your Flutter code
4. Save and copy the Gist ID from the URL

**Important:** DartPad uses published Mix package versions, not local development. Ensure your code is compatible with the latest published Mix version.

## Examples in Documentation

### Widget Documentation Page

```mdx
# Box Widget

The Box widget provides container styling...

## Basic Example

<Demo
  title="Simple Box"
  gistId="abc123def456"
  description="A box with color, size, and rounded corners"
/>

## Hover Effect

<Demo
  title="Interactive Box"
  flutterSrc="/demos/box-hover"
  description="Hover to see the color change"
  height={300}
/>
```

### Tutorial Page

```mdx
# Getting Started with Mix

## Step 1: Create a styled box

Try editing the code below:

<DartPadEmbed
  code={`
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

void main() => runApp(MaterialApp(home: Center(
  child: Box(
    style: BoxStyler()
        .color(Colors.blue)  // Try changing this color!
        .size(100, 100)
        .borderRounded(8),
  ),
)));
  `}
  theme="dark"
  title="Exercise: Change the color"
/>
```

## Troubleshooting

### DartPad shows old Mix version
DartPad uses pub.dev versions. Wait for new releases to propagate or use Flutter Element Embedding for latest features.

### Flutter embed not loading
1. Check browser console for errors
2. Verify the `src` path is correct
3. Ensure CORS headers are set if hosting externally
4. Try `useIframe={true}` as fallback

### Multi-View "Failed to load view" errors
1. Verify demos were built: `cd examples && bash scripts/build_web_demos.sh`
2. Check flutter_bootstrap.js was patched (should contain "Auto-load disabled")
3. Ensure only FlutterMultiView OR FlutterEmbed used on page (not both)

### Multi-View demos not appearing
1. Check browser console for Flutter engine errors
2. Verify demoId exists in demo_registry.dart
3. Check the container has non-zero height

### Code not syncing to DartPad
The inline code feature uses postMessage. If it's not working:
1. Check browser security settings
2. Try using a Gist ID instead
3. Ensure code doesn't have syntax errors

## Performance Considerations

### DartPad
- Lightweight, good for multiple embeds per page

### Multi-View Mode
- Recommended: Up to 10 concurrent FlutterMultiView instances per page
- Memory: Single engine (~15MB) shared across all views
- Lazy loading: Views only initialize when scrolled into viewport

### Iframe Mode
- Recommended: Up to 3-4 concurrent FlutterEmbed instances per page
- Memory: Each iframe loads a separate engine (~15MB each)
- Isolation: Complete WebGL isolation, no resource conflicts

### When to Use Each
| Scenario | Recommended Mode |
|----------|------------------|
| Many small demos (5+) | Multi-View |
| Few large demos (1-3) | Iframe |
| Mixed content page | Iframe only |
| Interactive demos needing isolation | Iframe |
