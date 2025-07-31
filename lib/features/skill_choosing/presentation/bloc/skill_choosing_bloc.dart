import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gwenchana/features/skill_choosing/presentation/bloc/skill_choosing_event.dart';
import 'package:gwenchana/features/skill_choosing/presentation/bloc/skill_choosing_state.dart';

class SkillChoosingBloc extends Bloc<SkillChoosingEvent, SkillChoosingState> {
  SkillChoosingBloc() : super(SkillsInitial()) {
    on<LoadSkills>(_onLoadSkills);
    on<SkillSelected>(_onSkillSelected);
  }

  Future<void> _onLoadSkills(
      LoadSkills event, Emitter<SkillChoosingState> emit) async {
    emit(SkillsLoading());
    try {
      final skills = [
        Skill(id: '1', name: 'Vocabulary'),
        Skill(id: '1', name: 'Reading'),
        Skill(id: '1', name: 'Writing'),
        Skill(id: '1', name: 'Speaking'),
      ];
      emit(SkillsLoaded(skills: skills));
    } catch (e) {
      emit(SkillsError('Error loading skills list'));
    }
  }

  void _onSkillSelected(SkillSelected event, Emitter<SkillChoosingState> emit) {
    if (state is SkillsLoaded) {
      final loadedState = state as SkillsLoaded;
      emit(SkillsLoaded(
        skills: loadedState.skills,
      ));
    }
  }
}
