import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/di/di_container.dart';
import '../../../../core/utils/bloc_status.dart';
import '../../data/models/assessment_model.dart';
import '../bloc/assessments_cubit.dart';

class AssessmentsScreen extends StatelessWidget {
  const AssessmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AssessmentsCubit>()..loadAssessments(),
      child: const _AssessmentsView(),
    );
  }
}

class _AssessmentsView extends StatelessWidget {
  const _AssessmentsView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AssessmentsCubit, AssessmentsState>(
      builder: (context, state) {
        if (state.status == BlocStatus.loading || state.status == BlocStatus.initial) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Assessments'),
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
              title: const Text('Assessments'),
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
                    onPressed: () => context.read<AssessmentsCubit>().loadAssessments(),
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
            title: const Text('Assessments'),
            leading: IconButton(
              icon: const Icon(PhosphorIconsRegular.arrowLeft),
              onPressed: () => context.pop(),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(children: [
                _SmallStat(value: '${state.completed.length}', label: 'Completed'),
                const SizedBox(width: 12),
                _SmallStat(value: '${state.available.length}', label: 'Available'),
                const SizedBox(width: 12),
                _SmallStat(value: '${state.bestScore}', label: 'Best Score'),
              ]),
              const SizedBox(height: 20),

              if (state.available.isNotEmpty) ...[
                const _SectionLabel('📋 Available Tests'),
                ...state.available.map((i) => _AssessmentCard(item: i)),
                const SizedBox(height: 8),
              ],

              if (state.completed.isNotEmpty) ...[
                const _SectionLabel('✅ Completed Tests'),
                ...state.completed.map((i) => _AssessmentCard(item: i)),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(text, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
    );
  }
}

class _AssessmentCard extends StatelessWidget {
  final AssessmentModel item;
  const _AssessmentCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final tagColor = switch (item.tag) {
      'Math' => AppColors.primaryBlue,
      'English' => AppColors.secondary,
      _ => AppColors.textSecondary,
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: tagColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(item.tag,
                  style: TextStyle(fontSize: 11, color: tagColor, fontWeight: FontWeight.w600)),
            ),
            const Spacer(),
            if (item.isCompleted)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text('✓ Completed',
                    style: TextStyle(
                        fontSize: 11, color: AppColors.success, fontWeight: FontWeight.w600)),
              ),
          ]),
          const SizedBox(height: 10),
          Text(item.title,
              style: const TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          const SizedBox(height: 4),
          Text(item.subtitle, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
          const SizedBox(height: 12),
          Row(children: [
            const Icon(PhosphorIconsRegular.question, size: 14, color: AppColors.textSecondary),
            const SizedBox(width: 4),
            Text('${item.totalQuestions} questions',
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            const SizedBox(width: 14),
            const Icon(PhosphorIconsRegular.clock, size: 14, color: AppColors.textSecondary),
            const SizedBox(width: 4),
            Text('${item.durationMin} min',
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            const Spacer(),
            if (item.score != null)
              Text('${item.score} / 1600',
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primaryBlue))
            else
              ElevatedButton(
                onPressed: () => _showStartDialog(context, item),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                child: const Text('Start'),
              ),
          ]),
        ],
      ),
    );
  }
}

void _showStartDialog(BuildContext context, AssessmentModel item) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Start Assessment'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.title,
              style: const TextStyle(
                  fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.textPrimary)),
          const SizedBox(height: 12),
          _InfoChip(icon: PhosphorIconsRegular.question, text: '${item.totalQuestions} questions'),
          const SizedBox(height: 6),
          _InfoChip(icon: PhosphorIconsRegular.clock, text: '${item.durationMin} minutes'),
          const SizedBox(height: 6),
          const _InfoChip(icon: PhosphorIconsRegular.warning, text: 'Cannot pause once started'),
          const SizedBox(height: 12),
          const Text('Make sure you have a stable connection and enough time to complete the test.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Not now', style: TextStyle(color: AppColors.textSecondary)),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(ctx);
            // Navigate to assessment test
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => _AssessmentTestScreen(item: item),
              ),
            );
          },
          child: const Text('Start Test'),
        ),
      ],
    ),
  );
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(icon, size: 14, color: AppColors.primaryBlue),
      const SizedBox(width: 6),
      Text(text, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
    ]);
  }
}

class _AssessmentTestScreen extends StatefulWidget {
  final AssessmentModel item;
  const _AssessmentTestScreen({required this.item});

  @override
  State<_AssessmentTestScreen> createState() => _AssessmentTestScreenState();
}

