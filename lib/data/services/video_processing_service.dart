import 'dart:io';
import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_kit_config.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/return_code.dart';
import 'package:path_provider/path_provider.dart';

class VideoProcessingService {
  Future<String?> generateVideo({
    required List<String> inputPaths,
    required String outputPath,
    required String musicPath,
    required int width,
    required int height,
    required int quality,
    required List<String> transitions,
    Function(double)? onProgress,
  }) async {
    try {
      // Enable statistics callback for progress
      FFmpegKitConfig.enableStatisticsCallback((statistics) {
        final time = statistics.getTime();
        if (time > 0 && onProgress != null) {
          // Rough progress estimation based on time
          final progress = (time / 30000).clamp(0.0, 0.95);
          onProgress(progress);
        }
      });

      // Build FFmpeg command for video generation
      final List<String> filters = [];
      final StringBuffer inputArgs = StringBuffer();
      final StringBuffer filterArgs = StringBuffer();
      final StringBuffer complexFilter = StringBuffer();

      // Add input files
      for (int i = 0; i < inputPaths.length; i++) {
        inputArgs.write('-i "${inputPaths[i]}" ');
      }

      // Add music input
      inputArgs.write('-i "$musicPath" ');

      // Build filter for each clip
      for (int i = 0; i < inputPaths.length; i++) {
        final isVideo = inputPaths[i].endsWith('.mp4') ||
            inputPaths[i].endsWith('.mov') ||
            inputPaths[i].endsWith('.avi');

        if (isVideo) {
          filterArgs.write(
            '[$i:v]scale=$width:$height:force_original_aspect_ratio=decrease,'
            'pad=$width:$height:(ow-iw)/2:(oh-ih)/2,setpts=PTS/2[v$i]; '
          );
        } else {
          filterArgs.write(
            '[$i:v]scale=$width:$height:force_original_aspect_ratio=decrease,'
            'pad=$width:$height:(ow-iw)/2:(oh-ih)/2,fps=30[v$i]; '
          );
        }
      }

      // Build concatenation
      if (inputPaths.length > 1) {
        for (int i = 0; i < inputPaths.length; i++) {
          complexFilter.write('[v$i]');
        }
        complexFilter.write('concat=n=${inputPaths.length}:v=1:a=0[outv]');
      } else {
        complexFilter.write('[v0]null[outv]');
      }

      // Build the FFmpeg command
      final command = '${inputArgs.toString().trim()} '
          '-filter_complex "${filterArgs.toString()}${complexFilter.toString()}" '
          '-map "[outv]" '
          '-map ${inputPaths.length}:a '
          '-c:v libx264 '
          '-preset fast '
          '-crf 23 '
          '-b:v ${quality}k '
          '-c:a aac '
          '-b:a 128k '
          '-shortest '
          '"$outputPath"';

      final session = await FFmpegKit.execute(command);
      final returnCode = await session.getReturnCode();

      if (ReturnCode.isSuccess(returnCode)) {
        onProgress?.call(1.0);
        return outputPath;
      } else {
        final logs = await session.getAllLogsAsString();
        print('FFmpeg error: $logs');
        return null;
      }
    } catch (e) {
      print('Video processing error: $e');
      return null;
    }
  }

  Future<String?> exportWithTransitions({
    required List<String> inputPaths,
    required String outputPath,
    required String transitionType,
    required int width,
    required int height,
  }) async {
    try {
      final session = await FFmpegKit.execute(
        '-i "${inputPaths[0]}" '
        '-i "${inputPaths[1]}" '
        '-filter_complex "[0:v][1:v]xfade=transition=fade:duration=1:offset=2[outv]" '
        '-map "[outv]" '
        '-c:v libx264 '
        '"$outputPath"',
      );

      final returnCode = await session.getReturnCode();
      return ReturnCode.isSuccess(returnCode) ? outputPath : null;
    } catch (e) {
      print('Export error: $e');
      return null;
    }
  }

  Future<File?> generateThumbnail(String videoPath) async {
    try {
      final directory = await getTemporaryDirectory();
      final outputPath = '${directory.path}/thumb_${DateTime.now().millisecondsSinceEpoch}.jpg';

      final session = await FFmpegKit.execute(
        '-i "$videoPath" '
        '-ss 00:00:01 '
        '-vframes 1 '
        '-q:v 2 '
        '"$outputPath"',
      );

      final returnCode = await session.getReturnCode();
      if (ReturnCode.isSuccess(returnCode)) {
        return File(outputPath);
      }
      return null;
    } catch (e) {
      print('Thumbnail generation error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getVideoMetadata(String path) async {
    try {
      final session = await FFmpegKit.execute(
        '-i "$path" '
        '-v quiet '
        '-print_format json '
        '-show_format '
        '-show_streams',
      );

      final output = await session.getOutput();
      // Parse metadata from output
      // This is simplified - in production you'd parse JSON properly
      return {
        'path': path,
        'duration': 15, // placeholder
        'width': 1080,
        'height': 1920,
      };
    } catch (e) {
      print('Metadata extraction error: $e');
      return null;
    }
  }
}