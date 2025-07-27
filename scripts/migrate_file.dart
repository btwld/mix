import 'dart:io';

import 'package:path/path.dart' as path;

/// Single file migration tool with comprehensive import handling
///
/// Usage: dart scripts/migrate_file.dart --from=lib/src/old.dart --to=lib/src/new.dart

// Comprehensive import/export pattern that handles all Dart syntax variations
final importExportPattern = RegExp(
  r'''(import|export)\s+(['"])([^'"]+)\2(?:\s+(?:deferred\s+)?as\s+\w+)?(?:\s+(?:show|hide)\s+[^;]+)?(?:\s+if\s*\([^)]+\)\s*[^;]+)?;''',
  multiLine: true,
);

// Pattern for part/part of statements
final partPattern = RegExp(
  r'''(part|part\s+of)\s+(['"])([^'"]+)\2\s*;''',
  multiLine: true,
);

void main(List<String> args) async {
  final argParser = ArgParser()
    ..addOption('from', abbr: 'f', mandatory: true, help: 'Source file path')
    ..addOption('to', abbr: 't', mandatory: true, help: 'Destination file path')
    ..addFlag('dry-run', abbr: 'd', help: 'Preview changes without applying')
    ..addFlag('skip-test', help: 'Skip test file migration')
    ..addFlag('verbose', abbr: 'v', help: 'Verbose output');

  try {
    final results = argParser.parse(args);
    final migrator = FileMigrator(
      from: results['from'],
      to: results['to'],
      isDryRun: results['dry-run'],
      skipTest: results['skip-test'],
      verbose: results['verbose'],
    );

    await migrator.migrate();
  } catch (e) {
    print('Error: $e');
    print('\nUsage: dart migrate_file.dart --from=<path> --to=<path>');
    exit(1);
  }
}

class FileMigrator {
  static const String packageName = 'mix';
  static const String libRoot = 'lib';
  static const String testRoot = 'test';
  static const String srcSubdir = 'src';
  static const String testSuffix = '_test.dart';
  static const List<String> excludedExtensions = ['.g.dart', '.freezed.dart'];

  static const Map<String, Map<String, dynamic>> specialCases = {
    'widget_state_provider.dart': {
      'usagePattern': r'\.(disabled|hovered|pressed|focused|selected)\b',
      'extensionPath':
          'lib/src/core/extensions/widget_state_controller_ext.dart',
      'extensionFileName': 'widget_state_controller_ext.dart',
    },
  };

  final String from;
  final String to;
  final bool isDryRun;
  final bool skipTest;
  final bool verbose;

  late final String baseDir;
  final List<String> errors = [];
  final List<String> warnings = [];
  final Map<String, String> importUpdates = {};
  final Set<String> modifiedFiles = {}; // Track for reset
  final Set<String> createdFiles = {}; // Track created files
  final Set<String> deletedFiles = {}; // Track deleted files
  final Set<String> createdDirs = {}; // Track created directories

  FileMigrator({
    required this.from,
    required this.to,
    this.isDryRun = false,
    this.skipTest = false,
    this.verbose = false,
  }) {
    // Determine base directory
    baseDir = _findBaseDir();
  }

  Future<void> migrate() async {
    print('🚀 Migrating file: $from → $to\n');

    if (isDryRun) {
      print('🔍 DRY RUN MODE - No files will be modified\n');
    } else {
      // Check for no unstaged changes
      final gitStatus = await Process.run('git', [
        'status',
        '--porcelain',
      ], workingDirectory: baseDir);
      if (gitStatus.stdout.toString().trim().isNotEmpty) {
        throw Exception(
          'Unstaged changes detected. Please commit or stash before migration.',
        );
      }
    }

    // Validate source file exists
    final sourceFile = File(path.join(baseDir, from));
    if (!await sourceFile.exists()) {
      throw Exception('Source file not found: $from');
    }

    try {
      // Phase 1: Analyze the file movement
      await analyzeFileMigration();

      // Phase 2: Move the main file and update its imports
      await migrateMainFile();

      // Phase 3: Move the test file if it exists
      if (!skipTest) {
        await migrateTestFile();
      }

      // Phase 4: Update imports in all files that reference the moved file
      await updateProjectImports();

      // Phase 5: Handle special cases
      await handleSpecialCases();

      // Phase 6: Validate the migration
      await validateMigration();

      // Report results
      generateReport();
    } catch (e) {
      // If any error occurs, revert all changes
      if (!isDryRun) {
        print('\n⚠️  Error occurred: $e');
        print('🔄 Reverting all changes...');
        await _revertAllChanges();
        print('✅ Revert complete.');
      }
      rethrow;
    }
  }

