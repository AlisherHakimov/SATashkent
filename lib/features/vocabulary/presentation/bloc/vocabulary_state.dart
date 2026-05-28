part of 'vocabulary_cubit.dart';

class VocabularyState {
  final BlocStatus status;
  final String? errorMessage;
  final List<WordModel> words;
  final int currentIndex;
  final bool isFlipped;

  VocabularyState({
    this.status = BlocStatus.initial,
    this.errorMessage,
    this.words = const [],
    this.currentIndex = 0,
    this.isFlipped = false,
  });

  List<WordModel> get flashcardWords =>
      words.where((w) => w.status != WordStatus.mastered).toList();

  List<WordModel> get learningWords => words.where((w) => w.status == WordStatus.learning).toList();

  List<WordModel> get masteredWords => words.where((w) => w.status == WordStatus.mastered).toList();

  WordModel? get currentWord {
    final list = flashcardWords;
    if (list.isEmpty || currentIndex >= list.length) return null;
    return list[currentIndex];
  }

  VocabularyState copyWith({
    BlocStatus? status,
    String? errorMessage,
    List<WordModel>? words,
    int? currentIndex,
    bool? isFlipped,
  }) {
    return VocabularyState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      words: words ?? this.words,
      currentIndex: currentIndex ?? this.currentIndex,
      isFlipped: isFlipped ?? this.isFlipped,
    );
  }
}
