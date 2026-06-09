import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/media_item.dart';

class MediaState {
  final List<MediaItem> items;
  final bool isLoading;
  final String? error;

  const MediaState({
    this.items = const [],
    this.isLoading = false,
    this.error,
  });

  MediaState copyWith({
    List<MediaItem>? items,
    bool? isLoading,
    String? error,
  }) {
    return MediaState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class MediaNotifier extends StateNotifier<MediaState> {
  MediaNotifier() : super(const MediaState());

  final _uuid = const Uuid();

  void addMediaItem(MediaItem item) {
    state = state.copyWith(
      items: [...state.items, item],
    );
  }

  void addMediaItems(List<MediaItem> items) {
    state = state.copyWith(
      items: [...state.items, ...items],
    );
  }

  void removeMediaItem(String id) {
    state = state.copyWith(
      items: state.items.where((item) => item.id != id).toList(),
    );
  }

  void clearMedia() {
    state = state.copyWith(items: []);
  }

  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  void setError(String? error) {
    state = state.copyWith(error: error);
  }

  String generateId() => _uuid.v4();
}

final mediaProvider = StateNotifierProvider<MediaNotifier, MediaState>((ref) {
  return MediaNotifier();
});

final selectedMediaProvider = StateProvider<List<String>>((ref) => []);

final mediaCountProvider = Provider<int>((ref) {
  final mediaState = ref.watch(mediaProvider);
  return mediaState.items.length;
});