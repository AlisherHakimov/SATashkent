import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/utils/bloc_status.dart';
import '../../data/models/question_model.dart';

part 'question_solve_state.dart';

@injectable
class QuestionSolveCubit extends Cubit<QuestionSolveState> {
  QuestionSolveCubit() : super(QuestionSolveState());

  void loadQuestion(QuestionModel question) {
    emit(QuestionSolveState(question: question));
  }

  void selectOption(String option) {
    if (state.isSubmitted) return;
    emit(state.copyWith(selectedOption: option));
  }

  void submit() {
    if (state.selectedOption == null || state.isSubmitted) return;
    final isCorrect = state.selectedOption == state.question?.answer;
    emit(state.copyWith(isSubmitted: true, isCorrect: isCorrect));
  }

  void reset() {
    emit(QuestionSolveState(question: state.question));
  }
}
