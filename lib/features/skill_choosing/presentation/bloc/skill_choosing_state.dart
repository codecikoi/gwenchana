import 'package:equatable/equatable.dart';

class Skill {
  final String id;
  final String name;

  Skill({
    required this.id,
    required this.name,
  });
}

abstract class SkillChoosingState extends Equatable {
  const SkillChoosingState();

  @override
  List<Object?> get props => [];
}

class SkillsInitial extends SkillChoosingState {}

class SkillsLoading extends SkillChoosingState {}

class SkillsLoaded extends SkillChoosingState {
  final List<Skill> skills;
  final String? selectedSkillId;

  const SkillsLoaded({
    required this.skills,
    this.selectedSkillId,
  });

  @override
  List<Object?> get props => [
        skills,
        selectedSkillId,
      ];
}

class SkillsError extends SkillChoosingState {
  final String message;

  const SkillsError(this.message);

  @override
  List<Object?> get props => [message];
}
