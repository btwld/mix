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
                'Using new BoxMix() fluent API',
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 16),

              // Simple colored box
              Box(
                style: BoxMix()
                    .color(Colors.red)
                    .width(100)
                    .height(100)
                    .roundedAll(8),
              ),

              const SizedBox(height: 16),

              // Box with padding and text
              Box(
                style: BoxMix()
                    .color(Colors.blue)
                    .width(150)
                    .height(80)
                    .paddingAll(16)
                    .roundedAll(12),
                child: const Text(
                  'Fluent API',
                  style: TextStyle(color: Colors.white),
                ),
              ),

              const SizedBox(height: 16),

              // Box with border
              Box(
                style: BoxMix()
                    .width(200)
                    .height(80)
                    .color(Colors.orange)
                    .paddingAll(12)
                    .roundedAll(16)
                    .border(BoxBorderMix.all(
                      BorderSideMix.only(width: 2, color: Colors.black),
                    )),
                child: const Center(
                  child: Text(
                    'Box with Border',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Purple rounded box
              Box(
                style: BoxMix()
                    .color(Colors.purple)
                    .width(120)
                    .height(120)
                    .roundedAll(20)
                    .paddingAll(8),
                child: const Center(
                  child: Text('Purple Box', style: TextStyle(color: Colors.white)),
                ),
              ),

              const SizedBox(height: 16),

              // Box with gradient
              Box(
                style: BoxMix()
                    .width(180)
                    .height(100)
                    .linearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.purple, Colors.blue],
                    )
                    .roundedAll(15)
                    .paddingAll(16),
                child: const Center(
                  child: Text(
                    'Gradient Box',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Box with different corner radii
              Box(
                style: BoxMix()
                    .color(Colors.teal)
                    .width(160)
                    .height(90)
                    .rounded(
                      topLeft: 20,
                      topRight: 5,
                      bottomLeft: 5,
                      bottomRight: 20,
                    )
                    .paddingAll(12),
                child: const Center(
                  child: Text(
                    'Custom Corners',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Box with shadows
              Box(
                style: BoxMix()
                    .color(Colors.white)
                    .width(140)
                    .height(70)
                    .roundedAll(10)
                    .shadow(BoxShadowMix.only(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ))
                    .paddingAll(12),
                child: const Center(
                  child: Text(
                    'Shadow Box',
                    style: TextStyle(color: Colors.black87),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Box with transform
              Box(
                style: BoxMix()
                    .color(Colors.amber)
                    .width(100)
                    .height(100)
                    .roundedAll(12)
                    .rotate(0.2)
                    .paddingAll(8),
                child: const Center(
                  child: Text(
                    'Rotated',
                    style: TextStyle(color: Colors.black87),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Box with scale transform
              Box(
                style: BoxMix()
                    .color(Colors.green)
                    .width(80)
                    .height(80)
                    .roundedAll(8)
                    .scale(1.2)
                    .paddingAll(8),
                child: const Center(
                  child: Text(
                    'Scaled',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'API Examples',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'BoxMix().color(Colors.blue).width(150).height(80).paddingAll(16).roundedAll(12)',
                style: TextStyle(fontSize: 12, fontFamily: 'monospace'),
              ),
              const SizedBox(height: 4),
              const Text(
                'BoxMix().linearGradient(colors: [Colors.purple, Colors.blue])',
                style: TextStyle(fontSize: 12, fontFamily: 'monospace'),
              ),
              const SizedBox(height: 4),
              const Text(
                'BoxMix().rotate(0.2).scale(1.2).translate(10, 5)',
                style: TextStyle(fontSize: 12, fontFamily: 'monospace'),
              ),
            ],
          ),
        ),
      ),
      title: 'Mix Box Examples',
    );
  }
}
