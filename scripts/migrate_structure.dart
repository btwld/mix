import 'dart:io';
import 'package:path/path.dart' as path;

/// Migration script for reorganizing the Mix package structure
/// 
/// This script automates:
/// - Moving files to new locations
/// - Updating imports in all affected files
/// - Migrating test files to match new structure
/// - Generating a detailed migration report
void main(List<String> args) async {
  final script = MigrationScript();
  
  // Check for dry-run mode
  final isDryRun = args.contains('--dry-run');
  script.isDryRun = isDryRun;
  
  if (isDryRun) {
    print('🔍 Running in DRY RUN mode - no files will be modified\n');
  }
  
  await script.run();
}

class FileMigration {
  final String from;
  final String to;
  final bool needsExtraction;
  final int? extractStartLine;
  final int? extractEndLine;
  
  FileMigration(
    this.from,
    this.to, {
    this.needsExtraction = false,
    this.extractStartLine,
    this.extractEndLine,
  });
}

class MigrationScript {
  final baseDir = 'packages/mix';
  final List<FileMigration> migrations = [];
  final Map<String, String> importMap = {};
  final List<String> createdDirectories = [];
  final List<String> movedFiles = [];
  final List<String> updatedFiles = [];
  final List<String> errors = [];
  bool isDryRun = false;
  
  Future<void> run() async {
    print('🚀 Starting Mix package reorganization...\n');
    
    // Preflight checks
    if (!await preflightCheck()) {
      print('❌ Preflight checks failed. Aborting.');
      exit(1);
    }
    
    // Define all migrations
    defineMigrations();
    
    // Create new directory structure
    await createDirectories();
    
    // Extract content from files that need splitting
    await extractFiles();
    
    // Move files
    await moveFiles();
    
    // Update imports in all Dart files
    await updateImports();
    
    // Move and update test files
    await migrateTests();
    
    // Clean up empty directories
    if (!isDryRun) {
      await cleanupEmptyDirectories();
    }
    
    // Generate report
    generateReport();
    
    if (errors.isNotEmpty) {
      print('\n⚠️  Migration completed with ${errors.length} errors');
      exit(1);
    } else {
      print('\n✅ Migration completed successfully!');
    }
  }
  
  Future<bool> preflightCheck() async {
    print('🔍 Running preflight checks...\n');
    
    // Check if we're in the right directory
    if (!await Directory(baseDir).exists()) {
      print('❌ Error: Must run from monorepo root');
      print('   Current directory: ${Directory.current.path}');
      return false;
    }
    
    // Check git status
    if (!isDryRun) {
      final gitStatus = await Process.run('git', ['status', '--porcelain']);
      if (gitStatus.stdout.toString().isNotEmpty) {
        print('⚠️  Warning: You have uncommitted changes');
        print('It\'s recommended to commit or stash changes first');
        print('Continue anyway? (y/n)');
        if (stdin.readLineSync()?.toLowerCase() != 'y') return false;
      }
      
      // Create backup
      print('💾 Creating backup...');
      final backupDir = '$baseDir.backup';
      if (await Directory(backupDir).exists()) {
        await Directory(backupDir).delete(recursive: true);
      }
      await Process.run('cp', ['-r', baseDir, backupDir]);
      print('   Backup created at: $backupDir');
    }
    
    return true;
  }
  
