import 'package:equatable/equatable.dart';

abstract class WritingSkillEvent extends Equatable {
  const WritingSkillEvent();

  @override
  List<Object?> get props => [];
}

class LoadWritingLevels extends WritingSkillEvent {
  const LoadWritingLevels();
}

class ChangeWritingLevel extends WritingSkillEvent {
  final int level;

  const ChangeWritingLevel(this.level);

  @override
  List<Object?> get props => [level];
}

class StartWritingSkill extends WritingSkillEvent {
  final int level;
  final int setIndex;

  const StartWritingSkill({
    required this.level,
    required this.setIndex,
  });

  @override
  List<Object?> get props => [level, setIndex];
}

class WritingInputChanged extends WritingSkillEvent {
  final String input;
  const WritingInputChanged(this.input);

  @override
  List<Object?> get props => [input];
}

class WritingCheckAnswer extends WritingSkillEvent {
  const WritingCheckAnswer();
}

class WritingNextWord extends WritingSkillEvent {
  const WritingNextWord();
}

class WritingPreviousWord extends WritingSkillEvent {
  const WritingPreviousWord();
}

class WritingSkipWord extends WritingSkillEvent {
  const WritingSkipWord();
}

class WritingResetProgress extends WritingSkillEvent {
  const WritingResetProgress();
}
