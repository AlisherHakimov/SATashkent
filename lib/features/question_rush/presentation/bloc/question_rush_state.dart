part of 'question_rush_cubit.dart';

enum GameStatus { idle, playing, finished }

class QuestionRushState {
  final GameStatus gameStatus;
  final BlocStatus status;
  final List<QuestionModel> questions;
  final int currentIndex;
  final int score;
  final int timeLeft;
  final String? selectedOption;

  QuestionRushState({
    this.gameStatus = GameStatus.idle,
    this.status = BlocStatus.initial,
    this.questions = const [],
    this.currentIndex = 0,
    this.score = 0,
    this.timeLeft = 30,
    this.selectedOption,
  });

  QuestionModel? get currentQuestion =>
      questions.isEmpty || currentIndex >= questions.length ? null : questions[currentIndex];

  double get timerProgress => timeLeft / 30;
  bool get isCorrect => selectedOption == currentQuestion?.answer;

  QuestionRushState copyWith({
    GameStatus? gameStatus,
    BlocStatus? status,
    List<QuestionModel>? questions,
    int? currentIndex,
    int? score,
    int? timeLeft,
    String? selectedOption,
    bool clearSelectedOption = false,
  }) {
    return QuestionRushState(
      gameStatus: gameStatus ?? this.gameStatus,
      status: status ?? this.status,
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      score: score ?? this.score,
      timeLeft: timeLeft ?? this.timeLeft,
      selectedOption: clearSelectedOption ? null : selectedOption ?? this.selectedOption,
    );
  }
}
