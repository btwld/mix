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
                    ..color.red()
                    ..width(100)
                    ..height(100)
                    ..borderRadius.circular(8),
              ),

              const SizedBox(height: 16),

              Box(
                style: $box
                    ..color.blue()
                    ..width(150)
                    ..height(80)
                    ..padding.all(16)
                    ..borderRadius.circular(12),
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
                    ..color.orange()
                    ..padding.all(12)
                    ..borderRadius.circular(16)
                    ..border.all.width(2).color.black(),
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
                    ..color.purple()
                    ..width(120)
                    ..height(120)
                    ..borderRadius.circular(20)
                    ..padding.all(8),
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
                'Cascade: \$box..border.all.width(2)',
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