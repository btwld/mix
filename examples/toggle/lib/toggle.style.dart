part of 'toggle.dart';

const Color _colorRed = Colors.red;
const Color _colorGreen = Color(0xff46E387);

Style _containerStyle() => Style(
        $box.chain
          ..width(90)
          ..height(50)
          ..wrap.transform.scale(1)
          ..borderRadius(30)
          ..shadow(
            offset: const Offset(0, 15),
            blurRadius: 15,
          ),
        $on.selected(
          $box.color(_colorGreen),
          $box.shadow.color(_colorGreen),
        ),
        $on.press(
          $box.wrap.transform.scale(0.95),
        ),
        $on.unselected(
          $box.color(_colorRed),
          $box.shadow.color(_colorRed),
        ),
        $box.shadow.color.withOpacity(0.3),
      ).animate();

  Style _outerCircleStyle() => Style(
        $box.chain
          ..padding(10)
          ..margin(10)
          ..height(30)
          ..color.white()
          ..borderRadius(15),
        $with.clipOval(),
        $on.selected(
          $with.align(alignment: Alignment.centerRight),
          $box.width(10),
        ),
        $on.unselected(
          $with.align(alignment: Alignment.centerLeft),
          $box.width(30),
        ),
      ).animate();

  Style _innerCircleStyle() => Style(
        $box.chain
          ..height(12)
          ..alignment.center()
          ..borderRadius(6),
        $on.selected(
          $box.width(0),
          $box.color(_colorGreen),
        ),
        $on.unselected(
          $box.width(12),
          $box.color(_colorRed),
        ),
      ).animate();