import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/di/di_container.dart';
import '../../../../features/questions/data/models/question_model.dart';
import '../bloc/question_rush_cubit.dart';

class QuestionRushScreen extends StatelessWidget {
  const QuestionRushScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<QuestionRushCubit>(),
      child: const _QuestionRushView(),
    );
  }
}

class _QuestionRushView extends StatelessWidget {
  const _QuestionRushView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuestionRushCubit, QuestionRushState>(
      builder: (context, state) {
        final cubit = context.read<QuestionRushCubit>();

        if (state.gameStatus == GameStatus.idle) {
          return _StartScreen(onStart: cubit.startGame);
        }

        if (state.gameStatus == GameStatus.finished) {
          return _ResultScreen(
            score: state.score,
            total: state.questions.length,
            onRetry: cubit.resetGame,
          );
        }

        final q = state.currentQuestion;
        if (q == null) return const SizedBox.shrink();

        return Scaffold(
          backgroundColor: AppColors.bgSecondary,
          appBar: AppBar(
            title: const Text('Question Rush ⚡'),
            leading: IconButton(
              icon: const Icon(PhosphorIconsRegular.x),
              onPressed: () {
                cubit.resetGame();
                context.pop();
              },
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: Text(
                    '${state.currentIndex + 1}/${state.questions.length}',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 6,
                color: state.timerProgress > 0.3 ? AppColors.primaryBlue : AppColors.error,
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: state.timerProgress,
                  child: Container(
                    color: state.timerProgress > 0.3 ? AppColors.primaryBlue : AppColors.error,
                  ),
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _TimerWidget(timeLeft: state.timeLeft),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.success.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(children: [
                              const Icon(PhosphorIconsFill.star,
                                  color: AppColors.success, size: 16),
                              const SizedBox(width: 4),
                              Text('${state.score} pts',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700, color: AppColors.success)),
                            ]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      Row(children: [
                        _DiffBadge(q.difficulty),
                        const SizedBox(width: 8),
                        _SubjectBadge(q.subject.label),
                      ]),
                      const SizedBox(height: 12),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.bgPrimary,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.borderLight),
                        ),
                        child: Text(q.text,
                            style: const TextStyle(
                                fontSize: 15, height: 1.6, color: AppColors.textPrimary)),
                      ),
                      const SizedBox(height: 16),

                      Expanded(
                        child: ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: q.options.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                          itemBuilder: (_, i) {
                            final opt = q.options[i];
                            final isSelected = state.selectedOption == opt;
                            final isCorrect = opt == q.answer;

                            Color bg = AppColors.bgPrimary;
                            Color border = AppColors.borderLight;
                            Color textColor = AppColors.textPrimary;

                            if (state.selectedOption != null) {
                              if (isCorrect) {
                                bg = AppColors.successLight;
                                border = AppColors.success;
                                textColor = AppColors.success;
                              } else if (isSelected) {
                                bg = AppColors.errorLight;
                                border = AppColors.error;
                                textColor = AppColors.error;
                              }
                            } else if (isSelected) {
                              bg = AppColors.primaryBlueLight;
                              border = AppColors.primaryBlue;
                              textColor = AppColors.primaryBlue;
                            }

                            return GestureDetector(
                              onTap: () => cubit.selectOption(opt),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                height: 56,
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  color: bg,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: border,
                                      width:
                                          isSelected || (state.selectedOption != null && isCorrect)
                                              ? 2
                                              : 1),
                                ),
                                alignment: Alignment.centerLeft,
                                child: Text(opt,
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: textColor,
                                        fontWeight: FontWeight.w500)),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TimerWidget extends StatelessWidget {
  final int timeLeft;
  const _TimerWidget({required this.timeLeft});

  @override
  Widget build(BuildContext context) {
    final color = timeLeft > 10 ? AppColors.primaryBlue : AppColors.error;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(children: [
        Icon(PhosphorIconsRegular.timer, color: color, size: 16),
        const SizedBox(width: 4),
        Text('${timeLeft}s',
            style: TextStyle(fontWeight: FontWeight.w700, color: color, fontSize: 16)),
      ]),
    );
  }
}

class _DiffBadge extends StatelessWidget {
  final QuestionDifficulty diff;
  const _DiffBadge(this.diff);

  @override
  Widget build(BuildContext context) {
    final color = switch (diff) {
      QuestionDifficulty.easy => AppColors.success,
      QuestionDifficulty.medium => AppColors.warning,
      QuestionDifficulty.hard => AppColors.error,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
      child: Text(diff.label,
          style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
    );
  }
}

class _SubjectBadge extends StatelessWidget {
  final String label;
  const _SubjectBadge(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration:
          BoxDecoration(color: AppColors.primaryBlueLight, borderRadius: BorderRadius.circular(6)),
      child: Text(label,
          style: const TextStyle(
              fontSize: 11, color: AppColors.primaryBlue, fontWeight: FontWeight.w600)),
    );
  }
}

class _StartScreen extends StatelessWidget {
  final VoidCallback onStart;
  const _StartScreen({required this.onStart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgSecondary,
      appBar: AppBar(
        title: const Text('Question Rush ⚡'),
        leading: IconButton(
          icon: const Icon(PhosphorIconsRegular.arrowLeft),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient:
                      const LinearGradient(colors: [AppColors.primary, AppColors.primaryDark]),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: const Icon(PhosphorIconsFill.lightning, color: Colors.white, size: 52),
              ),
              const SizedBox(height: 24),
              const Text('Question Rush',
                  style: TextStyle(
                      fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
              const SizedBox(height: 8),
              const Text(
                '30 seconds per question!\nHow fast and accurate can you be?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: AppColors.textSecondary, height: 1.5),
              ),
              const SizedBox(height: 32),
              const _RuleItem(icon: PhosphorIconsFill.timer, text: '30 seconds per question'),
              const _RuleItem(icon: PhosphorIconsFill.star, text: 'Correct answer = 1 point'),
              const _RuleItem(
                  icon: PhosphorIconsFill.lightning, text: 'Stay sharp under pressure!'),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: onStart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Start ⚡',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RuleItem extends StatelessWidget {
  final IconData icon;
  final String text;
  const _RuleItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(children: [
        Icon(icon, color: AppColors.primaryBlue, size: 20),
        const SizedBox(width: 10),
        Text(text, style: const TextStyle(fontSize: 15, color: AppColors.textPrimary)),
      ]),
    );
  }
}

class _ResultScreen extends StatelessWidget {
  final int score, total;
  final VoidCallback onRetry;
  const _ResultScreen({required this.score, required this.total, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final pct = total > 0 ? (score / total * 100).round() : 0;
    final emoji = pct >= 80
        ? '🏆'
        : pct >= 60
            ? '👏'
            : pct >= 40
                ? '💪'
                : '📚';

    return Scaffold(
      backgroundColor: AppColors.bgSecondary,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(emoji, style: const TextStyle(fontSize: 72)),
                const SizedBox(height: 16),
                Text('$score / $total',
                    style: const TextStyle(
                        fontSize: 48, fontWeight: FontWeight.w800, color: AppColors.primaryBlue)),
                const SizedBox(height: 8),
                Text('Correct: $pct%',
                    style: const TextStyle(fontSize: 18, color: AppColors.textSecondary)),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: onRetry,
                    child: const Text('Play Again'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    onPressed: () => context.pop(),
                    child: const Text('Exit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
