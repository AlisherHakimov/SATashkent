import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import '../../core/constants/storage_keys.dart';
import '../../core/services/storage_service.dart';
import '../../features/assessments/presentation/screens/assessments_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/competitions/presentation/screens/competitions_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/main/screens/main_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/question_rush/presentation/screens/question_rush_screen.dart';
import '../../features/questions/presentation/screens/question_bank_screen.dart';
import '../../features/questions/presentation/screens/question_solve_screen.dart';
import '../../features/roadmap/presentation/screens/roadmap_screen.dart';
import '../../features/settings/presentation/screens/legal_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/splash/screens/splash_screen.dart';
import '../../features/support/presentation/screens/support_screen.dart';
import '../../features/vocabulary/presentation/screens/vocabulary_screen.dart';

class Routes {
  Routes._();

  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';

  // Shell tabs
  static const String home = '/home';
  static const String questions = '/questions';
  static const String competitions = '/competitions';
  static const String vocabulary = '/vocabulary';
  static const String profile = '/profile';

  // Full-screen sub-pages
  static const String roadmap = '/roadmap';
  static const String assessments = '/assessments';
  static const String questionRush = '/question-rush';
  static const String notifications = '/notifications';
  static const String settings = '/settings';
  static const String support = '/support';
  static const String privacyPolicy = '/privacy-policy';
  static const String termsOfService = '/terms-of-service';
}

@singleton
class AppRouter {
  final StorageService _storage;

  AppRouter(this._storage);

  late final GoRouter router = GoRouter(
    initialLocation: Routes.splash,
    debugLogDiagnostics: true,
    redirect: (BuildContext context, GoRouterState state) {
      final isLoggedIn = _storage.getString(StorageKeys.accessToken)?.isNotEmpty == true;
      final loc = state.matchedLocation;

      const publicRoutes = {
        Routes.splash,
        Routes.login,
        Routes.register,
        Routes.privacyPolicy,
        Routes.termsOfService,
      };
      if (publicRoutes.contains(loc)) {
        // Already logged in → kick out of auth screens, allow legal pages
        if (isLoggedIn &&
            (loc == Routes.login || loc == Routes.register)) {
          return Routes.home;
        }
        return null;
      }
      if (!isLoggedIn) return Routes.login;
      return null;
    },
    routes: [
      GoRoute(path: Routes.splash, builder: (c, s) => const SplashScreen()),
      GoRoute(path: Routes.login, builder: (c, s) => const LoginScreen()),
      GoRoute(path: Routes.register, builder: (c, s) => const RegisterScreen()),

      StatefulShellRoute.indexedStack(
        builder: (c, s, shell) => MainScreen(navigationShell: shell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: Routes.home, builder: (c, s) => const HomeScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: Routes.questions,
              builder: (c, s) => const QuestionBankScreen(),
              routes: [
                GoRoute(
                  path: 'solve',
                  builder: (c, s) {
                    final qId = int.tryParse(s.uri.queryParameters['id'] ?? '') ?? 0;
                    return QuestionSolveScreen(questionId: qId);
                  },
                ),
              ],
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: Routes.competitions,
              builder: (c, s) => const CompetitionsScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: Routes.vocabulary,
              builder: (c, s) => const VocabularyScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: Routes.profile,
              builder: (c, s) => const ProfileScreen(),
            ),
          ]),
        ],
      ),

      GoRoute(path: Routes.roadmap, builder: (c, s) => const RoadmapScreen()),
      GoRoute(
        path: Routes.assessments,
        builder: (c, s) => const AssessmentsScreen(),
      ),
      GoRoute(
        path: Routes.questionRush,
        builder: (c, s) => const QuestionRushScreen(),
      ),
      GoRoute(
        path: Routes.notifications,
        builder: (c, s) => const NotificationsScreen(),
      ),
      GoRoute(
        path: Routes.settings,
        builder: (c, s) => const SettingsScreen(),
      ),
      GoRoute(
        path: Routes.support,
        builder: (c, s) => const SupportScreen(),
      ),
      GoRoute(
        path: Routes.privacyPolicy,
        builder: (c, s) => const LegalScreen(type: LegalType.privacyPolicy),
      ),
      GoRoute(
        path: Routes.termsOfService,
        builder: (c, s) => const LegalScreen(type: LegalType.termsOfService),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Page not found: ${state.error}')),
    ),
  );
}
