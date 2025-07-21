import 'package:equatable/equatable.dart';

abstract class WritingSkillEvent extends Equatable {
  const WritingSkillEvent();

  @override
  List<Object?> get props => [];
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
