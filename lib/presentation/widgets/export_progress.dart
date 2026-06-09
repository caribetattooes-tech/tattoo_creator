import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class ExportProgressWidget extends StatelessWidget {
  final double progress;
  final bool isExporting;
  final String? error;

  const ExportProgressWidget({
    super.key,
    required this.progress,
    this.isExporting = false,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isExporting) ...[
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.surfaceLight,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          const SizedBox(height: 8),
          Text(
            '${(progress * 100).toInt()}%',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Exportando video...',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textHint,
            ),
          ),
        ],
        if (error != null) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.error_outline,
                  color: AppColors.error,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    error!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.error,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        if (progress >= 1.0 && !isExporting) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle,
                  color: AppColors.success,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  '¡Video exportado correctamente!',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.success,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}