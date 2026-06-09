enum TransitionType { fade, slide, wipe, zoom }

class TemplateClip {
  final int order;
  final Duration minDuration;
  final Duration maxDuration;
  final String transitionType;
  final bool supportsVideo;
  final bool supportsImage;

  const TemplateClip({
    required this.order,
    required this.minDuration,
    required this.maxDuration,
    required this.transitionType,
    this.supportsVideo = true,
    this.supportsImage = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'order': order,
      'minDuration': minDuration.inMilliseconds,
      'maxDuration': maxDuration.inMilliseconds,
      'transitionType': transitionType,
      'supportsVideo': supportsVideo,
      'supportsImage': supportsImage,
    };
  }

  factory TemplateClip.fromJson(Map<String, dynamic> json) {
    return TemplateClip(
      order: json['order'] as int,
      minDuration: Duration(milliseconds: json['minDuration'] as int),
      maxDuration: Duration(milliseconds: json['maxDuration'] as int),
      transitionType: json['transitionType'] as String,
      supportsVideo: json['supportsVideo'] as bool? ?? true,
      supportsImage: json['supportsImage'] as bool? ?? true,
    );
  }
}

class Template {
  final String id;
  final String name;
  final String description;
  final String category;
  final List<TemplateClip> clips;
  final String musicAsset;
  final Duration totalDuration;
  final String thumbnailAsset;
  final List<String> captionTemplates;

  const Template({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.clips,
    required this.musicAsset,
    required this.totalDuration,
    required this.thumbnailAsset,
    required this.captionTemplates,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'clips': clips.map((c) => c.toJson()).toList(),
      'musicAsset': musicAsset,
      'totalDuration': totalDuration.inMilliseconds,
      'thumbnailAsset': thumbnailAsset,
      'captionTemplates': captionTemplates,
    };
  }

  factory Template.fromJson(Map<String, dynamic> json) {
    return Template(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      clips: (json['clips'] as List)
          .map((c) => TemplateClip.fromJson(c as Map<String, dynamic>))
          .toList(),
      musicAsset: json['musicAsset'] as String,
      totalDuration: Duration(milliseconds: json['totalDuration'] as int),
      thumbnailAsset: json['thumbnailAsset'] as String,
      captionTemplates: List<String>.from(json['captionTemplates'] as List),
    );
  }
}