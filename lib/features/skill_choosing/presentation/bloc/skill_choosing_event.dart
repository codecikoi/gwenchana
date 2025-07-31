import 'package:equatable/equatable.dart';

abstract class SkillChoosingEvent extends Equatable {
  const SkillChoosingEvent();

  @override
  List<Object?> get props => [];
}

class LoadSkills extends SkillChoosingEvent {}

class SkillSelected extends SkillChoosingEvent {
  final String skillsId;
  const SkillSelected(this.skillsId);

  @override
  List<Object?> get props => [skillsId];
}

class SkillAnimationEnded extends SkillChoosingEvent {}
