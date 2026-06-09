import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../providers/inspiration_provider.dart';
import '../../providers/media_provider.dart';
import '../../widgets/trend_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trends = ref.watch(trendingIdeasProvider);
    final mediaState = ref.watch(mediaProvider);
    final mediaCount = ref.watch(mediaCountProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.spacingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TattooCreator',
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Crea contenido viral para Instagram',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                    ),
                    child: const Icon(
                      Icons.person_outline,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spacingXL),

              // Quick Actions
              Row(
                children: [
                  Expanded(
                    child: _QuickActionCard(
                      icon: Icons.add_circle_outline,
                      title: 'Nuevo Video',
                      subtitle: 'Crear desde cero',
                      onTap: () => context.go('/inspiration'),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacingM),
                  Expanded(
                    child: _QuickActionCard(
                      icon: Icons.photo_library_outlined,
                      title: 'Mis Medios',
                      subtitle: '${mediaCount} archivos',
                      onTap: () => context.go('/import'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spacingXL),

              // Trending Ideas Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Ideas en Tendencia',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.go('/inspiration'),
                    child: const Text(
                      'Ver todas',
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spacingM),
              SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: trends.length,
                  itemBuilder: (context, index) {
                    final trend = trends[index];
                    return TrendCard(
                      trend: trend,
                      onTap: () {
                        ref.read(selectedTrendProvider.notifier).state = trend;
                        context.go('/import');
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: AppDimensions.spacingXL),

              // Categories Section
              const Text(
                'Categorías',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingM),
              Wrap(
                spacing: AppDimensions.spacingS,
                runSpacing: AppDimensions.spacingS,
                children: [
                  _CategoryChip(
                    label: 'Proceso',
                    icon: Icons.brush,
                    onTap: () {},
                  ),
                  _CategoryChip(
                    label: 'Before/After',
                    icon: Icons.compare,
                    onTap: () {},
                  ),
                  _CategoryChip(
                    label: 'Diseño',
                    icon: Icons.draw,
                    onTap: () {},
                  ),
                  _CategoryChip(
                    label: 'Detalles',
                    icon: Icons.zoom_in,
                    onTap: () {},
                  ),
                  _CategoryChip(
                    label: 'Estudio',
                    icon: Icons.location_city,
                    onTap: () {},
                  ),
                  _CategoryChip(
                    label: 'Estilos',
                    icon: Icons.style,
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spacingXL),

              // Tips Section
              Container(
                padding: const EdgeInsets.all(AppDimensions.spacingM),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.lightbulb_outline, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'Tip del día',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.spacingS),
                    const Text(
                      'Los videos de proceso en time-lapse tienen un 40% más engagement. Intenta mostrar el tatuaje de inicio a fin.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacingM),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white),
                      ),
                      child: const Text('Aprender más'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.spacingXL),

              // Recent Projects
              if (mediaState.items.isNotEmpty) ...[
                const Text(
                  'Medios Recientes',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingM),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: mediaState.items.length.clamp(0, 5),
                    itemBuilder: (context, index) {
                      final item = mediaState.items[index];
                      return Container(
                        width: 100,
                        margin: const EdgeInsets.only(right: AppDimensions.spacingS),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.image,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spacingM),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusS),
              ),
              child: Icon(icon, color: AppColors.primary, size: 24),
            ),
            const SizedBox(height: AppDimensions.spacingM),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingM,
          vertical: AppDimensions.spacingS,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusCircle),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: AppColors.textSecondary),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}