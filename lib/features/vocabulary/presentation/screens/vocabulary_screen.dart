import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/utils/bloc_status.dart';
import '../../../../features/vocabulary/data/models/word_model.dart';
import '../bloc/vocabulary_cubit.dart';

class VocabularyScreen extends StatelessWidget {
  const VocabularyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VocabularyCubit, VocabularyState>(
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
                    onPressed: () => context.read<VocabularyCubit>().loadWords(forceRefresh: true),
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
              title: const Text('Vocabulary'),
              bottom: TabBar(
                labelColor: AppColors.primaryBlue,
                unselectedLabelColor: AppColors.textSecondary,
                indicatorColor: AppColors.primaryBlue,
                tabs: [
                  const Tab(text: 'Flashcards'),
                  Tab(text: 'Learning (${state.learningWords.length})'),
                  Tab(text: 'Mastered (${state.masteredWords.length})'),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                const _FlashcardTab(),
                _WordList(words: state.learningWords),
                _WordList(words: state.masteredWords),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _FlashcardTab extends StatefulWidget {
  const _FlashcardTab();

  @override
  State<_FlashcardTab> createState() => _FlashcardTabState();
}

class _FlashcardTabState extends State<_FlashcardTab> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 350));
    _anim = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _flip(VocabularyCubit cubit, bool isCurrentlyFlipped) {
    if (isCurrentlyFlipped) {
      _ctrl.reverse();
    } else {
      _ctrl.forward();
    }
    cubit.flipCard();
  }

  void _next(VocabularyCubit cubit) {
    _ctrl.reset();
    cubit.nextCard();
  }

  void _prev(VocabularyCubit cubit) {
    _ctrl.reset();
    cubit.prevCard();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VocabularyCubit, VocabularyState>(
      builder: (context, state) {
        final cubit = context.read<VocabularyCubit>();
        final words = state.flashcardWords;

        if (words.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('🎉', style: TextStyle(fontSize: 56)),
                SizedBox(height: 12),
                Text('All words mastered!',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              ],
            ),
          );
        }

        final word = state.currentWord!;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(children: [
                Text('${state.currentIndex + 1}/${words.length}',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                const SizedBox(width: 12),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (state.currentIndex + 1) / words.length,
                      backgroundColor: AppColors.borderLight,
                      valueColor: const AlwaysStoppedAnimation(AppColors.primaryBlue),
                      minHeight: 6,
                    ),
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  onTap: () => _flip(cubit, state.isFlipped),
                  child: AnimatedBuilder(
                    animation: _anim,
                    builder: (_, __) {
                      final angle = _anim.value * 3.14159;
                      final showFront = _anim.value < 0.5;
                      return Transform(
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY(angle),
                        alignment: Alignment.center,
                        child: showFront
                            ? _CardFace(word: word)
                            : Transform(
                                transform: Matrix4.identity()..rotateY(3.14159),
                                alignment: Alignment.center,
                                child: _CardBack(word: word),
                              ),
                      );
                    },
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _CircleBtn(
                    icon: PhosphorIconsRegular.arrowLeft,
                    onTap: () => _prev(cubit),
                    enabled: state.currentIndex > 0,
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _flip(cubit, state.isFlipped),
                    icon: const Icon(PhosphorIconsRegular.arrowsClockwise, size: 18),
                    label: Text(state.isFlipped ? 'Word' : 'Definition'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                  _CircleBtn(
                    icon: PhosphorIconsRegular.arrowRight,
                    onTap: () => _next(cubit),
                    enabled: state.currentIndex < words.length - 1,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CardFace extends StatelessWidget {
  final WordModel word;
  const _CardFace({required this.word});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.gradientStart, AppColors.gradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(word.partOfSpeech,
              style: const TextStyle(
                  color: Colors.white54, fontSize: 14, fontStyle: FontStyle.italic)),
          const SizedBox(height: 12),
          Text(word.word,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5)),
          const SizedBox(height: 24),
          const Text('Tap to flip →', style: TextStyle(color: Colors.white54, fontSize: 12)),
        ],
      ),
    );
  }
}

class _CardBack extends StatelessWidget {
  final WordModel word;
  const _CardBack({required this.word});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.bgPrimary,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primaryBlue.withValues(alpha: 0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(word.word,
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.primaryBlue)),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),
          const Text('Definition:',
              style: TextStyle(
                  fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(word.definition,
              style: const TextStyle(fontSize: 15, height: 1.5, color: AppColors.textPrimary)),
          const SizedBox(height: 16),
          const Text('Example:',
              style: TextStyle(
                  fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(word.exampleSentence,
              style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: AppColors.textPrimary,
                  fontStyle: FontStyle.italic)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: word.synonyms
                .map((s) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.bgTertiary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(s,
                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _WordList extends StatelessWidget {
  final List<WordModel> words;
  const _WordList({required this.words});

  @override
  Widget build(BuildContext context) {
    if (words.isEmpty) {
      return const Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('📭', style: TextStyle(fontSize: 48)),
          SizedBox(height: 12),
          Text('No words here', style: TextStyle(color: AppColors.textSecondary)),
        ]),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: words.length,
      itemBuilder: (_, i) => _WordCard(word: words[i]),
    );
  }
}

class _WordCard extends StatelessWidget {
  final WordModel word;
  const _WordCard({required this.word});

  @override
  Widget build(BuildContext context) {
    final statusColor = switch (word.status) {
      WordStatus.new_ => AppColors.textSecondary,
      WordStatus.learning => AppColors.warning,
      WordStatus.mastered => AppColors.success,
    };
    final statusLabel = switch (word.status) {
      WordStatus.new_ => 'New',
      WordStatus.learning => 'Learning',
      WordStatus.mastered => 'Mastered',
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgPrimary,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(word.word,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                const SizedBox(height: 3),
                Text(word.definition,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style:
                        const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.4)),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(statusLabel,
                    style:
                        TextStyle(fontSize: 10, color: statusColor, fontWeight: FontWeight.w600)),
              ),
              if (word.reviewCount > 0) ...[
                const SizedBox(height: 4),
                Text('${word.reviewCount}× reviewed',
                    style: const TextStyle(fontSize: 10, color: AppColors.textTertiary)),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _CircleBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;
  const _CircleBtn({required this.icon, required this.onTap, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: enabled ? AppColors.bgTertiary : AppColors.borderLight,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: enabled ? AppColors.textPrimary : AppColors.textTertiary),
      ),
    );
  }
}
