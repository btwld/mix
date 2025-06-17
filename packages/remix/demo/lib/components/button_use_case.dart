// import 'package:demo/addons/icon_data_knob.dart';
// import 'package:flutter/widgets.dart';
// import 'package:remix/remix.dart';
// import 'package:widgetbook/widgetbook.dart';
// import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

// final _key = GlobalKey();

// @widgetbook.UseCase(
//   name: 'Button Component',
//   type: RxButton,
// )
// Widget buildButtonUseCase(BuildContext context) {
//   return KeyedSubtree(
//     key: _key,
//     child: Scaffold(
//       body: Center(
//         child: Builder(builder: (context) {
//           return RxButton(
//             onPressed: () {
//               showToast(
//                 context: context,
//                 entry: ToastEntry(
//                   showDuration: const Duration(milliseconds: 800),
//                   builder: (context, actions) => const Toast(
//                     title: 'Button pressed',
//                   ),
//                 ),
//               );
//             },
//             enabled: context.knobs.boolean(
//               label: 'Enabled',
//               initialValue: true,
//             ),
//             loading: context.knobs.boolean(
//               label: 'Loading',
//               initialValue: false,
//             ),
//             // iconLeft: context.knobs.iconData(
//             //   label: 'Icon left',
//             //   initialValue: null,
//             // ),
//             // iconRight: context.knobs.iconData(
//             //   label: 'Icon right',
//             //   initialValue: null,
//             // ),
//             label: context.knobs.string(
//               label: 'label',
//               initialValue: 'Button',
//             ),
//             leadingIcon: context.knobs.iconData(
//               label: 'Icon',
//               initialValue: null,
//             ),
//           );
//         }),
//       ),
//     ),
//   );
// }