  Future<void> analyzeFileMigration() async {
    if (verbose) print('📋 Analyzing file migration...\n');

    // Build import mappings for this specific file movement
    final oldPackageImport = from.replaceFirst(
      '$libRoot/',
      'package:$packageName/',
    );
    final newPackageImport = to.replaceFirst(
      '$libRoot/',
      'package:$packageName/',
    );

    importUpdates[oldPackageImport] = newPackageImport;
    importUpdates[from.replaceFirst('$libRoot/', '')] = to.replaceFirst(
      '$libRoot/',
      '',
    );

    // Add relative import mappings
    final fileName = path.basename(from);
    importUpdates[fileName] = to.replaceFirst('$libRoot/', '');
  }

  Future<void> migrateMainFile() async {
    print('📦 Moving main file...');

    final sourceFile = File(path.join(baseDir, from));
    final targetFile = File(path.join(baseDir, to));

    // Read file content
    var content = await sourceFile.readAsString();

    // Update imports in the file based on its new location
    content = await updateFileImportsForNewLocation(content, from, to);

    if (!isDryRun) {
      // Create target directory
      if (!await targetFile.parent.exists()) {
        await targetFile.parent.create(recursive: true);
        createdDirs.add(targetFile.parent.path);
      }

      // Write updated content to new location
      await targetFile.writeAsString(content);
      createdFiles.add(targetFile.path);

      // Delete old file
      await sourceFile.delete();
      deletedFiles.add(sourceFile.path);
    }

    print('   ✅ Moved and updated imports\n');
  }

  Future<String> updateFileImportsForNewLocation(
    String content,
    String oldPath,
    String newPath,
  ) async {
    final imports = parseImports(content);

    for (final import in imports) {
      if (import.isRelative) {
        // Calculate the absolute path of the imported file from old location
        final oldDir = path.dirname(oldPath);
        final importedPath = path.normalize(path.join(oldDir, import.path));

        // Calculate new relative path from new location
        final newDir = path.dirname(newPath);
        final newRelativePath = path.relative(importedPath, from: newDir);

        // Update the import
        content = updateImportInContent(content, import, newRelativePath);
      }
    }

    return content;
  }

  Future<void> updateTestImports(File testFile) async {
    var content = await testFile.readAsString();

    // Add import for the moved file if it's not already imported
    final fileName = path.basename(to).replaceAll('.dart', '');
    final packageImport =
        'package:$packageName/${to.replaceFirst('$libRoot/', '')}';

    if (!content.contains(packageImport) && !content.contains(fileName)) {
      // Find the last import
      final importRegex = RegExp(r'^import\s+.*?;', multiLine: true);
      final imports = importRegex.allMatches(content).toList();

      if (imports.isNotEmpty) {
        final lastImport = imports.last;
        final insertIndex = lastImport.end;
        content =
            content.substring(0, insertIndex) +
            '\nimport \'$packageImport\';' +
            content.substring(insertIndex);

        await testFile.writeAsString(content);
      }
    }
  }

