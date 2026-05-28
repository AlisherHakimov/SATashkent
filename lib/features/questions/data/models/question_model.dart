enum QuestionSubject { math, english, calcAB, calcBC, chemistry, biology, statistics, physics }

enum QuestionDifficulty { easy, medium, hard }

enum QuestionType { singleChoice, multipleChoice, input, multiInput }

extension QuestionSubjectExt on QuestionSubject {
  String get label => switch (this) {
        QuestionSubject.math => 'Math',
        QuestionSubject.english => 'English',
        QuestionSubject.calcAB => 'Calc AB',
        QuestionSubject.calcBC => 'Calc BC',
        QuestionSubject.chemistry => 'Chemistry',
        QuestionSubject.biology => 'Biology',
        QuestionSubject.statistics => 'Statistics',
        QuestionSubject.physics => 'Physics C',
      };

  String get apiKey => switch (this) {
        QuestionSubject.calcAB => 'calc_ab',
        QuestionSubject.calcBC => 'calc_bc',
        _ => name,
      };

  static QuestionSubject fromString(String? value) =>
      QuestionSubject.values.firstWhere(
        (s) => s.name == value || s.apiKey == value,
        orElse: () => QuestionSubject.math,
      );
}

extension QuestionDifficultyExt on QuestionDifficulty {
  String get label => switch (this) {
        QuestionDifficulty.easy => 'Easy',
        QuestionDifficulty.medium => 'Medium',
        QuestionDifficulty.hard => 'Hard',
      };

  static QuestionDifficulty fromString(String? value) =>
      QuestionDifficulty.values.firstWhere(
        (d) => d.name == value,
        orElse: () => QuestionDifficulty.easy,
      );
}

class QuestionModel {
  final int id;
  final String text;
  final QuestionSubject subject;
  final QuestionDifficulty difficulty;
  final QuestionType type;
  final List<String> options;
  final String answer;
  final String? explanation;
  final String? topic;

  const QuestionModel({
    required this.id,
    required this.text,
    required this.subject,
    required this.difficulty,
    required this.type,
    required this.options,
    required this.answer,
    this.explanation,
    this.topic,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) => QuestionModel(
        id: json['id'] as int,
        text: json['text'] as String,
        subject: QuestionSubjectExt.fromString(json['subject'] as String?),
        difficulty: QuestionDifficultyExt.fromString(json['difficulty'] as String?),
        type: QuestionType.values.firstWhere(
          (t) => t.name == json['type'],
          orElse: () => QuestionType.singleChoice,
        ),
        options: List<String>.from(json['options'] as List),
        answer: json['answer'] as String,
        explanation: json['explanation'] as String?,
        topic: json['topic'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'subject': subject.apiKey,
        'difficulty': difficulty.name,
        'type': type.name,
        'options': options,
        'answer': answer,
        'explanation': explanation,
        'topic': topic,
      };
}