class _AssessmentTestScreenState extends State<_AssessmentTestScreen> {
  int _currentQuestion = 0;
  int _answered = 0;
  String? _selectedOption;
  bool _submitted = false;

  // Mock questions for demonstration
  static const _mockOptions = ['Option A', 'Option B', 'Option C', 'Option D'];
  static const _correctAnswer = 'Option B';

  void _selectOption(String opt) {
    if (_submitted) return;
    setState(() => _selectedOption = opt);
  }

  void _submit() {
    if (_selectedOption == null) return;
    setState(() {
      _submitted = true;
      if (_selectedOption == _correctAnswer) _answered++;
    });
  }

  void _next() {
    if (_currentQuestion >= widget.item.totalQuestions - 1) {
      _showResult();
      return;
    }
    setState(() {
      _currentQuestion++;
      _selectedOption = null;
      _submitted = false;
    });
  }

  void _showResult() {
    final pct = (_answered / widget.item.totalQuestions * 100).round();
    // Rough SAT score estimate
    final satScore = 400 + (_answered / widget.item.totalQuestions * 1200).round();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Test Complete! 🎉'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('$_answered / ${widget.item.totalQuestions}',
                style: const TextStyle(
                    fontSize: 36, fontWeight: FontWeight.w800, color: AppColors.primaryBlue)),
            Text('$pct% correct', style: const TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient:
                    const LinearGradient(colors: [AppColors.gradientStart, AppColors.gradientEnd]),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(children: [
                const Text('Estimated SAT Score',
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
                Text('$satScore / 1600',
                    style: const TextStyle(
                        color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800)),
              ]),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_currentQuestion + 1) / widget.item.totalQuestions;

    return Scaffold(
      backgroundColor: AppColors.bgSecondary,
      appBar: AppBar(
        title: Text(widget.item.tag),
        leading: IconButton(
          icon: const Icon(PhosphorIconsRegular.x),
          onPressed: () => showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Exit Test?'),
              content: const Text('Your progress will be lost. Are you sure you want to exit?'),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Continue Test')),
                TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      Navigator.pop(context);
                    },
                    child: const Text('Exit', style: TextStyle(color: AppColors.error))),
              ],
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '${_currentQuestion + 1} / ${widget.item.totalQuestions}',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress bar
          ClipRect(
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.borderLight,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
              minHeight: 5,
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Question card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.bgPrimary,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: Text(
                      'Question ${_currentQuestion + 1}: This is a sample ${widget.item.tag} question for the assessment. Choose the best answer from the options below.',
                      style:
                          const TextStyle(fontSize: 15, height: 1.6, color: AppColors.textPrimary),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Options
                  Expanded(
                    child: ListView.separated(
                      itemCount: _mockOptions.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (_, i) {
                        final opt = _mockOptions[i];
                        final isSelected = _selectedOption == opt;
                        final isCorrect = _submitted && opt == _correctAnswer;
                        final isWrong = _submitted && isSelected && opt != _correctAnswer;

                        Color bg = AppColors.bgPrimary;
                        Color border = AppColors.borderLight;
                        Color textColor = AppColors.textPrimary;

                        if (isCorrect) {
                          bg = AppColors.successLight;
                          border = AppColors.success;
                          textColor = AppColors.success;
                        } else if (isWrong) {
                          bg = AppColors.errorLight;
                          border = AppColors.error;
                          textColor = AppColors.error;
                        } else if (isSelected) {
                          bg = AppColors.primaryLight;
                          border = AppColors.primaryBlue;
                          textColor = AppColors.primaryBlue;
                        }

                        return GestureDetector(
                          onTap: () => _selectOption(opt),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            height: 56,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: bg,
                              borderRadius: BorderRadius.circular(12),
                              border:
                                  Border.all(color: border, width: isSelected || isCorrect ? 2 : 1),
                            ),
                            alignment: Alignment.centerLeft,
                            child: Text(opt,
                                style: TextStyle(
                                    fontSize: 14, color: textColor, fontWeight: FontWeight.w500)),
                          ),
                        );
                      },
                    ),
                  ),

                  // Action button
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _submitted ? _next : (_selectedOption != null ? _submit : null),
                      child: Text(_submitted
                          ? (_currentQuestion >= widget.item.totalQuestions - 1
                              ? 'Finish'
                              : 'Next Question')
                          : 'Submit Answer'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallStat extends StatelessWidget {
  final String value, label;
  const _SmallStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.bgPrimary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(children: [
          Text(value,
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.primaryBlue)),
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        ]),
      ),
    );
  }
}
