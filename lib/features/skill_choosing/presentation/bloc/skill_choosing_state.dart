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
  final int selectedIndex;
  final bool isAnimating;

  const SkillsLoaded({
    required this.skills,
    this.selectedSkillId,
    this.selectedIndex = -1,
    this.isAnimating = false,
  });

  SkillsLoaded copyWith({
    List<Skill>? skills,
    String? selectedSkillId,
    int? selectedIndex,
    bool? isAnimating,
  }) =>
      SkillsLoaded(
        skills: skills ?? this.skills,
        selectedSkillId: selectedSkillId ?? this.selectedSkillId,
        selectedIndex: selectedIndex ?? this.selectedIndex,
        isAnimating: isAnimating ?? this.isAnimating,
      );

  @override
  List<Object?> get props => [
        skills,
        selectedSkillId,
        selectedIndex,
        isAnimating,
      ];
}

class SkillsError extends SkillChoosingState {
  final String message;

  const SkillsError(this.message);

  @override
  List<Object?> get props => [message];
}
