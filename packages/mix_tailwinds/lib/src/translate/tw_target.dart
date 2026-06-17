/// Target inference helpers shared by parser facade and widgets.
library;

import '../tw_utils.dart';

enum TwTarget { box, flexBox, text }

final _whitespaceRegex = RegExp(r'\s+');

const _boxUtilityPrefixes = [
  'p-',
  'px-',
  'py-',
  'pt-',
  'pr-',
  'pb-',
  'pl-',
  'bg-',
  'border',
  'rounded',
  'shadow',
  'opacity-',
  'blur',
];

bool hasBoxUtilities(String classNames) {
  final tokens = classNames.trim().isEmpty
      ? const <String>[]
      : classNames.trim().split(_whitespaceRegex);
  for (final token in tokens) {
    final base = baseTokenOutsideBrackets(token);
    for (final prefix in _boxUtilityPrefixes) {
      if (base.startsWith(prefix) || base == prefix.replaceAll('-', '')) {
        return true;
      }
    }
  }

  return false;
}

bool wantsFlex(Set<String> tokens) {
  for (final token in tokens) {
    final base = baseTokenOutsideBrackets(token);
    if (base == 'flex' || base == 'flex-row' || base == 'flex-col') {
      return true;
    }
    if (base.startsWith('items-') ||
        base.startsWith('justify-') ||
        base.startsWith('gap-') ||
        base == 'gap') {
      return true;
    }
  }

  return false;
}
