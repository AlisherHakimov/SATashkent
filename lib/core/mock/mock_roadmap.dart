import '../../features/roadmap/data/models/roadmap_model.dart';

class MockRoadmap {
  static const List<RoadmapSection> sections = [
    RoadmapSection(
      title: '📐 Math',
      topics: [
        RoadmapTopic(
            id: 1,
            title: 'Heart of Algebra',
            subject: 'Math',
            totalLessons: 12,
            completedLessons: 12,
            status: RoadmapTopicStatus.completed,
            icon: '🔢'),
        RoadmapTopic(
            id: 2,
            title: 'Linear Equations',
            subject: 'Math',
            totalLessons: 10,
            completedLessons: 10,
            status: RoadmapTopicStatus.completed,
            icon: '📈'),
        RoadmapTopic(
            id: 3,
            title: 'Systems of Equations',
            subject: 'Math',
            totalLessons: 8,
            completedLessons: 6,
            status: RoadmapTopicStatus.inProgress,
            icon: '⚖️'),
        RoadmapTopic(
            id: 4,
            title: 'Quadratic Equations',
            subject: 'Math',
            totalLessons: 10,
            completedLessons: 0,
            status: RoadmapTopicStatus.available,
            icon: '📊'),
        RoadmapTopic(
            id: 5,
            title: 'Exponential Functions',
            subject: 'Math',
            totalLessons: 8,
            completedLessons: 0,
            status: RoadmapTopicStatus.locked,
            icon: '🚀'),
        RoadmapTopic(
            id: 6,
            title: 'Geometry & Trigonometry',
            subject: 'Math',
            totalLessons: 14,
            completedLessons: 0,
            status: RoadmapTopicStatus.locked,
            icon: '📐'),
        RoadmapTopic(
            id: 7,
            title: 'Statistics & Probability',
            subject: 'Math',
            totalLessons: 10,
            completedLessons: 0,
            status: RoadmapTopicStatus.locked,
            icon: '🎲'),
      ],
    ),
    RoadmapSection(
      title: '📝 English',
      topics: [
        RoadmapTopic(
            id: 8,
            title: 'Reading Comprehension',
            subject: 'English',
            totalLessons: 15,
            completedLessons: 15,
            status: RoadmapTopicStatus.completed,
            icon: '📖'),
        RoadmapTopic(
            id: 9,
            title: 'Vocabulary in Context',
            subject: 'English',
            totalLessons: 10,
            completedLessons: 8,
            status: RoadmapTopicStatus.inProgress,
            icon: '💬'),
        RoadmapTopic(
            id: 10,
            title: 'Grammar & Usage',
            subject: 'English',
            totalLessons: 12,
            completedLessons: 4,
            status: RoadmapTopicStatus.inProgress,
            icon: '✏️'),
        RoadmapTopic(
            id: 11,
            title: 'Essay Analysis',
            subject: 'English',
            totalLessons: 8,
            completedLessons: 0,
            status: RoadmapTopicStatus.available,
            icon: '📄'),
        RoadmapTopic(
            id: 12,
            title: 'Data Interpretation',
            subject: 'English',
            totalLessons: 6,
            completedLessons: 0,
            status: RoadmapTopicStatus.locked,
            icon: '📊'),
      ],
    ),
  ];

  static int get totalTopics => sections.fold(0, (s, sec) => s + sec.topics.length);

  static int get completedTopics => sections.fold(
      0, (s, sec) => s + sec.topics.where((t) => t.status == RoadmapTopicStatus.completed).length);
}