  void defineMigrations() {
    migrations.addAll([
      // Core provider migrations
      FileMigration(
        'lib/src/core/style_provider.dart',
        'lib/src/core/providers/style_provider.dart',
      ),
      FileMigration(
        'lib/src/core/resolved_style_provider.dart',
        'lib/src/core/providers/resolved_style_provider.dart',
      ),
      FileMigration(
        'lib/src/core/widget_state/widget_state_provider.dart',
        'lib/src/core/providers/widget_state_provider.dart',
      ),
      
      // Extensions migrations
      FileMigration(
        'lib/src/helpers/extensions.dart',
        'lib/src/core/extensions/extensions.dart',
      ),
      
      // Widget state controller extensions (extracted from widget_state_provider.dart)
      FileMigration(
        'lib/src/core/widget_state/widget_state_provider.dart',
        'lib/src/core/extensions/widget_state_controller_ext.dart',
        needsExtraction: true,
        extractStartLine: 47,
        extractEndLine: 72,
      ),
      
      // Internal migrations
      FileMigration(
        'lib/src/internal/compare_mixin.dart',
        'lib/src/core/internal/compare_mixin.dart',
      ),
      FileMigration(
        'lib/src/internal/constants.dart',
        'lib/src/core/internal/constants.dart',
      ),
      FileMigration(
        'lib/src/internal/deep_collection_equality.dart',
        'lib/src/core/internal/deep_collection_equality.dart',
      ),
      FileMigration(
        'lib/src/internal/diagnostic_properties_builder_ext.dart',
        'lib/src/core/internal/diagnostic_properties_builder_ext.dart',
      ),
      FileMigration(
        'lib/src/internal/helper_util.dart',
        'lib/src/core/internal/helper_util.dart',
      ),
      FileMigration(
        'lib/src/internal/internal_extensions.dart',
        'lib/src/core/internal/internal_extensions.dart',
      ),
      FileMigration(
        'lib/src/internal/mix_error.dart',
        'lib/src/core/internal/mix_error.dart',
      ),
      FileMigration(
        'lib/src/core/widget_state/internal/mix_hoverable_region.dart',
        'lib/src/core/internal/mix_hoverable_region.dart',
      ),
      
      // Animation migrations
      FileMigration(
        'lib/src/core/animation_config.dart',
        'lib/src/animation/animation_config.dart',
      ),
      FileMigration(
        'lib/src/core/animation/animation_util.dart',
        'lib/src/animation/animation_util.dart',
      ),
      FileMigration(
        'lib/src/core/animation/curves.dart',
        'lib/src/animation/curves.dart',
      ),
      FileMigration(
        'lib/src/core/animation/style_animation_builder.dart',
        'lib/src/animation/style_animation_builder.dart',
      ),
      FileMigration(
        'lib/src/core/animation/style_animation_driver.dart',
        'lib/src/animation/style_animation_driver.dart',
      ),
      
      // Widget state (minimal)
      FileMigration(
        'lib/src/core/widget_state/cursor_position.dart',
        'lib/src/widget_state/cursor_position.dart',
      ),
      
      // Properties - Painting
      FileMigration(
        'lib/src/attributes/border_mix.dart',
        'lib/src/properties/painting/border_mix.dart',
      ),
      FileMigration(
        'lib/src/attributes/border_util.dart',
        'lib/src/properties/painting/border_util.dart',
      ),
      FileMigration(
        'lib/src/attributes/border_radius_mix.dart',
        'lib/src/properties/painting/border_radius_mix.dart',
      ),
      FileMigration(
        'lib/src/attributes/border_radius_util.dart',
        'lib/src/properties/painting/border_radius_util.dart',
      ),
      FileMigration(
        'lib/src/attributes/shape_border_mix.dart',
        'lib/src/properties/painting/shape_border_mix.dart',
      ),
      FileMigration(
        'lib/src/attributes/shape_border_util.dart',
        'lib/src/properties/painting/shape_border_util.dart',
      ),
      FileMigration(
        'lib/src/attributes/color_util.dart',
        'lib/src/properties/painting/color_util.dart',
      ),
      FileMigration(
        'lib/src/attributes/material_colors_util.dart',
        'lib/src/properties/painting/material_colors_util.dart',
      ),
      FileMigration(
        'lib/src/attributes/decoration_mix.dart',
        'lib/src/properties/painting/decoration_mix.dart',
      ),
      FileMigration(
        'lib/src/attributes/decoration_util.dart',
        'lib/src/properties/painting/decoration_util.dart',
      ),
      FileMigration(
        'lib/src/attributes/decoration_image_mix.dart',
        'lib/src/properties/painting/decoration_image_mix.dart',
      ),
      FileMigration(
        'lib/src/attributes/decoration_image_util.dart',
        'lib/src/properties/painting/decoration_image_util.dart',
      ),
      FileMigration(
        'lib/src/attributes/gradient_mix.dart',
        'lib/src/properties/painting/gradient_mix.dart',
      ),
      FileMigration(
        'lib/src/attributes/gradient_util.dart',
        'lib/src/properties/painting/gradient_util.dart',
      ),
      FileMigration(
        'lib/src/attributes/shadow_mix.dart',
        'lib/src/properties/painting/shadow_mix.dart',
      ),
      FileMigration(
        'lib/src/attributes/shadow_util.dart',
        'lib/src/properties/painting/shadow_util.dart',
      ),
      
      // Properties - Layout
      FileMigration(
        'lib/src/attributes/constraints_mix.dart',
        'lib/src/properties/layout/constraints_mix.dart',
      ),
      FileMigration(
        'lib/src/attributes/constraints_util.dart',
        'lib/src/properties/layout/constraints_util.dart',
      ),
      FileMigration(
        'lib/src/attributes/edge_insets_geometry_mix.dart',
        'lib/src/properties/layout/edge_insets_geometry_mix.dart',
      ),
      FileMigration(
        'lib/src/attributes/edge_insets_geometry_util.dart',
        'lib/src/properties/layout/edge_insets_geometry_util.dart',
      ),
      FileMigration(
        'lib/src/attributes/scalar_util.dart',
        'lib/src/properties/layout/scalar_util.dart',
      ),
      
      // Properties - Typography
      FileMigration(
        'lib/src/attributes/text_style_mix.dart',
        'lib/src/properties/typography/text_style_mix.dart',
      ),
      FileMigration(
        'lib/src/attributes/text_style_util.dart',
        'lib/src/properties/typography/text_style_util.dart',
      ),
      FileMigration(
        'lib/src/attributes/strut_style_mix.dart',
        'lib/src/properties/typography/strut_style_mix.dart',
      ),
      FileMigration(
        'lib/src/attributes/strut_style_util.dart',
        'lib/src/properties/typography/strut_style_util.dart',
      ),
      FileMigration(
        'lib/src/attributes/text_height_behavior_mix.dart',
        'lib/src/properties/typography/text_height_behavior_mix.dart',
      ),
      FileMigration(
        'lib/src/attributes/text_height_behavior_util.dart',
        'lib/src/properties/typography/text_height_behavior_util.dart',
      ),
      
      // Properties - Common
      FileMigration(
        'lib/src/specs/spec_util.dart',
        'lib/src/properties/spec_util.dart',
      ),
      
      // Widgets - Box
      FileMigration(
        'lib/src/specs/box/box_attribute.dart',
        'lib/src/widgets/box/box_attribute.dart',
      ),
      FileMigration(
        'lib/src/specs/box/box_spec.dart',
        'lib/src/widgets/box/box_spec.dart',
      ),
      FileMigration(
        'lib/src/specs/box/box_widget.dart',
        'lib/src/widgets/box/box_widget.dart',
      ),
      
      // Widgets - Text
      FileMigration(
        'lib/src/specs/text/text_attribute.dart',
        'lib/src/widgets/text/text_attribute.dart',
      ),
      FileMigration(
        'lib/src/specs/text/text_spec.dart',
        'lib/src/widgets/text/text_spec.dart',
      ),
      FileMigration(
        'lib/src/specs/text/text_widget.dart',
        'lib/src/widgets/text/text_widget.dart',
      ),
      FileMigration(
        'lib/src/specs/text/text_directives_util.dart',
        'lib/src/widgets/text/text_directives_util.dart',
      ),
      
      // Widgets - Icon
      FileMigration(
        'lib/src/specs/icon/icon_attribute.dart',
        'lib/src/widgets/icon/icon_attribute.dart',
      ),
      FileMigration(
        'lib/src/specs/icon/icon_spec.dart',
        'lib/src/widgets/icon/icon_spec.dart',
      ),
      FileMigration(
        'lib/src/specs/icon/icon_widget.dart',
        'lib/src/widgets/icon/icon_widget.dart',
      ),
      
      // Widgets - Image
      FileMigration(
        'lib/src/specs/image/image_attribute.dart',
        'lib/src/widgets/image/image_attribute.dart',
      ),
      FileMigration(
        'lib/src/specs/image/image_spec.dart',
        'lib/src/widgets/image/image_spec.dart',
      ),
      FileMigration(
        'lib/src/specs/image/image_widget.dart',
        'lib/src/widgets/image/image_widget.dart',
      ),
      
      // Widgets - Flex
      FileMigration(
        'lib/src/specs/flex/flex_attribute.dart',
        'lib/src/widgets/flex/flex_attribute.dart',
      ),
      FileMigration(
        'lib/src/specs/flex/flex_spec.dart',
        'lib/src/widgets/flex/flex_spec.dart',
      ),
      FileMigration(
        'lib/src/specs/flexbox/flexbox_spec.dart',
        'lib/src/widgets/flexbox/flexbox_spec.dart',
      ),
      FileMigration(
        'lib/src/specs/flexbox/flexbox_widget.dart',
        'lib/src/widgets/flexbox/flexbox_widget.dart',
      ),
      
      // Widgets - Stack
      FileMigration(
        'lib/src/specs/stack/stack_attribute.dart',
        'lib/src/widgets/stack/stack_attribute.dart',
      ),
      FileMigration(
        'lib/src/specs/stack/stack_spec.dart',
        'lib/src/widgets/stack/stack_spec.dart',
      ),
      FileMigration(
        'lib/src/specs/stack/stack_box_spec.dart',
        'lib/src/widgets/stack/stack_box_spec.dart',
      ),
      FileMigration(
        'lib/src/specs/stack/stack_widget.dart',
        'lib/src/widgets/stack/stack_widget.dart',
      ),
      
      // Widgets - Pressable
      FileMigration(
        'lib/src/widgets/pressable_widget.dart',
        'lib/src/widgets/pressable/pressable_widget.dart',
      ),
      
      // Variants
      FileMigration(
        'lib/src/core/variant.dart',
        'lib/src/variants/variant.dart',
      ),
    ]);
  }
  
