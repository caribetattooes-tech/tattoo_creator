enum MediaType { video, image }

class MediaItem {
  final String id;
  final String path;
  final MediaType type;
  final Duration? duration;
  final int width;
  final int height;
  final int fileSize;
  final DateTime importedAt;
  final String? thumbnailPath;

  const MediaItem({
    required this.id,
    required this.path,
    required this.type,
    this.duration,
    required this.width,
    required this.height,
    required this.fileSize,
    required this.importedAt,
    this.thumbnailPath,
  });

  MediaItem copyWith({
    String? id,
    String? path,
    MediaType? type,
    Duration? duration,
    int? width,
    int? height,
    int? fileSize,
    DateTime? importedAt,
    String? thumbnailPath,
  }) {
    return MediaItem(
      id: id ?? this.id,
      path: path ?? this.path,
      type: type ?? this.type,
      duration: duration ?? this.duration,
      width: width ?? this.width,
      height: height ?? this.height,
      fileSize: fileSize ?? this.fileSize,
      importedAt: importedAt ?? this.importedAt,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'path': path,
      'type': type.name,
      'duration': duration?.inMilliseconds,
      'width': width,
      'height': height,
      'fileSize': fileSize,
      'importedAt': importedAt.toIso8601String(),
      'thumbnailPath': thumbnailPath,
    };
  }

  factory MediaItem.fromJson(Map<String, dynamic> json) {
    return MediaItem(
      id: json['id'] as String,
      path: json['path'] as String,
      type: MediaType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => MediaType.image,
      ),
      duration: json['duration'] != null
          ? Duration(milliseconds: json['duration'] as int)
          : null,
      width: json['width'] as int,
      height: json['height'] as int,
      fileSize: json['fileSize'] as int,
      importedAt: DateTime.parse(json['importedAt'] as String),
      thumbnailPath: json['thumbnailPath'] as String?,
    );
  }
}