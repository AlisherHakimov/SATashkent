import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/di/di_container.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/bloc_status.dart';
import '../../../app/bloc/app_cubit.dart';
import '../bloc/profile_cubit.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state.status == BlocStatus.loading || state.status == BlocStatus.initial) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state.status == BlocStatus.error) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(PhosphorIconsRegular.wifiSlash,
                      size: 48, color: AppColors.textTertiary),
                  const SizedBox(height: 12),
                  Text(state.errorMessage ?? 'Something went wrong',
                      style: const TextStyle(color: AppColors.textSecondary)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<ProfileCubit>().loadProfile(forceRefresh: true),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.bgSecondary,
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _ProfileHeader(state: state)),
              SliverToBoxAdapter(child: _ScoreCards(state: state)),
              SliverToBoxAdapter(child: _SubjectProgress(state: state)),
              SliverToBoxAdapter(child: _MenuSection()),
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          ),
        );
      },
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final ProfileState state;
  const _ProfileHeader({required this.state});

  @override
  Widget build(BuildContext context) {
    final user = state.user;
    final initials = user?.firstName?.isNotEmpty == true ? user!.firstName![0].toUpperCase() : 'U';

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.gradientStart, AppColors.gradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          // Avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white24,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: Center(
              child: Text(
                initials,
                style:
                    const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            user?.fullName ?? 'Student',
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            user?.phone ?? '',
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _HeaderStat(label: 'Rank', value: '#${state.rank}'),
              Container(
                  width: 1,
                  height: 30,
                  color: Colors.white30,
                  margin: const EdgeInsets.symmetric(horizontal: 20)),
              _HeaderStat(label: 'Streak', value: '🔥 ${state.streak}'),
              Container(
                  width: 1,
                  height: 30,
                  color: Colors.white30,
                  margin: const EdgeInsets.symmetric(horizontal: 20)),
              _HeaderStat(label: 'Accuracy', value: '${state.accuracy.toStringAsFixed(0)}%'),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderStat extends StatelessWidget {
  final String label, value;
  const _HeaderStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(value,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
      Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
    ]);
  }
}

class _ScoreCards extends StatelessWidget {
  final ProfileState state;
  const _ScoreCards({required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgPrimary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('SAT Score', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(height: 14),
          Row(children: [
            Expanded(
                child: _ScoreItem(
                    label: 'Math', score: state.mathScore, max: 800, color: AppColors.primaryBlue)),
            const SizedBox(width: 12),
            Expanded(
                child: _ScoreItem(
                    label: 'English',
                    score: state.englishScore,
                    max: 800,
                    color: AppColors.secondary)),
          ]),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient:
                  const LinearGradient(colors: [AppColors.gradientStart, AppColors.gradientEnd]),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Total Score', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  Text('${state.totalScore} / 1600',
                      style: const TextStyle(
                          color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                ]),
                const Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text('Target', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  Text('1600',
                      style: TextStyle(
                          color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoreItem extends StatelessWidget {
  final String label;
  final int score, max;
  final Color color;
  const _ScoreItem(
      {required this.label, required this.score, required this.max, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text('$score', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: color)),
        Text('/ $max', style: TextStyle(fontSize: 11, color: color.withValues(alpha: 0.7))),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: score / max,
            backgroundColor: color.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation(color),
            minHeight: 6,
          ),
        ),
      ]),
    );
  }
}

class _SubjectProgress extends StatelessWidget {
  final ProfileState state;
  const _SubjectProgress({required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgPrimary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Answer Statistics',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(height: 14),
          _ProgressRow(
              label: 'Math questions',
              answered: state.totalAnswered ~/ 2,
              total: 150,
              color: AppColors.primaryBlue),
          const SizedBox(height: 10),
          _ProgressRow(
              label: 'English questions',
              answered: state.totalAnswered - state.totalAnswered ~/ 2,
              total: 120,
              color: AppColors.secondary),
          const SizedBox(height: 10),
          _ProgressRow(
              label: 'Easy',
              answered: (state.totalAnswered * 0.45).round(),
              total: 80,
              color: AppColors.success),
          const SizedBox(height: 10),
          _ProgressRow(
              label: 'Medium',
              answered: (state.totalAnswered * 0.35).round(),
              total: 120,
              color: AppColors.warning),
          const SizedBox(height: 10),
          _ProgressRow(
              label: 'Hard',
              answered: (state.totalAnswered * 0.20).round(),
              total: 80,
              color: AppColors.error),
        ],
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  final String label;
  final int answered, total;
  final Color color;
  const _ProgressRow(
      {required this.label, required this.answered, required this.total, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      SizedBox(
        width: 120,
        child: Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
      ),
      Expanded(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: (answered / total).clamp(0.0, 1.0),
            backgroundColor: AppColors.borderLight,
            valueColor: AlwaysStoppedAnimation(color),
            minHeight: 8,
          ),
        ),
      ),
      const SizedBox(width: 8),
      Text('$answered/$total',
          style: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
    ]);
  }
}