  Future<void> migrateTestFile() async {
    print('🧪 Checking for test file...');

    // Convert lib path to test path
    final testFrom = from
        .replaceFirst('$libRoot/$srcSubdir/', '$testRoot/$srcSubdir/')
        .replaceFirst('.dart', testSuffix);

    final testTo = to
        .replaceFirst('$libRoot/$srcSubdir/', '$testRoot/$srcSubdir/')
        .replaceFirst('.dart', testSuffix);

    final testFile = File(path.join(baseDir, testFrom));

    if (await testFile.exists()) {
      var content = await testFile.readAsString();

      // Update imports in test file
      content = await updateFileImportsForNewLocation(
        content,
        testFrom,
        testTo,
      );

      // Update imports to the main file being moved
      for (final mapping in importUpdates.entries) {
        content = updateImportReferences(content, mapping.key, mapping.value);
      }

      if (!isDryRun) {
        final targetTestFile = File(path.join(baseDir, testTo));
        if (!await targetTestFile.parent.exists()) {
          await targetTestFile.parent.create(recursive: true);
          createdDirs.add(targetTestFile.parent.path);
        }
        await targetTestFile.writeAsString(content);
        createdFiles.add(targetTestFile.path);
        await testFile.delete();
        deletedFiles.add(testFile.path);

        // Update imports in the test file
        await updateTestImports(targetTestFile);
      }

      print('   ✅ Moved test file\n');
    } else {
      print('   ℹ️  No test file found\n');
    }
  }

  Future<void> updateProjectImports() async {
    print('📝 Updating imports across project...');

    // Find all Dart files that might reference the moved file
    final affectedFiles = await _findAffectedFiles();

    for (final filePath in affectedFiles) {
      if (filePath == path.join(baseDir, to))
        continue; // Skip the moved file itself

      final file = File(filePath);
      var content = await file.readAsString();
      final originalContent = content;

      // Calculate relative path from this file to the new location
      final fileRelativePath = path.relative(filePath, from: baseDir);
      final fileDir = path.dirname(fileRelativePath);

      // Update imports based on context
      content = updateFileImportsWithContext(content, fileDir);

      // Only write if content changed
      if (content != originalContent) {
        if (!isDryRun) {
          await file.writeAsString(content);
          modifiedFiles.add(filePath);
        }
        if (verbose)
          print('   ✅ Updated: ${path.relative(filePath, from: baseDir)}');
      }
    }

    print('   ✅ Import updates complete\n');
  }

  Future<List<String>> _findAffectedFiles() async {
    final affectedFiles = <String>{};
    final fileName = path.basename(from);
    final fromPath = from.replaceFirst('$libRoot/', '');

    // Search patterns to find references
    final searchPatterns = [
      fileName, // 'color_util.dart'
      path.basenameWithoutExtension(fileName), // 'color_util'
      fromPath, // 'src/attributes/color_util.dart'
      fromPath.replaceAll('.dart', ''), // 'src/attributes/color_util'
    ];

    // Directories to search
    final searchDirs = [
      Directory(path.join(baseDir, libRoot)),
      Directory(path.join(baseDir, testRoot)),
    ];

    for (final dir in searchDirs) {
      if (!await dir.exists()) continue;

      await for (final entity in dir.list(recursive: true)) {
        if (entity is! File) continue;
        if (!entity.path.endsWith('.dart')) continue;
        if (excludedExtensions.any((ext) => entity.path.contains(ext)))
          continue;

        // Read file content to check if it references our moved file
        final content = await entity.readAsString();

        // Check if file contains any of our search patterns in imports/exports
        for (final pattern in searchPatterns) {
          if (_containsImportExportReference(content, pattern)) {
            affectedFiles.add(entity.path);
            break;
          }
        }
      }
    }

    return affectedFiles.toList();
  }

  bool _containsImportExportReference(String content, String pattern) {
    // Check for import/export statements
    final importExportMatches = importExportPattern.allMatches(content);
    for (final match in importExportMatches) {
      final importPath = match.group(3)!;
      if (importPath.contains(pattern)) {
        return true;
      }
    }

    // Check for part statements
    final partMatches = partPattern.allMatches(content);
    for (final match in partMatches) {
      final partPath = match.group(3)!;
      if (partPath.contains(pattern)) {
        return true;
      }
    }

    return false;
  }

