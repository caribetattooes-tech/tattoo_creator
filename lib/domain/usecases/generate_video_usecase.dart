import '../../data/models/media_item.dart';
import '../../data/models/template.dart';
import '../../data/services/video_processing_service.dart';
import '../../data/services/export_service.dart';

class GenerateVideoUseCase {
  final VideoProcessingService _videoService = VideoProcessingService();
  final ExportService _exportService = ExportService();

  Future<String?> execute({
    required List<MediaItem> mediaItems,
    required Template template,
    required ExportSettings settings,
    Function(double)? onProgress,
  }) async {
    try {
      // Get output path
      final outputPath = await _exportService.generateOutputPath('mp4');

      // Prepare input paths
      final inputPaths = mediaItems.map((m) => m.path).toList();

      // Get music asset path (placeholder)
      const musicPath = 'assets/music/inspiring.mp3';

      // Generate video
      final result = await _videoService.generateVideo(
        inputPaths: inputPaths,
        outputPath: outputPath,
        musicPath: musicPath,
        width: settings.width,
        height: settings.height,
        quality: settings.quality,
        transitions: template.clips.map((c) => c.transitionType).toList(),
        onProgress: onProgress,
      );

      return result;
    } catch (e) {
      // In production, use proper logging
      return null;
    }
  }
}

class ExportSettings {
  final int width;
  final int height;
  final int quality;

  const ExportSettings({
    required this.width,
    required this.height,
    required this.quality,
  });
}