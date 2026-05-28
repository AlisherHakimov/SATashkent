enum WordDifficulty { beginner, intermediate, advanced }

enum WordStatus { new_, learning, mastered }

class WordModel {
  final int id;
  final String word;
  final String definition;
  final String partOfSpeech;
  final String exampleSentence;
  final List<String> synonyms;
  final WordDifficulty difficulty;
  WordStatus status;
  int reviewCount;

  WordModel({
    required this.id,
    required this.word,
    required this.definition,
    required this.partOfSpeech,
    required this.exampleSentence,
    required this.synonyms,
    required this.difficulty,
    this.status = WordStatus.new_,
    this.reviewCount = 0,
  });

  factory WordModel.fromJson(Map<String, dynamic> json) => WordModel(
        id: json['id'] as int,
        word: json['word'] as String,
        definition: json['definition'] as String,
        partOfSpeech: json['part_of_speech'] as String? ?? '',
        exampleSentence: json['example_sentence'] as String? ?? '',
        synonyms: List<String>.from(json['synonyms'] as List? ?? []),
        difficulty: WordDifficulty.values.firstWhere(
          (d) => d.name == json['difficulty'],
          orElse: () => WordDifficulty.beginner,
        ),
        status: WordStatus.values.firstWhere(
          (s) => s.name == json['status'],
          orElse: () => WordStatus.new_,
        ),
        reviewCount: json['review_count'] as int? ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'word': word,
        'definition': definition,
        'part_of_speech': partOfSpeech,
        'example_sentence': exampleSentence,
        'synonyms': synonyms,
        'difficulty': difficulty.name,
        'status': status.name,
        'review_count': reviewCount,
      };
}
