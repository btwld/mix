import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/custom_matchers.dart';

void main() {
  group('BoxSpecAttribute', () {
    test('Constructor assigns correct properties', () {
      final containerSpecAttribute = BoxSpecAttribute(
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
        modifiers: WidgetModifiersConfigDto(
          modifiers: const [
            OpacityModifierSpecAttribute(opacity: 0.5),
            SizedBoxModifierSpecAttribute(height: 10, width: 10),
          ],
        ),
      );

      expect(containerSpecAttribute.alignment, Alignment.center);
      expect(containerSpecAttribute.clipBehavior, Clip.antiAlias);

      expect(
        containerSpecAttribute.constraints,
        BoxConstraintsDto(maxHeight: 100),
      );
      expect(
        containerSpecAttribute.decoration,
        BoxDecorationDto(color: Colors.blue),
      );

      expect(containerSpecAttribute.height, 100);
      expect(
        containerSpecAttribute.margin,
        EdgeInsetsGeometryDto.only(top: 10, bottom: 10, left: 10, right: 10),
      );
      expect(
        containerSpecAttribute.padding,
        EdgeInsetsGeometryDto.only(top: 20, bottom: 20, left: 20, right: 20),
      );
      expect(containerSpecAttribute.transform, Matrix4.identity());
      expect(containerSpecAttribute.width, 100);
      expect(
        containerSpecAttribute.modifiers,
        WidgetModifiersConfigDto(
          modifiers: const [
            OpacityModifierSpecAttribute(opacity: 0.5),
            SizedBoxModifierSpecAttribute(height: 10, width: 10),
          ],
        ),
      );
    });

    // resolve()
    test('resolve() returns correct instance', () {
      final containerSpecAttribute = BoxSpecAttribute(
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
        modifiers: WidgetModifiersConfigDto(
          modifiers: const [
            OpacityModifierSpecAttribute(opacity: 0.5),
            SizedBoxModifierSpecAttribute(height: 10, width: 10),
          ],
        ),
      );

      expect(
        containerSpecAttribute,
        resolvesTo(
          BoxSpec(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(
              left: 20,
              top: 20,
              right: 20,
              bottom: 20,
            ),
            margin: const EdgeInsets.only(
              left: 10,
              top: 10,
              right: 10,
              bottom: 10,
            ),
            constraints: const BoxConstraints(
              maxWidth: double.infinity,
              maxHeight: 100,
            ),
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
        ),
      );
    });

    // merge()
    test('merge() returns correct instance', () {
      final containerSpecAttribute = BoxSpecAttribute(
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
        modifiers: WidgetModifiersConfigDto(
          modifiers: const [
            OpacityModifierSpecAttribute(opacity: 0.5),
            SizedBoxModifierSpecAttribute(height: 10, width: 10),
          ],
        ),
      );

      final mergedBoxSpecAttribute = containerSpecAttribute.merge(
        BoxSpecAttribute(
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
          modifiers: WidgetModifiersConfigDto(
            modifiers: const [SizedBoxModifierSpecAttribute(width: 20)],
          ),
        ),
      );

      expect(mergedBoxSpecAttribute.alignment, Alignment.centerLeft);
      expect(mergedBoxSpecAttribute.clipBehavior, Clip.antiAliasWithSaveLayer);

      expect(
        mergedBoxSpecAttribute.constraints,
        resolvesTo(const BoxConstraints(maxHeight: 200)),
      );
      expect(
        mergedBoxSpecAttribute.decoration,
        resolvesTo(const BoxDecoration(color: Colors.red)),
      );

      expect(mergedBoxSpecAttribute.height, 200);
      expect(
        mergedBoxSpecAttribute.margin,
        resolvesTo(const EdgeInsets.all(20)),
      );
      expect(
        mergedBoxSpecAttribute.padding,
        resolvesTo(const EdgeInsets.all(30)),
      );
      expect(mergedBoxSpecAttribute.transform, Matrix4.identity());
      expect(mergedBoxSpecAttribute.width, 200);
      expect(
        mergedBoxSpecAttribute.modifiers,
        WidgetModifiersConfigDto(
          modifiers: const [
            OpacityModifierSpecAttribute(opacity: 0.5),
            SizedBoxModifierSpecAttribute(height: 10, width: 20),
          ],
        ),
      );
    });

    // equality
    test('equality', () {
      final containerSpecAttribute = BoxSpecAttribute(
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
        modifiers: WidgetModifiersConfigDto(
          modifiers: const [
            OpacityModifierSpecAttribute(opacity: 0.5),
            SizedBoxModifierSpecAttribute(height: 10, width: 10),
          ],
        ),
      );

      expect(
        containerSpecAttribute,
        equals(
          BoxSpecAttribute(
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
            modifiers: WidgetModifiersConfigDto(
              modifiers: const [
                OpacityModifierSpecAttribute(opacity: 0.5),
                SizedBoxModifierSpecAttribute(height: 10, width: 10),
              ],
            ),
          ),
        ),
      );
    });

    // not equals
    test('not equals', () {
      final containerSpecAttribute = BoxSpecAttribute(
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
      );

      expect(
        containerSpecAttribute,
        isNot(
          equals(
            BoxSpecAttribute(
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
              modifiers: WidgetModifiersConfigDto(
                modifiers: const [
                  OpacityModifierSpecAttribute(opacity: 0.4),
                  SizedBoxModifierSpecAttribute(height: 20, width: 10),
                ],
              ),
            ),
          ),
        ),
      );
    });
  });
}
