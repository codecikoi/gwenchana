import 'package:equatable/equatable.dart';

abstract class VocabularyEvent extends Equatable {
  const VocabularyEvent();

  @override
  List<Object?> get props => [];
}

class LoadProgressEvent extends VocabularyEvent {}

class ChangeLevelEvent extends VocabularyEvent {
  final int level;
  const ChangeLevelEvent(this.level);
  @override
  List<Object?> get props => [level];
}

class ResetProgressEvent extends VocabularyEvent {
  final int level;
  const ResetProgressEvent(this.level);
  @override
  List<Object?> get props => [level];
}

class UpdateProgressEvent extends VocabularyEvent {}
