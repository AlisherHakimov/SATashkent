import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/utils/bloc_status.dart';
import '../../data/models/roadmap_model.dart';
import '../../data/repository/roadmap_repository.dart';

part 'roadmap_state.dart';

@injectable
class RoadmapCubit extends Cubit<RoadmapState> {
  final RoadmapRepository _repository;

  RoadmapCubit(this._repository) : super(RoadmapState());

  Future<void> loadRoadmap() async {
    emit(state.copyWith(status: BlocStatus.loading));

    final result = await _repository.getRoadmap();
    result.fold(
      (failure) => emit(state.copyWith(
        status: BlocStatus.error,
        errorMessage: failure.message,
      )),
      (sections) => emit(state.copyWith(
        status: BlocStatus.success,
        sections: sections,
      )),
    );
  }

  Future<void> completeTopic(int topicId) async {
    await _repository.completeTopic(topicId);
  }
}
