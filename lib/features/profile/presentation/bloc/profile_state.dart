part of 'profile_cubit.dart';

class ProfileState {
  final BlocStatus status;
  final String? errorMessage;
  final UserModel? user;
  final int rank;
  final int streak;
  final double accuracy;
  final int mathScore;
  final int englishScore;
  final int totalAnswered;

  ProfileState({
    this.status = BlocStatus.initial,
    this.errorMessage,
    this.user,
    this.rank = 0,
    this.streak = 0,
    this.accuracy = 0,
    this.mathScore = 0,
    this.englishScore = 0,
    this.totalAnswered = 0,
  });

  int get totalScore => mathScore + englishScore;

  ProfileState copyWith({
    BlocStatus? status,
    String? errorMessage,
    UserModel? user,
    int? rank,
    int? streak,
    double? accuracy,
    int? mathScore,
    int? englishScore,
    int? totalAnswered,
  }) {
    return ProfileState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      user: user ?? this.user,
      rank: rank ?? this.rank,
      streak: streak ?? this.streak,
      accuracy: accuracy ?? this.accuracy,
      mathScore: mathScore ?? this.mathScore,
      englishScore: englishScore ?? this.englishScore,
      totalAnswered: totalAnswered ?? this.totalAnswered,
    );
  }
}
