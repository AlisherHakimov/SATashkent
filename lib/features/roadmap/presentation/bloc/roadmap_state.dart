part of 'roadmap_cubit.dart';

class RoadmapState {
  final BlocStatus status;
  final String? errorMessage;
  final List<RoadmapSection> sections;

  RoadmapState({
    this.status = BlocStatus.initial,
    this.errorMessage,
    this.sections = const [],
  });

  int get totalTopics => sections.fold(0, (s, sec) => s + sec.topics.length);

  int get completedTopics => sections.fold(
      0, (s, sec) => s + sec.topics.where((t) => t.status == RoadmapTopicStatus.completed).length);

  double get overallProgress => totalTopics == 0 ? 0 : completedTopics / totalTopics;

  RoadmapState copyWith({
    BlocStatus? status,
    String? errorMessage,
    List<RoadmapSection>? sections,
  }) {
    return RoadmapState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      sections: sections ?? this.sections,
    );
  }
}