  Future<void> createDirectories() async {
    print('📁 Creating directory structure...\n');
    
    final directories = [
      'lib/src/core/providers',
      'lib/src/core/extensions',
      'lib/src/core/internal',
      'lib/src/animation',
      'lib/src/widget_state',
      'lib/src/properties/painting',
      'lib/src/properties/layout',
      'lib/src/properties/typography',
      'lib/src/widgets/box',
      'lib/src/widgets/text',
      'lib/src/widgets/icon',
      'lib/src/widgets/image',
      'lib/src/widgets/flex',
      'lib/src/widgets/flexbox',
      'lib/src/widgets/stack',
      'lib/src/widgets/pressable',
      'lib/src/variants',
    ];
    
    for (final dir in directories) {
      final fullPath = '$baseDir/$dir';
      if (!isDryRun) {
        await Directory(fullPath).create(recursive: true);
      }
      createdDirectories.add(dir);
      print('   ✅ $dir');
    }
  }
  
  Future<void> extractFiles() async {
    print('\n✂️  Extracting file content...\n');
    
    for (final migration in migrations.where((m) => m.needsExtraction)) {
      if (migration.from == 'lib/src/core/widget_state/widget_state_provider.dart' &&
          migration.to == 'lib/src/core/extensions/widget_state_controller_ext.dart') {
        
        final sourceFile = File('$baseDir/${migration.from}');
        if (!await sourceFile.exists()) continue;
        
        final lines = await sourceFile.readAsLines();
        final extractedContent = StringBuffer();
        
        // Add imports
        extractedContent.writeln("import 'package:flutter/material.dart';");
        extractedContent.writeln();
        
        // Extract the extension
        for (int i = migration.extractStartLine! - 1; i < migration.extractEndLine!; i++) {
          if (i < lines.length) {
            extractedContent.writeln(lines[i]);
          }
        }
        
        if (!isDryRun) {
          final targetFile = File('$baseDir/${migration.to}');
          await targetFile.create(recursive: true);
          await targetFile.writeAsString(extractedContent.toString());
        }
        
        print('   ✅ Extracted ${migration.to}');
      }
    }
  }
  
