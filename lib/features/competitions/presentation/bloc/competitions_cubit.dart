import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/utils/bloc_status.dart';
import '../../data/models/competition_model.dart';
import '../../data/repository/competitions_repository.dart';

part 'competitions_state.dart';

@injectable
class CompetitionsCubit extends Cubit<CompetitionsState> {
  final CompetitionsRepository _repository;

  CompetitionsCubit(this._repository) : super(CompetitionsState());

  Future<void> loadCompetitions({bool forceRefresh = false}) async {
    if (state.status == BlocStatus.success && !forceRefresh) return;
    emit(state.copyWith(status: BlocStatus.loading));

    final result = await _repository.getCompetitions();
    result.fold(
      (failure) => emit(state.copyWith(
        status: BlocStatus.error,
        errorMessage: failure.message,
      )),
      (competitions) => emit(state.copyWith(
        status: BlocStatus.success,
        competitions: competitions,
      )),
    );
  }

  Future<void> joinCompetition(int id) async {
    await _repository.joinCompetition(id);
  }

  void selectTab(int index) => emit(state.copyWith(selectedTab: index));
}
