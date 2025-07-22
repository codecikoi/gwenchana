import 'package:equatable/equatable.dart';

class SkillChoosingState extends Equatable {
  final int selectedIndex;
  const SkillChoosingState({this.selectedIndex = -1});

  SkillChoosingState copyWith({int? selectedIndex}) => SkillChoosingState(
        selectedIndex: selectedIndex ?? this.selectedIndex,
      );
  @override
  List<Object?> get props => [selectedIndex];
}
