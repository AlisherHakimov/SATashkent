import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/utils/bloc_status.dart';
import '../../data/models/word_model.dart';
import '../../data/repository/vocabulary_repository.dart';

part 'vocabulary_state.dart';

@injectable
class VocabularyCubit extends Cubit<VocabularyState> {
  final VocabularyRepository _repository;

  VocabularyCubit(this._repository) : super(VocabularyState());

  Future<void> loadWords({bool forceRefresh = false}) async {
    if (state.status == BlocStatus.success && !forceRefresh) return;
    emit(state.copyWith(status: BlocStatus.loading));

    final result = await _repository.getWords();
    result.fold(
      (failure) => emit(state.copyWith(
        status: BlocStatus.error,
        errorMessage: failure.message,
      )),
      (words) => emit(state.copyWith(
        status: BlocStatus.success,
        words: words,
        currentIndex: 0,
        isFlipped: false,
      )),
    );
  }

  void nextCard() {
    final flashcardWords = state.flashcardWords;
    if (state.currentIndex < flashcardWords.length - 1) {
      emit(state.copyWith(
        currentIndex: state.currentIndex + 1,
        isFlipped: false,
      ));
    }
  }

  void prevCard() {
    if (state.currentIndex > 0) {
      emit(state.copyWith(
        currentIndex: state.currentIndex - 1,
        isFlipped: false,
      ));
    }
  }

  void flipCard() => emit(state.copyWith(isFlipped: !state.isFlipped));

  void markWord(int wordId, WordStatus newStatus) {
    final updated = state.words.map((w) {
      if (w.id == wordId) {
        w.status = newStatus;
        w.reviewCount++;
      }
      return w;
    }).toList();
    emit(state.copyWith(words: updated, isFlipped: false));
    _repository.updateWordStatus(wordId, newStatus);
  }
}
