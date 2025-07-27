import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

void main() {
  runApp(const BoxExampleApp());
}

class BoxExampleApp extends StatelessWidget {
  const BoxExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Mix Box Examples'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Box Styling Examples',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Using new \$box cascade API',
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 16),

              // Cascade notation API
              Box(
                style: $box
                    ..red()
                    ..width(100)
                    ..height(100)
                    ..borderRadiusCircular(8),
              ),

              const SizedBox(height: 16),

              Box(
                style: $box
                    ..blue()
                    ..width(150)
                    ..height(80)
                    ..paddingAll(16)
                    ..borderRadiusCircular(12),
                child: const Text(
                  'Cascade API',
                  style: TextStyle(color: Colors.white),
                ),
              ),

              const SizedBox(height: 16),

              // Cascade border access
              Box(
                style: $box
                    ..width(200)
                    ..height(80)
                    ..orange()
                    ..paddingAll(12)
                    ..borderRadiusCircular(16)
                    ..borderAll(2, color: Colors.black),
                child: const Center(
                  child: Text(
                    'Cascade Border',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Cascade chaining
              Box(
                style: $box
                    ..purple()
                    ..width(120)
                    ..height(120)
                    ..borderRadiusCircular(20)
                    ..paddingAll(8),
                child: const Center(
                  child: Text('Cascade', style: TextStyle(color: Colors.white)),
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Comparison: Old vs New API',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Old: \$box.decoration.box.border.all.width(2)',
                style: TextStyle(fontSize: 12, fontFamily: 'monospace'),
              ),
              const Text(
                'Cascade: \$box..borderAll(2)',
                style: TextStyle(fontSize: 12, fontFamily: 'monospace', color: Colors.green),
              ),
              const SizedBox(height: 16),

              // Gradient example with flattened access
              Box(
                style: $box
                    .width(180)
                    .height(100)
                    .color.purple()
                    .borderRadius.circular(15),
                child: const Center(
                  child: Text(
                    'Purple Box',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      title: 'Mix Box Examples',
    );
  }
}