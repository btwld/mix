import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:simples_design_system/button/button.dart';

import 'accordion/accordion.dart';
import 'checkbox/checkbox.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ComponentPage(),
    );
  }
}

class ComponentPage extends StatefulWidget {
  const ComponentPage({super.key});

  @override
  State<ComponentPage> createState() => _ComponentPageState();
}

class _ComponentPageState extends State<ComponentPage> {
  final checkbox = ValueNotifier(false);
  final accordion = ValueNotifier(true);

  List<Widget> get components {
    return [
      _buildPrimaryButton(
        (alias: "small", variant: ButtonSizeVariant.sm),
      ),
      _buildPrimaryButton(
        (alias: "medium", variant: ButtonSizeVariant.md),
      ),
      _buildPrimaryButton(
        (alias: "large", variant: ButtonSizeVariant.lg),
      ),
      _buildSecondaryButton(
        (alias: "small", variant: ButtonSizeVariant.sm),
      ),
      _buildSecondaryButton(
        (alias: "medium", variant: ButtonSizeVariant.md),
      ),
      _buildSecondaryButton(
        (alias: "large", variant: ButtonSizeVariant.lg),
      ),
      _buildDestructiveButton(
        (alias: "small", variant: ButtonSizeVariant.sm),
      ),
      _buildDestructiveButton(
        (alias: "medium", variant: ButtonSizeVariant.md),
      ),
      _buildDestructiveButton(
        (alias: "large", variant: ButtonSizeVariant.lg),
      ),
      ListenableBuilder(
        listenable: checkbox,
        builder: (context, child) => _buildCheckbox(),
      ),
      ListenableBuilder(
        listenable: accordion,
        builder: (context, child) => _buildAccordion(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GridView.builder(
        itemCount: components.length,
        padding: const EdgeInsets.all(32),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 400,
          childAspectRatio: 1,
          mainAxisSpacing: 24,
          crossAxisSpacing: 24,
        ),
        itemBuilder: (context, index) => components[index],
      ),
    );
  }

  Widget _buildPrimaryButton(
    ({String alias, ButtonSizeVariant variant}) extraVariant,
  ) {
    return ComponentContainer<ButtonSizeVariant>(
      baseVariant: ButtonTypeVariant.primary.value,
      extraVariant: extraVariant,
      componentBuilder: (v) => SimplePrimaryButton(
        label: "Primary",
        size: v!,
      ),
    );
  }

  Widget _buildSecondaryButton(
    ({String alias, ButtonSizeVariant variant}) extraVariant,
  ) {
    return ComponentContainer<ButtonSizeVariant>(
      baseVariant: ButtonTypeVariant.secondary.value,
      extraVariant: extraVariant,
      componentBuilder: (v) => SimpleSecondaryButton(
        label: "Secondary",
        size: v!,
      ),
    );
  }

  Widget _buildDestructiveButton(
    ({String alias, ButtonSizeVariant variant}) extraVariant,
  ) {
    return ComponentContainer<ButtonSizeVariant>(
      baseVariant: ButtonTypeVariant.destructive.value,
      extraVariant: extraVariant,
      componentBuilder: (v) => SimpleDestructiveButton(
        label: "Destructive",
        size: v!,
      ),
    );
  }

  Widget _buildCheckbox() {
    return ComponentContainer(
      componentBuilder: (_) => SimpleCheckbox(
        label: "Checkbox",
        value: checkbox.value,
        onChanged: (v) {
          checkbox.value = v;
        },
      ),
    );
  }

  Widget _buildAccordion() {
    return ComponentContainer(
      componentBuilder: (_) => SimpleAccordion(
        header: const Text("Header"),
        content: const Text("Content"),
        expanded: accordion.value,
        onChanged: (v) {
          accordion.value = !v;
        },
      ),
    );
  }
}

class ComponentContainer<T> extends StatelessWidget {
  const ComponentContainer({
    super.key,
    required this.componentBuilder,
    this.baseVariant,
    this.extraVariant,
  });

  final Widget Function(T? extraVariant) componentBuilder;
  // final List<Variant> variants;
  final Variant? baseVariant;
  final ({T variant, String alias})? extraVariant;

  String get label {
    if (baseVariant == null && extraVariant == null) {
      return "Default";
    }

    if (baseVariant == null) {
      return extraVariant!.alias;
    }
    return "${baseVariant?.name} + ${extraVariant?.alias}";
  }

  @override
  Widget build(BuildContext context) {
    final component = componentBuilder(extraVariant?.variant);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      height: 300,
      width: 300,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: component,
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: [
                  _buildVariantLabel(
                    context,
                    label,
                    color: Colors.black54,
                    fontWeight: FontWeight.w400,
                  ),
                  _buildVariantLabel(
                    context,
                    component.runtimeType.toString(),
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVariantLabel(BuildContext context, String label,
      {Color? color, FontWeight? fontWeight}) {
    return Text(
      label,
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: color,
            fontWeight: fontWeight,
          ),
    );
  }
}
