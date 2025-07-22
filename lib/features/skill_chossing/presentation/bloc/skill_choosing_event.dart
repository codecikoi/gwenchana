import 'package:equatable/equatable.dart';

abstract class SkillChoosingEvent extends Equatable {
  const SkillChoosingEvent();

  @override
  List<Object?> get props => [];
}

class SkillSelected extends SkillChoosingEvent {
  final int index;
  const SkillSelected(this.index);

  @override
  List<Object?> get props => [index];
}
