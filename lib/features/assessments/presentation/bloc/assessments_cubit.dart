import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/utils/bloc_status.dart';
import '../../data/models/assessment_model.dart';
import '../../data/repository/assessments_repository.dart';

part 'assessments_state.dart';

@injectable
class AssessmentsCubit extends Cubit<AssessmentsState> {
  final AssessmentsRepository _repository;

  AssessmentsCubit(this._repository) : super(AssessmentsState());

  Future<void> loadAssessments() async {
    emit(state.copyWith(status: BlocStatus.loading));

    final result = await _repository.getAssessments();
    result.fold(
      (failure) => emit(state.copyWith(
        status: BlocStatus.error,
        errorMessage: failure.message,
      )),
      (assessments) => emit(state.copyWith(
        status: BlocStatus.success,
        assessments: assessments,
      )),
    );
  }
}
