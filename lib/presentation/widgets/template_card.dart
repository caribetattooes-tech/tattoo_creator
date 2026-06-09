import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../data/models/template.dart';

class TemplateCard extends StatelessWidget {
  final Template template;
  final bool isSelected;
  final VoidCallback? onTap;

  const TemplateCard({
    super.key,
    required this.template,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: AppDimensions.spacingM),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          border: isSelected
              ? Border.all(color: AppColors.primary, width: 2)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail placeholder
            Container(
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppDimensions.radiusM),
                  topRight: Radius.circular(AppDimensions.radiusM),
                ),
              ),
              child: Center(
                child: Icon(
                  _getCategoryIcon(template.category),
                  size: 32,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppDimensions.spacingS),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    template.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${template.totalDuration.inSeconds}s',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      template.category,
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Transformación':
        return Icons.compare;
      case 'Proceso':
        return Icons.timer;
      case 'Detalles':
        return Icons.zoom_in;
      case 'Testimonial':
        return Icons.format_quote;
      case 'Portfolio':
        return Icons.grid_view;
      case 'Estudio':
        return Icons.location_city;
      default:
        return Icons.video_library;
    }
  }
}