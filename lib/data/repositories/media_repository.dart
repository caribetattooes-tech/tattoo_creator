import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../models/media_item.dart';

class MediaRepository {
  final ImagePicker _picker = ImagePicker();

  Future<List<MediaItem>> pickImages() async {
    final images = await _picker.pickMultiImage();
    final items = <MediaItem>[];

    for (final image in images) {
      items.add(MediaItem(
        id: DateTime.now().millisecondsSinceEpoch.toString() + image.path,
        path: image.path,
        type: MediaType.image,
        width: 1080,
        height: 1920,
        fileSize: 0,
        importedAt: DateTime.now(),
      ));
    }

    return items;
  }

  Future<MediaItem?> pickVideo() async {
    final video = await _picker.pickVideo(source: ImageSource.gallery);
    if (video == null) return null;

    return MediaItem(
      id: DateTime.now().millisecondsSinceEpoch.toString() + video.path,
      path: video.path,
      type: MediaType.video,
      duration: const Duration(seconds: 15),
      width: 1080,
      height: 1920,
      fileSize: 0,
      importedAt: DateTime.now(),
    );
  }

  Future<MediaItem?> takePhoto() async {
    final photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo == null) return null;

    return MediaItem(
      id: DateTime.now().millisecondsSinceEpoch.toString() + photo.path,
      path: photo.path,
      type: MediaType.image,
      width: 1080,
      height: 1920,
      fileSize: 0,
      importedAt: DateTime.now(),
    );
  }

  Future<String> getThumbnailPath(String mediaPath) async {
    final directory = await getTemporaryDirectory();
    final thumbnailDir = Directory('${directory.path}/thumbnails');
    if (!await thumbnailDir.exists()) {
      await thumbnailDir.create(recursive: true);
    }

    final fileName = mediaPath.split('/').last;
    final thumbnailPath = '${thumbnailDir.path}/thumb_$fileName.jpg';

    // For now, just return the original path as placeholder
    // In production, you'd generate an actual thumbnail using FFmpeg
    return thumbnailPath;
  }

  Future<void> deleteMedia(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print('Delete media error: $e');
    }
  }
}