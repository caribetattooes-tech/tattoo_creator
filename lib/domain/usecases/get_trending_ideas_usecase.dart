import '../../data/models/trend_item.dart';

class GetTrendingIdeasUseCase {
  List<TrendItem> execute() {
    return TrendData.tattooTrends;
  }

  List<TrendItem> filterByCategory(String category) {
    return TrendData.tattooTrends
        .where((t) => t.category == category)
        .toList();
  }

  List<TrendItem> getNewTrends() {
    return TrendData.tattooTrends.where((t) => t.isNew).toList();
  }

  List<TrendItem> getTopTrends({int limit = 5}) {
    final sorted = List<TrendItem>.from(TrendData.tattooTrends)
      ..sort((a, b) => b.popularityScore.compareTo(a.popularityScore));
    return sorted.take(limit).toList();
  }
}