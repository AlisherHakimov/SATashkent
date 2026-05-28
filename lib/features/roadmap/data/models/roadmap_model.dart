enum RoadmapTopicStatus { locked, available, inProgress, completed }

class RoadmapTopic {
  final int id;
  final String title;
  final String subject;
  final int totalLessons;
  final int completedLessons;
  final RoadmapTopicStatus status;
  final String icon;

  const RoadmapTopic({
    required this.id,
    required this.title,
    required this.subject,
    required this.totalLessons,
    required this.completedLessons,
    required this.status,
    required this.icon,
  });

  double get progress => totalLessons == 0 ? 0 : completedLessons / totalLessons;

  factory RoadmapTopic.fromJson(Map<String, dynamic> json) => RoadmapTopic(
        id: json['id'] as int,
        title: json['title'] as String,
        subject: json['subject'] as String? ?? '',
        totalLessons: json['total_lessons'] as int? ?? 0,
        completedLessons: json['completed_lessons'] as int? ?? 0,
        status: RoadmapTopicStatus.values.firstWhere(
          (s) => s.name == json['status'],
          orElse: () => RoadmapTopicStatus.locked,
        ),
        icon: json['icon'] as String? ?? '📚',
      );
}

class RoadmapSection {
  final String title;
  final List<RoadmapTopic> topics;

  const RoadmapSection({required this.title, required this.topics});

  factory RoadmapSection.fromJson(Map<String, dynamic> json) => RoadmapSection(
        title: json['title'] as String,
        topics: (json['topics'] as List<dynamic>)
            .map((e) => RoadmapTopic.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
