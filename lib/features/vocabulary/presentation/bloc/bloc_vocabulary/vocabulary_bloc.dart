import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:gwenchana/core/di/locator.dart';
import 'package:gwenchana/core/domain/models/level.dart';
import 'package:gwenchana/core/domain/repository/book_repository.dart';
import 'package:gwenchana/core/helper/card_colors.dart';
import 'package:gwenchana/core/services/progress_service.dart';
import 'package:gwenchana/features/vocabulary/presentation/bloc/bloc_vocabulary/vocabulary_event.dart';
import 'package:gwenchana/features/vocabulary/presentation/bloc/bloc_vocabulary/vocabulary_state.dart';
import 'package:gwenchana/features/vocabulary/presentation/pages/vocabulary_page.dart';

class VocabularyBloc extends Bloc<VocabularyEvent, VocabularyState> {
  final BookRepository _bookRepository = locator<BookRepository>();

  VocabularyBloc() : super(VocabularyLoadingState()) {
    on<LoadProgressEvent>(_onLoadProgress);
    on<ChangeLevelEvent>(_onChangeLevel);
    on<ResetProgressEvent>(_onResetProgress);
    on<UpdateProgressEvent>(_onUpdateProgress);
    on<LoadCardDataEvent>(_onLoadCardData);
    on<NextCardEvent>(_onNextCard);
    on<PreviousCardEvent>(_onPreviousCard);
    on<FlipCardEvent>(_onFlipCard);
    on<UpdateCardProgressEvent>(_onUpdateCardProgress);
    on<ResetCardProgressEvent>(_onResetCardProgress);
  }

  Future<void> _onLoadCardData(
    LoadCardDataEvent event,
    Emitter<VocabularyState> emit,
  ) async {
    emit(VocabularyLoadingState());

    try {
      final setTitle = _getCardTitle(
        event.selectedLevel,
        event.setIndex,
      );
      final currentProgress = await ProgressService.getProgress(
        event.setIndex,
        event.selectedLevel,
      );

      final currentIndex =
          (currentProgress - 1).clamp(0, event.wordCards.length - 1);

      final cardColor = cardColors[Random().nextInt(cardColors.length)];

      emit(CardDataLoadedState(
        wordCards: event.wordCards,
        currentIndex: currentIndex,
        showTranslation: false,
        currentProgress: currentProgress,
        setTitle: setTitle,
        setIndex: event.setIndex,
        selectedLevel: event.selectedLevel,
        cardColor: cardColor,
      ));
    } catch (e) {
      emit(VocabularyErrorState('Error loading cards $e'));
    }
  }

  Future<void> _onNextCard(
    NextCardEvent event,
    Emitter<VocabularyState> emit,
  ) async {
    final currenState = state;
    if (currenState is CardDataLoadedState) {
      if (currenState.currentIndex < currenState.wordCards.length - 1) {
        final newIndex = currenState.currentIndex + 1;
        emit(CardDataLoadedState(
          wordCards: currenState.wordCards,
          currentIndex: newIndex,
          showTranslation: false,
          currentProgress: currenState.currentProgress,
          setTitle: currenState.setTitle,
          setIndex: currenState.setIndex,
          selectedLevel: currenState.selectedLevel,
          cardColor: currenState.cardColor,
        ));

        add(UpdateCardProgressEvent(
          setIndex: currenState.setIndex,
          selectedLevel: currenState.selectedLevel,
          currentIndex: newIndex,
          totalCards: currenState.wordCards.length,
        ));
      }
    }
  }

  Future<void> _onPreviousCard(
    PreviousCardEvent event,
    Emitter<VocabularyState> emit,
  ) async {
    final currentState = state;
    if (currentState is CardDataLoadedState) {
      if (currentState.currentIndex > 0) {
        final newIndex = currentState.currentIndex - 1;
        emit(CardDataLoadedState(
          wordCards: currentState.wordCards,
          currentIndex: newIndex,
          showTranslation: false,
          currentProgress: currentState.currentProgress,
          setTitle: currentState.setTitle,
          setIndex: currentState.setIndex,
          selectedLevel: currentState.selectedLevel,
          cardColor: currentState.cardColor,
        ));
        add(UpdateCardProgressEvent(
          setIndex: currentState.setIndex,
          selectedLevel: currentState.selectedLevel,
          currentIndex: newIndex,
          totalCards: currentState.wordCards.length,
        ));
      }
    }
  }

