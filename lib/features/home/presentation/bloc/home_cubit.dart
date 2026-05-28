import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/utils/bloc_status.dart';
import '../../../competitions/data/models/competition_model.dart';
import '../../../questions/data/models/question_model.dart';
import '../../data/repository/home_repository.dart';

part 'home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _repository;

  HomeCubit(this._repository) : super(HomeState());

  Future<void> initialize({bool forceRefresh = false}) async {
    if (state.status == BlocStatus.success && !forceRefresh) return;
    emit(state.copyWith(status: BlocStatus.loading));

    final result = await _repository.getDashboard();
    result.fold(
      (failure) => emit(state.copyWith(
        status: BlocStatus.error,
        errorMessage: failure.message,
      )),
      (data) => emit(state.copyWith(
        status: BlocStatus.success,
        rank: data.rank,
        streak: data.streak,
        totalAnswered: data.totalAnswered,
        accuracy: data.accuracy,
        mathScore: data.mathScore,
        englishScore: data.englishScore,
        totalScore: data.totalScore,
        activeCompetitions: data.activeCompetitions,
        recentQuestions: data.recentQuestions,
      )),
    );
  }
}
