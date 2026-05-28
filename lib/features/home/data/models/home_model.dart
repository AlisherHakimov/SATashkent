import '../../../competitions/data/models/competition_model.dart';
import '../../../questions/data/models/question_model.dart';

class HomeData {
  final int rank;
  final int streak;
  final int totalAnswered;
  final double accuracy;
  final int mathScore;
  final int englishScore;
  final int totalScore;
  final List<CompetitionModel> activeCompetitions;
  final List<QuestionModel> recentQuestions;

  const HomeData({
    required this.rank,
    required this.streak,
    required this.totalAnswered,
    required this.accuracy,
    required this.mathScore,
    required this.englishScore,
    required this.totalScore,
    required this.activeCompetitions,
    required this.recentQuestions,
  });
}
