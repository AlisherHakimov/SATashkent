import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/di/di_container.dart';
import '../../../../core/mock/mock_questions.dart';
import '../../../../features/questions/data/models/question_model.dart';
import '../bloc/question_solve_cubit.dart';

class QuestionSolveScreen extends StatelessWidget {
  final int questionId;
  const QuestionSolveScreen({super.key, required this.questionId});

  @override
  Widget build(BuildContext context) {
    final question = MockQuestions.all.where((q) => q.id == questionId).firstOrNull;

    if (question == null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(PhosphorIconsRegular.arrowLeft),
            onPressed: () => context.pop(),
          ),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(PhosphorIconsRegular.questionMark, size: 48, color: AppColors.textTertiary),
              SizedBox(height: 12),
              Text('Question not found',
                  style: TextStyle(fontSize: 16, color: AppColors.textSecondary)),
            ],
          ),
        ),
      );
    }

    return BlocProvider(
      create: (_) => sl<QuestionSolveCubit>()..loadQuestion(question),
      child: const _QuestionSolveView(),
    );
  }
}

class _QuestionSolveView extends StatelessWidget {
  const _QuestionSolveView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuestionSolveCubit, QuestionSolveState>(
      builder: (context, state) {
        final cubit = context.read<QuestionSolveCubit>();
        final q = state.question;

        if (q == null) {
          return const Scaffold(
            body: Center(child: Text('Question not found')),
          );
        }

        final diffColor = switch (q.difficulty) {
          QuestionDifficulty.easy => AppColors.success,
          QuestionDifficulty.medium => AppColors.warning,
          QuestionDifficulty.hard => AppColors.error,
        };

        return Scaffold(
          backgroundColor: AppColors.bgSecondary,
          appBar: AppBar(
            title: Text(q.subject.label),
            leading: IconButton(
              icon: const Icon(PhosphorIconsRegular.arrowLeft),
              onPressed: () => context.pop(),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: diffColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(q.difficulty.label,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: diffColor)),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.bgPrimary,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (q.topic != null)
                        Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryBlueLight,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(q.topic!,
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.primaryBlue,
                                  fontWeight: FontWeight.w600)),
                        ),
                      Text(q.text,
                          style: const TextStyle(
                              fontSize: 15, height: 1.6, color: AppColors.textPrimary)),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                const Text('Choose your answer:',
                    style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                const SizedBox(height: 10),

                ...q.options.asMap().entries.map((e) {
                  final idx = e.key;
                  final opt = e.value;
                  final isSelected = state.selectedOption == opt;
                  final isCorrect = opt == q.answer;

                  Color borderColor = AppColors.borderLight;
                  Color bgColor = AppColors.bgPrimary;
                  Color textColor = AppColors.textPrimary;

                  if (state.isSubmitted) {
                    if (isCorrect) {
                      borderColor = AppColors.success;
                      bgColor = AppColors.successLight;
                      textColor = AppColors.success;
                    } else if (isSelected && !isCorrect) {
                      borderColor = AppColors.error;
                      bgColor = AppColors.errorLight;
                      textColor = AppColors.error;
                    }
                  } else if (isSelected) {
                    borderColor = AppColors.primaryBlue;
                    bgColor = AppColors.primaryBlueLight;
                    textColor = AppColors.primaryBlue;
                  }

                  return GestureDetector(
                    onTap: state.isSubmitted ? null : () => cubit.selectOption(opt),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: borderColor,
                            width: isSelected || (state.isSubmitted && isCorrect) ? 2 : 1),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSelected || (state.isSubmitted && isCorrect)
                                  ? textColor.withValues(alpha: 0.15)
                                  : AppColors.bgTertiary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              ['A', 'B', 'C', 'D'][idx],
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                color: isSelected || (state.isSubmitted && isCorrect)
                                    ? textColor
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(opt,
                                style: TextStyle(fontSize: 14, color: textColor, height: 1.4)),
                          ),
                          if (state.isSubmitted && isCorrect)
                            const Icon(PhosphorIconsFill.checkCircle,
                                color: AppColors.success, size: 20),
                          if (state.isSubmitted && isSelected && !isCorrect)
                            const Icon(PhosphorIconsFill.xCircle, color: AppColors.error, size: 20),
                        ],
                      ),
                    ),
                  );
                }),

                if (state.isSubmitted && q.explanation != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlueLight,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.primaryBlue.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(PhosphorIconsFill.lightbulb,
                            color: AppColors.primaryBlue, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Explanation',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primaryBlue,
                                      fontSize: 13)),
                              const SizedBox(height: 4),
                              Text(q.explanation!,
                                  style: const TextStyle(
                                      fontSize: 13, color: AppColors.textPrimary, height: 1.5)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 24),

                if (!state.isSubmitted)
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: state.selectedOption != null ? cubit.submit : null,
                      child: const Text('Check Answer'),
                    ),
                  )
                else
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () => context.pop(),
                      child: const Text('Back to Questions →'),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