  Future<void> _onFlipCard(
    FlipCardEvent event,
    Emitter<VocabularyState> emit,
  ) async {
    final currentState = state;
    if (currentState is CardDataLoadedState) {
      emit(CardDataLoadedState(
        wordCards: currentState.wordCards,
        currentIndex: currentState.currentIndex,
        showTranslation: !currentState.showTranslation,
        currentProgress: currentState.currentProgress,
        setTitle: currentState.setTitle,
        setIndex: currentState.setIndex,
        selectedLevel: currentState.selectedLevel,
        cardColor: currentState.cardColor,
      ));
    }
  }

  Future<void> _onUpdateCardProgress(
    UpdateCardProgressEvent event,
    Emitter<VocabularyState> emit,
  ) async {
    try {
      final newProgress = event.currentIndex + 1;
      await ProgressService.saveProgress(
        event.setIndex,
        newProgress,
        event.selectedLevel,
        event.totalCards,
      );

      final currentState = state;
      if (currentState is! CardDataLoadedState) {
        add(LoadProgressEvent());
      }
    } catch (e) {
      emit(VocabularyErrorState('error updating progress $e'));
    }
  }

  Future<void> _onResetCardProgress(
    ResetCardProgressEvent event,
    Emitter<VocabularyState> emit,
  ) async {
    try {
      await ProgressService.resetProgress(
        event.setIndex,
        event.selectedLevel,
      );

      final setTitle = _getCardTitle(
        event.selectedLevel,
        event.setIndex,
      );
      final currentProgress = await ProgressService.getProgress(
        event.setIndex,
        event.selectedLevel,
      );
      final levelEnum = Level.values[event.selectedLevel - 1];
      final lesson = _bookRepository.getLesson(
        level: levelEnum,
        lessonIndex: event.setIndex,
      );
      if (lesson != null) {
        final wordCards = lesson.words
            .map((word) => {
                  'korean': word.korean,
                  'english': word.english,
                })
            .toList();
        final currentIndex =
            (currentProgress - 1).clamp(0, wordCards.length - 1);
        final currentState = state;
        if (currentState is CardDataLoadedState) {
          emit(CardDataLoadedState(
            wordCards: wordCards,
            currentIndex: currentIndex,
            showTranslation: false,
            currentProgress: currentProgress,
            setTitle: setTitle,
            setIndex: event.setIndex,
            selectedLevel: event.selectedLevel,
            cardColor: currentState.cardColor,
          ));
        }
      } else {
        emit(VocabularyErrorState('Lesson not found'));
      }
    } catch (e) {
      emit(VocabularyErrorState('error reset progress $e'));
    }
  }

  int _getWordCount(int level, int index) {
    final levelEnum = Level.values[level - 1];
    final lessons = _bookRepository.getAllLessons(level: levelEnum);
    if (lessons == null || lessons.isEmpty || index >= lessons.length) return 0;
    return lessons[index].words.length;
  }

  Future<void> _onLoadProgress(
      LoadProgressEvent event, Emitter<VocabularyState> emit) async {
    emit(VocabularyLoadingState());

    final selectedLevel = await ProgressService.getSelectedLevel();
    final progress = await ProgressService.getAllProgress(selectedLevel);
    final completed = await ProgressService.getAllCompleted(selectedLevel);

    final levelEnum = Level.values[selectedLevel - 1];
    final lessonTitles = _bookRepository.getLessonTitlesForLevel(levelEnum);
    final cardCount = lessonTitles.length;

    final cards = List.generate(
      cardCount,
      (i) => VocabularyCardData(
        title: 'Card  ${i + 1}',
        mainTitle: _getCardTitle(selectedLevel, i),
        progress: progress[i],
        total: _getWordCount(selectedLevel, i),
        isCompleted: completed[i],
      ),
    );
    emit(VocabularyLoadedState(
      selectedLevel: selectedLevel,
      cards: cards,
    ));
  }

  Future<void> _onChangeLevel(
      ChangeLevelEvent event, Emitter<VocabularyState> emit) async {
    emit(VocabularyLoadingState());
    await ProgressService.saveSelectedLevel(event.level);
    add(LoadProgressEvent());
  }

  Future<void> _onResetProgress(
      ResetProgressEvent event, Emitter<VocabularyState> emit) async {
    emit(VocabularyLoadingState());
    await ProgressService.resetAllProgress(event.level);
    add(LoadProgressEvent());
  }

  Future<void> _onUpdateProgress(
      UpdateProgressEvent event, Emitter<VocabularyState> emit) async {
    add(LoadProgressEvent());
  }

  String _getCardTitle(int level, int index) {
    final levelEnum = Level.values[level - 1];
    final lessonTitles = _bookRepository.getLessonTitlesForLevel(levelEnum);
    if (index >= lessonTitles.length) return '';
    return lessonTitles[index];
  }
}
