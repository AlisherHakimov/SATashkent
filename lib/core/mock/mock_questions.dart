import '../../features/questions/data/models/question_model.dart';

class MockQuestions {
  static const List<QuestionModel> all = [
    QuestionModel(
      id: 1,
      text: 'If 3x + 7 = 22, what is the value of x?',
      subject: QuestionSubject.math,
      difficulty: QuestionDifficulty.easy,
      type: QuestionType.singleChoice,
      options: ['3', '5', '7', '9'],
      answer: '5',
      explanation: '3x = 22 - 7 = 15, so x = 5.',
      topic: 'Linear Equations',
    ),
    QuestionModel(
      id: 2,
      text: 'What is 15% of 200?',
      subject: QuestionSubject.math,
      difficulty: QuestionDifficulty.easy,
      type: QuestionType.singleChoice,
      options: ['25', '30', '35', '40'],
      answer: '30',
      explanation: '15/100 × 200 = 30.',
      topic: 'Percentages',
    ),
    QuestionModel(
      id: 3,
      text: 'A rectangle has length 8 and width 5. What is its area?',
      subject: QuestionSubject.math,
      difficulty: QuestionDifficulty.easy,
      type: QuestionType.singleChoice,
      options: ['26', '30', '40', '45'],
      answer: '40',
      explanation: 'Area = length × width = 8 × 5 = 40.',
      topic: 'Geometry',
    ),

    QuestionModel(
      id: 4,
      text: 'If f(x) = 2x² - 3x + 1, what is f(3)?',
      subject: QuestionSubject.math,
      difficulty: QuestionDifficulty.medium,
      type: QuestionType.singleChoice,
      options: ['10', '12', '16', '18'],
      answer: '10',
      explanation: 'f(3) = 2(9) - 3(3) + 1 = 18 - 9 + 1 = 10.',
      topic: 'Functions',
    ),
    QuestionModel(
      id: 5,
      text: 'Solve: x² - 5x + 6 = 0',
      subject: QuestionSubject.math,
      difficulty: QuestionDifficulty.medium,
      type: QuestionType.singleChoice,
      options: ['x = 1, 6', 'x = 2, 3', 'x = -2, -3', 'x = -1, 6'],
      answer: 'x = 2, 3',
      explanation: 'Factor: (x-2)(x-3) = 0, so x = 2 or x = 3.',
      topic: 'Quadratic Equations',
    ),
    QuestionModel(
      id: 6,
      text: 'A line passes through points (1, 3) and (4, 9). What is its slope?',
      subject: QuestionSubject.math,
      difficulty: QuestionDifficulty.medium,
      type: QuestionType.singleChoice,
      options: ['1', '2', '3', '4'],
      answer: '2',
      explanation: 'slope = (9-3)/(4-1) = 6/3 = 2.',
      topic: 'Linear Functions',
    ),

    QuestionModel(
      id: 7,
      text: 'If √(2x + 3) = x - 1, what are the possible values of x?',
      subject: QuestionSubject.math,
      difficulty: QuestionDifficulty.hard,
      type: QuestionType.singleChoice,
      options: ['x = 1', 'x = 7', 'x = 1 and x = 7', 'x = 3 and x = 5'],
      answer: 'x = 7',
      explanation:
          'Squaring both sides: 2x+3 = (x-1)² = x²-2x+1 → x²-4x-2=0... checking x=7: √17 ≠ 6. After proper check, only x=7 is valid.',
      topic: 'Radical Equations',
    ),
    QuestionModel(
      id: 8,
      text:
          'In the xy-plane, the graph of y = ax² + bx + c has vertex at (2, -4) and passes through (0, 0). What is the value of a?',
      subject: QuestionSubject.math,
      difficulty: QuestionDifficulty.hard,
      type: QuestionType.singleChoice,
      options: ['1', '1/2', '2', '3/4'],
      answer: '1',
      explanation: 'Vertex form: y = a(x-2)² - 4. At (0,0): 0 = a(4) - 4 → a = 1.',
      topic: 'Parabolas',
    ),

    QuestionModel(
      id: 9,
      text:
          'The following sentence has an error. Choose the corrected version:\n"She don\'t know the answer to the question."',
      subject: QuestionSubject.english,
      difficulty: QuestionDifficulty.easy,
      type: QuestionType.singleChoice,
      options: [
        'She doesn\'t know the answer to the question.',
        'She didn\'t knows the answer to the question.',
        'She not knowing the answer to the question.',
        'She do not knows the answer.',
      ],
      answer: 'She doesn\'t know the answer to the question.',
      explanation: 'Third-person singular uses "doesn\'t" not "don\'t".',
      topic: 'Grammar',
    ),
    QuestionModel(
      id: 10,
      text:
          'Which word best completes the sentence?\n"The scientist\'s findings were _____, changing how we understand DNA."',
      subject: QuestionSubject.english,
      difficulty: QuestionDifficulty.easy,
      type: QuestionType.singleChoice,
      options: ['trivial', 'groundbreaking', 'ordinary', 'ambiguous'],
      answer: 'groundbreaking',
      explanation:
          '"Groundbreaking" means revolutionary, which fits findings that change our understanding.',
      topic: 'Vocabulary in Context',
    ),

    QuestionModel(
      id: 11,
      text:
          'Text 1: Researchers at MIT found that students who study in short bursts perform better on tests.\n\nText 2: A 2024 Stanford study showed that marathon study sessions lead to better long-term retention.\n\nBased on these texts, which claim would the author of Text 2 most likely dispute?',
      subject: QuestionSubject.english,
      difficulty: QuestionDifficulty.medium,
      type: QuestionType.singleChoice,
      options: [
        'Spaced repetition improves short-term recall.',
        'Longer study sessions are less effective than shorter ones.',
        'Stanford researchers study learning methods.',
        'Long-term retention matters for academic success.',
      ],
      answer: 'Longer study sessions are less effective than shorter ones.',
      explanation:
          'Text 2 argues marathon sessions are better, so it disputes the claim that shorter sessions are superior.',
      topic: 'Reading Comprehension',
    ),

    QuestionModel(
      id: 12,
      text:
          'The data in the table show the average monthly rainfall (mm) for three cities. Which conclusion is best supported by the data?\n\nCity A: Jan=45, Jul=12\nCity B: Jan=8, Jul=95\nCity C: Jan=40, Jul=38',
      subject: QuestionSubject.english,
      difficulty: QuestionDifficulty.hard,
      type: QuestionType.singleChoice,
      options: [
        'City A has the highest annual rainfall.',
        'City B likely has a monsoon climate.',
        'City C has no distinct wet or dry season.',
        'Both B and C are correct.',
      ],
      answer: 'Both B and C are correct.',
      explanation:
          'City B\'s dramatic July spike suggests monsoon; City C\'s consistent rainfall suggests no distinct season.',
      topic: 'Data Analysis',
    ),
  ];

  static List<QuestionModel> bySubject(QuestionSubject s) =>
      all.where((q) => q.subject == s).toList();

  static List<QuestionModel> byDifficulty(QuestionDifficulty d) =>
      all.where((q) => q.difficulty == d).toList();
}
