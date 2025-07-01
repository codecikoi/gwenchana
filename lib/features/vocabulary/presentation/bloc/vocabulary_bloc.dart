import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gwenchana/core/services/progress_service.dart';
import 'package:gwenchana/features/vocabulary/presentation/bloc/vocabulary_event.dart';
import 'package:gwenchana/features/vocabulary/presentation/bloc/vocabulary_state.dart';
import 'package:gwenchana/features/vocabulary/presentation/pages/card_titles.dart';
import 'package:gwenchana/features/vocabulary/presentation/pages/vocabulary_page.dart';

class VocabularyBloc extends Bloc<VocabularyEvent, VocabularyState> {
  VocabularyBloc() : super(VocabularyLoading()) {
    on<LoadProgressEvent>(_onLoadProgress);
    on<ChangeLevelEvent>(_onChangeLevel);
    on<ResetProgressEvent>(_onResetProgress);
    on<UpdateProgressEvent>(_onUpdateProgress);
  }

  Future<void> _onLoadProgress(
      LoadProgressEvent event, Emitter<VocabularyState> emit) async {
    emit(VocabularyLoading());
    final selectedLevel = await ProgressService.getSelectedLevel();
    final progress = await ProgressService.getAllProgress(selectedLevel);
    final completed = await ProgressService.getAllCompleted(selectedLevel);
    final cards = List.generate(
      18,
      (i) => VocabularyCardData(
        title: 'Card ${i + 1}',
        mainTitle:
            _getCardTitle(selectedLevel, i), // название карт (далее корейский)
        progress: progress[i],
        total: 26, // количество слов в каждой тема (26 карт)
        isCompleted: completed[i],
      ),
    );
    emit(VocabularyLoaded(
      selectedLevel: selectedLevel,
      cards: cards,
    ));
  }

  Future<void> _onChangeLevel(
      ChangeLevelEvent event, Emitter<VocabularyState> emit) async {
    emit(VocabularyLoading());
    await ProgressService.saveSelectedLevel(event.level);
    add(LoadProgressEvent());
  }

  Future<void> _onResetProgress(
      ResetProgressEvent event, Emitter<VocabularyState> emit) async {
    emit(VocabularyLoading());
    await ProgressService.resetAllProgress(event.level);
    add(LoadProgressEvent());
  }

  Future<void> _onUpdateProgress(
      UpdateProgressEvent event, Emitter<VocabularyState> emit) async {
    add(LoadProgressEvent());
  }

  String _getCardTitle(int level, int index) {
    switch (level) {
      case 2:
        return cardTitlesLevel2[index];
      case 3:
        return cardTitlesLevel3[index];
      case 4:
        return cardTitlesLevel4[index];
      case 5:
        return cardTitlesLevel5[index];
      default:
        return cardTitlesLevel1[index];
    }
  }
}
