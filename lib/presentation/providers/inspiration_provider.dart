import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/trend_item.dart';

final trendingIdeasProvider = Provider<List<TrendItem>>((ref) {
  return TrendData.tattooTrends;
});

final selectedCategoryProvider = StateProvider<String?>((ref) => null);

final filteredTrendsProvider = Provider<List<TrendItem>>((ref) {
  final trends = ref.watch(trendingIdeasProvider);
  final category = ref.watch(selectedCategoryProvider);

  if (category == null) return trends;
  return trends.where((t) => t.category == category).toList();
});

final selectedTrendProvider = StateProvider<TrendItem?>((ref) => null);