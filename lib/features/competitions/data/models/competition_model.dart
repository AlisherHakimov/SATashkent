class LeaderboardEntry {
  final int rank;
  final String name;
  final String? avatar;
  final int questionsAnswered;
  final int totalQuestions;
  final double accuracy;
  final int score;
  final bool isCurrentUser;

  const LeaderboardEntry({
    required this.rank,
    required this.name,
    this.avatar,
    required this.questionsAnswered,
    required this.totalQuestions,
    required this.accuracy,
    required this.score,
    this.isCurrentUser = false,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) => LeaderboardEntry(
        rank: json['rank'] as int,
        name: json['name'] as String,
        avatar: json['avatar'] as String?,
        questionsAnswered: json['questions_answered'] as int? ?? 0,
        totalQuestions: json['total_questions'] as int? ?? 0,
        accuracy: (json['accuracy'] as num?)?.toDouble() ?? 0.0,
        score: json['score'] as int? ?? 0,
        isCurrentUser: json['is_current_user'] as bool? ?? false,
      );
}

enum CompetitionStatus { upcoming, active, ended }

class CompetitionModel {
  final int id;
  final String title;
  final String subject;
  final CompetitionStatus status;
  final DateTime startDate;
  final DateTime endDate;
  final int totalParticipants;
  final int totalQuestions;
  final List<LeaderboardEntry> leaderboard;
  final String? prize;

  const CompetitionModel({
    required this.id,
    required this.title,
    required this.subject,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.totalParticipants,
    required this.totalQuestions,
    required this.leaderboard,
    this.prize,
  });

  factory CompetitionModel.fromJson(Map<String, dynamic> json) => CompetitionModel(
        id: json['id'] as int,
        title: json['title'] as String,
        subject: json['subject'] as String,
        status: CompetitionStatus.values.firstWhere(
          (s) => s.name == json['status'],
          orElse: () => CompetitionStatus.upcoming,
        ),
        startDate: DateTime.parse(json['start_date'] as String),
        endDate: DateTime.parse(json['end_date'] as String),
        totalParticipants: json['total_participants'] as int? ?? 0,
        totalQuestions: json['total_questions'] as int? ?? 0,
        leaderboard: (json['leaderboard'] as List<dynamic>?)
                ?.map((e) => LeaderboardEntry.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        prize: json['prize'] as String?,
      );
}
