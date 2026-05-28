part of 'question_solve_cubit.dart';

class QuestionSolveState {
  final BlocStatus status;
  final QuestionModel? question;
  final String? selectedOption;
  final bool isSubmitted;
  final bool isCorrect;

  QuestionSolveState({
    this.status = BlocStatus.initial,
    this.question,
    this.selectedOption,
    this.isSubmitted = false,
    this.isCorrect = false,
  });

  QuestionSolveState copyWith({
    BlocStatus? status,
    QuestionModel? question,
    String? selectedOption,
    bool? isSubmitted,
    bool? isCorrect,
  }) {
    return QuestionSolveState(
      status: status ?? this.status,
      question: question ?? this.question,
      selectedOption: selectedOption ?? this.selectedOption,
      isSubmitted: isSubmitted ?? this.isSubmitted,
      isCorrect: isCorrect ?? this.isCorrect,
    );
  }
}
