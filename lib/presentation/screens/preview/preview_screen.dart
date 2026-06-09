import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../providers/project_provider.dart';
import '../../providers/export_provider.dart';
import '../../widgets/export_progress.dart';

class PreviewScreen extends ConsumerWidget {
  const PreviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectState = ref.watch(projectProvider);
    final exportState = ref.watch(exportProvider);
    final project = projectState.currentProject;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/editor'),
        ),
        actions: [
          if (!exportState.isExporting && project != null)
            TextButton(
              onPressed: () => context.go('/export'),
              child: const Text(
                'Exportar',
                style: TextStyle(color: AppColors.primary),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Video preview placeholder
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(AppDimensions.spacingM),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (exportState.isExporting)
                      Column(
                        children: [
                          const CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                          const SizedBox(height: AppDimensions.spacingM),
                          Text(
                            'Generando video... ${(exportState.progress * 100).toInt()}%',
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      )
                    else if (project != null)
                      Column(
                        children: [
                          Icon(
                            Icons.play_circle_outline,
                            size: 80,
                            color: AppColors.primary.withOpacity(0.7),
                          ),
                          const SizedBox(height: AppDimensions.spacingM),
                          Text(
                            project.template.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: AppDimensions.spacingS),
                          Text(
                            '${project.mediaItems.length} clips • ${project.template.totalDuration.inSeconds}s',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      )
                    else
                      const Text(
                        'No hay proyecto activo',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          // Export progress
          if (exportState.isExporting)
            Padding(
              padding: const EdgeInsets.all(AppDimensions.spacingM),
              child: ExportProgressWidget(
                progress: exportState.progress,
                isExporting: true,
              ),
            ),

          // Project info
          if (project != null)
            Container(
              padding: const EdgeInsets.all(AppDimensions.spacingM),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(
                  top: BorderSide(color: AppColors.surfaceLight),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Información del proyecto',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingS),
                  Row(
                    children: [
                      _InfoItem(
                        icon: Icons.layers,
                        label: 'Plantilla',
                        value: project.template.name,
                      ),
                      const SizedBox(width: AppDimensions.spacingL),
                      _InfoItem(
                        icon: Icons.photo_library,
                        label: 'Medios',
                        value: '${project.mediaItems.length}',
                      ),
                      const SizedBox(width: AppDimensions.spacingL),
                      _InfoItem(
                        icon: Icons.tag,
                        label: 'Hashtags',
                        value: '${project.selectedHashtags.length}',
                      ),
                    ],
                  ),
                ],
              ),
            ),

          // Action buttons
          Container(
            padding: const EdgeInsets.all(AppDimensions.spacingM),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.go('/editor'),
                      child: const Text('Editar Plantilla'),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacingM),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: project != null && !exportState.isExporting
                          ? () => context.go('/export')
                          : null,
                      child: const Text('Exportar'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: AppColors.textSecondary),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}