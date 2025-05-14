import 'package:flutter/material.dart';

/// A basic avatar component with no default styling.
///
/// NakedAvatar provides a simple container for avatar content without any
/// built-in interactions or state management. It allows you to fully customize
/// the avatar's appearance through the imageWidgetBuilder.
///
/// The widget accepts an optional [image] provider and requires an [imageWidgetBuilder]
/// that determines how the avatar should be rendered. The builder receives both the
/// build context and an optional child widget containing the loaded image.
///
/// Example:
/// ```dart
// NakedAvatar(
//   image: NetworkImage(imageUrl),
//   imageWidgetBuilder: (context, image) => Container(
//     height: 80,
//     width: 80,
//     clipBehavior: Clip.hardEdge,
//     decoration: BoxDecoration(
//       color: Colors.grey.shade300,
//       shape: BoxShape.circle,
//     ),
//     child: Stack(
//       alignment: Alignment.center,
//       children: [
//         Text(
//           'AB',
//           style: TextStyle(
//             fontSize: 26,
//             fontWeight: FontWeight.bold,
//             color: Colors.grey.shade700,
//           ),
//         ),
//         image!,
//       ],
//     ),
//   ),
// ),
/// ```
///
/// If no image is provided, the imageWidgetBuilder will receive null as the child,
/// allowing you to show a fallback or placeholder.

typedef ImageWidgetBuilder = Widget Function(
    BuildContext context, Widget? child);

class NakedAvatar extends StatelessWidget {
  /// The image provider for the avatar image.
  final ImageProvider? image;

  /// Builder that determines how the avatar should be rendered.
  /// Receives the build context and an optional child widget containing the loaded image.
  /// When no image is provided or while the image is loading, child will be null.
  final ImageWidgetBuilder imageWidgetBuilder;

  /// Optional callback when the image fails to load.
  final ImageErrorListener? onError;

  /// Optional semantic label for the avatar.
  final String? semanticLabel;

  const NakedAvatar({
    super.key,
    this.image,
    required this.imageWidgetBuilder,
    this.onError,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    final child = image != null
        ? Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: image!,
                onError: onError,
                fit: BoxFit.cover,
              ),
            ),
          )
        : null;

    return imageWidgetBuilder(
      context,
      child,
    );
  }
}
