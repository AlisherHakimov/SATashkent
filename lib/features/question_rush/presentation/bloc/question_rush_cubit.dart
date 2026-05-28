import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/mock/mock_questions.dart';
import '../../../../core/utils/bloc_status.dart';
import '../../../questions/data/models/question_model.dart';

part 'question_rush_state.dart';

@injectable
class QuestionRushCubit extends Cubit<QuestionRushState> {
  static const int _timePerQuestion = 30;
  Timer? _timer;

  QuestionRushCubit() : super(QuestionRushState());

  void startGame() {
    final questions = List<QuestionModel>.from(MockQuestions.all)..shuffle();
    emit(QuestionRushState(
      gameStatus: GameStatus.playing,
      questions: questions,
      currentIndex: 0,
      timeLeft: _timePerQuestion,
    ));
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.timeLeft <= 1) {
        _onTimeout();
      } else {
        emit(state.copyWith(timeLeft: state.timeLeft - 1));
      }
    });
  }

  void _onTimeout() {
    _timer?.cancel();
    _moveNext(skipped: true);
  }

  void selectOption(String option) {
    if (state.selectedOption != null) return;
    _timer?.cancel();

    final isCorrect = option == state.currentQuestion?.answer;
    emit(state.copyWith(
      selectedOption: option,
      score: isCorrect ? state.score + 1 : state.score,
    ));

    Future.delayed(const Duration(milliseconds: 700), () => _moveNext());
  }

  void _moveNext({bool skipped = false}) {
    if (state.currentIndex >= state.questions.length - 1) {
      emit(state.copyWith(gameStatus: GameStatus.finished));
      return;
    }
    emit(state.copyWith(
      currentIndex: state.currentIndex + 1,
      timeLeft: _timePerQuestion,
      selectedOption: null,
      clearSelectedOption: true,
    ));
    _startTimer();
  }

  void resetGame() {
    _timer?.cancel();
    emit(QuestionRushState());
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
