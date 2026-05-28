part of 'competitions_cubit.dart';

class CompetitionsState {
  final BlocStatus status;
  final String? errorMessage;
  final List<CompetitionModel> competitions;
  final int selectedTab;

  CompetitionsState({
    this.status = BlocStatus.initial,
    this.errorMessage,
    this.competitions = const [],
    this.selectedTab = 0,
  });

  List<CompetitionModel> get active =>
      competitions.where((c) => c.status == CompetitionStatus.active).toList();
  List<CompetitionModel> get upcoming =>
      competitions.where((c) => c.status == CompetitionStatus.upcoming).toList();
  List<CompetitionModel> get ended =>
      competitions.where((c) => c.status == CompetitionStatus.ended).toList();

  CompetitionsState copyWith({
    BlocStatus? status,
    String? errorMessage,
    List<CompetitionModel>? competitions,
    int? selectedTab,
  }) {
    return CompetitionsState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      competitions: competitions ?? this.competitions,
      selectedTab: selectedTab ?? this.selectedTab,
    );
  }
}
