import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/mock/mock_questions.dart';
import '../../../../core/services/connectivity_service.dart';
import '../api/questions_api.dart';
import '../models/question_model.dart';

@lazySingleton
class QuestionsRepository {
  final QuestionsApi _api;
  final ConnectivityService _connectivity;

  const QuestionsRepository(this._api, this._connectivity);

  Future<Either<Failure, List<QuestionModel>>> getQuestions({
    QuestionSubject? subject,
    QuestionDifficulty? difficulty,
  }) async {
    if (!await _connectivity.isConnected) {
      return Right(_applyFilters(MockQuestions.all, subject, difficulty));
    }
    try {
      final raw = await _api.getQuestions(
        subject: subject?.apiKey,
        difficulty: difficulty?.name,
      );
      final questions = (raw as List)
          .map((e) => QuestionModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return Right(questions);
    } catch (_) {
      return Right(_applyFilters(MockQuestions.all, subject, difficulty));
    }
  }

  Future<Either<Failure, QuestionModel>> getQuestion(int id) async {
    if (!await _connectivity.isConnected) {
      final q = MockQuestions.all.where((q) => q.id == id).firstOrNull;
      return q != null ? Right(q) : const Left(NotFoundFailure());
    }
    try {
      final raw = await _api.getQuestion(id);
      return Right(QuestionModel.fromJson(raw as Map<String, dynamic>));
    } catch (_) {
      final q = MockQuestions.all.where((q) => q.id == id).firstOrNull;
      return q != null ? Right(q) : const Left(NotFoundFailure());
    }
  }

  List<QuestionModel> _applyFilters(
    List<QuestionModel> all,
    QuestionSubject? subject,
    QuestionDifficulty? difficulty,
  ) {
    return all.where((q) {
      if (subject != null && q.subject != subject) return false;
      if (difficulty != null && q.difficulty != difficulty) return false;
      return true;
    }).toList();
  }
}
