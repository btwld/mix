// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mix/experimental.dart';
// import 'package:mix/mix.dart';

// enum BlockPhases {
//   identity,
//   compress,
//   expand;

//   double get value => switch (this) {
//         identity => 0,
//         compress => -0.5,
//         expand => 0.5,
//       };
// }

// class BlockGroup extends StatelessWidget {
//   const BlockGroup({
//     super.key,
//     required this.rows,
//     required this.cols,
//     required this.count,
//   });
//   final int rows;
//   final int cols;
//   final int count;

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       showPerformanceOverlay: true,
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
//       ),
//       home: Scaffold(
//         backgroundColor: Colors.white,
//         body: Center(
//           child: SpecBuilder(builder: (context) {
//             return AnimatedBlock(rows: rows, cols: cols, count: count);
//           }),
//         ),
//       ),
//     );
//   }
// }

// class AnimatedBlock extends StatefulWidget {
//   const AnimatedBlock({
//     super.key,
//     required this.rows,
//     required this.cols,
//     required this.count,
//   });
//   final int rows;
//   final int cols;
//   final int count;

//   @override
//   State<AnimatedBlock> createState() => _AnimatedBlockState();
// }

// class _AnimatedBlockState extends State<AnimatedBlock> {
//   Point<int> waveOriginal = const Point(0, 0);
//   late final int _rows = widget.rows;
//   late final int _cols = widget.cols;
//   final double _size = 15;
//   final double _spacing = 8;
//   late final double _maxDistance = calculateHypot(
//     const Point(0, 0),
//     Point(_cols - 1, _rows - 1),
//   );

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       spacing: _spacing,
//       children: List.generate(_rows, (rowIndex) {
//         return Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           spacing: _spacing,
//           children: List.generate(_cols, (colIndex) {
//             return SpecPhaseAnimator<BlockPhases, BoxSpecAttribute, BoxSpec>(
//               phases: BlockPhases.values,
//               phaseBuilder: (phase) {
//                 final cellCordinates = Point<int>(colIndex, rowIndex);

//                 final originDistance = calculateHypot(
//                   waveOriginal,
//                   cellCordinates,
//                 );
//                 final originDistanceNormalized = originDistance / _maxDistance;
//                 final waveImpact = 1 - originDistanceNormalized;

//                 return Style(
//                   $box.transform(
//                       Matrix4.identity()..scale(1 + phase.value * waveImpact)),
//                   $box.color(
//                     phase == BlockPhases.identity
//                         ? Colors.blueGrey.shade200
//                         : Colors.blueGrey.shade200.mix(
//                             Colors.lightBlueAccent,
//                             (waveImpact * 100).toInt(),
//                           ),
//                   ),
//                   $box.transformAlignment.center(),
//                 );
//               },
//               animation: (phase) {
//                 final cellCordinates = Point<int>(colIndex, rowIndex);

//                 final originDistance = calculateHypot(
//                   waveOriginal,
//                   cellCordinates,
//                 );

//                 return switch (phase) {
//                   BlockPhases.identity => SpecPhaseAnimationData(
//                       duration: const Duration(milliseconds: 100),
//                       curve: Curves.easeInOut,
//                       delay: Duration(
//                           milliseconds: (100.0 * originDistance).toInt()),
//                     ),
//                   BlockPhases.compress => const SpecPhaseAnimationData(
//                       duration: Duration(milliseconds: 200),
//                       curve: Curves.easeInOut,
//                     ),
//                   BlockPhases.expand => const SpecPhaseAnimationData(
//                       duration: Duration(milliseconds: 200),
//                       curve: Curves.easeInOut,
//                     ),
//                 };
//               },
//               trigger: widget.count,
//               builder: (context, scaleStyle, phase) {
//                 return GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       waveOriginal = Point(colIndex, rowIndex);
//                     });
//                   },
//                   child: Box(
//                     style: Style(
//                       $box.height(_size),
//                       $box.width(_size),
//                       $box.borderRadius.all(_size * 0.25),
//                       scaleStyle(),
//                     ),
//                   ),
//                 );
//               },
//             );
//           }),
//         );
//       }),
//     );
//   }
// }

// double calculateHypot(Point<int> p1, Point<int> p2) {
//   final dx = (p2.x - p1.x).abs();
//   final dy = (p2.y - p1.y).abs();
//   return sqrt(dx * dx + dy * dy);
// }

// void main() {
//   testWidgets('animation does not drop frames', (tester) async {
//     final stopwatch = Stopwatch()..start();

//     await tester.pumpWidget(const BlockGroup(rows: 2, cols: 2, count: 0));
//     await tester.pumpWidget(const BlockGroup(rows: 2, cols: 2, count: 0));

//     // Simulate animation over time
//     for (int i = 0; i < 60; i++) {
//       await tester.pump(const Duration(milliseconds: 16)); // 60 FPS frame
//     }

//     stopwatch.stop();

//     print(stopwatch.elapsed.inMilliseconds);

//     // Check if the animation took too long
//     const safeMargin = 100;
//     expect(
//       stopwatch.elapsed.inMilliseconds < 16 * 60 + safeMargin,
//       true,
//     ); // allow some margin
//   });
// }
