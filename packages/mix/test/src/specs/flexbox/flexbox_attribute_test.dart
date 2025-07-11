import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/custom_matchers.dart';

void main() {
  group('FlexBoxSpecAttribute', () {
    test('Constructor assigns correct properties', () {
      final flexBoxSpecAttribute = FlexBoxSpecAttribute(
        box: BoxSpecAttribute(
          alignment: Alignment.center,
          padding: EdgeInsetsGeometryDto.only(
            top: 20,
            bottom: 20,
            left: 20,
            right: 20,
          ),
          margin: EdgeInsetsGeometryDto.only(
            top: 10,
            bottom: 10,
            left: 10,
            right: 10,
          ),
          constraints: BoxConstraintsDto(maxHeight: 100),
          decoration: BoxDecorationDto(color: Colors.blue),
          transform: Matrix4.identity(),
          clipBehavior: Clip.antiAlias,
          width: 100,
          height: 100,
          modifiers: WidgetModifiersConfigDto([
            const OpacityModifierSpecAttribute(opacity: 0.5),
            const SizedBoxModifierSpecAttribute(height: 10, width: 10),
          ]),
        ),
        flex: FlexSpecAttribute(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          verticalDirection: VerticalDirection.down,
          textDirection: TextDirection.ltr,
          textBaseline: TextBaseline.alphabetic,
        ),
      );

      expect(flexBoxSpecAttribute.box!.alignment, Alignment.center);
      expect(flexBoxSpecAttribute.box!.clipBehavior, Clip.antiAlias);

      expect(
        flexBoxSpecAttribute.box!.constraints,
        BoxConstraintsDto(maxHeight: 100),
      );
      expect(
        flexBoxSpecAttribute.box!.decoration,
        BoxDecorationDto(color: Colors.blue),
      );

      expect(flexBoxSpecAttribute.box!.height, 100);
      expect(
        flexBoxSpecAttribute.box!.margin,
        EdgeInsetsGeometryDto.only(top: 10, bottom: 10, left: 10, right: 10),
      );
      expect(
        flexBoxSpecAttribute.box!.padding,
        EdgeInsetsGeometryDto.only(top: 20, bottom: 20, left: 20, right: 20),
      );
      expect(flexBoxSpecAttribute.box!.transform, Matrix4.identity());
      expect(flexBoxSpecAttribute.box!.width, 100);
      expect(
        flexBoxSpecAttribute.box!.modifiers,
        WidgetModifiersConfigDto([
          const OpacityModifierSpecAttribute(opacity: 0.5),
          const SizedBoxModifierSpecAttribute(height: 10, width: 10),
        ]),
      );

      expect(
        flexBoxSpecAttribute.flex!.mainAxisAlignment,
        MainAxisAlignment.center,
      );
      expect(
        flexBoxSpecAttribute.flex!.crossAxisAlignment,
        CrossAxisAlignment.center,
      );
      expect(flexBoxSpecAttribute.flex!.mainAxisSize, MainAxisSize.max);
      expect(
        flexBoxSpecAttribute.flex!.verticalDirection,
        VerticalDirection.down,
      );
      expect(flexBoxSpecAttribute.flex!.textDirection, TextDirection.ltr);
      expect(flexBoxSpecAttribute.flex!.textBaseline, TextBaseline.alphabetic);
    });

    // resolve()
    test('resolve() returns correct instance', () {
      final flexBoxSpecAttribute = FlexBoxSpecAttribute(
        box: BoxSpecAttribute(
          alignment: Alignment.center,
          padding: EdgeInsetsGeometryDto.only(
            top: 20,
            bottom: 20,
            left: 20,
            right: 20,
          ),
          margin: EdgeInsetsGeometryDto.only(
            top: 10,
            bottom: 10,
            left: 10,
            right: 10,
          ),
          constraints: BoxConstraintsDto(maxHeight: 100),
          decoration: BoxDecorationDto(color: Colors.blue),
          transform: Matrix4.identity(),
          clipBehavior: Clip.antiAlias,
          width: 100,
          height: 100,
          modifiers: WidgetModifiersConfigDto([
            const OpacityModifierSpecAttribute(opacity: 0.5),
            const SizedBoxModifierSpecAttribute(height: 10, width: 10),
          ]),
        ),
        flex: FlexSpecAttribute(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          verticalDirection: VerticalDirection.down,
          textDirection: TextDirection.ltr,
          textBaseline: TextBaseline.alphabetic,
        ),
      );

      expect(
        flexBoxSpecAttribute,
        resolvesTo(FlexBoxSpec(
          box: BoxSpec(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 20),
            margin: const EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 10),
            constraints: const BoxConstraints(maxWidth: double.infinity, maxHeight: 100),
            decoration: const BoxDecoration(color: Colors.blue),
            transform: Matrix4.identity(),
            clipBehavior: Clip.antiAlias,
            width: 100,
            height: 100,
            modifiers: const WidgetModifiersConfig([
              OpacityModifierSpec(0.5),
              SizedBoxModifierSpec(height: 10, width: 10),
            ]),
          ),
          flex: const FlexSpec(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            verticalDirection: VerticalDirection.down,
            textDirection: TextDirection.ltr,
            textBaseline: TextBaseline.alphabetic,
          ),
        )),
      );
    });

    // merge()
    test('merge() returns correct instance', () {
      final flexBoxSpecAttribute = FlexBoxSpecAttribute(
        box: BoxSpecAttribute(
          alignment: Alignment.center,
          padding: EdgeInsetsGeometryDto.only(
            top: 20,
            bottom: 20,
            left: 20,
            right: 20,
          ),
          margin: EdgeInsetsGeometryDto.only(
            top: 10,
            bottom: 10,
            left: 10,
            right: 10,
          ),
          constraints: BoxConstraintsDto(maxHeight: 100),
          decoration: BoxDecorationDto(color: Colors.blue),
          transform: Matrix4.identity(),
          clipBehavior: Clip.antiAlias,
          width: 100,
          height: 100,
          modifiers: WidgetModifiersConfigDto([
            const OpacityModifierSpecAttribute(opacity: 0.5),
            const SizedBoxModifierSpecAttribute(height: 10, width: 10),
          ]),
        ),
        flex: FlexSpecAttribute(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          verticalDirection: VerticalDirection.down,
          textDirection: TextDirection.ltr,
          textBaseline: TextBaseline.alphabetic,
        ),
      );

      final mergedFlexBoxSpecAttribute = flexBoxSpecAttribute.merge(
        FlexBoxSpecAttribute(
          box: BoxSpecAttribute(
            alignment: Alignment.centerLeft,
            padding: EdgeInsetsGeometryDto.only(
              top: 30,
              bottom: 30,
              left: 30,
              right: 30,
            ),
            margin: EdgeInsetsGeometryDto.only(
              top: 20,
              bottom: 20,
              left: 20,
              right: 20,
            ),
            constraints: BoxConstraintsDto(maxHeight: 200),
            decoration: BoxDecorationDto(color: Colors.red),
            transform: Matrix4.identity(),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            width: 200,
            height: 200,
            modifiers: WidgetModifiersConfigDto([
              SizedBoxModifierSpecAttribute(width: 20),
            ]),
          ),
          flex: FlexSpecAttribute(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.up,
            textDirection: TextDirection.rtl,
            textBaseline: TextBaseline.ideographic,
          ),
        ),
      );

      expect(mergedFlexBoxSpecAttribute.box!.alignment, Alignment.centerLeft);
      expect(
        mergedFlexBoxSpecAttribute.box!.clipBehavior,
        Clip.antiAliasWithSaveLayer,
      );

      expect(
        mergedFlexBoxSpecAttribute.box!.constraints,
        BoxConstraintsDto(maxHeight: 200),
      );
      expect(
        mergedFlexBoxSpecAttribute.box!.decoration,
        BoxDecorationDto(color: Colors.red),
      );

      expect(mergedFlexBoxSpecAttribute.box!.height, 200);
      expect(
        mergedFlexBoxSpecAttribute.box!.margin,
        EdgeInsetsGeometryDto.only(top: 20, bottom: 20, left: 20, right: 20),
      );
      expect(
        mergedFlexBoxSpecAttribute.box!.padding,
        EdgeInsetsGeometryDto.only(top: 30, bottom: 30, left: 30, right: 30),
      );
      expect(mergedFlexBoxSpecAttribute.box!.transform, Matrix4.identity());
      expect(mergedFlexBoxSpecAttribute.box!.width, 200);
      expect(
        mergedFlexBoxSpecAttribute.box!.modifiers,
        WidgetModifiersConfigDto([
          const OpacityModifierSpecAttribute(opacity: 0.5),
          SizedBoxModifierSpecAttribute(height: 10, width: 20),
        ]),
      );

      expect(
        mergedFlexBoxSpecAttribute.flex!.mainAxisAlignment,
        MainAxisAlignment.start,
      );
      expect(
        mergedFlexBoxSpecAttribute.flex!.crossAxisAlignment,
        CrossAxisAlignment.start,
      );
      expect(mergedFlexBoxSpecAttribute.flex!.mainAxisSize, MainAxisSize.min);
      expect(
        mergedFlexBoxSpecAttribute.flex!.verticalDirection,
        VerticalDirection.up,
      );
      expect(mergedFlexBoxSpecAttribute.flex!.textDirection, TextDirection.rtl);
      expect(
        mergedFlexBoxSpecAttribute.flex!.textBaseline,
        TextBaseline.ideographic,
      );
    });

    // equality
    test('equality', () {
      final flexBoxSpecAttribute = FlexBoxSpecAttribute(
        box: BoxSpecAttribute(
          alignment: Alignment.center,
          padding: EdgeInsetsGeometryDto.only(
            top: 20,
            bottom: 20,
            left: 20,
            right: 20,
          ),
          margin: EdgeInsetsGeometryDto.only(
            top: 10,
            bottom: 10,
            left: 10,
            right: 10,
          ),
          constraints: BoxConstraintsDto(maxHeight: 100),
          decoration: BoxDecorationDto(color: Colors.blue),
          transform: Matrix4.identity(),
          clipBehavior: Clip.antiAlias,
          width: 100,
          height: 100,
          modifiers: WidgetModifiersConfigDto([
            const OpacityModifierSpecAttribute(opacity: 0.5),
            const SizedBoxModifierSpecAttribute(height: 10, width: 10),
          ]),
        ),
        flex: FlexSpecAttribute(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          verticalDirection: VerticalDirection.down,
          textDirection: TextDirection.ltr,
          textBaseline: TextBaseline.alphabetic,
        ),
      );

      expect(
        flexBoxSpecAttribute,
        equals(
          FlexBoxSpecAttribute(
            box: BoxSpecAttribute(
              alignment: Alignment.center,
              padding: EdgeInsetsGeometryDto.only(
                top: 20,
                bottom: 20,
                left: 20,
                right: 20,
              ),
              margin: EdgeInsetsGeometryDto.only(
                top: 10,
                bottom: 10,
                left: 10,
                right: 10,
              ),
              constraints: BoxConstraintsDto(maxHeight: 100),
              decoration: BoxDecorationDto(color: Colors.blue),
              transform: Matrix4.identity(),
              clipBehavior: Clip.antiAlias,
              width: 100,
              height: 100,
              modifiers: WidgetModifiersConfigDto(const [
                const OpacityModifierSpecAttribute(opacity: 0.5),
                const SizedBoxModifierSpecAttribute(height: 10, width: 10),
              ]),
            ),
            flex: FlexSpecAttribute(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              verticalDirection: VerticalDirection.down,
              textDirection: TextDirection.ltr,
              textBaseline: TextBaseline.alphabetic,
            ),
          ),
        ),
      );
    });

    // not equals
    test('not equals', () {
      final flexBoxSpecAttribute = FlexBoxSpecAttribute(
        box: BoxSpecAttribute(
          alignment: Alignment.center,
          padding: EdgeInsetsGeometryDto.only(
            top: 20,
            bottom: 20,
            left: 20,
            right: 20,
          ),
          margin: EdgeInsetsGeometryDto.only(
            top: 10,
            bottom: 10,
            left: 10,
            right: 10,
          ),
          constraints: BoxConstraintsDto(maxHeight: 100),
          decoration: BoxDecorationDto(color: Colors.blue),
          transform: Matrix4.identity(),
          clipBehavior: Clip.antiAlias,
          width: 100,
          height: 100,
        ),
        flex: FlexSpecAttribute(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          verticalDirection: VerticalDirection.down,
          textDirection: TextDirection.ltr,
          textBaseline: TextBaseline.alphabetic,
        ),
      );

      expect(
        flexBoxSpecAttribute,
        isNot(
          equals(
            FlexBoxSpecAttribute(
              box: BoxSpecAttribute(
                alignment: Alignment.centerLeft,
                padding: EdgeInsetsGeometryDto.only(
                  top: 30,
                  bottom: 30,
                  left: 30,
                  right: 30,
                ),
                margin: EdgeInsetsGeometryDto.only(
                  top: 20,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                constraints: BoxConstraintsDto(maxHeight: 200),
                decoration: BoxDecorationDto(color: Colors.red),
                transform: Matrix4.identity(),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                width: 200,
                height: 200,
                modifiers: WidgetModifiersConfigDto(const [
                  OpacityModifierSpecAttribute(opacity: 0.4),
                  SizedBoxModifierSpecAttribute(height: 20, width: 10),
                ]),
              ),
              flex: FlexSpecAttribute(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                verticalDirection: VerticalDirection.up,
                textDirection: TextDirection.rtl,
                textBaseline: TextBaseline.ideographic,
              ),
            ),
          ),
        ),
      );
    });
  });
}
