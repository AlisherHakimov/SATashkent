import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/di/di_container.dart';
import '../../../../core/utils/bloc_status.dart';
import '../../../../features/roadmap/data/models/roadmap_model.dart';
import '../bloc/roadmap_cubit.dart';

class RoadmapScreen extends StatelessWidget {
  const RoadmapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<RoadmapCubit>()..loadRoadmap(),
      child: const _RoadmapView(),
    );
  }
}

class _RoadmapView extends StatelessWidget {
  const _RoadmapView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoadmapCubit, RoadmapState>(
      builder: (context, state) {
        if (state.status == BlocStatus.loading || state.status == BlocStatus.initial) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Roadmap'),
              leading: IconButton(
                icon: const Icon(PhosphorIconsRegular.arrowLeft),
                onPressed: () => context.pop(),
              ),
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state.status == BlocStatus.error) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Roadmap'),
              leading: IconButton(
                icon: const Icon(PhosphorIconsRegular.arrowLeft),
                onPressed: () => context.pop(),
              ),
            ),
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
                    onPressed: () => context.read<RoadmapCubit>().loadRoadmap(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.bgSecondary,
          appBar: AppBar(
            title: const Text('Roadmap'),
            leading: IconButton(
              icon: const Icon(PhosphorIconsRegular.arrowLeft),
              onPressed: () => context.pop(),
            ),
          ),
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.gradientSuccessStart, AppColors.gradientSuccessEnd],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Learning Path',
                          style: TextStyle(
                              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text(
                        '${state.completedTopics} / ${state.totalTopics} topics completed',
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      const SizedBox(height: 14),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: state.overallProgress,
                          backgroundColor: Colors.white24,
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                          minHeight: 10,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${(state.overallProgress * 100).toStringAsFixed(0)}% complete',
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),

              ...state.sections.map((section) => SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                          child: Text(section.title,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                        ),
                        ...section.topics.map((t) => _TopicTile(topic: t)),
                        const SizedBox(height: 8),
                      ],
                    ),
                  )),

              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          ),
        );
      },
    );
  }
}

class _TopicTile extends StatelessWidget {
  final RoadmapTopic topic;
  const _TopicTile({required this.topic});

  @override
  Widget build(BuildContext context) {
    final isLocked = topic.status == RoadmapTopicStatus.locked;
    final isInProgress = topic.status == RoadmapTopicStatus.inProgress;
    final isClickable = !isLocked;

    final statusColor = switch (topic.status) {
      RoadmapTopicStatus.completed => AppColors.success,
      RoadmapTopicStatus.inProgress => AppColors.primaryBlue,
      RoadmapTopicStatus.available => AppColors.warning,
      RoadmapTopicStatus.locked => AppColors.textTertiary,
    };

    final statusIcon = switch (topic.status) {
      RoadmapTopicStatus.completed => PhosphorIconsFill.checkCircle,
      RoadmapTopicStatus.inProgress => PhosphorIconsFill.clockCounterClockwise,
      RoadmapTopicStatus.available => PhosphorIconsRegular.circle,
      RoadmapTopicStatus.locked => PhosphorIconsFill.lock,
    };

    final statusLabel = switch (topic.status) {
      RoadmapTopicStatus.completed => 'Completed',
      RoadmapTopicStatus.inProgress => 'In Progress',
      RoadmapTopicStatus.available => 'Available',
      RoadmapTopicStatus.locked => 'Locked',
    };

    return GestureDetector(
        onTap: isClickable ? () => _showTopicSheet(context, topic) : null,
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isLocked ? AppColors.bgTertiary : AppColors.bgPrimary,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isInProgress
                  ? AppColors.primaryBlue.withValues(alpha: 0.4)
                  : AppColors.borderLight,
              width: isInProgress ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Text(topic.icon, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      topic.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isLocked ? AppColors.textTertiary : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${topic.completedLessons}/${topic.totalLessons} lessons',
                      style: TextStyle(
                          fontSize: 12,
                          color: isLocked ? AppColors.textTertiary : AppColors.textSecondary),
                    ),
                    if (!isLocked && topic.completedLessons > 0) ...[
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: topic.progress,
                          backgroundColor: AppColors.borderLight,
                          valueColor: AlwaysStoppedAnimation(statusColor),
                          minHeight: 5,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                children: [
                  Icon(statusIcon, color: statusColor, size: 22),
                  const SizedBox(height: 4),
                  Text(
                    statusLabel,
                    style: TextStyle(fontSize: 9, color: statusColor, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),
        )); // closes GestureDetector + Container
  }

  void _showTopicSheet(BuildContext context, RoadmapTopic topic) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _TopicDetailSheet(topic: topic),
    );
  }
}

