import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/constants/colors.dart';
import '../../../core/di/di_container.dart';
import '../../../features/competitions/presentation/bloc/competitions_cubit.dart';
import '../../../features/home/presentation/bloc/home_cubit.dart';
import '../../../features/profile/presentation/bloc/profile_cubit.dart';
import '../../../features/questions/presentation/bloc/questions_cubit.dart';
import '../../../features/vocabulary/presentation/bloc/vocabulary_cubit.dart';

class MainScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const MainScreen({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeCubit>(
          create: (_) => sl<HomeCubit>()..initialize(),
        ),
        BlocProvider<QuestionsCubit>(
          create: (_) => sl<QuestionsCubit>()..loadQuestions(),
        ),
        BlocProvider<CompetitionsCubit>(
          create: (_) => sl<CompetitionsCubit>()..loadCompetitions(),
        ),
        BlocProvider<VocabularyCubit>(
          create: (_) => sl<VocabularyCubit>()..loadWords(),
        ),
        BlocProvider<ProfileCubit>(
          create: (_) => sl<ProfileCubit>()..loadProfile(),
        ),
      ],
      child: _MainScaffold(navigationShell: navigationShell),
    );
  }
}

class _MainScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const _MainScaffold({required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: navigationShell.currentIndex == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) navigationShell.goBranch(0);
      },
      child: Scaffold(
        // navigationShell IS the IndexedStack — renders the active branch
        body: navigationShell,
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: AppColors.borderLight, width: 1)),
          ),
          child: BottomNavigationBar(
            currentIndex: navigationShell.currentIndex,
            onTap: (i) => navigationShell.goBranch(
              i,
              // Tapping the current tab again resets its stack to root
              initialLocation: i == navigationShell.currentIndex,
            ),
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppColors.bgPrimary,
            selectedItemColor: AppColors.navActive,
            unselectedItemColor: AppColors.navInactive,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedFontSize: 11,
            unselectedFontSize: 11,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(PhosphorIconsRegular.house),
                activeIcon: Icon(PhosphorIconsFill.house),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(PhosphorIconsRegular.bookOpen),
                activeIcon: Icon(PhosphorIconsFill.bookOpen),
                label: 'Questions',
              ),
              BottomNavigationBarItem(
                icon: Icon(PhosphorIconsRegular.trophy),
                activeIcon: Icon(PhosphorIconsFill.trophy),
                label: 'Competitions',
              ),
              BottomNavigationBarItem(
                icon: Icon(PhosphorIconsRegular.textAa),
                activeIcon: Icon(PhosphorIconsFill.textAa),
                label: 'Vocabulary',
              ),
              BottomNavigationBarItem(
                icon: Icon(PhosphorIconsRegular.user),
                activeIcon: Icon(PhosphorIconsFill.user),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
