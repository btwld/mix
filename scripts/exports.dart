#!/usr/bin/env dart

import 'dart:developer';
import 'dart:io';

void main(List<String> args) {
  if (args.isEmpty) {
    throw Exception('Please provide the directory path as an argument.');
  }

  final rootDirectory = Directory(args[0]);
  final libDirectory = Directory(_joinPaths(rootDirectory.path, 'lib'));
  final srcDirectory = Directory(_joinPaths(libDirectory.path, 'src'));

  final packageName = rootDirectory.absolute.parent.path.split('/').last;
  final mixFile = File(_joinPaths(libDirectory.path, '$packageName.dart'));

  if (!libDirectory.existsSync()) {
    throw Exception(
      'The lib directory (${libDirectory.path}) was not found.',
    );
  }

  _libraryExport(
    src: srcDirectory,
    lib: libDirectory,
    mixFile: mixFile,
    packageName: packageName,
  );
}

Future<void> _libraryExport({
  required Directory src,
  required Directory lib,
  required File mixFile,
  required String packageName,
}) async {
  if (mixFile.existsSync()) {
    mixFile.deleteSync();
  }
  final libOutputString = StringBuffer();
  libOutputString.write(_libAsci);

  libOutputString.writeln('library $packageName;\n');

  final fileMap = await _getImportedFilesByDirectory(src: src, lib: lib);

  // Traverse the /lib/ directory
  for (final key in fileMap.keys) {
    final importList = fileMap[key]!;
    final barrelDir = Directory(_joinPaths(src.path, key));
    final barreFile = File(_joinPaths(barrelDir.path, '$key.dart'));
    if (barreFile.existsSync()) {
      barreFile.deleteSync();
    }
    libOutputString.writeln('/// ${key.toUpperCase()}');

    final barrelOutput = StringBuffer();
    barrelOutput.write(_generatedMessage);
    for (final import in importList) {
      libOutputString.writeln('export \'$import\';');
    }
  }

  mixFile.writeAsStringSync(libOutputString.toString());

  log('Exports file updated with ${libOutputString.length} exports.');
}

bool _isInternal(String path) {
  return path.contains('/internal/');
}

bool _isDartFile(String path) {
  return path.endsWith('.dart');
}

String _joinPaths(String path1, String path2, [String? path3, String? path4]) {
  return [path1, path2, path3, path4]
      .where((e) => e != null)
      .join(Platform.pathSeparator);
}

String _getRelativePath(String filePath, String fromPath) {
  // Normalize both paths to use the POSIX path separator
  final String normalizedFilePath = filePath.replaceAll('\\', '/');
  final String normalizedFromPath = fromPath.replaceAll('\\', '/');

  // Split the paths into components
  final List<String> fileComponents = normalizedFilePath.split('/');
  final List<String> fromComponents = normalizedFromPath.split('/');

  // Find the common prefix between the paths
  int commonPrefixLength = 0;
  while (commonPrefixLength < fileComponents.length &&
      commonPrefixLength < fromComponents.length &&
      fileComponents[commonPrefixLength] ==
          fromComponents[commonPrefixLength]) {
    commonPrefixLength++;
  }

  // Build the relative path
  final List<String> relativePath = [];

  // Add '..' for each remaining component in fromPath
  for (int i = commonPrefixLength; i < fromComponents.length; i++) {
    relativePath.add('..');
  }

  // Add the remaining components from filePath
  for (int i = commonPrefixLength; i < fileComponents.length; i++) {
    relativePath.add(fileComponents[i]);
  }

  // Join the relative path components
  return relativePath.join('/');
}

Future<Map<String, List<String>>> _getImportedFilesByDirectory({
  required Directory src,
  required Directory lib,
}) async {
  final result = <String, List<String>>{};

  final filesList = await _getFilesInDirectory(src);

  // Order the files alphabetically
  filesList.sort((a, b) => a.compareTo(b));

  for (final filePath in filesList) {
    if (!_isDartFile(filePath)) {
      continue;
    }
    if (_isInternal(filePath)) {
      continue;
    }

    if (_isPartOfFile(filePath)) {
      continue;
    }

    final relativePath = _getRelativePath(filePath, lib.path);
    // file path will like this src/theme/mix_theme.dart, or src/sub1/**/*/*.dart
    // I would like to get sub1 and or the first direcotry and save as a variable
    // so I can use it in the export file.
    const dirIndex = 1;
    final dirName = relativePath.split('/')[dirIndex];

    result.putIfAbsent(dirName, () => []);
    result[dirName]!.add(relativePath);
  }

  return result;
}

Future<List<String>> _getFilesInDirectory(Directory directory) async {
  final List<String> filePaths = [];

  await for (final FileSystemEntity entity in directory.list(recursive: true)) {
    if (entity is File) {
      filePaths.add(entity.path);
    }
  }

  return filePaths;
}

bool _isPartOfFile(String filePath) {
  final file = File(filePath);
  final contentLines = file.readAsLinesSync();

  return contentLines.any((element) => element.startsWith('part of '));
}

const _libAsci = r'''
///   /\\\\            /\\\\  /\\\\\\\\\\\  /\\\       /\\\              
///   \/\\\\\\        /\\\\\\ \/////\\\///  \///\\\   /\\\/  
///    \/\\\//\\\    /\\\//\\\     \/\\\       \///\\\\\\/    
///     \/\\\\///\\\/\\\/ \/\\\     \/\\\         \//\\\\      
///      \/\\\  \///\\\/   \/\\\     \/\\\          \/\\\\      
///       \/\\\    \///     \/\\\     \/\\\          /\\\\\\     
///        \/\\\             \/\\\     \/\\\        /\\\////\\\   
///         \/\\\             \/\\\  /\\\\\\\\\\\  /\\\/   \///\\\ 
///          \///              \///  \///////////  \///       \/// 
///
///                        https://fluttermix.com 
/// 
///             /\///////////////////////////////////////////////////\
///             \/\           ***** GENERATED CODE *****            \ \
///              \/\            ** DO NOT EDIT THIS FILE **          \ \
///               \/\             Generated with barrel script        \ \
///                \/////////////////////////////////////////////////////

''';

const _generatedMessage = r'''
//  /\///////////////////////////////////////////////\
//  \/\         ***** GENERATED CODE *****          \ \
//   \/\          ** DO NOT EDIT THIS FILE **        \ \
//    \/\          Generated with barrel script      \ \
//     \/////////////////////////////////////////////////

''';
