# Box Utilities

## $box.width

Sets the width of the box.

```dart
$box.width(200)
```

## $box.height

Sets the height of the box.

```dart
$box.height(100)
```

## $box.padding

Sets the padding of the box.

```dart
$box.padding(10);

$box.padding(10, 20);

$box.padding(10, 20, 30);

$box.padding(10, 20, 30, 40);
```

### $box.padding.all

Sets the padding of the box on all sides.

```dart
$box.padding.all(10)
```

### $box.padding.top

Sets the padding of the box on the top side.

```dart
$box.padding.top(10)
```

### $box.padding.bottom

Sets the padding of the box on the bottom side.

```dart
$box.padding.bottom(10)
```

### $box.padding.left

Sets the padding of the box on the left side.

```dart
$box.padding.left(10)
```

### $box.padding.right

Sets the padding of the box on the right side.

```dart
$box.padding.right(10)
```

### $box.padding.horizontal

Sets the padding of the box on the horizontal (left and right) sides.

```dart
$box.padding.horizontal(10)
```

### $box.padding.vertical

Sets the padding of the box on the vertical (top and bottom) sides.

```dart
$box.padding.vertical(10)
```

### $box.padding.only

Sets the padding of the box on the specified sides.

```dart
$box.padding.only(
  top: 10,
  bottom: 20,
  left: 30,
  right: 40
);
```

## Constraints

### $box.maxWidth

Sets the maximum width the box can have.

```dart
$box.maxWidth(200)
```

### $box.minWidth

Sets the minimum width the box must have.

```dart
$box.minWidth(100)
```

### $box.maxHeight

Sets the maximum height the box can have.

```dart
$box.maxHeight(200)
```

### $box.minHeight

Sets the minimum height the box must have.

```dart
$box.minHeight(100)
```

## $box.color

Sets the background color of the box.

```dart
$box.color(Colors.blue)
$box.color.blue()
```

## $box.elevation

Sets the elevation of the box.

```dart
// Elevation can be 0, 1, 2, 3, 4, 6, 8, 9, 12, 16, 24
$box.elevation(2)
```

## $box.alignment

Sets the alignment of the box.

```dart
// You can pass the alignment into the utility
$box.alignment(Alignment.center);

// Or you can use the alignment utility
$box.alignment.center();
$box.alignment.centerLeft();
$box.alignment.centerRight();
$box.alignment.topLeft();
$box.alignment.topCenter();
$box.alignment.topRight();
$box.alignment.bottomLeft();
$box.alignment.bottomCenter();
$box.alignment.bottomRight();
```

## $box.clipBehavior

Sets the clip behavior of the box.

```dart
// You can pass the clip into the utility
$box.clipBehavior(Clip.hardEdge)
$box.clipBehavior.none();
$box.clipBehavior.hardEdge();
$box.clipBehavior.antiAlias();
$box.clipBehavior.antiAliasWithSaveLayer();
```

## Decoration

### $box.border

Defines the border of a Box. Equivalent to `BoxDecoration.border`, in a `Container`

#### $box.border()

Styles all sides of `Border`.

```dart
$box.border(
  color: Colors.red,
  width: 2,
  style: BorderStyle.solid,
  strokeAlign: 0.5
);
```

#### $box.border.all

Styles all sides of `Border`.

```dart
$box.border.all.color.red();
$box.border.all.width(2);
$box.border.all.style.solid();
$box.border.all.strokeAlign(0.5);
```

#### $box.border.top

Styles the top side of `Border`.

```dart
$box.border.top.color.red();
$box.border.top.width(2);
$box.border.top.style.solid();
$box.border.top.strokeAlign(0.5);
```

#### $box.border.bottom

Styles the bottom side of `Border`.

```dart
$box.border.bottom.color.red();
$box.border.bottom.width(2);
$box.border.bottom.style.solid();
$box.border.bottom.strokeAlign(0.5);
```

#### $box.border.left

Styles the left side of `Border`.

```dart
$box.border.left.color.red();
$box.border.left.width(2);
$box.border.left.style.solid();
$box.border.left.strokeAlign(0.5);
```

#### $box.border.right

Styles the right side`Border`.

```dart
$box.border.right.color.red();
$box.border.right.width(2);
$box.border.right.style.solid();
$box.border.right.strokeAlign(0.5);
```

#### $box.border.start

Styles the start side of `BorderDirectional`.

```dart
$box.border.start.color.red();
$box.border.start.width(2);
$box.border.start.style.solid();
$box.border.start.strokeAlign(0.5);
```

#### $box.border.end

Styles the end side of `BorderDirectional`.

```dart
$box.border.end.color.red();
$box.border.end.width(2);
$box.border.end.style.solid();
$box.border.end.strokeAlign(0.5);
```

#### $box.border.horizontal

