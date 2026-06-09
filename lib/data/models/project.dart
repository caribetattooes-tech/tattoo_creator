import 'media_item.dart';
import 'template.dart';

enum ExportStatus { idle, preparing, exporting, completed, failed }

enum ExportFormat { reels, story, postSquare }

class ExportSettings {
  final ExportFormat format;
  final int width;
  final int height;
  final int quality; // bitrate in kbps

  const ExportSettings({
    required this.format,
    required this.width,
    required this.height,
    required this.quality,
  });

  static ExportSettings reelsHD() => const ExportSettings(
        format: ExportFormat.reels,
        width: 1080,
        height: 1920,
        quality: 8000,
      );

  static ExportSettings reels720p() => const ExportSettings(
        format: ExportFormat.reels,
        width: 720,
        height: 1280,
        quality: 4000,
      );

  static ExportSettings storyHD() => const ExportSettings(
        format: ExportFormat.story,
        width: 1080,
        height: 1920,
        quality: 8000,
      );

  static ExportSettings postSquareHD() => const ExportSettings(
        format: ExportFormat.postSquare,
        width: 1080,
        height: 1080,
        quality: 8000,
      );
}

class Project {
  final String id;
  final String name;
  final Template template;
  final List<MediaItem> mediaItems;
  final List<String> selectedHashtags;
  final String? outputPath;
  final ExportStatus status;
  final double exportProgress;
  final ExportSettings exportSettings;
  final DateTime createdAt;
  final DateTime? modifiedAt;

  const Project({
    required this.id,
    required this.name,
    required this.template,
    required this.mediaItems,
    required this.selectedHashtags,
    this.outputPath,
    this.status = ExportStatus.idle,
    this.exportProgress = 0.0,
    required this.exportSettings,
    required this.createdAt,
    this.modifiedAt,
  });

  Project copyWith({
    String? id,
    String? name,
    Template? template,
    List<MediaItem>? mediaItems,
    List<String>? selectedHashtags,
    String? outputPath,
    ExportStatus? status,
    double? exportProgress,
    ExportSettings? exportSettings,
    DateTime? createdAt,
    DateTime? modifiedAt,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      template: template ?? this.template,
      mediaItems: mediaItems ?? this.mediaItems,
      selectedHashtags: selectedHashtags ?? this.selectedHashtags,
      outputPath: outputPath ?? this.outputPath,
      status: status ?? this.status,
      exportProgress: exportProgress ?? this.exportProgress,
      exportSettings: exportSettings ?? this.exportSettings,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'template': template.toJson(),
      'mediaItems': mediaItems.map((m) => m.toJson()).toList(),
      'selectedHashtags': selectedHashtags,
      'outputPath': outputPath,
      'status': status.name,
      'exportProgress': exportProgress,
      'exportSettings': {
        'format': exportSettings.format.name,
        'width': exportSettings.width,
        'height': exportSettings.height,
        'quality': exportSettings.quality,
      },
      'createdAt': createdAt.toIso8601String(),
      'modifiedAt': modifiedAt?.toIso8601String(),
    };
  }

  factory Project.fromJson(Map<String, dynamic> json) {
    final settings = json['exportSettings'] as Map<String, dynamic>;
    return Project(
      id: json['id'] as String,
      name: json['name'] as String,
      template: Template.fromJson(json['template'] as Map<String, dynamic>),
      mediaItems: (json['mediaItems'] as List)
          .map((m) => MediaItem.fromJson(m as Map<String, dynamic>))
          .toList(),
      selectedHashtags: List<String>.from(json['selectedHashtags'] as List),
      outputPath: json['outputPath'] as String?,
      status: ExportStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ExportStatus.idle,
      ),
      exportProgress: (json['exportProgress'] as num).toDouble(),
      exportSettings: ExportSettings(
        format: ExportFormat.values.firstWhere(
          (e) => e.name == settings['format'],
          orElse: () => ExportFormat.reels,
        ),
        width: settings['width'] as int,
        height: settings['height'] as int,
        quality: settings['quality'] as int,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      modifiedAt: json['modifiedAt'] != null
          ? DateTime.parse(json['modifiedAt'] as String)
          : null,
    );
  }
}