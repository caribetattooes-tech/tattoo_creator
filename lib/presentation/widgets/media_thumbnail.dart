import 'dart:io';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../data/models/media_item.dart';

class MediaThumbnail extends StatelessWidget {
  final MediaItem media;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;

  const MediaThumbnail({
    super.key,
    required this.media,
    this.isSelected = false,
    this.onTap,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppDimensions.thumbnailSize,
        height: AppDimensions.thumbnailSize,
        margin: const EdgeInsets.only(right: AppDimensions.spacingS),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          border: isSelected
              ? Border.all(color: AppColors.primary, width: 2)
              : null,
        ),
        child: Stack(
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(AppDimensions.radiusS - 2),
              child: media.thumbnailPath != null
                  ? Image.file(
                      File(media.thumbnailPath!),
                      width: AppDimensions.thumbnailSize,
                      height: AppDimensions.thumbnailSize,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _buildPlaceholder(),
                    )
                  : _buildPlaceholder(),
            ),
            // Media type indicator
            Positioned(
              bottom: 4,
              left: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      media.type == MediaType.video
                          ? Icons.videocam
                          : Icons.image,
                      size: 12,
                      color: Colors.white,
                    ),
                    if (media.duration != null) ...[
                      const SizedBox(width: 2),
                      Text(
                        _formatDuration(media.duration!),
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            // Remove button
            if (onRemove != null)
              Positioned(
                top: 2,
                right: 2,
                child: GestureDetector(
                  onTap: onRemove,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: AppDimensions.thumbnailSize,
      height: AppDimensions.thumbnailSize,
      color: AppColors.surfaceLight,
      child: Icon(
        media.type == MediaType.video ? Icons.videocam : Icons.image,
        color: AppColors.textSecondary,
        size: 24,
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}