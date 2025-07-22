import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('FlexBoxSpecAttribute', () {
    test('Constructor assigns correct properties', () {
      final flexBoxSpecAttribute = FlexBoxSpecAttribute(
        box: BoxSpecAttribute(
          alignment: Alignment.center,
          padding: EdgeInsetsGeometryMix.only(
            top: 20,
            bottom: 20,
            left: 20,
            right: 20,
          ),
          margin: EdgeInsetsGeometryMix.only(
            top: 10,
            bottom: 10,
            left: 10,
            right: 10,
          ),
          constraints: BoxConstraintsMix(maxHeight: 100),
          decoration: BoxDecorationMix(color: Colors.blue),
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

      expect(flexBoxSpecAttribute.box!.alignment, resolvesTo(Alignment.center));
      expect(
        flexBoxSpecAttribute.box!.clipBehavior,
        resolvesTo(Clip.antiAlias),
      );

      expect(
        flexBoxSpecAttribute.box!.constraints,
        resolvesTo(const BoxConstraints(maxHeight: 100)),
      );
      expect(
        flexBoxSpecAttribute.box!.decoration?.mixValue,
        BoxDecorationMix(color: Colors.blue),
      );

      expect(flexBoxSpecAttribute.box!.height, resolvesTo(100));
      expect(
        flexBoxSpecAttribute.box!.margin?.mixValue,
        EdgeInsetsGeometryMix.only(top: 10, bottom: 10, left: 10, right: 10),
      );
      expect(
        flexBoxSpecAttribute.box!.padding?.mixValue,
        EdgeInsetsGeometryMix.only(top: 20, bottom: 20, left: 20, right: 20),
      );
      expect(
        flexBoxSpecAttribute.box!.transform,
        resolvesTo(Matrix4.identity()),
      );
      expect(flexBoxSpecAttribute.box!.width, resolvesTo(100));

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
          padding: EdgeInsetsGeometryMix.only(
            top: 20,
            bottom: 20,
            left: 20,
            right: 20,
          ),
          margin: EdgeInsetsGeometryMix.only(
            top: 10,
            bottom: 10,
            left: 10,
            right: 10,
          ),
          constraints: BoxConstraintsMix(maxHeight: 100),
          decoration: BoxDecorationMix(color: Colors.blue),
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

      final resolved = flexBoxSpecAttribute.resolve(MockBuildContext());
      expect(resolved, isA<FlexBoxSpec>());
      expect(resolved.box.alignment, Alignment.center);
      expect(resolved.box.padding, const EdgeInsets.all(20));
      expect(resolved.box.margin, const EdgeInsets.all(10));
      expect(resolved.box.constraints, const BoxConstraints(maxHeight: 100));
      expect(resolved.box.decoration, const BoxDecoration(color: Colors.blue));
      expect(resolved.box.clipBehavior, Clip.antiAlias);
      expect(resolved.box.width, 100);
      expect(resolved.box.height, 100);
      expect(resolved.flex.mainAxisAlignment, MainAxisAlignment.center);
      expect(resolved.flex.crossAxisAlignment, CrossAxisAlignment.center);
      expect(resolved.flex.mainAxisSize, MainAxisSize.max);
      expect(resolved.flex.verticalDirection, VerticalDirection.down);
      expect(resolved.flex.textDirection, TextDirection.ltr);
      expect(resolved.flex.textBaseline, TextBaseline.alphabetic);
    });

    // merge()
    test('merge() returns correct instance', () {
      final flexBoxSpecAttribute = FlexBoxSpecAttribute(
        box: BoxSpecAttribute(
          alignment: Alignment.center,
          padding: EdgeInsetsGeometryMix.only(
            top: 20,
            bottom: 20,
            left: 20,
            right: 20,
          ),
          margin: EdgeInsetsGeometryMix.only(
            top: 10,
            bottom: 10,
            left: 10,
            right: 10,
          ),
          constraints: BoxConstraintsMix(maxHeight: 100),
          decoration: BoxDecorationMix(color: Colors.blue),
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

      final mergedFlexBoxSpecAttribute = flexBoxSpecAttribute.merge(
        FlexBoxSpecAttribute(
          box: BoxSpecAttribute(
            alignment: Alignment.centerLeft,
            padding: EdgeInsetsGeometryMix.only(
              top: 30,
              bottom: 30,
              left: 30,
              right: 30,
            ),
            margin: EdgeInsetsGeometryMix.only(
              top: 20,
              bottom: 20,
              left: 20,
              right: 20,
            ),
            constraints: BoxConstraintsMix(maxHeight: 200),
            decoration: BoxDecorationMix(color: Colors.red),
            transform: Matrix4.identity(),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            width: 200,
            height: 200,
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

      expect(
        mergedFlexBoxSpecAttribute.box!.alignment,
        resolvesTo(Alignment.centerLeft),
      );
      expect(
        mergedFlexBoxSpecAttribute.box!.clipBehavior,
        resolvesTo(Clip.antiAliasWithSaveLayer),
      );

      expect(
        mergedFlexBoxSpecAttribute.box!.constraints,
        resolvesTo(const BoxConstraints(maxHeight: 200)),
      );
      expect(
        mergedFlexBoxSpecAttribute.box!.decoration,
        resolvesTo(const BoxDecoration(color: Colors.red)),
      );

      expect(mergedFlexBoxSpecAttribute.box!.height, resolvesTo(200));
      expect(
        mergedFlexBoxSpecAttribute.box!.margin,
        resolvesTo(const EdgeInsets.all(20)),
      );
      expect(
        mergedFlexBoxSpecAttribute.box!.padding,
        resolvesTo(const EdgeInsets.all(30)),
      );
      expect(
        mergedFlexBoxSpecAttribute.box!.transform,
        resolvesTo(Matrix4.identity()),
      );
      expect(mergedFlexBoxSpecAttribute.box!.width, resolvesTo(200));

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
        box: BoxSpecAttribute.only(
          alignment: Alignment.center,
          padding: EdgeInsetsGeometryMix.only(
            top: 20,
            bottom: 20,
            left: 20,
            right: 20,
          ),
          margin: EdgeInsetsGeometryMix.only(
            top: 10,
            bottom: 10,
            left: 10,
            right: 10,
          ),
          constraints: BoxConstraintsMix(maxHeight: 100),
          decoration: BoxDecorationMix(color: Colors.blue),
          transform: Matrix4.identity(),
          clipBehavior: Clip.antiAlias,
          width: 100,
          height: 100,
        ),
        flex: FlexSpecAttribute.only(
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
              padding: EdgeInsetsGeometryMix.only(
                top: 20,
                bottom: 20,
                left: 20,
                right: 20,
              ),
              margin: EdgeInsetsGeometryMix.only(
                top: 10,
                bottom: 10,
                left: 10,
                right: 10,
              ),
              constraints: BoxConstraintsMix(maxHeight: 100),
              decoration: BoxDecorationMix(color: Colors.blue),
              transform: Matrix4.identity(),
              clipBehavior: Clip.antiAlias,
              width: 100,
              height: 100,
              modifiers: const [
                OpacityModifierAttribute(opacity: 0.5),
                SizedBoxModifierAttribute(height: 10, width: 10),
              ],
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
          padding: EdgeInsetsGeometryMix.only(
            top: 20,
            bottom: 20,
            left: 20,
            right: 20,
          ),
          margin: EdgeInsetsGeometryMix.only(
            top: 10,
            bottom: 10,
            left: 10,
            right: 10,
          ),
          constraints: BoxConstraintsMix(maxHeight: 100),
          decoration: BoxDecorationMix(color: Colors.blue),
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
                padding: EdgeInsetsGeometryMix.only(
                  top: 30,
                  bottom: 30,
                  left: 30,
                  right: 30,
                ),
                margin: EdgeInsetsGeometryMix.only(
                  top: 20,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                constraints: BoxConstraintsMix(maxHeight: 200),
                decoration: BoxDecorationMix(color: Colors.red),
                transform: Matrix4.identity(),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                width: 200,
                height: 200,
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
