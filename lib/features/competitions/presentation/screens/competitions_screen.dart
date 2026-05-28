import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/utils/bloc_status.dart';
import '../../../../features/competitions/data/models/competition_model.dart';
import '../bloc/competitions_cubit.dart';

class CompetitionsScreen extends StatelessWidget {
  const CompetitionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompetitionsCubit, CompetitionsState>(
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
                    onPressed: () =>
                        context.read<CompetitionsCubit>().loadCompetitions(forceRefresh: true),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        return DefaultTabController(
          length: 3,
          child: Scaffold(
            backgroundColor: AppColors.bgSecondary,
            appBar: AppBar(
              title: const Text('Competitions'),
              bottom: TabBar(
                labelColor: AppColors.primaryBlue,
                unselectedLabelColor: AppColors.textSecondary,
                indicatorColor: AppColors.primaryBlue,
                tabs: [
                  Tab(text: 'Active (${state.active.length})'),
                  Tab(text: 'Upcoming (${state.upcoming.length})'),
                  Tab(text: 'Ended (${state.ended.length})'),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                _CompetitionList(items: state.active),
                _CompetitionList(items: state.upcoming),
                _CompetitionList(items: state.ended),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CompetitionList extends StatelessWidget {
  final List<CompetitionModel> items;
  const _CompetitionList({required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(PhosphorIconsRegular.trophy, size: 48, color: AppColors.textTertiary),
          SizedBox(height: 12),
          Text('No competitions', style: TextStyle(color: AppColors.textSecondary)),
        ]),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (_, i) => _CompetitionCard(comp: items[i]),
    );
  }
}

class _CompetitionCard extends StatelessWidget {
  final CompetitionModel comp;
  const _CompetitionCard({required this.comp});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.bgPrimary,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.gradientStart, AppColors.gradientEnd],
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  const Icon(PhosphorIconsFill.trophy, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(comp.title,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
                  ),
                  _StatusBadge(status: comp.status),
                ]),
                const SizedBox(height: 8),
                Text('${comp.subject} · ${comp.totalQuestions} questions',
                    style: const TextStyle(color: Colors.white70, fontSize: 13)),
                if (comp.prize != null) ...[
                  const SizedBox(height: 6),
                  Text(comp.prize!,
                      style: const TextStyle(
                          color: Colors.white, fontSize: 12, fontStyle: FontStyle.italic)),
                ],
              ],
            ),
          ),

          // Stats row
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                _StatItem(
                    value: '${comp.totalParticipants}',
                    label: 'Participants',
                    icon: PhosphorIconsFill.users),
                const SizedBox(width: 16),
                _StatItem(
                    value: '${comp.totalQuestions}',
                    label: 'Questions',
                    icon: PhosphorIconsFill.question),
                const Spacer(),
                if (comp.status == CompetitionStatus.active)
                  ElevatedButton.icon(
                    onPressed: () => _showLeaderboard(context, comp),
                    icon: const Icon(PhosphorIconsRegular.trophy, size: 16),
                    label: const Text('Leaderboard'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ),
                if (comp.status == CompetitionStatus.upcoming)
                  OutlinedButton(
                    onPressed: () => _showJoinDialog(context, comp),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    ),
                    child: const Text('Join', style: TextStyle(fontSize: 13)),
                  ),
                if (comp.status == CompetitionStatus.ended)
                  TextButton(
                    onPressed: () => _showLeaderboard(context, comp),
                    child: const Text('Results', style: TextStyle(fontSize: 13)),
                  ),
              ],
            ),
          ),

          // Leaderboard preview (top 3)
          if (comp.leaderboard.isNotEmpty) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('TOP 3',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary,
                          letterSpacing: 1)),
                  const SizedBox(height: 10),
                  ...comp.leaderboard.take(3).map((e) => _LeaderboardRow(entry: e, compact: true)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showLeaderboard(BuildContext context, CompetitionModel comp) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _LeaderboardSheet(comp: comp),
    );
  }

  void _showJoinDialog(BuildContext context, CompetitionModel comp) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Join Competition'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(comp.title,
                style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            const SizedBox(height: 8),
            Text('${comp.subject} · ${comp.totalQuestions} questions',
                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
            if (comp.prize != null) ...[
              const SizedBox(height: 6),
              Row(children: [
                const Text('🏆 ', style: TextStyle(fontSize: 14)),
                Text(comp.prize!,
                    style: const TextStyle(
                        fontSize: 13, color: AppColors.warning, fontWeight: FontWeight.w600)),
              ]),
            ],
            const SizedBox(height: 12),
            const Text(
                'By joining you agree to compete fairly. Results are tracked on the leaderboard.',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(children: [
                    const Icon(Icons.check_circle_outline, color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                    Expanded(child: Text('You\'ve joined "${comp.title}"! Good luck 🎉')),
                  ]),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: AppColors.success,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              );
            },
            child: const Text('Join Now'),
          ),
        ],
      ),
    );
  }
}