  Future<void> handleSpecialCases() async {
    for (final entry in specialCases.entries) {
      if (from.contains(entry.key)) {
        print('🔧 Handling ${entry.key} extension imports...');

        final extensionPattern = RegExp(entry.value['usagePattern'] as String);
        final extensionPath = entry.value['extensionPath'] as String;
        final extensionFileName = entry.value['extensionFileName'] as String;
        final libDir = Directory(path.join(baseDir, libRoot));

        await for (final entity in libDir.list(recursive: true)) {
          if (entity is! File) continue;
          if (!entity.path.endsWith('.dart')) continue;
          if (excludedExtensions.any((ext) => entity.path.contains(ext)))
            continue;

          final content = await entity.readAsString();

          // Check if file uses the extensions
          if (extensionPattern.hasMatch(content)) {
            // Calculate relative import path
            final fileDir = path.dirname(
              path.relative(entity.path, from: baseDir),
            );
            final relativeImport = path.relative(extensionPath, from: fileDir);

            // Add import if not present
            if (!content.contains(extensionFileName)) {
              final updatedContent = addImportToFile(content, relativeImport);

              if (!isDryRun) {
                await entity.writeAsString(updatedContent);
                modifiedFiles.add(entity.path);
              }

              if (verbose)
                print(
                  '   ✅ Added extension import: ${path.relative(entity.path, from: baseDir)}',
                );
            }
          }
        }
      }
    }
  }

  Future<void> validateMigration() async {
    if (isDryRun) return;

    print('🔍 Validating migration...');

    // Collect all affected files for analysis
    final affected = await _findAffectedFiles();
    affected.add(path.join(baseDir, to));
    if (!skipTest) {
      final testTo = to
          .replaceFirst('$libRoot/$srcSubdir/', '$testRoot/$srcSubdir/')
          .replaceFirst('.dart', testSuffix);
      final testFile = File(path.join(baseDir, testTo));
      if (await testFile.exists()) {
        affected.add(testFile.path);
      }
    }

    // Run dart analyze on affected files
    final result = await Process.run('dart', [
      'analyze',
      '--no-fatal-warnings',
      ...affected,
    ], workingDirectory: baseDir);

    if (result.exitCode != 0) {
      warnings.add('Dart analyze found issues. Reverting changes...');
      if (verbose) {
        print('   ⚠️  Analyze output:');
        print(result.stdout);
      }
      // Complete revert of all changes
      await _revertAllChanges();
      print('   🔄 All changes reverted.');
    } else {
      print('   ✅ No analyze errors\n');
    }
  }

  void generateReport() {
    print('=' * 60);
    print('📊 MIGRATION REPORT');
    print('=' * 60);

    print('\n✅ Migration completed');
    print('   From: $from');
    print('   To:   $to');

    if (warnings.isNotEmpty) {
      print('\n⚠️  Warnings:');
      for (final warning in warnings) {
        print('   - $warning');
      }
    }

    if (errors.isNotEmpty) {
      print('\n❌ Errors:');
      for (final error in errors) {
        print('   - $error');
      }
    }

    if (!isDryRun) {
      print('\n📌 Next steps:');
      print('   1. Run: dart analyze');
      print('   2. Run: flutter test');
      print('   3. Review changes and commit');
    }
  }

  // Helper methods

  String _findBaseDir() {
    // Look for packages/[packageName] directory
    var current = Directory.current;

    // Check if we're already in packages/[packageName]
    if (File(path.join(current.path, 'pubspec.yaml')).existsSync() &&
        current.path.endsWith(packageName)) {
      return current.path;
    }

    while (current.path != current.parent.path) {
      final pkgDir = Directory(
        path.join(current.path, 'packages', packageName),
      );
      if (pkgDir.existsSync()) {
        return pkgDir.path;
      }

      current = current.parent;
    }

    throw Exception('Could not find packages/$packageName directory');
  }

