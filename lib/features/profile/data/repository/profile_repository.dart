import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/mock/mock_user.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../../auth/data/models/auth_model.dart';
import '../api/profile_api.dart';

class ProfileStats {
  final int rank;
  final int streak;
  final double accuracy;
  final int mathScore;
  final int englishScore;
  final int totalAnswered;

  const ProfileStats({
    required this.rank,
    required this.streak,
    required this.accuracy,
    required this.mathScore,
    required this.englishScore,
    required this.totalAnswered,
  });

  factory ProfileStats.fromJson(Map<String, dynamic> json) => ProfileStats(
        rank: json['rank'] as int? ?? 0,
        streak: json['streak'] as int? ?? 0,
        accuracy: (json['accuracy'] as num?)?.toDouble() ?? 0.0,
        mathScore: json['math_score'] as int? ?? 0,
        englishScore: json['english_score'] as int? ?? 0,
        totalAnswered: json['total_answered'] as int? ?? 0,
      );

  static const mock = ProfileStats(
    rank: MockUser.rank,
    streak: MockUser.streak,
    accuracy: MockUser.accuracy,
    mathScore: MockUser.mathScore,
    englishScore: MockUser.englishScore,
    totalAnswered: MockUser.totalAnswered,
  );
}

@lazySingleton
class ProfileRepository {
  final ProfileApi _api;
  final ConnectivityService _connectivity;

  const ProfileRepository(this._api, this._connectivity);

  Future<Either<Failure, UserModel>> getProfile() async {
    if (!await _connectivity.isConnected) return const Right(MockUser.currentUser);
    try {
      final raw = await _api.getProfile();
      return Right(UserModel.fromJson(raw as Map<String, dynamic>));
    } catch (_) {
      return const Right(MockUser.currentUser);
    }
  }

  Future<Either<Failure, ProfileStats>> getStats() async {
    if (!await _connectivity.isConnected) return const Right(ProfileStats.mock);
    try {
      final raw = await _api.getStats();
      return Right(ProfileStats.fromJson(raw as Map<String, dynamic>));
    } catch (_) {
      return const Right(ProfileStats.mock);
    }
  }

  Future<Either<Failure, UserModel>> updateProfile({
    String? firstName,
    String? lastName,
    String? email,
  }) async {
    if (!await _connectivity.isConnected) return const Left(NetworkFailure());
    try {
      final raw = await _api.updateProfile(
        firstName: firstName,
        lastName: lastName,
        email: email,
      );
      return Right(UserModel.fromJson(raw as Map<String, dynamic>));
    } catch (e) {
      return const Left(ServerFailure());
    }
  }
}
