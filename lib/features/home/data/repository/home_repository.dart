import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/mock/mock_competitions.dart';
import '../../../../core/mock/mock_questions.dart';
import '../../../../core/mock/mock_user.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../../competitions/data/models/competition_model.dart';
import '../../../questions/data/models/question_model.dart';
import '../api/home_api.dart';
import '../models/home_model.dart';

@lazySingleton
class HomeRepository {
  final HomeApi _api;
  final ConnectivityService _connectivity;

  const HomeRepository(this._api, this._connectivity);

  Future<Either<Failure, HomeData>> getDashboard() async {
    if (!await _connectivity.isConnected) return Right(_mockDashboard());
    try {
      final raw = await _api.getDashboard();
      return Right(_parseHomeData(raw as Map<String, dynamic>));
    } catch (_) {
      return Right(_mockDashboard());
    }
  }

  HomeData _mockDashboard() => HomeData(
        rank: MockUser.rank,
        streak: MockUser.streak,
        totalAnswered: MockUser.totalAnswered,
        accuracy: MockUser.accuracy,
        mathScore: MockUser.mathScore,
        englishScore: MockUser.englishScore,
        totalScore: MockUser.totalScore,
        activeCompetitions: MockCompetitions.all
            .where((c) => c.status == CompetitionStatus.active)
            .toList(),
        recentQuestions: MockQuestions.all.take(4).toList(),
      );

  HomeData _parseHomeData(Map<String, dynamic> raw) => HomeData(
        rank: raw['rank'] as int? ?? 0,
        streak: raw['streak'] as int? ?? 0,
        totalAnswered: raw['total_answered'] as int? ?? 0,
        accuracy: (raw['accuracy'] as num?)?.toDouble() ?? 0.0,
        mathScore: raw['math_score'] as int? ?? 0,
        englishScore: raw['english_score'] as int? ?? 0,
        totalScore: raw['total_score'] as int? ?? 0,
        activeCompetitions: (raw['active_competitions'] as List<dynamic>?)
                ?.map((e) => CompetitionModel.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        recentQuestions: (raw['recent_questions'] as List<dynamic>?)
                ?.map((e) => QuestionModel.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
      );
}
