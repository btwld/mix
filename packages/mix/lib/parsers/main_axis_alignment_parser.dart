import 'package:flutter/material.dart';

import 'base/parser_base.dart';

/// Parser for MainAxisAlignment enum following KISS principle
class MainAxisAlignmentParser implements Parser<MainAxisAlignment> {
  static const instance = MainAxisAlignmentParser();

  const MainAxisAlignmentParser();

  @override
  Object? encode(MainAxisAlignment? value) {
    if (value == null) return null;

    return switch (value) {
      MainAxisAlignment.start => 'start',
      MainAxisAlignment.end => 'end',
      MainAxisAlignment.center => 'center',
      MainAxisAlignment.spaceBetween => 'spaceBetween',
      MainAxisAlignment.spaceAround => 'spaceAround',
      MainAxisAlignment.spaceEvenly => 'spaceEvenly',
    };
  }

  @override
  MainAxisAlignment? decode(Object? json) {
    if (json == null) return null;

    return switch (json) {
      'start' => MainAxisAlignment.start,
      'end' => MainAxisAlignment.end,
      'center' => MainAxisAlignment.center,
      'spaceBetween' => MainAxisAlignment.spaceBetween,
      'spaceAround' => MainAxisAlignment.spaceAround,
      'spaceEvenly' => MainAxisAlignment.spaceEvenly,
      _ => null,
    };
  }
}
