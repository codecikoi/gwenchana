import 'package:equatable/equatable.dart';

abstract class WritingSkillState extends Equatable {
  const WritingSkillState();
  @override
  List<Object?> get props => [];
}

class WritingSkillInitial extends WritingSkillState {}

class WritingSkillInProgress extends WritingSkillState {
  final int currentIndex;
  final String userInput;
  final bool showResult;
  final bool isCorrect;
  final bool hasStudied;
  final int totalWords;
  final Map<String, String> currentWord;

  const WritingSkillInProgress({
    required this.currentIndex,
    required this.userInput,
    required this.showResult,
    required this.isCorrect,
    required this.hasStudied,
    required this.totalWords,
    required this.currentWord,
  });

  WritingSkillInProgress copyWith({
    int? currentIndex,
    String? userInput,
    bool? showResult,
    bool? isCorrect,
    bool? hasStudied,
    int? totalWords,
    Map<String, String>? currentWord,
  }) {
    return WritingSkillInProgress(
      currentIndex: currentIndex ?? this.currentIndex,
      userInput: userInput ?? this.userInput,
      showResult: showResult ?? this.showResult,
      isCorrect: isCorrect ?? this.isCorrect,
      hasStudied: hasStudied ?? this.hasStudied,
      totalWords: totalWords ?? this.totalWords,
      currentWord: currentWord ?? this.currentWord,
    );
  }

  @override
  List<Object?> get props => [
        currentIndex,
        userInput,
        showResult,
        isCorrect,
        hasStudied,
        totalWords,
        currentWord
      ];
}

class WritingSkillFinished extends WritingSkillState {}
