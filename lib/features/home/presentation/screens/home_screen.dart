import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/mock/mock_user.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/bloc_status.dart';
import '../../../../features/competitions/data/models/competition_model.dart';
import '../../../../features/questions/data/models/question_model.dart';
import '../../../../shared/widgets/cards/stat_card.dart';
import '../bloc/home_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state.status == BlocStatus.loading || state.status == BlocStatus.initial) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (state.status == BlocStatus.error) {
          return Scaffold(
            body: Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(PhosphorIconsRegular.wifiSlash, size: 48, color: AppColors.textTertiary),
                const SizedBox(height: 12),
                Text(state.errorMessage ?? 'Something went wrong',
                    style: const TextStyle(color: AppColors.textSecondary)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.read<HomeCubit>().initialize(forceRefresh: true),
                  child: const Text('Retry'),
                ),
              ]),
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.bgSecondary,
          body: RefreshIndicator(
            onRefresh: () => context.read<HomeCubit>().initialize(forceRefresh: true),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _Header(state: state)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: _ScoreBanner(state: state),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: _StatsGrid(state: state),
                  ),
                ),
                const SliverToBoxAdapter(child: _QuickActionsSection()),
                _SectionHeader(
                  title: 'Active Competitions',
                  onTap: () => context.go(Routes.competitions),
                ),
                SliverToBoxAdapter(
                  child: _ActiveCompetitions(competitions: state.activeCompetitions),
                ),
                _SectionHeader(
                  title: 'Recent Questions',
                  onTap: () => context.go(Routes.questions),
                ),
                SliverToBoxAdapter(
                  child: _RecentQuestions(questions: state.recentQuestions),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  final HomeState state;

  const _Header({required this.state});

  String get _userName {
    final first = MockUser.currentUser.firstName ?? 'Student';
    final lastInitial = MockUser.currentUser.lastName?.isNotEmpty == true
        ? ' ${MockUser.currentUser.lastName![0]}.'
        : '';
    return '$first$lastInitial';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Row(
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Welcome back! 👋',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
              const SizedBox(height: 2),
              Text(
                  _userName,
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
            ]),
            const Spacer(),
            GestureDetector(
              onTap: () => context.push(Routes.notifications),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primaryBlueLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  PhosphorIconsRegular.bell,
                  color: AppColors.primaryBlue,
                  size: 22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScoreBanner extends StatelessWidget {
  final HomeState state;

  const _ScoreBanner({required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.gradientStart, AppColors.gradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Current Score', style: TextStyle(color: Colors.white70, fontSize: 13)),
              const SizedBox(height: 4),
              Text('${state.totalScore}',
                  style: const TextStyle(
                      color: Colors.white, fontSize: 40, fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              const Text('Target: 1600', style: TextStyle(color: Colors.white70, fontSize: 13)),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: state.totalScore / 1600,
                  backgroundColor: Colors.white24,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  minHeight: 8,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${(state.totalScore / 1600 * 100).toStringAsFixed(0)}% toward your goal',
                style: const TextStyle(color: Colors.white70, fontSize: 11),
              ),
            ]),
          ),
          const SizedBox(width: 16),
          Column(children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(children: [
                const Icon(PhosphorIconsFill.trophy, color: Colors.white, size: 28),
                const SizedBox(height: 4),
                Text('#${state.rank}',
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
                const Text('Rank', style: TextStyle(color: Colors.white70, fontSize: 10)),
              ]),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(children: [
                const Text('🔥', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 4),
                Text('${state.streak} days',
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
              ]),
            ),
          ]),
        ],
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  final HomeState state;

  const _StatsGrid({required this.state});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.4,
      children: [
        StatCard(
          label: 'Answered',
          value: '${state.totalAnswered}',
          icon: const Icon(PhosphorIconsFill.checkCircle),
          color: AppColors.success,
        ),
        StatCard(
          label: 'Accuracy',
          value: '${state.accuracy.toStringAsFixed(1)}%',
          icon: const Icon(PhosphorIconsFill.target),
          color: AppColors.warning,
        ),
        StatCard(
          label: 'Math Score',
          value: '${state.mathScore}',
          icon: const Icon(PhosphorIconsFill.mathOperations),
          color: AppColors.primaryBlue,
        ),
        StatCard(
          label: 'English Score',
          value: '${state.englishScore}',
          icon: const Icon(PhosphorIconsFill.bookOpen),
          color: AppColors.secondary,
        ),
      ],
    );
  }
}

