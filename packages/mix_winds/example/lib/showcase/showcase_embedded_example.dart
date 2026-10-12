import 'package:flutter/material.dart';
import 'package:mix_winds/mix_winds.dart';

import '../advanced_parity_preview.dart';
import 'showcase_view_data.dart';

/// The native Flutter surface mounted into one showcase host element.
class ShowcaseEmbeddedExample extends StatelessWidget {
  const ShowcaseEmbeddedExample({super.key});

  @override
  Widget build(BuildContext context) {
    final viewData = ShowcaseViewData.forView(View.of(context).viewId);
    final baseConfig = TwConfig.standard();
    final config = baseConfig.copyWith(
      textDefaults: baseConfig.textDefaults.copyWith(
        fontFamily: 'TwParityRoboto',
        fontFamilyFallback: const [],
      ),
    );

    return WidgetsApp(
      color: const Color(0xFFF1F5F9),
      debugShowCheckedModeBanner: false,
      pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
        settings: settings,
        pageBuilder: (context, animation, secondaryAnimation) {
          return builder(context);
        },
      ),
      home: ColoredBox(
        color: const Color(0xFFF1F5F9),
        child: TwScope(
          config: config,
          child: SingleChildScrollView(
            child: AdvancedParityPreview(exampleId: viewData.exampleId),
          ),
        ),
      ),
    );
  }
}
