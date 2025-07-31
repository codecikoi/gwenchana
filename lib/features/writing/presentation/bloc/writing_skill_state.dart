import 'package:equatable/equatable.dart';

abstract class WritingSkillState extends Equatable {
  const WritingSkillState();
  @override
  List<Object?> get props => [];
}

class WritingLevelsLoading extends WritingSkillState {}

class WritingLevelsLoaded extends WritingSkillState {
  final int selectedLevel;
  final List<String> levelNames;
  final List<String> lessonTitles;

  const WritingLevelsLoaded({
    required this.selectedLevel,
    required this.levelNames,
    required this.lessonTitles,
  });

  WritingLevelsLoaded copyWith({
    int? selectedLevel,
    List<String>? levelNames,
    List<String>? lessonTitles,
  }) {
    return WritingLevelsLoaded(
      selectedLevel: selectedLevel ?? this.selectedLevel,
      levelNames: levelNames ?? this.levelNames,
      lessonTitles: lessonTitles ?? this.lessonTitles,
    );
  }

  @override
  List<Object?> get props => [selectedLevel, levelNames, lessonTitles];
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

class WritingError extends WritingSkillState {
  final String message;

  const WritingError(this.message);

  @override
  List<Object?> get props => [message];
}