Styles the horizontal (top and bottom) sides of `Border`.

```dart
$box.border.horizontal.color.red();
$box.border.horizontal.width(2);
$box.border.horizontal.style.solid();
$box.border.horizontal.strokeAlign(0.5);
```

#### $box.border.vertical

Styles the vertical (left and right) sides of `Border`.

```dart
$box.border.vertical.color.red();
$box.border.vertical.width(2);
$box.border.vertical.style.solid();
$box.border.vertical.strokeAlign(0.5);
```

### $box.borderDirectional

Defines the `BorderDirectional` of a Box. Equivalent to `BoxDecoration.border`, in a `Container`

### $box.borderDirectional()

Styles all sides of `BorderDirectional`.

```dart
$box.borderDirectional(
  color: Colors.red,
  width: 2,
  style: BorderStyle.solid,
  strokeAlign: 0.5
);
```

#### $box.borderDirectional.all

Styles all sides of `BorderDirectional`.

```dart
$box.borderDirectional.all.color.red();
$box.borderDirectional.all.width(2);
$box.borderDirectional.all.style.solid();
$box.borderDirectional.all.strokeAlign(0.5);
```

#### $box.borderDirectional.top

Styles the top side `BorderDirectional`.

```dart
$box.borderDirectional.top.color.red();
$box.borderDirectional.top.width(2);
$box.borderDirectional.top.style.solid();
$box.borderDirectional.top.strokeAlign(0.5);
```

#### $box.borderDirectional.bottom

Styles the bottom side of `BorderDirectional`.

```dart
$box.borderDirectional.bottom.color.red();
$box.borderDirectional.bottom.width(2);
$box.borderDirectional.bottom.style.solid();
$box.borderDirectional.bottom.strokeAlign(0.5);
```

#### $box.borderDirectional.start

Styles the start side of `BorderDirectional`.

```dart
$box.borderDirectional.start.color.red();
$box.borderDirectional.start.width(2);
$box.borderDirectional.start.style.solid();
$box.borderDirectional.start.strokeAlign(0.5);
```

#### $box.borderDirectional.end

Styles the end side of `BorderDirectional`.

```dart
$box.borderDirectional.end.color.red();
$box.borderDirectional.end.width(2);
$box.borderDirectional.end.style.solid();
$box.borderDirectional.end.strokeAlign(0.5);
```

#### $box.borderDirectional.horizontal

Styles the horizontal (start and end) sides of `BorderDirectional`.

```dart
$box.borderDirectional.horizontal.color.red();
$box.borderDirectional.horizontal.width(2);
$box.borderDirectional.horizontal.style.solid();
$box.borderDirectional.horizontal.strokeAlign(0.5);
```

#### $box.borderDirectional.vertical

Styles the vertical (top and bottom) sides of `BorderDirectional`.

```dart
$box.borderDirectional.vertical.color.red();
$box.borderDirectional.vertical.width(2);
$box.borderDirectional.vertical.style.solid();
$box.borderDirectional.vertical.strokeAlign(0.5);
```

### $box.borderRadius

Styles `Radius` the corners of a `BorderRadiusGeometry` of a `BoxDecoration.$box.borderRadius`.

```dart
// BorderRadius all: Radius.circular(10)
$box.borderRadius(10);

// BorderRadius topLeft and topRight: Radius.circular(10), bottomLeft and bottomRight: Radius.circular(20)
$box.borderRadius(10, 20);

// BorderRadius topLeft: Radius.circular(10), topRight and bottomLeft: Radius.circular(20), bottomRight: Radius.circular(30)
$box.borderRadius(10, 20, 30);

// BorderRadius topLeft: Radius.circular(10), topRight: Radius.circular(20), bottomLeft: Radius.circular(30), bottomRight: Radius.circular(40)
$box.borderRadius(10, 20, 30, 40);

/// BorderRadius all: Radius.circular(10)
$box.borderRadius.circular(10);

/// BorderRadius all: Radius.elliptical(10, 20)
$box.borderRadius.elliptical(10, 20);

/// BorderRadius all: Radius.zero
$box.borderRadius.zero();
```

#### $box.borderRadius.all

Styles a uniform `BorderRadius` of a `BoxDecoration.$box.borderRadius`.

```dart
$box.borderRadius.all(10);
$box.borderRadius.all.circular(10);
$box.borderRadius.all.elliptical(10, 20);
$box.borderRadius.all.zero();
```

#### $box.borderRadius.topLeft

Styles the topLeft `BorderRadius` of a `BoxDecoration.$box.borderRadius`.

```dart
$box.borderRadius.topLeft(10);
$box.borderRadius.topLeft.circular(10);
$box.borderRadius.topLeft.elliptical(10, 20);
$box.borderRadius.topLeft.zero();
```

#### $box.borderRadius.topRight

