import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../data/models/media_item.dart';
import '../../providers/media_provider.dart';
import '../../providers/inspiration_provider.dart';
import '../../widgets/media_thumbnail.dart';

class ImportMediaScreen extends ConsumerStatefulWidget {
  const ImportMediaScreen({super.key});

  @override
  ConsumerState<ImportMediaScreen> createState() => _ImportMediaScreenState();
}

class _ImportMediaScreenState extends ConsumerState<ImportMediaScreen> {
  final _picker = ImagePicker();
  bool _isLoading = false;

  Future<void> _pickMedia() async {
    setState(() => _isLoading = true);

    try {
      // Pick multiple images/videos
      final images = await _picker.pickMultiImage();
      final video = await _picker.pickVideo(source: ImageSource.gallery);

      final uuid = const Uuid();

      // Add images
      for (final image in images) {
        final mediaItem = MediaItem(
          id: uuid.v4(),
          path: image.path,
          type: MediaType.image,
          width: 1080,
          height: 1920,
          fileSize: 0,
          importedAt: DateTime.now(),
        );
        ref.read(mediaProvider.notifier).addMediaItem(mediaItem);
      }

      // Add video
      if (video != null) {
        final mediaItem = MediaItem(
          id: uuid.v4(),
          path: video.path,
          type: MediaType.video,
          duration: const Duration(seconds: 15),
          width: 1080,
          height: 1920,
          fileSize: 0,
          importedAt: DateTime.now(),
        );
        ref.read(mediaProvider.notifier).addMediaItem(mediaItem);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al importar: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _takePhoto() async {
    setState(() => _isLoading = true);

    try {
      final photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        final uuid = const Uuid();
        final mediaItem = MediaItem(
          id: uuid.v4(),
          path: photo.path,
          type: MediaType.image,
          width: 1080,
          height: 1920,
          fileSize: 0,
          importedAt: DateTime.now(),
        );
        ref.read(mediaProvider.notifier).addMediaItem(mediaItem);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al tomar foto: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaState = ref.watch(mediaProvider);
    final selectedTrend = ref.watch(selectedTrendProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Importar Medios'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/inspiration'),
        ),
        actions: [
          if (mediaState.items.isNotEmpty)
            TextButton(
              onPressed: () => context.go('/editor'),
              child: const Text(
                'Siguiente',
                style: TextStyle(color: AppColors.primary),
              ),
            ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Selected trend info
          if (selectedTrend != null)
            Container(
              margin: const EdgeInsets.all(AppDimensions.spacingM),
              padding: const EdgeInsets.all(AppDimensions.spacingM),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
              child: Row(
                children: [
                  const Icon(Icons.lightbulb, color: AppColors.primary),
                  const SizedBox(width: AppDimensions.spacingS),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Idea: ${selectedTrend.title}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          selectedTrend.suggestedHashtags.join(' '),
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // Media grid
          Expanded(
            child: mediaState.items.isEmpty
                ? _buildEmptyState()
                : GridView.builder(
                    padding: const EdgeInsets.all(AppDimensions.spacingM),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: AppDimensions.spacingS,
                      mainAxisSpacing: AppDimensions.spacingS,
                    ),
                    itemCount: mediaState.items.length,
                    itemBuilder: (context, index) {
                      final item = mediaState.items[index];
                      return MediaThumbnail(
                        media: item,
                        onRemove: () {
                          ref.read(mediaProvider.notifier).removeMediaItem(item.id);
                        },
                      );
                    },
                  ),
          ),

          // Import buttons
          Container(
            padding: const EdgeInsets.all(AppDimensions.spacingM),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(
                top: BorderSide(color: AppColors.surfaceLight),
              ),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _isLoading ? null : _takePhoto,
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Cámara'),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacingM),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _pickMedia,
                      icon: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.photo_library),
                      label: Text(_isLoading ? 'Importando...' : 'Galería'),
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.photo_library_outlined,
            size: 80,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: AppDimensions.spacingM),
          const Text(
            'No hay medios importados',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingS),
          const Text(
            'Importa fotos y videos de tu galería\npara crear tu video',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textHint,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingXL),
          ElevatedButton.icon(
            onPressed: _pickMedia,
            icon: const Icon(Icons.add),
            label: const Text('Importar Medios'),
          ),
        ],
      ),
    );
  }
}