  List<ImportInfo> parseImports(String content) {
    final imports = <ImportInfo>[];

    // Parse import/export statements
    for (final match in importExportPattern.allMatches(content)) {
      final type = match.group(1)!;
      final pathStr = match.group(3)!;
      final fullMatch = match.group(0)!;

      imports.add(
        ImportInfo(
          type: type,
          path: pathStr,
          fullStatement: fullMatch,
          isRelative: pathStr.startsWith('.'),
        ),
      );
    }

    // Parse part statements
    for (final match in partPattern.allMatches(content)) {
      final type = match.group(1)!;
      final pathStr = match.group(3)!;
      final fullMatch = match.group(0)!;

      imports.add(
        ImportInfo(
          type: type,
          path: pathStr,
          fullStatement: fullMatch,
          isRelative: pathStr.startsWith('.'),
        ),
      );
    }

    return imports;
  }

  String updateImportInContent(
    String content,
    ImportInfo importInfo,
    String newPath,
  ) {
    final updatedStatement = importInfo.fullStatement.replaceFirst(
      importInfo.path,
      newPath.replaceAll('\\', '/'), // Ensure forward slashes
    );

    return content.replaceAll(importInfo.fullStatement, updatedStatement);
  }

  String updateImportReferences(
    String content,
    String oldImport,
    String newImport,
  ) {
    // Update package imports
    content = content.replaceAllMapped(
      RegExp('(import|export)\\s+([\'"])${RegExp.escape(oldImport)}\\2'),
      (match) =>
          '${match.group(1)} ${match.group(2)}$newImport${match.group(2)}',
    );

    return content;
  }

  String updateFileImportsWithContext(String content, String importingFileDir) {
    final fileName = path.basename(from);
    final fromPath = from.replaceFirst('$libRoot/', '');
    final toPath = to.replaceFirst('$libRoot/', '');

    // Check for conditionals and warn
    if (content.contains('if (dart.library.')) {
      warnings.add(
        'Conditional import detected in $importingFileDir; manual review recommended.',
      );
    }

    // Update import/export statements
    content = content.replaceAllMapped(importExportPattern, (match) {
      final statement = match.group(1)!; // 'import' or 'export'
      final quote = match.group(2)!;
      final importPath = match.group(3)!;
      final restOfStatement = match
          .group(0)!
          .substring(
            match.group(0)!.indexOf(importPath) + importPath.length + 1,
          ); // Everything after the path including the closing quote

      // Check if this import references our moved file
      if (_isReferencingMovedFile(importPath, fileName, fromPath)) {
        // Calculate the new import path
        final newImportPath = _calculateNewImportPath(
          importPath,
          importingFileDir,
          fromPath,
          toPath,
        );
        if (verbose) {
          final relativeFilePath = path.relative(
            path.join(baseDir, importingFileDir),
            from: baseDir,
          );
          print('     $relativeFilePath: "$importPath" → "$newImportPath"');
        }
        return '$statement $quote$newImportPath$quote$restOfStatement';
      }

      // Return unchanged if not referencing our file
      return match.group(0)!;
    });

    // Update part statements
    content = content.replaceAllMapped(partPattern, (match) {
      final statement = match.group(1)!; // 'part' or 'part of'
      final quote = match.group(2)!;
      final partPath = match.group(3)!;

      // Check if this part references our moved file
      if (_isReferencingMovedFile(partPath, fileName, fromPath)) {
        // Calculate the new part path
        final newPartPath = _calculateNewImportPath(
          partPath,
          importingFileDir,
          fromPath,
          toPath,
        );
        return '$statement $quote$newPartPath$quote;';
      }

      // Return unchanged if not referencing our file
      return match.group(0)!;
    });

    return content;
  }

  bool _isReferencingMovedFile(
    String importPath,
    String fileName,
    String fromPath,
  ) {
    // Normalize paths for comparison
    var normalizedImportPath = importPath.replaceAll('\\', '/');
    final fileNameWithoutExt = path.basenameWithoutExtension(fileName);

    if (normalizedImportPath.startsWith('package:$packageName/')) {
      normalizedImportPath = normalizedImportPath.replaceFirst(
        'package:$packageName/',
        '',
      );
    }

    // Stricter checks
    return path.basename(normalizedImportPath) ==
            fileName || // Exact basename match
        normalizedImportPath.endsWith('/$fileName') ||
        normalizedImportPath == fromPath ||
        normalizedImportPath == fromPath.replaceAll('.dart', '') ||
        path.basename(normalizedImportPath) == fileNameWithoutExt ||
        normalizedImportPath.endsWith(fromPath);
  }

