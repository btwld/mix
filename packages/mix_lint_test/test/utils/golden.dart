// /// Taken from https://github.com/rrousselGit/riverpod/blob/master/packages/riverpod_lint_flutter_test/test/golden.dart
// ///
// /// MIT License
// ///
// /// Copyright (c) 2020 Remi Rousselet
// ///
// /// Permission is hereby granted, free of charge, to any person obtaining a copy
// /// of this software and associated documentation files (the "Software"), to deal
// /// in the Software without restriction, including without limitation the rights
// /// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// /// copies of the Software, and to permit persons to whom the Software is
// /// furnished to do so, subject to the following conditions:
// ///
// /// The above copyright notice and this permission notice shall be included in all
// /// copies or substantial portions of the Software.
// ///
// /// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// /// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// /// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// /// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// /// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// /// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// /// SOFTWARE.

// import 'dart:io';

// import 'package:analyzer/dart/analysis/results.dart';
// import 'package:analyzer/dart/analysis/utilities.dart';
// import 'package:analyzer_plugin/protocol/protocol_generated.dart';
// import 'package:custom_lint_core/custom_lint_core.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:path/path.dart';

// @Deprecated('Do not commit')
// bool goldenWrite = false;

// File writeToTemporaryFile(String content) {
//   final tempDir = Directory.systemTemp.createTempSync();
//   addTearDown(() => tempDir.deleteSync(recursive: true));

//   final file = File(join(tempDir.path, 'file.dart'))
//     ..createSync(recursive: true)
//     ..writeAsStringSync(content);

//   return file;
// }

// void testGolden(
//   String description,
//   String fileName,
//   Future<Iterable<PrioritizedSourceChange>> Function(ResolvedUnitResult unit)
//       body, {
//   required String sourcePath,
// }) {
//   test(description, () async {
//     final file = File(sourcePath).absolute;

//     final result = await resolveFile2(path: file.path);
//     result as ResolvedUnitResult;

//     final changes = await body(result).then((value) => value.toList());
//     final source = file.readAsStringSync();

//     try {
//       expect(
//         changes,
//         matcherNormalizedPrioritizedSourceChangeSnapshot(
//           fileName,
//           sources: {'**': source},
//           relativePath: Directory.current.path,
//         ),
//       );
//     } on TestFailure {
//       // ignore: deprecated_member_use_from_same_package
//       if (!goldenWrite) rethrow;

//       final source = File(sourcePath).readAsStringSync();
//       final result = encodePrioritizedSourceChanges(
//         changes,
//         sources: {'**': source},
//         relativePath: Directory.current.path,
//       );

//       final golden = File('test/$fileName');
//       golden
//         ..createSync(recursive: true)
//         ..writeAsStringSync(result);

//       return;
//     }
//   });
// }
