import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../data/models/project.dart';
import '../../providers/project_provider.dart';
import '../../providers/export_provider.dart';
import '../../widgets/export_progress.dart';

class ExportScreen extends ConsumerWidget {
  const ExportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectState = ref.watch(projectProvider);
    final exportState = ref.watch(exportProvider);
    final project = projectState.currentProject;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exportar'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/preview'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Format selection
            const Text(
              'Formato de exportación',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingM),
            Row(
              children: [
                Expanded(
                  child: _FormatOption(
                    label: 'Reels',
                    subtitle: '1080x1920',
                    icon: Icons.smartphone,
                    isSelected: exportState.format == ExportFormat.reels,
                    onTap: () {
                      ref.read(exportProvider.notifier).setFormat(ExportFormat.reels);
                      ref.read(exportProvider.notifier).setQuality(8000);
                    },
                  ),
                ),
                const SizedBox(width: AppDimensions.spacingS),
                Expanded(
                  child: _FormatOption(
                    label: 'Story',
                    subtitle: '1080x1920',
                    icon: Icons.auto_stories,
                    isSelected: exportState.format == ExportFormat.story,
                    onTap: () {
                      ref.read(exportProvider.notifier).setFormat(ExportFormat.story);
                      ref.read(exportProvider.notifier).setQuality(8000);
                    },
                  ),
                ),
                const SizedBox(width: AppDimensions.spacingS),
                Expanded(
                  child: _FormatOption(
                    label: 'Post',
                    subtitle: '1080x1080',
                    icon: Icons.crop_square,
                    isSelected: exportState.format == ExportFormat.postSquare,
                    onTap: () {
                      ref.read(exportProvider.notifier).setFormat(ExportFormat.postSquare);
                      ref.read(exportProvider.notifier).setQuality(8000);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingXL),

            // Quality selection
            const Text(
              'Calidad',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingM),
            Row(
              children: [
                Expanded(
                  child: _QualityOption(
                    label: '720p',
                    subtitle: 'Menor tamaño',
                    isSelected: exportState.quality == 4000,
                    onTap: () {
                      ref.read(exportProvider.notifier).setQuality(4000);
                    },
                  ),
                ),
                const SizedBox(width: AppDimensions.spacingS),
                Expanded(
                  child: _QualityOption(
                    label: '1080p',
                    subtitle: 'Mejor calidad',
                    isSelected: exportState.quality == 8000,
                    onTap: () {
                      ref.read(exportProvider.notifier).setQuality(8000);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingXL),

            // Export progress
            if (exportState.isExporting || exportState.outputPath != null)
              ExportProgressWidget(
                progress: exportState.progress,
                isExporting: exportState.isExporting,
                error: exportState.error,
              ),

            const SizedBox(height: AppDimensions.spacingXL),

            // Export button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: exportState.isExporting
                    ? null
                    : () => _startExport(context, ref),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    exportState.isExporting
                        ? 'Exportando...'
                        : exportState.outputPath != null
                            ? 'Exportar de nuevo'
                            : 'Exportar Video',
                  ),
                ),
              ),
            ),

            // Share button
            if (exportState.outputPath != null) ...[
              const SizedBox(height: AppDimensions.spacingM),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Share.shareXFiles(
                      [XFile(exportState.outputPath!)],
                      text: 'Mi video de tatuaje creado con TattooCreator',
                    );
                  },
                  icon: const Icon(Icons.share),
                  label: const Text('Compartir'),
                ),
              ),
            ],

            // Project summary
            if (project != null) ...[
              const SizedBox(height: AppDimensions.spacingXL),
              Container(
                padding: const EdgeInsets.all(AppDimensions.spacingM),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Resumen del proyecto',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacingM),
                    _SummaryRow(
                      label: 'Plantilla',
                      value: project.template.name,
                    ),
                    _SummaryRow(
                      label: 'Formato',
                      value: '${exportState.format.name} (${exportState.quality}kbps)',
                    ),
                    _SummaryRow(
                      label: 'Duración',
                      value: '${project.template.totalDuration.inSeconds}s',
                    ),
                    _SummaryRow(
                      label: 'Archivos',
                      value: '${project.mediaItems.length}',
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _startExport(BuildContext context, WidgetRef ref) async {
    ref.read(exportProvider.notifier).startExport();

    // Simulate export progress
    for (int i = 0; i <= 100; i += 10) {
      await Future.delayed(const Duration(milliseconds: 500));
      ref.read(exportProvider.notifier).updateProgress(i / 100);
    }

    // Complete export
    final outputPath = '/path/to/export/video_${DateTime.now().millisecondsSinceEpoch}.mp4';
    ref.read(exportProvider.notifier).completeExport(outputPath);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Video exportado correctamente!'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }
}

class _FormatOption extends StatelessWidget {
  final String label;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _FormatOption({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spacingM),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          border: isSelected
              ? Border.all(color: AppColors.primary, width: 2)
              : Border.all(color: AppColors.surfaceLight),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              size: 28,
            ),
            const SizedBox(height: AppDimensions.spacingS),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QualityOption extends StatelessWidget {
  final String label;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _QualityOption({
    required this.label,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spacingM),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          border: isSelected
              ? Border.all(color: AppColors.primary, width: 2)
              : Border.all(color: AppColors.surfaceLight),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spacingS),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}