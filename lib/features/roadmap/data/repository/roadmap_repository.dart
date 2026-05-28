import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/mock/mock_roadmap.dart';
import '../../../../core/services/connectivity_service.dart';
import '../api/roadmap_api.dart';
import '../models/roadmap_model.dart';

@lazySingleton
class RoadmapRepository {
  final RoadmapApi _api;
  final ConnectivityService _connectivity;

  const RoadmapRepository(this._api, this._connectivity);

  Future<Either<Failure, List<RoadmapSection>>> getRoadmap() async {
    if (!await _connectivity.isConnected) return const Right(MockRoadmap.sections);
    try {
      final raw = await _api.getRoadmap();
      return Right((raw as List<dynamic>)
          .map((e) => RoadmapSection.fromJson(e as Map<String, dynamic>))
          .toList());
    } catch (_) {
      return const Right(MockRoadmap.sections);
    }
  }

  Future<Either<Failure, void>> completeTopic(int topicId) async {
    if (!await _connectivity.isConnected) return const Left(NetworkFailure());
    try {
      await _api.completeTopic(topicId);
      return const Right(null);
    } catch (_) {
      return const Right(null);
    }
  }
}
