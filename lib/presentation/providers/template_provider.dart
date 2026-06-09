import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/template.dart';

final templatesProvider = Provider<List<Template>>((ref) {
  return _predefinedTemplates;
});

final selectedTemplateProvider = StateProvider<Template?>((ref) => null);

final templateCategoriesProvider = Provider<List<String>>((ref) {
  return _predefinedTemplates.map((t) => t.category).toSet().toList();
});

final filteredTemplatesProvider = Provider<List<Template>>((ref) {
  final templates = ref.watch(templatesProvider);
  final category = ref.watch(selectedCategoryProvider);
  if (category == null) return templates;
  return templates.where((t) => t.category == category).toList();
});

final selectedCategoryProvider = StateProvider<String?>((ref) => null);

// Predefined templates for tattoo content
final List<Template> _predefinedTemplates = [
  Template(
    id: 'before_after',
    name: 'Before/After',
    description: 'Foto inicio → Foto resultado con transición elegante',
    category: 'Transformación',
    clips: const [
      TemplateClip(
        order: 0,
        minDuration: Duration(seconds: 2),
        maxDuration: Duration(seconds: 5),
        transitionType: 'fade',
        supportsVideo: false,
        supportsImage: true,
      ),
      TemplateClip(
        order: 1,
        minDuration: Duration(seconds: 2),
        maxDuration: Duration(seconds: 5),
        transitionType: 'fade',
        supportsVideo: false,
        supportsImage: true,
      ),
    ],
    musicAsset: 'assets/music/inspiring.mp3',
    totalDuration: const Duration(seconds: 15),
    thumbnailAsset: 'assets/images/before_after.png',
    captionTemplates: [
      'Del diseño a la realidad #tattootransformation',
      'El resultado habla por sí mismo #beforeandafter',
    ],
  ),
  Template(
    id: 'timelapse',
    name: 'Time-lapse',
    description: 'Clips acelerados del proceso de tatuaje',
    category: 'Proceso',
    clips: const [
      TemplateClip(
        order: 0,
        minDuration: Duration(seconds: 5),
        maxDuration: Duration(seconds: 15),
        transitionType: 'slide',
        supportsVideo: true,
        supportsImage: false,
      ),
      TemplateClip(
        order: 1,
        minDuration: Duration(seconds: 5),
        maxDuration: Duration(seconds: 15),
        transitionType: 'slide',
        supportsVideo: true,
        supportsImage: false,
      ),
      TemplateClip(
        order: 2,
        minDuration: Duration(seconds: 5),
        maxDuration: Duration(seconds: 15),
        transitionType: 'slide',
        supportsVideo: true,
        supportsImage: false,
      ),
    ],
    musicAsset: 'assets/music/energetic.mp3',
    totalDuration: const Duration(seconds: 30),
    thumbnailAsset: 'assets/images/timelapse.png',
    captionTemplates: [
      'De blanco a negro #tattooprocess #timelapse',
      'El arte toma forma #tattooing',
    ],
  ),
  Template(
    id: 'detalle',
    name: 'Detalle',
    description: 'Close-ups con música ambiental',
    category: 'Detalles',
    clips: const [
      TemplateClip(
        order: 0,
        minDuration: Duration(seconds: 3),
        maxDuration: Duration(seconds: 8),
        transitionType: 'zoom',
        supportsVideo: true,
        supportsImage: true,
      ),
      TemplateClip(
        order: 1,
        minDuration: Duration(seconds: 3),
        maxDuration: Duration(seconds: 8),
        transitionType: 'zoom',
        supportsVideo: true,
        supportsImage: true,
      ),
      TemplateClip(
        order: 2,
        minDuration: Duration(seconds: 3),
        maxDuration: Duration(seconds: 8),
        transitionType: 'fade',
        supportsVideo: true,
        supportsImage: true,
      ),
    ],
    musicAsset: 'assets/music/ambient.mp3',
    totalDuration: const Duration(seconds: 15),
    thumbnailAsset: 'assets/images/detalle.png',
    captionTemplates: [
      'Los detalles importan #tattoodetail #closeuptattoo',
      'Cada línea cuenta #tattootechnology',
    ],
  ),
  Template(
    id: 'testimonial',
    name: 'Testimonial',
    description: 'Video con texto superpuesto estilo entrevista',
    category: 'Testimonial',
    clips: const [
      TemplateClip(
        order: 0,
        minDuration: Duration(seconds: 5),
        maxDuration: Duration(seconds: 15),
        transitionType: 'fade',
        supportsVideo: true,
        supportsImage: true,
      ),
    ],
    musicAsset: 'assets/music/emotional.mp3',
    totalDuration: const Duration(seconds: 30),
    thumbnailAsset: 'assets/images/testimonial.png',
    captionTemplates: [
      'Cada tatuaje cuenta una historia #tattooartistlife',
      'Arte que permanece #tattoolife',
    ],
  ),
  Template(
    id: 'quick_stats',
    name: 'Quick Stats',
    description: 'Múltiples fotos con transiciones rápidas estilo reel',
    category: 'Portfolio',
    clips: const [
      TemplateClip(
        order: 0,
        minDuration: Duration(seconds: 1),
        maxDuration: Duration(seconds: 3),
        transitionType: 'wipe',
        supportsVideo: false,
        supportsImage: true,
      ),
      TemplateClip(
        order: 1,
        minDuration: Duration(seconds: 1),
        maxDuration: Duration(seconds: 3),
        transitionType: 'wipe',
        supportsVideo: false,
        supportsImage: true,
      ),
      TemplateClip(
        order: 2,
        minDuration: Duration(seconds: 1),
        maxDuration: Duration(seconds: 3),
        transitionType: 'wipe',
        supportsVideo: false,
        supportsImage: true,
      ),
      TemplateClip(
        order: 3,
        minDuration: Duration(seconds: 1),
        maxDuration: Duration(seconds: 3),
        transitionType: 'wipe',
        supportsVideo: false,
        supportsImage: true,
      ),
      TemplateClip(
        order: 4,
        minDuration: Duration(seconds: 1),
        maxDuration: Duration(seconds: 3),
        transitionType: 'wipe',
        supportsVideo: false,
        supportsImage: true,
      ),
    ],
    musicAsset: 'assets/music/upbeat.mp3',
    totalDuration: const Duration(seconds: 15),
    thumbnailAsset: 'assets/images/quick_stats.png',
    captionTemplates: [
      'Mi trabajo #tattoowork #artistsoninstagram',
      'Colección reciente #tattoodesign',
    ],
  ),
  Template(
    id: 'behind_scenes',
    name: 'Behind Scenes',
    description: 'Clips del estudio con música energética',
    category: 'Estudio',
    clips: const [
      TemplateClip(
        order: 0,
        minDuration: Duration(seconds: 5),
        maxDuration: Duration(seconds: 15),
        transitionType: 'slide',
        supportsVideo: true,
        supportsImage: false,
      ),
      TemplateClip(
        order: 1,
        minDuration: Duration(seconds: 5),
        maxDuration: Duration(seconds: 15),
        transitionType: 'slide',
        supportsVideo: true,
        supportsImage: false,
      ),
      TemplateClip(
        order: 2,
        minDuration: Duration(seconds: 5),
        maxDuration: Duration(seconds: 15),
        transitionType: 'fade',
        supportsVideo: true,
        supportsImage: true,
      ),
    ],
    musicAsset: 'assets/music/energetic.mp3',
    totalDuration: const Duration(seconds: 30),
    thumbnailAsset: 'assets/images/behind_scenes.png',
    captionTemplates: [
      'Así se hace #tattoostudio #inklife',
      'Detrás del arte #tattooartist',
    ],
  ),
];