  Future<void> moveFiles() async {
    print('\n📦 Moving files...\n');
    
    for (final migration in migrations) {
      if (migration.needsExtraction) continue; // Skip extractions
      
      final sourceFile = File('$baseDir/${migration.from}');
      final targetFile = File('$baseDir/${migration.to}');
      
      if (!await sourceFile.exists()) {
        errors.add('Source file not found: ${migration.from}');
        print('   ❌ ${migration.from} (not found)');
        continue;
      }
      
      if (!isDryRun) {
        await targetFile.parent.create(recursive: true);
        await sourceFile.rename(targetFile.path);
      }
      
      movedFiles.add(migration.to);
      print('   ✅ ${migration.from} → ${migration.to}');
    }
  }
  
  Future<void> updateImports() async {
    print('\n📝 Updating imports...\n');
    
    // Build import mapping
    for (final migration in migrations) {
      if (migration.needsExtraction) continue;
      
      // Package imports
      final oldImport = migration.from.replaceFirst('lib/', 'package:mix/');
      final newImport = migration.to.replaceFirst('lib/', 'package:mix/');
      importMap[oldImport] = newImport;
      
      // Also map the source file without package prefix
      final oldSrc = migration.from.replaceFirst('lib/', '');
      final newSrc = migration.to.replaceFirst('lib/', '');
      importMap[oldSrc] = newSrc;
    }
    
    // Update all Dart files
    await _updateImportsInDirectory(Directory('$baseDir/lib'));
    await _updateImportsInDirectory(Directory('$baseDir/test'));
  }
  
