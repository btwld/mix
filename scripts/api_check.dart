#!/usr/bin/env dart

import 'dart:convert';
import 'dart:io';

const mixPackages = ['mix', 'mix_annotations', 'mix_generator', 'mix_lint'];

Future<void> main(List<String> args) async {
  // Parse arguments
  String? packageName;
  String? version;

  if (args.isNotEmpty) {
    final firstArg = args[0];

    // Check if first argument is a package name or version
    if (mixPackages.contains(firstArg)) {
      packageName = firstArg;
      if (args.length > 1) {
        version = args[1];
      }
    } else if (firstArg.startsWith('v') ||
        RegExp(r'^\d+\.\d+\.\d+').hasMatch(firstArg)) {
      // First argument looks like a version (starts with 'v' or matches version pattern)
      version = firstArg;
      packageName = null; // Will check all packages
    } else {
      print(
        '❌ Invalid package name. Available packages: ${mixPackages.join(', ')}',
      );
      printUsage();
      exit(1);
    }
  }

  // If no version provided, get latest from pub.dev
  if (version == null) {
    if (packageName != null) {
      version = await getLatestVersion(packageName);
    } else {
      print('❌ Please specify a version when checking all packages');
      printUsage();
      exit(1);
    }
  }

  // Remove 'v' prefix if present
  final cleanVersion = version.startsWith('v') ? version.substring(1) : version;

  print('🚀 API Compatibility Check vs $version');

  // Activate dart_apitool
  await runCommand('dart', ['pub', 'global', 'activate', 'dart_apitool']);

  // Check packages
  final packagesToCheck = packageName != null ? [packageName] : mixPackages;
  final reports = <String>[];

  for (final pkg in packagesToCheck) {
    await checkPackage(pkg, cleanVersion, version, reports);
  }

  // Print summary
  print('');
  print('🎯 API compatibility check completed!');
  print('📂 Reports saved in project root:');
  for (final report in reports) {
    print('   • $report');
  }
}

Future<String> getLatestVersion(String packageName) async {
  try {
    final result = await Process.run('curl', [
      '-s',
      'https://pub.dev/api/packages/$packageName',
    ]);

    if (result.exitCode == 0) {
      final json = jsonDecode(result.stdout);
      return json['latest']['version'];
    }
  } catch (e) {
    print(
      '⚠️  Could not fetch latest version for $packageName, please specify version manually',
    );
  }

  exit(1);
}

Future<void> checkPackage(
  String packageName,
  String cleanVersion,
  String displayVersion,
  List<String> reports,
) async {
  print('📦 Checking $packageName package...');

  final reportFile = 'api-compat-$packageName-vs-$displayVersion.md';

  // Use Flutter flag for the main mix package since it requires Flutter SDK
  final args = [
    'diff',
    '--old',
    'pub://$packageName/$cleanVersion',
    '--new',
    './packages/$packageName',
    '--report-format',
    'markdown',
    '--report-file-path',
    reportFile,
    '--ignore-prerelease',
  ];

  if (packageName == 'mix') {
    args.add('--force-use-flutter');
  }

  final result = await Process.run('dart-apitool', args);

  // Check if report file was actually created
  final reportExists = await File(reportFile).exists();

  if (reportExists) {
    reports.add(reportFile);
    if (result.exitCode == 0) {
      print('✅ $packageName: API check completed - no breaking changes');
    } else {
      print(
        '⚠️  $packageName: API changes detected (exit code: ${result.exitCode})',
      );
      // Non-zero exit code often means breaking changes were found, which is expected
    }
    print('📄 Report saved: $reportFile');
  } else {
    print('❌ $packageName: Failed to generate report');
    if (result.stderr.isNotEmpty) {
      print('   Error: ${result.stderr.toString().trim()}');
    }
    if (result.stdout.isNotEmpty) {
      print('   Output: ${result.stdout.toString().trim()}');
    }
  }
}

Future<void> runCommand(String command, List<String> args) async {
  final result = await Process.run(command, args);
  if (result.exitCode != 0) {
    print('Error running $command ${args.join(' ')}');
    print(result.stderr);
  }
}

void printUsage() {
  print('');
  print('Usage: dart scripts/api_check.dart [PACKAGE] [VERSION]');
  print('');
  print('Arguments:');
  print('  PACKAGE  Package to check (${mixPackages.join('|')})');
  print('           If not provided, checks all packages');
  print('  VERSION  Version to compare against (e.g., v1.6.0 or 1.6.0)');
  print(
    '           If not provided with single package, uses latest from pub.dev',
  );
  print('');
  print('Examples:');
  print(
    '  dart scripts/api_check.dart mix                    # Check mix against latest',
  );
  print(
    '  dart scripts/api_check.dart mix v1.6.0            # Check mix against v1.6.0',
  );
  print(
    '  dart scripts/api_check.dart v1.6.0                # Check all packages against v1.6.0',
  );
  print('');
  print('Melos usage:');
  print('  melos run api-check -- mix v1.6.0');
  print('  melos run api-check -- v1.6.0');
}
