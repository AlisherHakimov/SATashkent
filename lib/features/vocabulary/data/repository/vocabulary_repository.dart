import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/mock/mock_vocabulary.dart';
import '../../../../core/services/connectivity_service.dart';
import '../api/vocabulary_api.dart';
import '../models/word_model.dart';

@lazySingleton
class VocabularyRepository {
  final VocabularyApi _api;
  final ConnectivityService _connectivity;

  const VocabularyRepository(this._api, this._connectivity);

  Future<Either<Failure, List<WordModel>>> getWords({
    WordDifficulty? difficulty,
    WordStatus? status,
  }) async {
    if (!await _connectivity.isConnected) {
      return Right(_applyFilters(MockVocabulary.all, difficulty, status));
    }
    try {
      final raw = await _api.getWords(
        difficulty: difficulty?.name,
        status: status?.name,
      );
      return Right((raw as List)
          .map((e) => WordModel.fromJson(e as Map<String, dynamic>))
          .toList());
    } catch (_) {
      return Right(_applyFilters(MockVocabulary.all, difficulty, status));
    }
  }

  Future<Either<Failure, void>> updateWordStatus(int id, WordStatus status) async {
    if (!await _connectivity.isConnected) return const Left(NetworkFailure());
    try {
      await _api.updateWordStatus(id, status: status.name);
      return const Right(null);
    } catch (_) {
      return const Right(null);
    }
  }

  List<WordModel> _applyFilters(
    List<WordModel> all,
    WordDifficulty? difficulty,
    WordStatus? status,
  ) {
    return all.where((w) {
      if (difficulty != null && w.difficulty != difficulty) return false;
      if (status != null && w.status != status) return false;
      return true;
    }).toList();
  }
}
