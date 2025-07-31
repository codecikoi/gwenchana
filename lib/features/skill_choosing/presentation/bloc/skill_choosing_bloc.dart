import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gwenchana/features/skill_choosing/presentation/bloc/skill_choosing_event.dart';
import 'package:gwenchana/features/skill_choosing/presentation/bloc/skill_choosing_state.dart';

class SkillChoosingBloc extends Bloc<SkillChoosingEvent, SkillChoosingState> {
  SkillChoosingBloc() : super(SkillsInitial()) {
    on<LoadSkills>(_onLoadSkills);
    on<SkillSelected>(_onSkillSelected);
    on<SkillAnimationEnded>(_onSkillAnimationEnded);
  }

  Future<void> _onLoadSkills(
      LoadSkills event, Emitter<SkillChoosingState> emit) async {
    emit(SkillsLoading());
    try {
      final skills = [
        Skill(id: '0', name: 'Vocabulary'),
        Skill(id: '1', name: 'Reading'),
        Skill(id: '2', name: 'Writing'),
        Skill(id: '3', name: 'Speaking'),
      ];
      emit(SkillsLoaded(skills: skills));
    } catch (e) {
      emit(SkillsError('Error loading skills list'));
    }
  }

  void _onSkillSelected(SkillSelected event, Emitter<SkillChoosingState> emit) {
    if (state is SkillsLoaded) {
      final loadedState = state as SkillsLoaded;
      final selectedIndex =
          event.skillsId.isEmpty ? -1 : int.tryParse(event.skillsId) ?? -1;
      emit(SkillsLoaded(
        skills: loadedState.skills,
        selectedSkillId: event.skillsId.isEmpty ? null : event.skillsId,
        selectedIndex: selectedIndex,
        isAnimating: true,
      ));
    }
  }

  void _onSkillAnimationEnded(
      SkillAnimationEnded event, Emitter<SkillChoosingState> emit) {
    if (state is SkillsLoaded) {
      final loadedState = state as SkillsLoaded;
      emit(SkillsLoaded(
        skills: loadedState.skills,
        isAnimating: false,
      ));
    }
  }
}
