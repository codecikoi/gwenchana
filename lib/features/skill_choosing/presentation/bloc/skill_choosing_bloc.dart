import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gwenchana/features/skill_choosing/presentation/bloc/skill_choosing_event.dart';
import 'package:gwenchana/features/skill_choosing/presentation/bloc/skill_choosing_state.dart';

class SkillChoosingBloc extends Bloc<SkillChoosingEvent, SkillChoosingState> {
  SkillChoosingBloc() : super(const SkillChoosingState()) {
    on<SkillSelected>((event, emit) {
      emit(state.copyWith(selectedIndex: event.index, isAnimating: true));
    });
    on<SkillAnimationEnded>((event, emit) {
      emit(state.copyWith(isAnimating: false));
    });
  }
}
