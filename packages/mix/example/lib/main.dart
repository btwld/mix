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
                    .height(150)
                    .borderRadius(.circular(8)),
              ),

              const SizedBox(height: 16),

              // Box with padding and text
              Box(
                style: BoxMix()
                    .color(Colors.blue)
                    .width(150)
                    .height(80)
                    .padding(.all(16))
                    .borderRadius(.circular(12)),
                child: const Text(
                  'Fluent API',
                  style: TextStyle(color: Colors.white),
                ),
              ),

              const SizedBox(height: 16),

              // Box with border
              Box(
                style: Style.box()
                    .width(200)
                    .height(80)
                    .color(Colors.orange)
                    .borderRadius(.circular(16))
                    .onHovered(
                      .color(Colors.orangeAccent)
                    )
                    .border(
                      .all(
                        .width(2)
                        .color(Colors.white),
                      ),
                    ),
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
                style: Style.box()
                    .color(Colors.purple)
                    .width(120)
                    .translate(0,0)
                    .height(120)
                    .onHovered(
                      .color(Colors.red)
                      .translate(5, 5)                      
                    )
                    .wrapOpacity(0.2)
                    .borderRadius(.circular(20))
                    .animate(.linear(200.ms))
                    .padding(.all(8)),

                child: const Center(
                  child: Text(
                    'Purple Box',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Box with gradient
              Box(
                style: BoxMix()
                    .width(180)
                    .height(100)
                    .gradient(
                      .linear(
                        .begin(.topLeft)
                        .end(.bottomRight)
                        .colors([Colors.purple, Colors.blue]),
                      )
                    )
                    .borderRadius(.circular(15))
                    .padding(.all(16)),
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
                    .width(160)
                    .color(Colors.teal)
                    .height(90)
                    .borderRadius(
                      .top(.circular(20))
                      .bottomLeft(.circular(10)),
                    )
                    .padding(.all(12)),
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
                style: $box()
                    .color(Colors.white)
                    .width(140)
                    .height(70)
                    .borderRadius(
                      .circular(10)
                    )
                    .shadow(
                      .color(Colors.black26)
                      .blurRadius(8)
                      .offset(Offset(0, 4)),
                    )
                    .padding(
                      .all(12)
                    ),
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
                    .borderRadius(.circular(12))
                    .rotate(0.2)
                    .padding(.all(8)),
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
                    .borderRadius(.circular(10))
                    .scale(1.2)
                    .padding(.all(8)),
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
                'BoxMix().color(Colors.blue).width(150).height(80).paddingAll(16).radiusAll(12)',
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