  String _calculateNewImportPath(
    String oldImportPath,
    String importingFileDir,
    String fromPath,
    String toPath,
  ) {
    // Note: importingFileDir is like 'lib/src/attributes'
    // fromPath is like 'src/attributes/color_util.dart' 
    // toPath is like 'src/utilities/color_util.dart'
    // Handle package imports
    if (oldImportPath.startsWith('package:$packageName/')) {
      // Replace the old path portion with the new path
      return oldImportPath.replaceFirst(
        'package:$packageName/$fromPath',
        'package:$packageName/$toPath',
      );
    }

    // Handle absolute imports that match our from path
    // These need to be converted to relative paths too
    if (oldImportPath == fromPath ||
        oldImportPath == fromPath.replaceAll('.dart', '')) {
      // Calculate relative path from importing file to new location
      // importingFileDir already includes 'lib/src/attributes' format
      final newAbsolutePath = path.join(baseDir, to);
      final relativePath = path.relative(
        newAbsolutePath,
        from: path.join(baseDir, importingFileDir),
      );
      return relativePath.replaceAll('\\', '/');
    }

    // Handle relative imports
    if (oldImportPath.startsWith('.')) {
      // Calculate the absolute path of what's being imported from the importing file's perspective
      final importingDirFull = path.join(baseDir, importingFileDir);
      final resolvedOldPath = path.normalize(
        path.join(importingDirFull, oldImportPath),
      );

      // Check if this resolves to our moved file
      if (resolvedOldPath.endsWith(fromPath)) {
        // Stricter endsWith
        // Calculate new relative path
        final newAbsolutePath = path.join(baseDir, to);
        final relativePath = path.relative(
          newAbsolutePath,
          from: importingDirFull,
        );
        return relativePath.replaceAll('\\', '/');
      }
    }

    // Handle filename-only imports (need to calculate relative path)
    if (path.basename(oldImportPath) == path.basename(fromPath) ||
        path.basename(oldImportPath) ==
            path.basenameWithoutExtension(fromPath)) {
      // Calculate relative path from importing file to new location
      final importingDirFull = path.join(baseDir, importingFileDir);
      final newAbsolutePath = path.join(baseDir, to);
      final relativePath = path.relative(
        newAbsolutePath,
        from: importingDirFull,
      );
      return relativePath.replaceAll('\\', '/');
    }

    // Handle partial path imports (e.g., 'attributes/color_util.dart')
    if (oldImportPath.endsWith(path.basename(fromPath))) {
      // Check if the old import path ends with a portion of our from path
      for (int i = 0; i < fromPath.length; i++) {
        if (fromPath.substring(i) == oldImportPath ||
            fromPath.substring(i).replaceAll('.dart', '') == oldImportPath) {
          // Found a match, calculate relative path to new location
          final importingDirFull = path.join(baseDir, importingFileDir);
          final newAbsolutePath = path.join(baseDir, to);
          final relativePath = path.relative(
            newAbsolutePath,
            from: importingDirFull,
          );
          return relativePath.replaceAll('\\', '/');
        }
      }
    }

    // Default: return the old path unchanged (not referencing our file)
    return oldImportPath;
  }

  String addImportToFile(String content, String importPath) {
    // Find the last import statement
    final importMatches = RegExp(
      r'^import\s+.*?;',
      multiLine: true,
    ).allMatches(content).toList();

    if (importMatches.isNotEmpty) {
      final lastImport = importMatches.last;
      final insertIndex = lastImport.end;

      return content.substring(0, insertIndex) +
          '\nimport \'$importPath\';' +
          content.substring(insertIndex);
    }

    // No imports found, add at the beginning
    return 'import \'$importPath\';\n\n$content';
  }

