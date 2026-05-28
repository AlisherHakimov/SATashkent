import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/mock/mock_competitions.dart';
import '../../../../core/services/connectivity_service.dart';
import '../api/competitions_api.dart';
import '../models/competition_model.dart';

@lazySingleton
class CompetitionsRepository {
  final CompetitionsApi _api;
  final ConnectivityService _connectivity;

  const CompetitionsRepository(this._api, this._connectivity);

  Future<Either<Failure, List<CompetitionModel>>> getCompetitions() async {
    if (!await _connectivity.isConnected) return Right(MockCompetitions.all);
    try {
      final raw = await _api.getCompetitions();
      return Right((raw as List)
          .map((e) => CompetitionModel.fromJson(e as Map<String, dynamic>))
          .toList());
    } catch (_) {
      return Right(MockCompetitions.all);
    }
  }

  Future<Either<Failure, void>> joinCompetition(int id) async {
    if (!await _connectivity.isConnected) return const Left(NetworkFailure());
    try {
      await _api.joinCompetition(id);
      return const Right(null);
    } catch (e) {
      return const Left(ServerFailure());
    }
  }

  Future<Either<Failure, List<LeaderboardEntry>>> getLeaderboard(int id) async {
    if (!await _connectivity.isConnected) {
      final comp = MockCompetitions.all.where((c) => c.id == id).firstOrNull;
      return Right(comp?.leaderboard ?? []);
    }
    try {
      final raw = await _api.getLeaderboard(id);
      return Right((raw as List)
          .map((e) => LeaderboardEntry.fromJson(e as Map<String, dynamic>))
          .toList());
    } catch (_) {
      final comp = MockCompetitions.all.where((c) => c.id == id).firstOrNull;
      return Right(comp?.leaderboard ?? []);
    }
  }
}
