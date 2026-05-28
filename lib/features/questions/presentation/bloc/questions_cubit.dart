import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/utils/bloc_status.dart';
import '../../data/models/question_model.dart';
import '../../data/repository/questions_repository.dart';

part 'questions_state.dart';

@injectable
class QuestionsCubit extends Cubit<QuestionsState> {
  final QuestionsRepository _repository;

  QuestionsCubit(this._repository) : super(QuestionsState());

  Future<void> loadQuestions({bool forceRefresh = false}) async {
    if (state.status == BlocStatus.success && !forceRefresh) return;
    emit(state.copyWith(status: BlocStatus.loading));

    final result = await _repository.getQuestions(
      subject: state.selectedSubject,
      difficulty: state.selectedDifficulty,
    );
    result.fold(
      (failure) => emit(state.copyWith(
        status: BlocStatus.error,
        errorMessage: failure.message,
      )),
      (questions) => emit(state.copyWith(
        status: BlocStatus.success,
        allQuestions: questions,
      )),
    );
  }

  void filterBySubject(QuestionSubject? subject) {
    emit(state.copyWith(selectedSubject: subject, clearSubject: subject == null));
  }

  void filterByDifficulty(QuestionDifficulty? difficulty) {
    emit(state.copyWith(selectedDifficulty: difficulty, clearDifficulty: difficulty == null));
  }

  void search(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  void clearFilters() {
    emit(state.copyWith(
      searchQuery: '',
      clearSubject: true,
      clearDifficulty: true,
    ));
  }
}