  Future<void> _revertAllChanges() async {
    try {
      // 1. Delete created files
      for (final filePath in createdFiles) {
        final file = File(filePath);
        if (await file.exists()) {
          await file.delete();
        }
      }

      // 2. Restore deleted files
      for (final filePath in deletedFiles) {
        await Process.run('git', [
          'checkout',
          'HEAD',
          '--',
          path.relative(filePath, from: baseDir),
        ], workingDirectory: baseDir);
      }

      // 3. Revert modified files
      for (final filePath in modifiedFiles) {
        await Process.run('git', [
          'checkout',
          'HEAD',
          '--',
          path.relative(filePath, from: baseDir),
        ], workingDirectory: baseDir);
      }

      // 4. Remove created directories (in reverse order to handle nested dirs)
      final sortedDirs = createdDirs.toList()
        ..sort((a, b) => b.length.compareTo(a.length));
      for (final dirPath in sortedDirs) {
        final dir = Directory(dirPath);
        if (await dir.exists() && (await dir.list().toList()).isEmpty) {
          await dir.delete();
        }
      }
    } catch (e) {
      print('   ⚠️  Error during revert: $e');
    }
  }
}

class ImportInfo {
  final String type; // 'import' or 'export' or 'part' or 'part of'
  final String path;
  final String fullStatement;
  final bool isRelative;

  ImportInfo({
    required this.type,
    required this.path,
    required this.fullStatement,
    required this.isRelative,
  });
}

class ArgParser {
  final Map<String, ArgOption> _options = {};
  final Map<String, ArgFlag> _flags = {};

  void addOption(
    String name, {
    String? abbr,
    bool mandatory = false,
    String? help,
  }) {
    _options[name] = ArgOption(
      name: name,
      abbr: abbr,
      mandatory: mandatory,
      help: help,
    );
  }

  void addFlag(String name, {String? abbr, String? help}) {
    _flags[name] = ArgFlag(name: name, abbr: abbr, help: help);
  }

  Map<String, dynamic> parse(List<String> args) {
    final results = <String, dynamic>{};

    // Initialize flags to false
    for (final flag in _flags.values) {
      results[flag.name] = false;
    }

    // Parse arguments
    for (int i = 0; i < args.length; i++) {
      final arg = args[i];

      if (arg.startsWith('--')) {
        final parts = arg.substring(2).split('=');
        final name = parts[0];

        if (_options.containsKey(name)) {
          if (parts.length > 1) {
            results[name] = parts[1];
          } else if (i + 1 < args.length && !args[i + 1].startsWith('-')) {
            results[name] = args[++i];
          }
        } else if (_flags.containsKey(name)) {
          results[name] = true;
        }
      } else if (arg.startsWith('-') && arg.length == 2) {
        final abbr = arg.substring(1);

        // Find option or flag by abbreviation
        final option = _options.values.firstWhere(
          (o) => o.abbr == abbr,
          orElse: () => ArgOption(name: '', abbr: null),
        );

        if (option.name.isNotEmpty) {
          if (i + 1 < args.length && !args[i + 1].startsWith('-')) {
            results[option.name] = args[++i];
          }
        } else {
          final flag = _flags.values.firstWhere(
            (f) => f.abbr == abbr,
            orElse: () => ArgFlag(name: '', abbr: null),
          );

          if (flag.name.isNotEmpty) {
            results[flag.name] = true;
          }
        }
      }
    }

    // Check mandatory options
    for (final option in _options.values) {
      if (option.mandatory && !results.containsKey(option.name)) {
        throw Exception('Missing required option: --${option.name}');
      }
    }

    return results;
  }
}

class ArgOption {
  final String name;
  final String? abbr;
  final bool mandatory;
  final String? help;

  ArgOption({required this.name, this.abbr, this.mandatory = false, this.help});
}

class ArgFlag {
  final String name;
  final String? abbr;
  final String? help;

  ArgFlag({required this.name, this.abbr, this.help});
}
