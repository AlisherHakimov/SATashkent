part of 'questions_cubit.dart';

class QuestionsState {
  final BlocStatus status;
  final String? errorMessage;
  final List<QuestionModel> allQuestions;
  final QuestionSubject? selectedSubject;
  final QuestionDifficulty? selectedDifficulty;
  final String searchQuery;

  QuestionsState({
    this.status = BlocStatus.initial,
    this.errorMessage,
    this.allQuestions = const [],
    this.selectedSubject,
    this.selectedDifficulty,
    this.searchQuery = '',
  });

  List<QuestionModel> get filtered {
    return allQuestions.where((q) {
      final matchSubject = selectedSubject == null || q.subject == selectedSubject;
      final matchDiff = selectedDifficulty == null || q.difficulty == selectedDifficulty;
      final matchSearch = searchQuery.isEmpty ||
          q.text.toLowerCase().contains(searchQuery.toLowerCase()) ||
          (q.topic?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false);
      return matchSubject && matchDiff && matchSearch;
    }).toList();
  }

  QuestionsState copyWith({
    BlocStatus? status,
    String? errorMessage,
    List<QuestionModel>? allQuestions,
    QuestionSubject? selectedSubject,
    QuestionDifficulty? selectedDifficulty,
    String? searchQuery,
    bool clearSubject = false,
    bool clearDifficulty = false,
  }) {
    return QuestionsState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      allQuestions: allQuestions ?? this.allQuestions,
      selectedSubject: clearSubject ? null : selectedSubject ?? this.selectedSubject,
      selectedDifficulty: clearDifficulty ? null : selectedDifficulty ?? this.selectedDifficulty,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
