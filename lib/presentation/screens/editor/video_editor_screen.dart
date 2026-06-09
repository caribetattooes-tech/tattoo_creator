import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../providers/template_provider.dart';
import '../../providers/media_provider.dart';
import '../../providers/project_provider.dart';
import '../../providers/inspiration_provider.dart';
import '../../widgets/template_card.dart';
import '../../widgets/media_thumbnail.dart';

class VideoEditorScreen extends ConsumerWidget {
  const VideoEditorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final templates = ref.watch(templatesProvider);
    final selectedTemplate = ref.watch(selectedTemplateProvider);
    final mediaState = ref.watch(mediaProvider);
    final selectedTrend = ref.watch(selectedTrendProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar Plantilla'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/import'),
        ),
        actions: [
          if (selectedTemplate != null && mediaState.items.isNotEmpty)
            TextButton(
              onPressed: () {
                // Create project
                ref.read(projectProvider.notifier).createProject(
                  name: 'Proyecto ${DateTime.now().millisecondsSinceEpoch}',
                  template: selectedTemplate,
                  mediaItems: mediaState.items,
                  hashtags: selectedTrend?.suggestedHashtags ?? [],
                );
                context.go('/preview');
              },
              child: const Text(
                'Continuar',
                style: TextStyle(color: AppColors.primary),
              ),
            ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Media preview
          Container(
            height: 120,
            padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacingS),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spacingM,
              ),
              itemCount: mediaState.items.length,
              itemBuilder: (context, index) {
                final item = mediaState.items[index];
                return MediaThumbnail(
                  media: item,
                  isSelected: true,
                );
              },
            ),
          ),

          // Templates section
          Padding(
            padding: const EdgeInsets.all(AppDimensions.spacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Plantillas de Video',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingS),
                const Text(
                  'Selecciona una plantilla para tu video',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Templates horizontal list
          SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spacingM,
              ),
              itemCount: templates.length,
              itemBuilder: (context, index) {
                final template = templates[index];
                return TemplateCard(
                  template: template,
                  isSelected: selectedTemplate?.id == template.id,
                  onTap: () {
                    ref.read(selectedTemplateProvider.notifier).state = template;
                  },
                );
              },
            ),
          ),

          const SizedBox(height: AppDimensions.spacingM),

          // Template details
          if (selectedTemplate != null)
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(AppDimensions.spacingM),
                padding: const EdgeInsets.all(AppDimensions.spacingM),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedTemplate.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            selectedTemplate.category,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.spacingS),
                    Text(
                      selectedTemplate.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacingM),
                    Row(
                      children: [
                        _InfoChip(
                          icon: Icons.timer,
                          label: '${selectedTemplate.totalDuration.inSeconds}s',
                        ),
                        const SizedBox(width: AppDimensions.spacingS),
                        _InfoChip(
                          icon: Icons.layers,
                          label: '${selectedTemplate.clips.length} clips',
                        ),
                        const SizedBox(width: AppDimensions.spacingS),
                        _InfoChip(
                          icon: Icons.music_note,
                          label: 'Música',
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.spacingM),
                    const Text(
                      'Captions sugeridos:',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textHint,
                      ),
                    ),
                    const SizedBox(height: 4),
                    ...selectedTemplate.captionTemplates.map((caption) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          caption,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
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
    );
  }
}