class _TopicDetailSheet extends StatelessWidget {
  final RoadmapTopic topic;
  const _TopicDetailSheet({required this.topic});

  // Mock lesson titles
  static List<String> _lessonNames(RoadmapTopic t) => List.generate(
        t.totalLessons,
        (i) => 'Lesson ${i + 1}: ${t.title} — Part ${i + 1}',
      );

  @override
  Widget build(BuildContext context) {
    final lessons = _lessonNames(topic);
    final statusColor = switch (topic.status) {
      RoadmapTopicStatus.completed => AppColors.success,
      RoadmapTopicStatus.inProgress => AppColors.primaryBlue,
      RoadmapTopicStatus.available => AppColors.warning,
      RoadmapTopicStatus.locked => AppColors.textTertiary,
    };

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      maxChildSize: 0.92,
      minChildSize: 0.4,
      builder: (_, ctrl) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.bgPrimary,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
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
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(children: [
                  Text(topic.icon, style: const TextStyle(fontSize: 36)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(topic.title,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary)),
                      Text(
                          '${topic.subject} · ${topic.completedLessons}/${topic.totalLessons} lessons',
                          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                    ]),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      topic.status == RoadmapTopicStatus.inProgress
                          ? 'In Progress'
                          : topic.status == RoadmapTopicStatus.available
                              ? 'Available'
                              : 'Completed',
                      style:
                          TextStyle(fontSize: 11, color: statusColor, fontWeight: FontWeight.w600),
                    ),
                  ),
                ]),
              ),

              // Progress bar
              if (topic.completedLessons > 0) ...[
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: topic.progress,
                      backgroundColor: AppColors.borderLight,
                      valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                      minHeight: 8,
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 16),
              const Divider(height: 1),

              // Lessons list
              Expanded(
                child: ListView.separated(
                  controller: ctrl,
                  padding: const EdgeInsets.all(16),
                  itemCount: lessons.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (ctx, i) {
                    final isDone = i < topic.completedLessons;
                    final isCurrent = i == topic.completedLessons;
                    return GestureDetector(
                      onTap: isDone || isCurrent
                          ? () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(ctx).showSnackBar(
                                SnackBar(
                                  content: Text('Starting: ${lessons[i]}'),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: AppColors.primaryBlue,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              );
                            }
                          : null,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: isCurrent ? AppColors.primaryLight : AppColors.bgSecondary,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: isCurrent
                                  ? AppColors.primaryBlue.withValues(alpha: 0.3)
                                  : AppColors.borderLight),
                        ),
                        child: Row(children: [
                          Icon(
                            isDone
                                ? PhosphorIconsFill.checkCircle
                                : isCurrent
                                    ? PhosphorIconsFill.playCircle
                                    : PhosphorIconsRegular.circle,
                            size: 20,
                            color: isDone
                                ? AppColors.success
                                : isCurrent
                                    ? AppColors.primaryBlue
                                    : AppColors.textTertiary,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(lessons[i],
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400,
                                    color: isDone || isCurrent
                                        ? AppColors.textPrimary
                                        : AppColors.textTertiary)),
                          ),
                          if (isCurrent)
                            const Text('Start →',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.primaryBlue,
                                    fontWeight: FontWeight.w600)),
                        ]),
                      ),
                    );
                  },
                ),
              ),

              // Start/Continue button
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(topic.completedLessons > 0
                              ? 'Continuing ${topic.title}...'
                              : 'Starting ${topic.title}...'),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: AppColors.primaryBlue,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      );
                    },
                    icon: Icon(topic.completedLessons > 0
                        ? PhosphorIconsFill.play
                        : PhosphorIconsFill.rocket),
                    label: Text(topic.completedLessons > 0 ? 'Continue Learning' : 'Start Topic'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
