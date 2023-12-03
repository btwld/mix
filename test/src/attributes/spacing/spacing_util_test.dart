import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix/src/attributes/spacing/spacing_dto.dart';

void main() {
  group('Padding Utils', () {
    test('padding()', () {
      expect(
        padding(10),
        const PaddingAttribute(
            SpacingDto(top: 10, bottom: 10, left: 10, right: 10)),
      );
      expect(
        padding(10, 20),
        const PaddingAttribute(
            SpacingDto(top: 10, bottom: 10, left: 20, right: 20)),
      );
      expect(
        padding(10, 20, 30),
        const PaddingAttribute(
            SpacingDto(top: 10, bottom: 30, left: 20, right: 20)),
      );
      expect(
        padding(10, 20, 30, 40),
        const PaddingAttribute(
            SpacingDto(top: 10, bottom: 30, left: 40, right: 20)),
      );
    });

    test('padding.directional()', () {
      expect(
        padding.directional(10),
        const PaddingAttribute(
            SpacingDto(start: 10, end: 10, top: 10, bottom: 10)),
        reason: '1',
      );
      expect(
        padding.directional(10, 20),
        const PaddingAttribute(
            SpacingDto(top: 10, bottom: 10, start: 20, end: 20)),
        reason: '2',
      );
      expect(
        padding.directional(10, 20, 30),
        const PaddingAttribute(
            SpacingDto(top: 10, bottom: 30, start: 20, end: 20)),
        reason: '3',
      );
      expect(
        padding.directional(10, 20, 30, 40),
        const PaddingAttribute(
            SpacingDto(top: 10, end: 20, bottom: 30, start: 40)),
        reason: '4',
      );
    });

    test('padding.from', () {
      expect(
        padding.as(const EdgeInsets.all(10)),
        const PaddingAttribute(
            SpacingDto(top: 10, bottom: 10, left: 10, right: 10)),
        reason: '1',
      );

      expect(
        padding.as(const EdgeInsets.only(top: 10)),
        const PaddingAttribute(
            SpacingDto(top: 10, bottom: 0, left: 0, right: 0)),
        reason: '2',
      );

      expect(
        padding.as(const EdgeInsets.only(left: 10)),
        const PaddingAttribute(
            SpacingDto(left: 10, bottom: 0, top: 0, right: 0)),
        reason: '3',
      );

      expect(
        padding.as(const EdgeInsets.only(right: 10)),
        const PaddingAttribute(
            SpacingDto(right: 10, bottom: 0, top: 0, left: 0)),
        reason: '4',
      );

      expect(
        padding.as(const EdgeInsets.only(bottom: 10)),
        const PaddingAttribute(
            SpacingDto(bottom: 10, top: 0, left: 0, right: 0)),
        reason: '5',
      );

      expect(
        padding.as(const EdgeInsets.symmetric(horizontal: 10)),
        const PaddingAttribute(
            SpacingDto(left: 10, right: 10, top: 0, bottom: 0)),
        reason: '6',
      );

      expect(
        padding.as(const EdgeInsets.symmetric(vertical: 10)),
        const PaddingAttribute(
            SpacingDto(top: 10, bottom: 10, left: 0, right: 0)),
        reason: '7',
      );

      expect(
        padding.directional.as(const EdgeInsetsDirectional.only(start: 10)),
        const PaddingAttribute(
            SpacingDto(start: 10, end: 0, top: 0, bottom: 0)),
        reason: '8',
      );

      expect(
        padding.directional.as(const EdgeInsetsDirectional.only(end: 10)),
        const PaddingAttribute(
            SpacingDto(end: 10, start: 0, top: 0, bottom: 0)),
        reason: '9',
      );

      expect(
        padding.directional.as(const EdgeInsetsDirectional.only(top: 10)),
        const PaddingAttribute(
            SpacingDto(top: 10, bottom: 0, start: 0, end: 0)),
        reason: '10',
      );

      expect(
        padding.directional.as(const EdgeInsetsDirectional.only(bottom: 10)),
        const PaddingAttribute(
            SpacingDto(bottom: 10, top: 0, start: 0, end: 0)),
        reason: '11',
      );

      expect(
        padding.directional
            .as(const EdgeInsetsDirectional.only(start: 10, end: 20)),
        const PaddingAttribute(
            SpacingDto(start: 10, end: 20, top: 0, bottom: 0)),
        reason: '12',
      );

      expect(
        padding.directional
            .as(const EdgeInsetsDirectional.only(start: 10, end: 20, top: 30)),
        const PaddingAttribute(
            SpacingDto(start: 10, end: 20, top: 30, bottom: 0)),
        reason: '13',
      );

      expect(
        padding.directional.as(
          const EdgeInsetsDirectional.only(
            start: 10,
            end: 20,
            top: 30,
            bottom: 40,
          ),
        ),
        const PaddingAttribute(
            SpacingDto(start: 10, end: 20, top: 30, bottom: 40)),
        reason: '14',
      );
    });

    // padding.directionalFrom

    test('padding.only', () {
      expect(
        padding.only(top: 10),
        const PaddingAttribute(SpacingDto(top: 10)),
      );

      expect(
        padding.only(left: 10),
        const PaddingAttribute(SpacingDto(left: 10)),
      );

      expect(
        padding.only(right: 10),
        const PaddingAttribute(SpacingDto(right: 10)),
      );

      expect(
        padding.only(bottom: 10),
        const PaddingAttribute(SpacingDto(bottom: 10)),
      );
    });

    test('padding.top', () {
      expect(
        padding.top(10),
        const PaddingAttribute(SpacingDto(top: 10)),
      );
    });

    test('padding.bottom', () {
      expect(
        padding.bottom(10),
        const PaddingAttribute(SpacingDto(bottom: 10)),
      );
    });

    test('padding.left', () {
      expect(
        padding.left(10),
        const PaddingAttribute(SpacingDto(left: 10)),
      );
    });

    test('padding.right', () {
      expect(
        padding.right(10),
        const PaddingAttribute(SpacingDto(right: 10)),
      );
    });

    test('padding.directional.start', () {
      expect(
        padding.directional.start(10),
        const PaddingAttribute(SpacingDto(start: 10)),
      );
    });

    test('padding.directional.end', () {
      expect(
        padding.directional.end(10),
        const PaddingAttribute(SpacingDto(end: 10)),
      );
    });

    test('padding.horizontal', () {
      expect(
        padding.horizontal(10),
        const PaddingAttribute(SpacingDto(left: 10, right: 10)),
      );
    });

    test('padding.vertical', () {
      expect(
        padding.vertical(10),
        const PaddingAttribute(SpacingDto(top: 10, bottom: 10)),
      );
    });

    test('padding.all', () {
      expect(
        padding.all(10),
        const PaddingAttribute(
            SpacingDto(top: 10, bottom: 10, left: 10, right: 10)),
      );
    });

    test('padding.directional.only', () {
      expect(
        padding.directional.only(start: 10),
        const PaddingAttribute(SpacingDto(start: 10)),
      );

      expect(
        padding.directional.only(end: 10),
        const PaddingAttribute(SpacingDto(end: 10)),
      );

      expect(
        padding.directional.only(start: 10, end: 20),
        const PaddingAttribute(SpacingDto(start: 10, end: 20)),
      );

      expect(
        padding.directional.only(start: 10, end: 20, top: 30),
        const PaddingAttribute(SpacingDto(start: 10, end: 20, top: 30)),
      );

      expect(
        padding.directional.only(start: 10, end: 20, top: 30, bottom: 40),
        const PaddingAttribute(
            SpacingDto(start: 10, end: 20, top: 30, bottom: 40)),
      );
    });
  });

  group('Margin Utils', () {
    test('margin()', () {
      expect(
        margin(10),
        const MarginAttribute(
          SpacingDto(top: 10, bottom: 10, left: 10, right: 10),
        ),
      );
      expect(
        margin(10, 20),
        const MarginAttribute(
          SpacingDto(top: 10, bottom: 10, left: 20, right: 20),
        ),
      );
      expect(
        margin(10, 20, 30),
        const MarginAttribute(
          SpacingDto(top: 10, bottom: 30, left: 20, right: 20),
        ),
      );
      expect(
        margin(10, 20, 30, 40),
        const MarginAttribute(
          SpacingDto(top: 10, bottom: 30, left: 40, right: 20),
        ),
      );
    });

    // margin.directional()
    test('margin.directional()', () {
      expect(
        margin.directional(10),
        const MarginAttribute(
          SpacingDto(
            start: 10,
            end: 10,
            top: 10,
            bottom: 10,
          ),
        ),
        reason: '1',
      );
      expect(
        margin.directional(10, 20),
        const MarginAttribute(
          SpacingDto(
            top: 10,
            bottom: 10,
            start: 20,
            end: 20,
          ),
        ),
        reason: '2',
      );
      expect(
        margin.directional(10, 20, 30),
        const MarginAttribute(
          SpacingDto(
            top: 10,
            bottom: 30,
            start: 20,
            end: 20,
          ),
        ),
        reason: '3',
      );
      expect(
        margin.directional(10, 20, 30, 40),
        const MarginAttribute(
          SpacingDto(
            top: 10,
            end: 20,
            bottom: 30,
            start: 40,
          ),
        ),
        reason: '4',
      );
    });

    test('margin.only', () {
      expect(
        margin.only(top: 10),
        const MarginAttribute(
          SpacingDto(top: 10),
        ),
      );

      expect(
        margin.only(left: 10),
        const MarginAttribute(
          SpacingDto(left: 10),
        ),
      );

      expect(
        margin.only(right: 10),
        const MarginAttribute(
          SpacingDto(right: 10),
        ),
      );

      expect(
        margin.only(bottom: 10),
        const MarginAttribute(
          SpacingDto(bottom: 10),
        ),
      );
    });

    test('margin.top', () {
      expect(
        margin.top(10),
        const MarginAttribute(
          SpacingDto(top: 10),
        ),
      );
    });

    test('margin.bottom', () {
      expect(
        margin.bottom(10),
        const MarginAttribute(
          SpacingDto(bottom: 10),
        ),
      );
    });

    test('margin.left', () {
      expect(
        margin.left(10),
        const MarginAttribute(
          SpacingDto(left: 10),
        ),
      );
    });

    test('margin.right', () {
      expect(
        margin.right(10),
        const MarginAttribute(
          SpacingDto(right: 10),
        ),
      );
    });

    test('margin.directional.start', () {
      expect(
        margin.directional.start(10),
        const MarginAttribute(
          SpacingDto(start: 10),
        ),
      );
    });

    test('margin.directional.end', () {
      expect(
        margin.directional.end(10),
        const MarginAttribute(
          SpacingDto(end: 10),
        ),
      );
    });

    test('margin.horizontal', () {
      expect(
        margin.horizontal(10),
        const MarginAttribute(
          SpacingDto(left: 10, right: 10),
        ),
      );
    });

    test('margin.vertical', () {
      expect(
        margin.vertical(10),
        const MarginAttribute(SpacingDto(top: 10, bottom: 10)),
      );
    });

    test('margin.all', () {
      expect(
        margin.all(10),
        const MarginAttribute(
          SpacingDto(top: 10, bottom: 10, left: 10, right: 10),
        ),
      );
    });

    test('margin.as', () {
      expect(
        margin.as(const EdgeInsets.all(10)),
        const MarginAttribute(
          SpacingDto(top: 10, bottom: 10, left: 10, right: 10),
        ),
      );

      expect(
        margin.as(const EdgeInsets.only(top: 10)),
        const MarginAttribute(
          SpacingDto(top: 10, bottom: 0, left: 0, right: 0),
        ),
      );

      expect(
        margin.as(const EdgeInsets.only(left: 10)),
        const MarginAttribute(
          SpacingDto(left: 10, bottom: 0, top: 0, right: 0),
        ),
      );

      expect(
        margin.as(const EdgeInsets.only(right: 10)),
        const MarginAttribute(
          SpacingDto(right: 10, bottom: 0, top: 0, left: 0),
        ),
      );

      expect(
        margin.as(const EdgeInsets.only(bottom: 10)),
        const MarginAttribute(
          SpacingDto(bottom: 10, top: 0, left: 0, right: 0),
        ),
      );

      expect(
        margin.as(const EdgeInsets.symmetric(horizontal: 10)),
        const MarginAttribute(
          SpacingDto(left: 10, right: 10, top: 0, bottom: 0),
        ),
      );

      expect(
        margin.as(const EdgeInsets.symmetric(vertical: 10)),
        const MarginAttribute(
          SpacingDto(top: 10, bottom: 10, left: 0, right: 0),
        ),
      );

      expect(
        margin.directional.as(const EdgeInsetsDirectional.only(start: 10)),
        const MarginAttribute(
          SpacingDto(start: 10, end: 0, top: 0, bottom: 0),
        ),
      );

      expect(
        margin.directional.as(const EdgeInsetsDirectional.only(end: 10)),
        const MarginAttribute(
          SpacingDto(end: 10, start: 0, top: 0, bottom: 0),
        ),
      );

      expect(
        margin.directional.as(const EdgeInsetsDirectional.only(top: 10)),
        const MarginAttribute(SpacingDto(top: 10, bottom: 0, start: 0, end: 0)),
      );

      expect(
        margin.directional.as(const EdgeInsetsDirectional.only(bottom: 10)),
        const MarginAttribute(
          SpacingDto(bottom: 10, top: 0, start: 0, end: 0),
        ),
      );

      expect(
        margin.directional
            .as(const EdgeInsetsDirectional.only(start: 10, end: 20)),
        const MarginAttribute(
          SpacingDto(start: 10, end: 20, top: 0, bottom: 0),
        ),
      );

      expect(
        margin.directional
            .as(const EdgeInsetsDirectional.only(start: 10, end: 20, top: 30)),
        const MarginAttribute(
          SpacingDto(start: 10, end: 20, top: 30, bottom: 0),
        ),
      );

      expect(
        margin.directional.as(const EdgeInsetsDirectional.only(
            start: 10, end: 20, top: 30, bottom: 40)),
        const MarginAttribute(
          SpacingDto(start: 10, end: 20, top: 30, bottom: 40),
        ),
      );
    });

    test('margin.directional.only', () {
      expect(
        margin.directional.only(start: 10),
        const MarginAttribute(
          SpacingDto(start: 10),
        ),
      );

      expect(
        margin.directional.only(end: 10),
        const MarginAttribute(
          SpacingDto(end: 10),
        ),
      );

      expect(
        margin.directional.only(start: 10, end: 20),
        const MarginAttribute(
          SpacingDto(start: 10, end: 20),
        ),
      );

      expect(
        margin.directional.only(start: 10, end: 20, top: 30),
        const MarginAttribute(
          SpacingDto(start: 10, end: 20, top: 30),
        ),
      );

      expect(
        margin.directional.only(start: 10, end: 20, top: 30, bottom: 40),
        const MarginAttribute(
          SpacingDto(start: 10, end: 20, top: 30, bottom: 40),
        ),
      );
    });
  });
}
