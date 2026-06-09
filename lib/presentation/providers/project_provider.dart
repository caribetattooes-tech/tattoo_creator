import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/project.dart';
import '../../data/models/template.dart';
import '../../data/models/media_item.dart';

class ProjectState {
  final Project? currentProject;
  final List<Project> recentProjects;
  final bool isGenerating;
  final String? error;

  const ProjectState({
    this.currentProject,
    this.recentProjects = const [],
    this.isGenerating = false,
    this.error,
  });

  ProjectState copyWith({
    Project? currentProject,
    List<Project>? recentProjects,
    bool? isGenerating,
    String? error,
  }) {
    return ProjectState(
      currentProject: currentProject ?? this.currentProject,
      recentProjects: recentProjects ?? this.recentProjects,
      isGenerating: isGenerating ?? this.isGenerating,
      error: error,
    );
  }
}

class ProjectNotifier extends StateNotifier<ProjectState> {
  ProjectNotifier() : super(const ProjectState());

  final _uuid = const Uuid();

  void createProject({
    required String name,
    required Template template,
    required List<MediaItem> mediaItems,
    required List<String> hashtags,
  }) {
    final project = Project(
      id: _uuid.v4(),
      name: name,
      template: template,
      mediaItems: mediaItems,
      selectedHashtags: hashtags,
      exportSettings: ExportSettings.reelsHD(),
      createdAt: DateTime.now(),
    );

    state = state.copyWith(
      currentProject: project,
      recentProjects: [project, ...state.recentProjects.take(4)],
    );
  }

  void updateProject(Project project) {
    state = state.copyWith(currentProject: project);
  }

  void updateExportSettings(ExportSettings settings) {
    if (state.currentProject == null) return;
    state = state.copyWith(
      currentProject: state.currentProject!.copyWith(
        exportSettings: settings,
        modifiedAt: DateTime.now(),
      ),
    );
  }

  void updateStatus(ExportStatus status, {double? progress}) {
    if (state.currentProject == null) return;
    state = state.copyWith(
      currentProject: state.currentProject!.copyWith(
        status: status,
        exportProgress: progress ?? state.currentProject!.exportProgress,
        modifiedAt: DateTime.now(),
      ),
    );
  }

  void setOutputPath(String path) {
    if (state.currentProject == null) return;
    state = state.copyWith(
      currentProject: state.currentProject!.copyWith(
        outputPath: path,
        status: ExportStatus.completed,
        modifiedAt: DateTime.now(),
      ),
    );
  }

  void setGenerating(bool generating) {
    state = state.copyWith(isGenerating: generating);
  }

  void setError(String? error) {
    state = state.copyWith(error: error);
  }

  void clearProject() {
    state = state.copyWith(currentProject: null);
  }
}

final projectProvider = StateNotifierProvider<ProjectNotifier, ProjectState>((ref) {
  return ProjectNotifier();
});

final currentProjectProvider = Provider<Project?>((ref) {
  return ref.watch(projectProvider).currentProject;
});

final isGeneratingProvider = Provider<bool>((ref) {
  return ref.watch(projectProvider).isGenerating;
});