// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'box_widget.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

class Badge extends StatelessWidget {
  final String label;
  final Color color;
  final Widget? child;
  final BoxStyler? style;

  const Badge(
    this.label, {
    super.key,
    this.color = const Color(0xFF000000),
    this.child,
    this.style,
  });

  @override
  Widget build(BuildContext context) =>
      badge(label, color: color).merge(style)(child: child);
}

class Card extends StatelessWidget {
  final Widget? child;

  const Card({super.key, this.child});

  @override
  Widget build(BuildContext context) => _style(child: child);
}

class CardV extends StatelessWidget {
  final List<Widget> children;

  const CardV({super.key, required this.children});

  @override
  Widget build(BuildContext context) => _styleV(children: children);
}

class CardH extends StatelessWidget {
  final List<Widget> children;

  const CardH({super.key, required this.children});

  @override
  Widget build(BuildContext context) => _styleH(children: children);
}

class H1 extends StatelessWidget {
  final String text;
  final TextStyler? style;

  const H1(this.text, {super.key, this.style});

  @override
  Widget build(BuildContext context) => _styleH1.merge(style)(text);
}
