String formatDuration(Duration duration) {
  final minutes = duration.inMinutes;
  final seconds = duration.inSeconds % 60;
  return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
}

String formatFileSize(int bytes) {
  if (bytes < 1024) return '$bytes B';
  if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
  if (bytes < 1024 * 1024 * 1024) {
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
  return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
}

String formatResolution(int width, int height) {
  if (width >= 3840 || height >= 3840) return '4K';
  if (width >= 1920 || height >= 1920) return '1080p';
  if (width >= 1280 || height >= 1280) return '720p';
  if (width >= 854 || height >= 854) return '480p';
  return '${width}x$height';
}