class _QuickActionsSection extends StatelessWidget {
  const _QuickActionsSection();

  @override
  Widget build(BuildContext context) {
    final actions = [
      (
        icon: PhosphorIconsFill.lightning,
        label: 'Question\nRush',
        color: AppColors.primary,
        route: Routes.questionRush
      ),
      (
        icon: PhosphorIconsFill.clipboardText,
        label: 'Assessments',
        color: AppColors.secondary,
        route: Routes.assessments
      ),
      (
        icon: PhosphorIconsFill.path,
        label: 'Roadmap',
        color: AppColors.success,
        route: Routes.roadmap
      ),
      (
        icon: PhosphorIconsFill.headset,
        label: 'Support',
        color: AppColors.warning,
        route: Routes.support
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 20, 16, 12),
          child: Text('Quick Actions',
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: actions.map((a) {
              return Expanded(
                child: GestureDetector(
                  onTap: () => context.push(a.route),
                  child: Container(
                    margin: EdgeInsets.only(right: a == actions.last ? 0 : 10),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: a.color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: a.color.withValues(alpha: 0.2)),
                    ),
                    child: Column(children: [
                      Icon(a.icon, color: a.color, size: 26),
                      const SizedBox(height: 6),
                      Text(a.label,
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: a.color)),
                    ]),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _ActiveCompetitions extends StatelessWidget {
  final List<CompetitionModel> competitions;

  const _ActiveCompetitions({required this.competitions});

  @override
  Widget build(BuildContext context) {
    if (competitions.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: competitions.length,
        itemBuilder: (_, i) {
          final comp = competitions[i];
          return GestureDetector(
            onTap: () => context.go(Routes.competitions),
            child: Container(
              width: 220,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.bgPrimary,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    const Icon(PhosphorIconsFill.trophy, color: AppColors.warning, size: 18),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(comp.title,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ),
                  ]),
                  const SizedBox(height: 6),
                  Text('${comp.totalParticipants} participants · ${comp.subject}',
                      style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text('Active ✓',
                        style: TextStyle(
                            fontSize: 11, color: AppColors.success, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _RecentQuestions extends StatelessWidget {
  final List<QuestionModel> questions;

  const _RecentQuestions({required this.questions});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: questions.map((q) {
          final diffColor = switch (q.difficulty) {
            QuestionDifficulty.easy => AppColors.success,
            QuestionDifficulty.medium => AppColors.warning,
            QuestionDifficulty.hard => AppColors.error,
          };
          return GestureDetector(
            onTap: () => context.push('${Routes.questions}/solve?id=${q.id}'),
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.bgPrimary,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Row(children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(q.text,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 13, color: AppColors.textPrimary)),
                      const SizedBox(height: 6),
                      Row(children: [
                        _Tag(label: q.subject.label, color: AppColors.primaryBlue),
                        const SizedBox(width: 6),
                        _Tag(label: q.difficulty.label, color: diffColor),
                      ]),
                    ],
                  ),
                ),
                const Icon(PhosphorIconsRegular.caretRight,
                    color: AppColors.textTertiary, size: 18),
              ]),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final Color color;

  const _Tag({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w600)),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const _SectionHeader({required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            if (onTap != null)
              GestureDetector(
                onTap: onTap,
                child: const Text('See all',
                    style: TextStyle(
                        fontSize: 13, color: AppColors.primaryBlue, fontWeight: FontWeight.w600)),
              ),
          ],
        ),
      ),
    );
  }
}
