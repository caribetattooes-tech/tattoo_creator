import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/trending_hashtags.dart';
import '../../providers/inspiration_provider.dart';
import '../../widgets/trend_card.dart';

class InspirationScreen extends ConsumerWidget {
  const InspirationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trends = ref.watch(trendingIdeasProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inspiración'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Categories filter
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingM),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _CategoryFilterChip(
                  label: 'Todas',
                  isSelected: selectedCategory == null,
                  onTap: () => ref.read(selectedCategoryProvider.notifier).state = null,
                ),
                ...TrendingHashtags.categories.map((cat) {
                  return _CategoryFilterChip(
                    label: cat['name']!,
                    isSelected: selectedCategory == cat['name'],
                    onTap: () => ref.read(selectedCategoryProvider.notifier).state = cat['name'],
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.spacingM),

          // Trending ideas grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingM),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: AppDimensions.spacingM,
                  mainAxisSpacing: AppDimensions.spacingM,
                ),
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
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/import'),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add),
        label: const Text('Crear Video'),
      ),
    );
  }
}

class _CategoryFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryFilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: AppDimensions.spacingS),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingM,
          vertical: AppDimensions.spacingS,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusCircle),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}