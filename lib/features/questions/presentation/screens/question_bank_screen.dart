import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/bloc_status.dart';
import '../../../../features/questions/data/models/question_model.dart';
import '../bloc/questions_cubit.dart';

class QuestionBankScreen extends StatelessWidget {
  const QuestionBankScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuestionsCubit, QuestionsState>(
      builder: (context, state) {
        final cubit = context.read<QuestionsCubit>();

        return Scaffold(
          backgroundColor: AppColors.bgSecondary,
          appBar: AppBar(
            title: const Text('Question Bank'),
            actions: [
              if (state.status == BlocStatus.success)
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Center(
                    child: Text(
                      '${state.allQuestions.length} questions',
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    ),
                  ),
                ),
            ],
          ),
          body: Column(
            children: [
              Container(
                color: AppColors.bgPrimary,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Column(
                  children: [
                    _SearchBar(
                      onChanged: cubit.search,
                      initialValue: state.searchQuery,
                    ),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _Chip(
                            label: 'All',
                            selected: state.selectedSubject == null,
                            onTap: () => cubit.filterBySubject(null),
                          ),
                          ...QuestionSubject.values.map((s) => _Chip(
                                label: s.label,
                                selected: state.selectedSubject == s,
                                onTap: () =>
                                    cubit.filterBySubject(state.selectedSubject == s ? null : s),
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: QuestionDifficulty.values.map((d) {
                        final color = switch (d) {
                          QuestionDifficulty.easy => AppColors.success,
                          QuestionDifficulty.medium => AppColors.warning,
                          QuestionDifficulty.hard => AppColors.error,
                        };
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: _Chip(
                            label: d.label,
                            selected: state.selectedDifficulty == d,
                            activeColor: color,
                            onTap: () =>
                                cubit.filterByDifficulty(state.selectedDifficulty == d ? null : d),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              if (state.status == BlocStatus.loading || state.status == BlocStatus.initial)
                const Expanded(child: Center(child: CircularProgressIndicator()))
              else if (state.status == BlocStatus.error)
                Expanded(
                  child: Center(
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
                          onPressed: cubit.loadQuestions,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              else ...[
                // Results count
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${state.filtered.length} results',
                    style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  ),
                ),
                // Question list
                Expanded(
                  child: state.filtered.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(PhosphorIconsRegular.magnifyingGlass,
                                  size: 48, color: AppColors.textTertiary),
                              SizedBox(height: 12),
                              Text('No questions found',
                                  style: TextStyle(color: AppColors.textSecondary)),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          itemCount: state.filtered.length,
                          itemBuilder: (_, i) => _QuestionCard(q: state.filtered[i]),
                        ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _SearchBar extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final String initialValue;
  const _SearchBar({required this.onChanged, required this.initialValue});

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _ctrl,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        hintText: 'Search questions...',
        prefixIcon: const Icon(PhosphorIconsRegular.magnifyingGlass,
            color: AppColors.textTertiary, size: 20),
        filled: true,
        fillColor: AppColors.bgTertiary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  final QuestionModel q;
  const _QuestionCard({required this.q});

  @override
  Widget build(BuildContext context) {
    final diffColor = switch (q.difficulty) {
      QuestionDifficulty.easy => AppColors.success,
      QuestionDifficulty.medium => AppColors.warning,
      QuestionDifficulty.hard => AppColors.error,
    };
    return GestureDetector(
      onTap: () => context.push('${Routes.questions}/solve?id=${q.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.bgPrimary,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _TagBadge(label: q.subject.label, color: AppColors.primaryBlue),
                const SizedBox(width: 6),
                _TagBadge(label: q.difficulty.label, color: diffColor),
                if (q.topic != null) ...[
                  const SizedBox(width: 6),
                  _TagBadge(label: q.topic!, color: AppColors.textSecondary),
                ],
                const Spacer(),
                const Icon(PhosphorIconsRegular.caretRight,
                    size: 16, color: AppColors.textTertiary),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              q.text,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, color: AppColors.textPrimary, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}

class _TagBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _TagBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color? activeColor;

  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = activeColor ?? AppColors.primaryBlue;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? color : AppColors.bgTertiary,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? color : AppColors.borderLight),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