  Future<void> _updateImportsInDirectory(Directory dir) async {
    if (!await dir.exists()) return;
    
    await for (final entity in dir.list(recursive: true)) {
      if (entity is File && entity.path.endsWith('.dart')) {
        await _updateFileImports(entity);
      }
    }
  }
  
  Future<void> _updateFileImports(File file) async {
    var content = await file.readAsString();
    var modified = false;
    
    // Update imports
    importMap.forEach((oldImport, newImport) {
      // Package imports
      final packagePattern = RegExp('import\\s+[\'"]$oldImport[\'"];');
      if (content.contains(packagePattern)) {
        content = content.replaceAll(packagePattern, "import '$newImport';");
        modified = true;
      }
      
      // Relative imports from src
      final srcPattern = RegExp('import\\s+[\'"]../+$oldImport[\'"];');
      final replacement = "import 'package:mix/$newImport';";
      if (content.contains(srcPattern)) {
        content = content.replaceAll(srcPattern, replacement);
        modified = true;
      }
    });
    
    // Special case: Update extracted widget state controller extension import
    if (content.contains("import 'package:mix/src/core/widget_state/widget_state_provider.dart';") ||
        content.contains("import '../core/widget_state/widget_state_provider.dart';")) {
      
      // Check if file uses the extension
      if (content.contains('WidgetStateControllerExtension') || 
          content.contains('.disabled') ||
          content.contains('.hovered') ||
          content.contains('.pressed')) {
        
        // Add the new import if not already present
        if (!content.contains("import 'package:mix/src/core/extensions/widget_state_controller_ext.dart';")) {
          final importSection = content.indexOf('import');
          final firstImport = content.indexOf(';', importSection) + 1;
          content = content.substring(0, firstImport) + 
                   "\nimport 'package:mix/src/core/extensions/widget_state_controller_ext.dart';" +
                   content.substring(firstImport);
          modified = true;
        }
      }
    }
    
    if (modified && !isDryRun) {
      await file.writeAsString(content);
      updatedFiles.add(file.path);
    }
  }
  