Styles the topRight `BorderRadius` of a `BoxDecoration.$box.borderRadius`.

```dart
$box.borderRadius.topRight(10);
$box.borderRadius.topRight.circular(10);
$box.borderRadius.topRight.elliptical(10, 20);
$box.borderRadius.topRight.zero();
```

#### $box.borderRadius.bottomLeft

Styles the bottomLeft `BorderRadius` of a `BoxDecoration.$box.borderRadius`.

```dart
$box.borderRadius.bottomLeft(10);
$box.borderRadius.bottomLeft.circular(10);
$box.borderRadius.bottomLeft.elliptical(10, 20);
$box.borderRadius.bottomLeft.zero();
```

#### $box.borderRadius.bottomRight

Styles the bottomRight `BorderRadius` of a `BoxDecoration.$box.borderRadius`.

```dart
$box.borderRadius.bottomRight(10);
$box.borderRadius.bottomRight.circular(10);
$box.borderRadius.bottomRight.elliptical(10, 20);
$box.borderRadius.bottomRight.zero();
```

#### $box.borderRadius.topStart

Styles the topStart `BorderRadiusDirectional` of a `BoxDecoration.$box.borderRadius`.

```dart
$box.borderRadius.topStart(10);
$box.borderRadius.topStart.circular(10);
$box.borderRadius.topStart.elliptical(10, 20);
$box.borderRadius.topStart.zero();
```

#### $box.borderRadius.topEnd

Styles the topEnd `BorderRadiusDirectional` of a `BoxDecoration.$box.borderRadius`.

```dart
$box.borderRadius.topEnd(10);
$box.borderRadius.topEnd.circular(10);
$box.borderRadius.topEnd.elliptical(10, 20);
$box.borderRadius.topEnd.zero();
```

#### $box.borderRadius.bottomStart

Styles the bottomStart `BorderRadiusDirectional` of a `BoxDecoration.$box.borderRadius`.

```dart
$box.borderRadius.bottomStart(10);
$box.borderRadius.bottomStart.circular(10);
$box.borderRadius.bottomStart.elliptical(10, 20);
$box.borderRadius.bottomStart.zero();
```

#### $box.borderRadius.bottomEnd

Styles the bottomEnd `BorderRadiusDirectional` of a `BoxDecoration.$box.borderRadius`.

```dart
$box.borderRadius.bottomEnd(10);
$box.borderRadius.bottomEnd.circular(10);
$box.borderRadius.bottomEnd.elliptical(10, 20);
$box.borderRadius.bottomEnd.zero();
```

#### $box.borderRadius.top

Styles the top (topLeft and topRight) `BorderRadius` of a `BoxDecoration.$box.borderRadius`.

```dart
$box.borderRadius.top(10);
$box.borderRadius.top.circular(10);
$box.borderRadius.top.elliptical(10, 20);
$box.borderRadius.top.zero();
```

#### $box.borderRadius.bottom

Styles the bottom (bottomLeft and bottomRight) `BorderRadius` of a `BoxDecoration.$box.borderRadius`.

```dart
$box.borderRadius.bottom(10);
$box.borderRadius.bottom.circular(10);
$box.borderRadius.bottom.elliptical(10, 20);
$box.borderRadius.bottom.zero();
```

#### $box.borderRadius.left

Styles the left (topLeft and bottomLeft) `BorderRadius` of a `BoxDecoration.$box.borderRadius`.

```dart
$box.borderRadius.left(10);
$box.borderRadius.left.circular(10);
$box.borderRadius.left.elliptical(10, 20);
$box.borderRadius.left.zero();
```

#### $box.borderRadius.right

Styles the right (topRight and bottomRight) `BorderRadius` of a `BoxDecoration.$box.borderRadius`.

```dart
$box.borderRadius.right(10);
$box.borderRadius.right.circular(10);
$box.borderRadius.right.elliptical(10, 20);
$box.borderRadius.right.zero();
```

#### $box.borderRadius.only

The same as calling `BorderRadius.only` of a `BoxDecoration.$box.borderRadius`.

```dart
$box.borderRadius.only(
  topLeft: Radius.circular(10),
  topRight: Radius.circular(20),
  bottomLeft: Radius.circular(30),
  bottomRight: Radius.circular(40)
);
```

### $box.borderRadiusDirectional

Styles the `BorderRadiusDirectional` of a `BoxDecoration.$box.borderRadius`.

