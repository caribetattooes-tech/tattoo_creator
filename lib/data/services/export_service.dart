import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ExportService {
  Future<String> getOutputDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    final outputDir = Directory('${directory.path}/TattooCreator/exports');
    if (!await outputDir.exists()) {
      await outputDir.create(recursive: true);
    }
    return outputDir.path;
  }

  Future<String> generateOutputPath(String format) async {
    final outputDir = await getOutputDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return '$outputDir/video_$timestamp.$format';
  }

  Future<bool> saveToGallery(String filePath) async {
    try {
      // On iOS, we save to the app's documents directory
      // The user can then access it through the Files app
      return File(filePath).existsSync();
    } catch (e) {
      print('Save to gallery error: $e');
      return false;
    }
  }

  Future<File?> getExportedFile(String path) async {
    final file = File(path);
    if (await file.exists()) {
      return file;
    }
    return null;
  }

  Future<void> cleanupOldExports({int keepCount = 10}) async {
    try {
      final outputDir = await getOutputDirectory();
      final directory = Directory(outputDir);
      final files = directory.listSync()
        ..sort((a, b) => b.statSync().modified.compareTo(a.statSync().modified));

      // Keep only the most recent files
      if (files.length > keepCount) {
        for (var i = keepCount; i < files.length; i++) {
          await files[i].delete();
        }
      }
    } catch (e) {
      print('Cleanup error: $e');
    }
  }
}