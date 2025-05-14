import 'package:flutter/material.dart';
import 'package:naked/naked.dart';

class NakedSliderExample extends StatefulWidget {
  const NakedSliderExample({super.key});

  @override
  State<NakedSliderExample> createState() => _NakedSliderExampleState();
}

class _NakedSliderExampleState extends State<NakedSliderExample> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Slider Examples',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937), // text-gray-800
              ),
            ),
            const SizedBox(height: 32),

            // Basic Slider
            _buildSection(
              title: 'Basic Slider',
              child: const BasicSlider(),
            ),

            // Slider with Value Display
            _buildSection(
              title: 'Slider with Value Display',
              child: const SliderWithValue(),
            ),

            // Range Slider
            // _buildSection(
            //   title: 'Range Slider',
            //   child: const RangeSlider(),
            // ),

            // Slider Variants
            _buildSection(
              title: 'Slider Variants',
              child: const SliderVariants(),
            ),

            // Slider with Icons
            _buildSection(
              title: 'Slider with Icons',
              child: const SliderWithIcons(),
            ),

            // Stepped Slider
            _buildSection(
              title: 'Stepped Slider',
              child: const SteppedSlider(),
            ),

            // Vertical Slider
            _buildSection(
              title: 'Vertical Slider',
              child: const VerticalSlider(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 48.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151), // text-gray-700
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}

// Placeholder classes - to be implemented
class BasicSlider extends StatefulWidget {
  const BasicSlider({super.key});

  @override
  State<BasicSlider> createState() => _BasicSliderState();
}

