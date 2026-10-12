import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import 'gallery.dart';
import 'theme.dart';

class SnacksGalleryApp extends StatelessWidget {
  const SnacksGalleryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mix Snacks',
      theme: snacksMaterialTheme(),
      builder: (context, child) {
        return MixScope(
          colors: snacksColors(),
          radii: snacksRadii(),
          child: child!,
        );
      },
      home: Scaffold(
        backgroundColor: const Color(0xFF07070B),
        appBar: AppBar(
          title: const Text('Mix Snacks'),
          backgroundColor: const Color(0xFF07070B),
        ),
        body: const SnacksGalleryScreen(),
      ),
    );
  }
}
