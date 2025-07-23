import 'package:equatable/equatable.dart';

class SkillChoosingState extends Equatable {
  final int selectedIndex;
  final bool isAnimating;

  const SkillChoosingState({
    this.selectedIndex = -1,
    this.isAnimating = false,
  });

  SkillChoosingState copyWith({int? selectedIndex, bool? isAnimating}) =>
      SkillChoosingState(
        selectedIndex: selectedIndex ?? this.selectedIndex,
        isAnimating: isAnimating ?? this.isAnimating,
      );
  @override
  List<Object?> get props => [selectedIndex, isAnimating];
}
