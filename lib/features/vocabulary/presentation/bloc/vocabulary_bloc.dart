import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:gwenchana/core/services/progress_service.dart';
import 'package:gwenchana/features/vocabulary/presentation/bloc/vocabulary_event.dart';
import 'package:gwenchana/features/vocabulary/presentation/bloc/vocabulary_state.dart';
import 'package:gwenchana/features/vocabulary/presentation/widgets/card_titles.dart';
import 'package:gwenchana/features/vocabulary/presentation/pages/vocabulary_page.dart';
import 'package:gwenchana/features/vocabulary/presentation/widgets/word_card_model.dart';
import 'package:hive/hive.dart';

class VocabularyBloc extends Bloc<VocabularyEvent, VocabularyState> {
  VocabularyBloc() : super(VocabularyLoading()) {
    on<LoadProgressEvent>(_onLoadProgress);
    on<ChangeLevelEvent>(_onChangeLevel);
    on<ResetProgressEvent>(_onResetProgress);
    on<UpdateProgressEvent>(_onUpdateProgress);
    on<LoadCardsEvent>(_onLoadCards);
    on<AddCardEvent>(_onAddCard);
    on<AddToFavoritesEvent>(_onAddToFavorites);
    on<LoadFavoritesEvent>(_onLoadFavorites);
    on<RemoveFromFavoritesEvent>(_onRemoveFromFavorites);
  }

  Future<void> _onRemoveFromFavorites(
      RemoveFromFavoritesEvent event, Emitter<VocabularyState> emit) async {
    try {
      final favBox = await Hive.openBox('favorites');
      final favorites = favBox.values.toList();
      final index = favorites.indexWhere((e) =>
          e['korean'] == event.card.korean &&
          e['translation'] == event.card.translation);
      if (index != -1) {
        await favBox.deleteAt(index);
      }
      final updatedFavorites = await getFavorites();
      emit(FavoritesLoaded(updatedFavorites));
    } catch (e) {
      emit(VocabularyError('Ошибка удаления из избранного'));
    }
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

  // favorites and myCards bloc

  Future<void> _onLoadCards(
      LoadCardsEvent event, Emitter<VocabularyState> emit) async {
    emit(VocabularyLoading());
    try {
      final cards = await getAllCards();
      emit(CardsLoaded(cards));
    } catch (e) {
      emit(VocabularyError('Ошибка загрузки карточек'));
    }
  }

  Future<void> _onAddCard(
      AddCardEvent event, Emitter<VocabularyState> emit) async {
    emit(VocabularyLoading());
    try {
      final box = await Hive.openBox<MyCard>('my_cards');
      await box.add(event.card);
      final cards = await getAllCards();
      emit(CardsLoaded(cards));
    } catch (e) {
      emit(VocabularyError('Ошибка добавления карточки'));
    }
  }

  Future<void> _onAddToFavorites(
      AddToFavoritesEvent event, Emitter<VocabularyState> emit) async {
    try {
      await addToFavorites(event.card);
      final favorites = await getFavorites();
      emit(FavoritesLoaded(favorites));
    } catch (e) {
      emit(VocabularyError('Ошибка добавления в избранное'));
    }
  }

  Future<void> _onLoadFavorites(
      LoadFavoritesEvent event, Emitter<VocabularyState> emit) async {
    emit(VocabularyLoading());
    try {
      final favorites = await getFavorites();
      emit(FavoritesLoaded(favorites));
    } catch (e) {
      emit(VocabularyError('Ошибка загрузки избранного'));
    }
  }
}
