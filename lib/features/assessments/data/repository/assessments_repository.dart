import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/services/connectivity_service.dart';
import '../api/assessments_api.dart';
import '../models/assessment_model.dart';

const _mockAssessments = [
  AssessmentModel(
    id: 1, title: 'Full SAT Practice Test #1',
    subtitle: 'Full SAT simulation — Math + English',
    totalQuestions: 98, durationMin: 134,
    isCompleted: true, score: 1200, tag: 'Full SAT',
  ),
  AssessmentModel(
    id: 2, title: 'Full SAT Practice Test #2',
    subtitle: 'Full SAT simulation — Math + English',
    totalQuestions: 98, durationMin: 134,
    isCompleted: true, score: 1250, tag: 'Full SAT',
  ),
  AssessmentModel(
    id: 3, title: 'Full SAT Practice Test #3',
    subtitle: 'Full SAT simulation — Math + English',
    totalQuestions: 98, durationMin: 134,
    isCompleted: false, tag: 'Full SAT',
  ),
  AssessmentModel(
    id: 4, title: 'Math Section Test #1',
    subtitle: 'Math section only',
    totalQuestions: 44, durationMin: 70,
    isCompleted: true, score: 680, tag: 'Math',
  ),
  AssessmentModel(
    id: 5, title: 'Math Section Test #2',
    subtitle: 'Math section only',
    totalQuestions: 44, durationMin: 70,
    isCompleted: false, tag: 'Math',
  ),
  AssessmentModel(
    id: 6, title: 'English Section Test #1',
    subtitle: 'Reading & Writing section',
    totalQuestions: 54, durationMin: 64,
    isCompleted: true, score: 580, tag: 'English',
  ),
  AssessmentModel(
    id: 7, title: 'English Section Test #2',
    subtitle: 'Reading & Writing section',
    totalQuestions: 54, durationMin: 64,
    isCompleted: false, tag: 'English',
  ),
];

@lazySingleton
class AssessmentsRepository {
  final AssessmentsApi _api;
  final ConnectivityService _connectivity;

  const AssessmentsRepository(this._api, this._connectivity);

  Future<Either<Failure, List<AssessmentModel>>> getAssessments() async {
    if (!await _connectivity.isConnected) return const Right(_mockAssessments);
    try {
      final raw = await _api.getAssessments();
      return Right((raw as List)
          .map((e) => AssessmentModel.fromJson(e as Map<String, dynamic>))
          .toList());
    } catch (_) {
      return const Right(_mockAssessments);
    }
  }

  Future<Either<Failure, Map<String, dynamic>>> startAssessment(int id) async {
    if (!await _connectivity.isConnected) return const Left(NetworkFailure());
    try {
      final result = await _api.startAssessment(id);
      return Right(result as Map<String, dynamic>);
    } catch (_) {
      return const Left(ServerFailure());
    }
  }

  Future<Either<Failure, Map<String, dynamic>>> submitAssessment(
    int id,
    Map<String, dynamic> answers,
  ) async {
    if (!await _connectivity.isConnected) return const Left(NetworkFailure());
    try {
      final result = await _api.submitAssessment(id, answers: answers);
      return Right(result as Map<String, dynamic>);
    } catch (_) {
      return const Left(ServerFailure());
    }
  }
}
