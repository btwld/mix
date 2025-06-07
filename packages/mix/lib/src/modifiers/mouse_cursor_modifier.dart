// ignore_for_file: prefer-named-boolean-parameters

import 'package:flutter/material.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../core/element.dart';
import '../core/factory/mix_data.dart';
import '../core/modifier.dart';
import '../core/utility.dart';

part 'mouse_cursor_modifier.g.dart';

@MixableSpec(components: GeneratedSpecComponents.skipUtility)
class MouseCursorDecoratorSpec
    extends WidgetModifierSpec<MouseCursorDecoratorSpec>
    with _$MouseCursorDecoratorSpec {
  final MouseCursor? mouseCursor;

  const MouseCursorDecoratorSpec({this.mouseCursor});

  @override
  MouseCursorDecoratorSpecAttribute toAttribute() {
    return MouseCursorDecoratorSpecAttribute(mouseCursor: mouseCursor);
  }

  @override
  Widget build(Widget child) {
    return MouseRegion(
      cursor: mouseCursor ?? MouseCursor.defer,
      child: child,
    );
  }
}

class MouseCursorModifierSpecUtility<T extends Attribute>
    extends MixUtility<T, MouseCursorDecoratorSpecAttribute> {
  const MouseCursorModifierSpecUtility(super.builder);
  T call(MouseCursor? mouseCursor) {
    return builder(MouseCursorDecoratorSpecAttribute(mouseCursor: mouseCursor));
  }

  T defer() => call(MouseCursor.defer);
  T uncontrolled() => call(MouseCursor.uncontrolled);

  T none() => call(SystemMouseCursors.none);

  T basic() => call(SystemMouseCursors.basic);

  T click() => call(SystemMouseCursors.click);

  T forbidden() => call(SystemMouseCursors.forbidden);

  T wait() => call(SystemMouseCursors.wait);

  T progress() => call(SystemMouseCursors.progress);

  T contextMenu() => call(SystemMouseCursors.contextMenu);

  T help() => call(SystemMouseCursors.help);

  T text() => call(SystemMouseCursors.text);

  T verticalText() => call(SystemMouseCursors.verticalText);

  T cell() => call(SystemMouseCursors.cell);

  T precise() => call(SystemMouseCursors.precise);

  T move() => call(SystemMouseCursors.move);

  T grab() => call(SystemMouseCursors.grab);

  T grabbing() => call(SystemMouseCursors.grabbing);

  T noDrop() => call(SystemMouseCursors.noDrop);

  T alias() => call(SystemMouseCursors.alias);

  T copy() => call(SystemMouseCursors.copy);
  T disappearing() => call(SystemMouseCursors.disappearing);

  T allScroll() => call(SystemMouseCursors.allScroll);

  T resizeLeftRight() => call(SystemMouseCursors.resizeLeftRight);

  T resizeUpDown() => call(SystemMouseCursors.resizeUpDown);

  T resizeUpLeftDownRight() => call(SystemMouseCursors.resizeUpLeftDownRight);

  T resizeUpRightDownLeft() => call(SystemMouseCursors.resizeUpRightDownLeft);

  T resizeUp() => call(SystemMouseCursors.resizeUp);

  T resizeDown() => call(SystemMouseCursors.resizeDown);

  T resizeLeft() => call(SystemMouseCursors.resizeLeft);

  T resizeRight() => call(SystemMouseCursors.resizeRight);

  T resizeUpLeft() => call(SystemMouseCursors.resizeUpLeft);

  T resizeUpRight() => call(SystemMouseCursors.resizeUpRight);

  T resizeDownLeft() => call(SystemMouseCursors.resizeDownLeft);

  T resizeDownRight() => call(SystemMouseCursors.resizeDownRight);

  T resizeColumn() => call(SystemMouseCursors.resizeColumn);

  T resizeRow() => call(SystemMouseCursors.resizeRow);

  T zoomIn() => call(SystemMouseCursors.zoomIn);

  T zoomOut() => call(SystemMouseCursors.zoomOut);
}
