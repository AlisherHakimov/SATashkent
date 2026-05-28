part of 'home_cubit.dart';

class HomeState {
  final BlocStatus status;
  final String? errorMessage;
  final int rank;
  final int streak;
  final int totalAnswered;
  final double accuracy;
  final int mathScore;
  final int englishScore;
  final int totalScore;
  final List<CompetitionModel> activeCompetitions;
  final List<QuestionModel> recentQuestions;

  HomeState({
    this.status = BlocStatus.initial,
    this.errorMessage,
    this.rank = 0,
    this.streak = 0,
    this.totalAnswered = 0,
    this.accuracy = 0,
    this.mathScore = 0,
    this.englishScore = 0,
    this.totalScore = 0,
    this.activeCompetitions = const [],
    this.recentQuestions = const [],
  });

  HomeState copyWith({
    BlocStatus? status,
    String? errorMessage,
    int? rank,
    int? streak,
    int? totalAnswered,
    double? accuracy,
    int? mathScore,
    int? englishScore,
    int? totalScore,
    List<CompetitionModel>? activeCompetitions,
    List<QuestionModel>? recentQuestions,
  }) {
    return HomeState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      rank: rank ?? this.rank,
      streak: streak ?? this.streak,
      totalAnswered: totalAnswered ?? this.totalAnswered,
      accuracy: accuracy ?? this.accuracy,
      mathScore: mathScore ?? this.mathScore,
      englishScore: englishScore ?? this.englishScore,
      totalScore: totalScore ?? this.totalScore,
      activeCompetitions: activeCompetitions ?? this.activeCompetitions,
      recentQuestions: recentQuestions ?? this.recentQuestions,
    );
  }
}
