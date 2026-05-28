class AssessmentModel {
  final int id;
  final String title;
  final String subtitle;
  final int totalQuestions;
  final int durationMin;
  final bool isCompleted;
  final int? score;
  final String tag;

  const AssessmentModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.totalQuestions,
    required this.durationMin,
    required this.isCompleted,
    required this.tag,
    this.score,
  });

  factory AssessmentModel.fromJson(Map<String, dynamic> json) => AssessmentModel(
        id: json['id'] as int,
        title: json['title'] as String,
        subtitle: json['subtitle'] as String? ?? '',
        totalQuestions: json['total_questions'] as int? ?? 0,
        durationMin: json['duration_min'] as int? ?? 0,
        isCompleted: json['is_completed'] as bool? ?? false,
        score: json['score'] as int?,
        tag: json['tag'] as String? ?? '',
      );
}
