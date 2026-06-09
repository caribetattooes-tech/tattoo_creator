import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/project.dart';

class ExportState {
  final ExportFormat format;
  final int quality;
  final double progress;
  final bool isExporting;
  final String? error;
  final String? outputPath;

  const ExportState({
    this.format = ExportFormat.reels,
    this.quality = 8000,
    this.progress = 0.0,
    this.isExporting = false,
    this.error,
    this.outputPath,
  });

  ExportState copyWith({
    ExportFormat? format,
    int? quality,
    double? progress,
    bool? isExporting,
    String? error,
    String? outputPath,
  }) {
    return ExportState(
      format: format ?? this.format,
      quality: quality ?? this.quality,
      progress: progress ?? this.progress,
      isExporting: isExporting ?? this.isExporting,
      error: error,
      outputPath: outputPath ?? this.outputPath,
    );
  }
}

class ExportNotifier extends StateNotifier<ExportState> {
  ExportNotifier() : super(const ExportState());

  void setFormat(ExportFormat format) {
    state = state.copyWith(format: format);
  }

  void setQuality(int quality) {
    state = state.copyWith(quality: quality);
  }

  void startExport() {
    state = state.copyWith(isExporting: true, progress: 0.0, error: null);
  }

  void updateProgress(double progress) {
    state = state.copyWith(progress: progress);
  }

  void completeExport(String outputPath) {
    state = state.copyWith(
      isExporting: false,
      progress: 1.0,
      outputPath: outputPath,
    );
  }

  void exportFailed(String error) {
    state = state.copyWith(
      isExporting: false,
      progress: 0.0,
      error: error,
    );
  }

  void reset() {
    state = const ExportState();
  }
}

final exportProvider = StateNotifierProvider<ExportNotifier, ExportState>((ref) {
  return ExportNotifier();
});

final exportProgressProvider = Provider<double>((ref) {
  return ref.watch(exportProvider).progress;
});

final isExportingProvider = Provider<bool>((ref) {
  return ref.watch(exportProvider).isExporting;
});