class _LeaderboardSheet extends StatelessWidget {
  final CompetitionModel comp;
  const _LeaderboardSheet({required this.comp});

  @override
  Widget build(BuildContext context) {
    final maxH = MediaQuery.of(context).size.height * 0.85;

    return Container(
      constraints: BoxConstraints(maxHeight: maxH),
      decoration: const BoxDecoration(
        color: AppColors.bgPrimary,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
                color: AppColors.borderMedium, borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 16),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(children: [
              const Icon(PhosphorIconsFill.trophy, color: AppColors.warning),
              const SizedBox(width: 8),
              Expanded(
                child: Text(comp.title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              ),
            ]),
          ),
          const SizedBox(height: 4),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Your rank: #342',
                  style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),

          // Entries — scrollable only when they overflow
          Flexible(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              children: comp.leaderboard.map((e) => _LeaderboardRow(entry: e)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _LeaderboardRow extends StatelessWidget {
  final LeaderboardEntry entry;
  final bool compact;
  const _LeaderboardRow({required this.entry, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final rankEmoji = entry.rank == 1
        ? '🥇'
        : entry.rank == 2
            ? '🥈'
            : entry.rank == 3
                ? '🥉'
                : '#${entry.rank}';
    final isCurrent = entry.isCurrentUser;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isCurrent ? AppColors.primaryBlueLight : AppColors.bgTertiary,
        borderRadius: BorderRadius.circular(12),
        border: isCurrent ? Border.all(color: AppColors.primaryBlue, width: 1.5) : null,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 36,
            child: Text(rankEmoji,
                style: TextStyle(
                    fontSize: entry.rank <= 3 ? 18 : 13,
                    fontWeight: FontWeight.w700,
                    color: isCurrent ? AppColors.primaryBlue : AppColors.textSecondary)),
          ),
          Expanded(
            child: Text(
              entry.name + (isCurrent ? ' (You)' : ''),
              style: TextStyle(
                  fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                  color: isCurrent ? AppColors.primaryBlue : AppColors.textPrimary,
                  fontSize: 13),
            ),
          ),
          if (!compact) ...[
            Text('${entry.questionsAnswered}/${entry.totalQuestions}',
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            const SizedBox(width: 12),
          ],
          Text('${entry.accuracy.toStringAsFixed(1)}%',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isCurrent ? AppColors.primaryBlue : AppColors.textPrimary)),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  const _StatItem({required this.value, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(icon, size: 16, color: AppColors.textSecondary),
      const SizedBox(width: 4),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
      ]),
    ]);
  }
}

class _StatusBadge extends StatelessWidget {
  final CompetitionStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      CompetitionStatus.active => ('● Active', AppColors.success),
      CompetitionStatus.upcoming => ('○ Upcoming', AppColors.warning),
      CompetitionStatus.ended => ('✓ Ended', Colors.white54),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
    );
  }
}
