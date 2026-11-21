import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

void main() => runApp(
  const MaterialApp(
    home: Scaffold(body: Center(child: ImageExample())),
  ),
);

/// A hosted image keeps the copied example runnable without project assets.
class ImageExample extends StatelessWidget {
  const ImageExample({super.key});

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(12),
    child: StyledImage(
      image: const NetworkImage(
        'https://images.unsplash.com/photo-1501785888041-af3ef285b470?w=640&q=80',
      ),
      style: ImageStyler()
          .width(320)
          .height(190)
          .fit(.cover)
          .semanticLabel('Mountain lake landscape'),
    ),
  );
}