class _MenuSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = [
      (
        icon: PhosphorIconsRegular.path,
        label: 'Roadmap',
        subtitle: 'Your learning path',
        color: AppColors.success,
        onTap: () => context.push(Routes.roadmap),
        isDestructive: false,
      ),
      (
        icon: PhosphorIconsRegular.clipboardText,
        label: 'Assessments',
        subtitle: 'Full practice tests',
        color: AppColors.secondary,
        onTap: () => context.push(Routes.assessments),
        isDestructive: false,
      ),
      (
        icon: PhosphorIconsRegular.lightning,
        label: 'Question Rush',
        subtitle: 'Speed challenge mode',
        color: AppColors.primary,
        onTap: () => context.push(Routes.questionRush),
        isDestructive: false,
      ),
      (
        icon: PhosphorIconsRegular.headset,
        label: 'Support Sessions',
        subtitle: 'Live lessons & mentoring',
        color: AppColors.warning,
        onTap: () => context.push(Routes.support),
        isDestructive: false,
      ),
      (
        icon: PhosphorIconsRegular.bell,
        label: 'Notifications',
        subtitle: 'Alerts and messages',
        color: AppColors.primaryBlue,
        onTap: () => context.push(Routes.notifications),
        isDestructive: false,
      ),
      (
        icon: PhosphorIconsRegular.gear,
        label: 'Settings',
        subtitle: 'Account & preferences',
        color: AppColors.primaryBlue,
        onTap: () => context.push(Routes.settings),
        isDestructive: false,
      ),
    ];

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          decoration: BoxDecoration(
            color: AppColors.bgPrimary,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Column(
            children: items.asMap().entries.map((e) {
              final i = e.key;
              final item = e.value;
              return Column(
                children: [
                  ListTile(
                    onTap: item.onTap,
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: item.color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(item.icon, color: item.color, size: 20),
                    ),
                    title: Text(item.label,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: Text(item.subtitle,
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    trailing: const Icon(PhosphorIconsRegular.caretRight,
                        size: 16, color: AppColors.textTertiary),
                  ),
                  if (i < items.length - 1) const Divider(height: 1, indent: 16),
                ],
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 12),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.bgPrimary,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: ListTile(
            onTap: () => _showLogoutDialog(context),
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(PhosphorIconsRegular.signOut, color: AppColors.error, size: 20),
            ),
            title: const Text('Log Out',
                style:
                    TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.error)),
            subtitle: const Text('Sign out of your account',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            trailing: const Icon(PhosphorIconsRegular.caretRight,
                size: 16, color: AppColors.textTertiary),
          ),
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Log Out', style: TextStyle(fontWeight: FontWeight.w700)),
        content: const Text('Are you sure you want to log out of your account?',
            style: TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await sl<AppCubit>().logout();
              sl<AppRouter>().router.go(Routes.login);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }
}
