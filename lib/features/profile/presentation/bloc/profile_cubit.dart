import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/utils/bloc_status.dart';
import '../../../auth/data/models/auth_model.dart';
import '../../data/repository/profile_repository.dart';

part 'profile_state.dart';

@injectable
class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _repository;

  ProfileCubit(this._repository) : super(ProfileState());

  Future<void> loadProfile({bool forceRefresh = false}) async {
    if (state.status == BlocStatus.success && !forceRefresh) return;
    emit(state.copyWith(status: BlocStatus.loading));

    final userResult = await _repository.getProfile();
    final statsResult = await _repository.getStats();

    UserModel? user;
    userResult.fold(
      (f) => emit(state.copyWith(status: BlocStatus.error, errorMessage: f.message)),
      (u) => user = u,
    );
    if (user == null) return;

    statsResult.fold(
      (f) => emit(state.copyWith(status: BlocStatus.error, errorMessage: f.message)),
      (stats) => emit(state.copyWith(
        status: BlocStatus.success,
        user: user,
        rank: stats.rank,
        streak: stats.streak,
        accuracy: stats.accuracy,
        mathScore: stats.mathScore,
        englishScore: stats.englishScore,
        totalAnswered: stats.totalAnswered,
      )),
    );
  }
}