class _BasicSliderState extends State<BasicSlider> {
  double _value = 50;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'A simple slider with default styling',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF4B5563), // text-gray-600
          ),
        ),
        const SizedBox(height: 16),
        NakedSlider(
          value: _value / 100,
          onChanged: (value) => setState(() {
            _value = value * 100;
          }),
          child: Builder(
            builder: (context) {
              final sliderState = NakedSliderState.of(context);
              final isHovered = sliderState.isHovered;
              final isFocused = sliderState.isFocused;
              final isDragging = sliderState.isDragging;

              return SizedBox(
                width: 300,
                height: 16,
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    // Track background
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5E7EB), // bg-gray-200
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),

                    // Active track
                    Align(
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: _value / 100,
                        child: Container(
                          height: 8,
                          decoration: BoxDecoration(
                            color: isFocused
                                ? const Color.fromARGB(255, 40, 91, 174)
                                : const Color(0xFF3B82F6),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),

                    // Thumb
                    Positioned(
                      left: (_value / 100) * 300 - 8,
                      child: Container(
                        width: isDragging ? 20 : 16,
                        height: isDragging ? 20 : 16,
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B82F6), // bg-blue-500
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                          boxShadow: [
                            if (isHovered || isFocused || isDragging)
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class SliderWithValue extends StatefulWidget {
  const SliderWithValue({super.key});

  @override
  State<SliderWithValue> createState() => _SliderWithValueState();
}

class _SliderWithValueState extends State<SliderWithValue> {
  double _value = 50;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Adjust value',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF4B5563), // text-gray-600
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFDBEAFE), // bg-blue-100
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '${_value.round()}%',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1E40AF), // text-blue-800
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        NakedSlider(
          value: _value / 100,
          onChanged: (value) => setState(() {
            _value = value * 100;
          }),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final sliderState = NakedSliderState.of(context);
              final isHovered = sliderState.isHovered;
              final isFocused = sliderState.isFocused;
              final isDragging = sliderState.isDragging;

              return SizedBox(
                height: 20,
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    // Track background
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5E7EB), // bg-gray-200
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),

                    // Active track
                    Align(
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: _value / 100,
                        child: Container(
                          height: 8,
                          decoration: BoxDecoration(
                            color: isFocused
                                ? const Color.fromARGB(255, 40, 91, 174)
                                : const Color(0xFF3B82F6), // bg-blue-500
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),

                    // Thumb
                    Positioned(
                      left: (_value / 100) * constraints.maxWidth - 10,
                      child: Container(
                        width: isDragging ? 24 : 20,
                        height: isDragging ? 24 : 20,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF3B82F6), // border-blue-500
                            width: 2,
                          ),
                          boxShadow: [
                            if (isHovered || isFocused || isDragging)
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(5, (index) {
            final value = index * 25;
            return Text(
              '$value%',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF6B7280), // text-gray-500
              ),
            );
          }),
        ),
      ],
    );
  }
}

// class RangeSlider extends StatefulWidget {
//   const RangeSlider({super.key});

//   @override
//   State<RangeSlider> createState() => _RangeSliderState();
// }

// class _RangeSliderState extends State<RangeSlider> {
//   double _minValue = 25;
//   double _maxValue = 75;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Text(
//               'Price Range',
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Color(0xFF4B5563),
//               ),
//             ),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFDBEAFE),
//                 borderRadius: BorderRadius.circular(6),
//               ),
//               child: Text(
//                 '\$${_minValue.round()} - \$${_maxValue.round()}',
//                 style: const TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                   color: Color(0xFF1E40AF),
//                 ),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 24),
//         Stack(
//           children: [
//             // Min value slider
//             NakedSlider(
//               value: _minValue / 100,
//               onChanged: (value) {
//                 final newValue = value * 100;
//                 if (newValue < _maxValue) {
//                   setState(() => _minValue = newValue);
//                 }
//               },
//               child: Builder(
//                 builder: (context) {
//                   final sliderState = NakedSliderState.of(context);
//                   final isHovered = sliderState.isHovered;
//                   final isFocused = sliderState.isFocused;
//                   final isDragging = sliderState.isDragging;

//                   return SizedBox(
//                     width: 300,
//                     height: 32,
//                     child: Stack(
//                       alignment: Alignment.center,
//                       clipBehavior: Clip.none,
//                       children: [
//                         // Track background
//                         Container(
//                           height: 8,
//                           decoration: BoxDecoration(
//                             color: const Color(0xFFE5E7EB), // bg-gray-200
//                             borderRadius: BorderRadius.circular(4),
//                           ),
//                         ),

//                         // Active track
//                         Positioned(
//                           left: (_minValue / 100) * 300,
//                           width: (_maxValue - _minValue) / 100 * 300,
//                           child: Container(
//                             height: 8,
//                             decoration: BoxDecoration(
//                               color: const Color(0xFF3B82F6), // bg-blue-500
//                               borderRadius: BorderRadius.circular(4),
//                             ),
//                           ),
//                         ),

//                         // Min thumb
//                         Positioned(
//                           left: (_minValue / 100) * 300 - 10,
//                           child: Container(
//                             width: isDragging ? 24 : 20,
//                             height: isDragging ? 24 : 20,
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               shape: BoxShape.circle,
//                               border: Border.all(
//                                 color:
//                                     const Color(0xFF3B82F6), // border-blue-500
//                                 width: 2,
//                               ),
//                               boxShadow: [
//                                 if (isHovered || isFocused || isDragging)
//                                   BoxShadow(
//                                     color: Colors.black.withValues(alpha: 0.1),
//                                     blurRadius: 4,
//                                     offset: const Offset(0, 2),
//                                   ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),

//             // Max value slider
//             NakedSlider(
//               value: _maxValue / 100,
//               onChanged: (value) {
//                 final newValue = value * 100;
//                 if (newValue > _minValue) {
//                   setState(() => _maxValue = newValue);
//                 }
//               },
//               child: Builder(
//                 builder: (context) {
//                   final sliderState = NakedSliderState.of(context);
//                   final isHovered = sliderState.isHovered;
//                   final isFocused = sliderState.isFocused;
//                   final isDragging = sliderState.isDragging;

//                   return SizedBox(
//                     width: 300,
//                     height: 32,
//                     child: Stack(
//                       alignment: Alignment.center,
//                       clipBehavior: Clip.none,
//                       children: [
//                         // Max thumb
//                         Positioned(
//                           left: (_maxValue / 100) * 300 - 10,
//                           child: Container(
//                             width: isDragging ? 24 : 20,
//                             height: isDragging ? 24 : 20,
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               shape: BoxShape.circle,
//                               border: Border.all(
//                                 color:
//                                     const Color(0xFF3B82F6), // border-blue-500
//                                 width: 2,
//                               ),
//                               boxShadow: [
//                                 if (isHovered || isFocused || isDragging)
//                                   BoxShadow(
//                                     color: Colors.black.withValues(alpha: 0.1),
//                                     blurRadius: 4,
//                                     offset: const Offset(0, 2),
//                                   ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 24),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: List.generate(5, (index) {
//             final value = index * 25;
//             return Text(
//               '\$$value',
//               style: const TextStyle(
//                 fontSize: 12,
//                 color: Color(0xFF6B7280), // text-gray-500
//               ),
//             );
//           }),
//         ),
//       ],
//     );
//   }
// }

class SliderVariants extends StatefulWidget {
  const SliderVariants({super.key});

  @override
  State<SliderVariants> createState() => _SliderVariantsState();
}

class _SliderVariantsState extends State<SliderVariants> {
  final Map<String, double> _values = {
    'primary': 60,
    'secondary': 40,
    'success': 75,
    'danger': 25,
  };

  final List<Map<String, dynamic>> _variants = [
    {
      'name': 'primary',
      'label': 'Primary',
      'trackColor': const Color(0xFF3B82F6), // bg-blue-500
      'thumbColor': const Color(0xFF3B82F6), // bg-blue-500
    },
    {
      'name': 'secondary',
      'label': 'Secondary',
      'trackColor': const Color(0xFF9333EA), // bg-purple-500
      'thumbColor': const Color(0xFF9333EA), // bg-purple-500
    },
    {
      'name': 'success',
      'label': 'Success',
      'trackColor': const Color(0xFF22C55E), // bg-green-500
      'thumbColor': const Color(0xFF22C55E), // bg-green-500
    },
    {
      'name': 'danger',
      'label': 'Danger',
      'trackColor': const Color(0xFFEF4444), // bg-red-500
      'thumbColor': const Color(0xFFEF4444), // bg-red-500
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: _variants.map((variant) {
        final name = variant['name'] as String;
        final label = variant['label'] as String;
        final trackColor = variant['trackColor'] as Color;
        final thumbColor = variant['thumbColor'] as Color;
        final value = _values[name]!;

        return SizedBox(
          width: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF374151), // text-gray-700
                    ),
                  ),
                  Text(
                    '${value.round()}%',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF4B5563), // text-gray-600
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              NakedSlider(
                value: value / 100,
                onChanged: (newValue) => setState(() {
                  _values[name] = newValue * 100;
                }),
                child: Builder(
                  builder: (context) {
                    final sliderState = NakedSliderState.of(context);
                    final isHovered = sliderState.isHovered;
                    final isFocused = sliderState.isFocused;
                    final isDragging = sliderState.isDragging;

                    return SizedBox(
                      height: 16,
                      child: Stack(
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
                        children: [
                          // Track background
                          Container(
                            height: 8,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE5E7EB), // bg-gray-200
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),

                          // Active track
                          Align(
                            alignment: Alignment.centerLeft,
                            child: FractionallySizedBox(
                              widthFactor: value / 100,
                              child: Container(
                                height: 8,
                                decoration: BoxDecoration(
                                  color: trackColor,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ),

                          // Thumb
                          Positioned(
                            left: (value / 100) * 300 - 8,
                            child: Container(
                              width: isDragging ? 20 : 16,
                              height: isDragging ? 20 : 16,
                              decoration: BoxDecoration(
                                color: thumbColor,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                                boxShadow: [
                                  if (isHovered || isFocused || isDragging)
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.1),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class SliderWithIcons extends StatefulWidget {
  const SliderWithIcons({super.key});

  @override
  State<SliderWithIcons> createState() => _SliderWithIconsState();
}

class _SliderWithIconsState extends State<SliderWithIcons> {
  double _volume = 50;
  double _brightness = 70;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Volume Slider
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Volume',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF374151), // text-gray-700
                  ),
                ),
                Text(
                  '${_volume.round()}%',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF4B5563), // text-gray-600
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  _volume == 0 ? Icons.volume_off : Icons.volume_down,
                  size: 20,
                  color: const Color(0xFF6B7280), // text-gray-500
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: NakedSlider(
                    value: _volume / 100,
                    onChanged: (value) => setState(() {
                      _volume = value * 100;
                    }),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final sliderState = NakedSliderState.of(context);
                        final isHovered = sliderState.isHovered;
                        final isFocused = sliderState.isFocused;
                        final isDragging = sliderState.isDragging;

                        return SizedBox(
                          height: 16,
                          child: Stack(
                            alignment: Alignment.center,
                            clipBehavior: Clip.none,
                            children: [
                              // Track background
                              Container(
                                height: 8,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE5E7EB), // bg-gray-200
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),

                              // Active track
                              Align(
                                alignment: Alignment.centerLeft,
                                child: FractionallySizedBox(
                                  widthFactor: _volume / 100,
                                  child: Container(
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: const Color(
                                          0xFF3B82F6), // bg-blue-500
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                              ),

                              // Thumb
                              Positioned(
                                left:
                                    (_volume / 100) * constraints.maxWidth - 8,
                                child: Container(
                                  width: isDragging ? 20 : 16,
                                  height: isDragging ? 20 : 16,
                                  decoration: BoxDecoration(
                                    color:
                                        const Color(0xFF3B82F6), // bg-blue-500
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      if (isHovered || isFocused || isDragging)
                                        BoxShadow(
                                          color: Colors.black
                                              .withValues(alpha: 0.1),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(
                  Icons.volume_up,
                  size: 20,
                  color: Color(0xFF6B7280), // text-gray-500
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),
        // Brightness Slider
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Brightness',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF374151), // text-gray-700
                  ),
                ),
                Text(
                  '${_brightness.round()}%',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF4B5563), // text-gray-600
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.dark_mode,
                  size: 20,
                  color: Color(0xFF6B7280), // text-gray-500
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: NakedSlider(
                    value: _brightness / 100,
                    onChanged: (value) => setState(() {
                      _brightness = value * 100;
                    }),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final sliderState = NakedSliderState.of(context);
                        final isHovered = sliderState.isHovered;
                        final isFocused = sliderState.isFocused;
                        final isDragging = sliderState.isDragging;

                        return SizedBox(
                          height: 16,
                          child: Stack(
                            alignment: Alignment.center,
                            clipBehavior: Clip.none,
                            children: [
                              // Track background
                              Container(
                                height: 8,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE5E7EB), // bg-gray-200
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),

                              // Active track
                              Align(
                                alignment: Alignment.centerLeft,
                                child: FractionallySizedBox(
                                  widthFactor: _brightness / 100,
                                  child: Container(
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: const Color(
                                          0xFFF59E0B), // bg-amber-500
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                              ),

                              // Thumb
                              Positioned(
                                left:
                                    (_brightness / 100) * constraints.maxWidth -
                                        8,
                                child: Container(
                                  width: isDragging ? 20 : 16,
                                  height: isDragging ? 20 : 16,
                                  decoration: BoxDecoration(
                                    color:
                                        const Color(0xFFF59E0B), // bg-amber-500
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      if (isHovered || isFocused || isDragging)
                                        BoxShadow(
                                          color: Colors.black
                                              .withValues(alpha: 0.1),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(
                  Icons.light_mode,
                  size: 20,
                  color: Color(0xFF6B7280), // text-gray-500
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class SteppedSlider extends StatefulWidget {
  const SteppedSlider({super.key});

  @override
  State<SteppedSlider> createState() => _SteppedSliderState();
}

class _SteppedSliderState extends State<SteppedSlider> {
  double _value = 2;
  final List<Map<String, dynamic>> _steps = [
    {'value': 0, 'label': 'Beginner'},
    {'value': 1, 'label': 'Intermediate'},
    {'value': 2, 'label': 'Advanced'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Skill Level',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF4B5563), // text-gray-600
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFDBEAFE), // bg-blue-100
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                _steps[_value.toInt()]['label'] as String,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1D4ED8), // text-blue-800
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        NakedSlider(
          value: _value / (_steps.length - 1),
          divisions: _steps.length - 1,
          onChanged: (value) {
            final stepValue = (value * (_steps.length - 1)).roundToDouble();
            setState(() {
              _value = stepValue;
            });
          },
          child: Builder(
            builder: (context) {
              final sliderState = NakedSliderState.of(context);
              final isHovered = sliderState.isHovered;
              final isFocused = sliderState.isFocused;
              final isDragging = sliderState.isDragging;

              return SizedBox(
                width: 300,
                height: 64,
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    // Track background
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5E7EB), // bg-gray-200
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),

                    // Step markers
                    ...List.generate(_steps.length, (index) {
                      final isActive = index <= _value;
                      return Positioned(
                        left: (index / (_steps.length - 1)) * 300 - 6,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: isActive
                                ? const Color(0xFF3B82F6) // bg-blue-500
                                : Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isActive
                                  ? const Color(0xFF3B82F6) // bg-blue-500
                                  : const Color(0xFFD1D5DB), // bg-gray-300
                              width: 2,
                            ),
                          ),
                        ),
                      );
                    }),

                    // Active track
                    Align(
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: _value / (_steps.length - 1),
                        child: Container(
                          height: 8,
                          decoration: BoxDecoration(
                            color: const Color(0xFF3B82F6), // bg-blue-500
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),

                    // Thumb
                    Positioned(
                      left: (_value / (_steps.length - 1)) * 300 - 10,
                      child: Container(
                        width: isDragging ? 24 : 20,
                        height: isDragging ? 24 : 20,
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B82F6), // bg-blue-500
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                          boxShadow: [
                            if (isHovered || isFocused || isDragging)
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                          ],
                        ),
                      ),
                    ),

                    // Step labels
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: _steps.map((step) {
                          final isActive = step['value'] <= _value;
                          return Text(
                            step['label'] as String,
                            style: TextStyle(
                              fontSize: 12,
                              color: isActive
                                  ? const Color(0xFF1F2937) // text-gray-800
                                  : const Color(0xFF6B7280), // text-gray-500
                              fontWeight: isActive
                                  ? FontWeight.w500
                                  : FontWeight.normal,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class VerticalSlider extends StatefulWidget {
  const VerticalSlider({super.key});

  @override
  State<VerticalSlider> createState() => _VerticalSliderState();
}

class _VerticalSliderState extends State<VerticalSlider> {
  double _value = 75;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Value labels
          const Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '100',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6B7280), // text-gray-500
                ),
              ),
              Text(
                '75',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6B7280), // text-gray-500
                ),
              ),
              Text(
                '50',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6B7280), // text-gray-500
                ),
              ),
              Text(
                '25',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6B7280), // text-gray-500
                ),
              ),
              Text(
                '0',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6B7280), // text-gray-500
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          // Slider
          NakedSlider(
            value: _value / 100,
            direction: SliderDirection.vertical,
            onChanged: (value) => setState(() {
              _value = value * 100;
            }),
            child: Builder(
              builder: (context) {
                final sliderState = NakedSliderState.of(context);
                final isHovered = sliderState.isHovered;
                final isFocused = sliderState.isFocused;
                final isDragging = sliderState.isDragging;

                return SizedBox(
                  width: 16,
                  height: 300,
                  child: Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      // Track background
                      Container(
                        width: 8,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE5E7EB), // bg-gray-200
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),

                      // Active track
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: FractionallySizedBox(
                          heightFactor: _value / 100,
                          child: Container(
                            width: 8,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Color(0xFF3B82F6), // blue-500
                                  Color(0xFF60A5FA), // blue-400
                                ],
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),

                      // Thumb
                      Positioned(
                        bottom: (_value / 100) * 300 - 10,
                        child: Container(
                          width: isDragging ? 24 : 20,
                          height: isDragging ? 24 : 20,
                          decoration: BoxDecoration(
                            color: const Color(0xFF3B82F6), // bg-blue-500
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                            boxShadow: [
                              if (isHovered || isFocused || isDragging)
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          // Current value display
          IntrinsicHeight(
            child: Container(
              constraints: const BoxConstraints(minWidth: 4 * 14),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFDBEAFE), // bg-blue-100
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '${_value.round()}%',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFeatures: [FontFeature.tabularFigures()],
                  color: Color(0xFF1D4ED8), // text-blue-800
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