```dart
// BorderRadiusDirectional.all(Radius.circular(10));
$box.borderRadiusDirectional(10);

// BorderRadiusDirectional.only(topStart: Radius.circular(10), topEnd: Radius.circular(20), bottomStart: Radius.circular(10), bottomEnd: Radius.circular(20));
$box.borderRadiusDirectional(10, 20);

// Applies 10 to topStart, 20 to topEnd and bottomStart, 30 to bottomEnd
// BorderRadiusDirectional.only(topStart: Radius.circular(10), topEnd: Radius.circular(20), bottomStart: Radius.circular(30), bottomEnd: Radius.circular(20));
$box.borderRadiusDirectional(10, 20, 30);

// BorderRadiusDirectional.only(topStart: Radius.circular(10), topEnd: Radius.circular(20), bottomStart: Radius.circular(30), bottomEnd: Radius.circular(40));
$box.borderRadiusDirectional(10, 20, 30, 40);

$box.borderRadiusDirectional.circular(10);
$box.borderRadiusDirectional.elliptical(10, 20);
$box.borderRadiusDirectional.zero();
```

#### $box.borderRadiusDirectional.all

Styles the `BorderRadiusDirectional.all` of a `BoxDecoration.$box.borderRadius`.

```dart
$box.borderRadiusDirectional.all(10);
$box.borderRadiusDirectional.all.circular(10);
$box.borderRadiusDirectional.all.elliptical(10, 20);
$box.borderRadiusDirectional.all.zero();
```

#### $box.borderRadiusDirectional.topStart

Styles the `BorderRadiusDirectional.topStart` of a `BoxDecoration.$box.borderRadius`.

```dart
$box.borderRadiusDirectional.topStart(10);
$box.borderRadiusDirectional.topStart.circular(10);
$box.borderRadiusDirectional.topStart.elliptical(10, 20);
$box.borderRadiusDirectional.topStart.zero();
```

#### $box.borderRadiusDirectional.topEnd

Styles the `BorderRadiusDirectional.topEnd` of a `BoxDecoration.$box.borderRadius`.

```dart
$box.borderRadiusDirectional.topEnd(10);
$box.borderRadiusDirectional.topEnd.circular(10);
$box.borderRadiusDirectional.topEnd.elliptical(10, 20);
$box.borderRadiusDirectional.topEnd.zero();
```

#### $box.borderRadiusDirectional.bottomStart

Styles the `BorderRadiusDirectional.bottomStart` of a `BoxDecoration.$box.borderRadius`.

```dart
$box.borderRadiusDirectional.bottomStart(10);
$box.borderRadiusDirectional.bottomStart.circular(10);
$box.borderRadiusDirectional.bottomStart.elliptical(10, 20);
$box.borderRadiusDirectional.bottomStart.zero();
```

#### $box.borderRadiusDirectional.bottomEnd

Styles the `BorderRadiusDirectional.bottomEnd` of a `BoxDecoration.$box.borderRadius`.

```dart
$box.borderRadiusDirectional.bottomEnd(10);
$box.borderRadiusDirectional.bottomEnd.circular(10);
$box.borderRadiusDirectional.bottomEnd.elliptical(10, 20);
$box.borderRadiusDirectional.bottomEnd.zero();
```

#### $box.borderRadiusDirectional.top

Styles the (topStart and topEnd) of a `BoxDecoration.$box.borderRadius`.

```dart
$box.borderRadiusDirectional.top(10);
$box.borderRadiusDirectional.top.circular(10);
$box.borderRadiusDirectional.top.elliptical(10, 20);
$box.borderRadiusDirectional.top.zero();
```

#### $box.borderRadiusDirectional.bottom

Styles the (bottomStart and bottomEnd) of a `BoxDecoration.$box.borderRadius`.

```dart
$box.borderRadiusDirectional.bottom(10);
$box.borderRadiusDirectional.bottom.circular(10);
$box.borderRadiusDirectional.bottom.elliptical(10, 20);
$box.borderRadiusDirectional.bottom.zero();
```

#### $box.borderRadiusDirectional.start

Styles (topStart and bottomStart) `BorderRadiusDirectional` of a `BoxDecoration.$box.borderRadius`.

```dart
$box.borderRadiusDirectional.start(10);
$box.borderRadiusDirectional.start.circular(10);
$box.borderRadiusDirectional.start.elliptical(10, 20);
$box.borderRadiusDirectional.start.zero();
```

#### $box.borderRadiusDirectional.end

Styles (topEnd and bottomEnd) `BorderRadiusDirectional` of a `BoxDecoration.$box.borderRadius`.

```dart
$box.borderRadiusDirectional.end(10);
$box.borderRadiusDirectional.end.circular(10);
$box.borderRadiusDirectional.end.elliptical(10, 20);
$box.borderRadiusDirectional.end.zero();
```

#### $box.borderRadiusDirectional.only

Similar to using `BorderRadiusDirectional.only` of a `BoxDecoration.$box.borderRadius`.

```dart

$box.borderRadiusDirectional.only(
  topStart: Radius.circular(10),
  topEnd: Radius.circular(20),
  bottomStart: Radius.circular(10),
  bottomEnd: Radius.circular(20)
);
```
