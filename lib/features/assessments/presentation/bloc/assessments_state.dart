part of 'assessments_cubit.dart';

class AssessmentsState {
  final BlocStatus status;
  final String? errorMessage;
  final List<AssessmentModel> assessments;

  AssessmentsState({
    this.status = BlocStatus.initial,
    this.errorMessage,
    this.assessments = const [],
  });

  List<AssessmentModel> get completed => assessments.where((a) => a.isCompleted).toList();
  List<AssessmentModel> get available => assessments.where((a) => !a.isCompleted).toList();
  int get bestScore => assessments
      .where((a) => a.score != null)
      .fold(0, (max, a) => a.score! > max ? a.score! : max);

  AssessmentsState copyWith({
    BlocStatus? status,
    String? errorMessage,
    List<AssessmentModel>? assessments,
  }) {
    return AssessmentsState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      assessments: assessments ?? this.assessments,
    );
  }
}
