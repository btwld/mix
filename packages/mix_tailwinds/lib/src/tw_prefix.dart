/// Tailwind token prefix constants and helpers.
abstract final class TwPrefix {
  // Spacing
  static const padding = 'p-';
  static const paddingX = 'px-';
  static const paddingY = 'py-';
  static const paddingTop = 'pt-';
  static const paddingRight = 'pr-';
  static const paddingBottom = 'pb-';
  static const paddingLeft = 'pl-';

  static const margin = 'm-';
  static const marginX = 'mx-';
  static const marginY = 'my-';
  static const marginTop = 'mt-';
  static const marginRight = 'mr-';
  static const marginBottom = 'mb-';
  static const marginLeft = 'ml-';

  // Gaps
  static const gap = 'gap-';
  static const gapX = 'gap-x-';
  static const gapY = 'gap-y-';

  // Sizing
  static const width = 'w-';
  static const height = 'h-';
  static const minWidth = 'min-w-';
  static const minHeight = 'min-h-';

  // Colors
  static const background = 'bg-';
  static const text = 'text-';

  // Borders
  static const border = 'border-';
  static const borderTop = 'border-t-';
  static const borderRight = 'border-r-';
  static const borderBottom = 'border-b-';
  static const borderLeft = 'border-l-';
  static const borderX = 'border-x-';
  static const borderY = 'border-y-';

  // Radius
  static const rounded = 'rounded-';

  // Transforms
  static const scale = 'scale-';
  static const rotate = 'rotate-';
  static const rotateNeg = '-rotate-';
  static const translateX = 'translate-x-';
  static const translateY = 'translate-y-';
  static const translateXNeg = '-translate-x-';
  static const translateYNeg = '-translate-y-';

  // Animation
  static const duration = 'duration-';
  static const delay = 'delay-';
}

extension TwPrefixExtraction on String {
  /// Returns the suffix after [prefix], or null if this string doesn't start with it.
  String? suffixAfter(String prefix) {
    if (!startsWith(prefix)) return null;
    return substring(prefix.length);
  }
}