  Future<void> migrateTests() async {
    print('\n🧪 Migrating test files...\n');
    
    for (final migration in migrations) {
      if (migration.needsExtraction) continue;
      
      // Convert lib path to test path
      final testFrom = migration.from
          .replaceFirst('lib/src/', 'test/src/')
          .replaceFirst('.dart', '_test.dart');
      
      final testTo = migration.to
          .replaceFirst('lib/src/', 'test/src/')
          .replaceFirst('.dart', '_test.dart');
      
      final testFile = File('$baseDir/$testFrom');
      if (await testFile.exists()) {
        if (!isDryRun) {
          final testDir = Directory(path.dirname('$baseDir/$testTo'));
          await testDir.create(recursive: true);
          await testFile.rename('$baseDir/$testTo');
        }
        
        movedFiles.add(testTo);
        print('   ✅ $testFrom → $testTo');
      }
    }
  }
  
  Future<void> cleanupEmptyDirectories() async {
    print('\n🧹 Cleaning up empty directories...\n');
    
    final dirsToCheck = [
      '$baseDir/lib/src/attributes',
      '$baseDir/lib/src/specs',
      '$baseDir/lib/src/helpers',
      '$baseDir/lib/src/internal',
      '$baseDir/lib/src/core/animation',
      '$baseDir/lib/src/core/widget_state',
      '$baseDir/test/src/attributes',
      '$baseDir/test/src/specs',
      '$baseDir/test/src/helpers',
      '$baseDir/test/src/internal',
    ];
    
    for (final dirPath in dirsToCheck) {
      final dir = Directory(dirPath);
      if (await dir.exists()) {
        final isEmpty = await dir.list().isEmpty;
        if (isEmpty) {
          await dir.delete();
          print('   ✅ Removed empty directory: $dirPath');
        }
      }
    }
  }
  
  void generateReport() {
    final report = StringBuffer();
    report.writeln('\n' + '=' * 60);
    report.writeln('📊 MIGRATION REPORT');
    report.writeln('=' * 60);
    
    report.writeln('\n✅ Created Directories: ${createdDirectories.length}');
    if (createdDirectories.isNotEmpty) {
      createdDirectories.forEach((dir) => report.writeln('   - $dir'));
    }
    
    report.writeln('\n✅ Moved Files: ${movedFiles.length}');
    
    report.writeln('\n✅ Updated Imports in: ${updatedFiles.length} files');
    
    if (errors.isNotEmpty) {
      report.writeln('\n❌ Errors: ${errors.length}');
      errors.forEach((error) => report.writeln('   - $error'));
    }
    
    if (!isDryRun) {
      report.writeln('\n📁 New Structure:');
      report.writeln(_generateTreeView());
      
      // Save report
      final reportFile = File('migration_report.txt');
      reportFile.writeAsStringSync(report.toString());
      print('\n📄 Full report saved to: migration_report.txt');
    }
    
    print(report.toString());
  }
  
  String _generateTreeView() {
    final tree = StringBuffer();
    tree.writeln('packages/mix/lib/src/');
    tree.writeln('├── core/');
    tree.writeln('│   ├── providers/');
    tree.writeln('│   ├── extensions/');
    tree.writeln('│   └── internal/');
    tree.writeln('├── animation/');
    tree.writeln('├── widget_state/');
    tree.writeln('├── properties/');
    tree.writeln('│   ├── painting/');
    tree.writeln('│   ├── layout/');
    tree.writeln('│   └── typography/');
    tree.writeln('├── widgets/');
    tree.writeln('│   ├── box/');
    tree.writeln('│   ├── text/');
    tree.writeln('│   ├── icon/');
    tree.writeln('│   ├── image/');
    tree.writeln('│   ├── flex/');
    tree.writeln('│   ├── flexbox/');
    tree.writeln('│   ├── stack/');
    tree.writeln('│   └── pressable/');
    tree.writeln('├── variants/');
    tree.writeln('├── modifiers/');
    tree.writeln('└── theme/');
    return tree.toString();
  }
}