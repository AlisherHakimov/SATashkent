import '../../features/auth/data/models/auth_model.dart';

class MockUser {
  static const UserModel currentUser = UserModel(
    id: 1,
    phone: '+998901234567',
    firstName: 'Alisher',
    lastName: 'Hakimov',
  );

  static const int rank = 342;
  static const int totalStudents = 10480;
  static const int streak = 7;
  static const int totalAnswered = 234;
  static const double accuracy = 78.4;
  static const int mathScore = 620;
  static const int englishScore = 580;
  static const int totalScore = 1200;
  static const int targetScore = 1600;
}
