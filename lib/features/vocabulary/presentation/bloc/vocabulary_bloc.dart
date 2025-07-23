import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:gwenchana/core/services/progress_service.dart';
import 'package:gwenchana/features/vocabulary/data/vocabulary_begginer_one_data.dart';
import 'package:gwenchana/features/vocabulary/data/vocabulary_beginner_two_data.dart';
import 'package:gwenchana/features/vocabulary/data/vocabulary_elementary_data.dart';
import 'package:gwenchana/features/vocabulary/data/vocabulary_intermediate_one.dart';
import 'package:gwenchana/features/vocabulary/data/vocabulary_intermediate_two.dart';
import 'package:gwenchana/features/vocabulary/presentation/bloc/vocabulary_event.dart';
import 'package:gwenchana/features/vocabulary/presentation/bloc/vocabulary_state.dart';
import 'package:gwenchana/features/vocabulary/presentation/widgets/card_titles.dart';
import 'package:gwenchana/features/vocabulary/presentation/pages/vocabulary_page.dart';
import 'package:gwenchana/features/vocabulary/presentation/widgets/word_card_model.dart';

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
      await HiveStorageService.removeFromFavorites(event.card);
      final updateFavorites = await HiveStorageService.getFavorites();
      emit(FavoritesLoaded(updateFavorites));
    } catch (e) {
      emit(VocabularyError('Error deleting from favorites: $e'));
    }
  }

  int _getWordCount(int level, int index) {
    switch (level) {
      case 2:
        return allBeginnerLevelOneDataSets[index].length;
      case 3:
        return allBeginnerLevelTwoDataSets[index].length;
      case 4:
        return allIntermediateLevelOneDataSets[index].length;
      case 5:
        return allIntermediateLevelTwoDataSets[index].length;
      default:
        return allElementaryLevelDataSets[index].length;
    }
  }

  Future<void> _onLoadProgress(
      LoadProgressEvent event, Emitter<VocabularyState> emit) async {
    emit(VocabularyLoading());
    final selectedLevel = await ProgressService.getSelectedLevel();
    final progress = await ProgressService.getAllProgress(selectedLevel);
    final completed = await ProgressService.getAllCompleted(selectedLevel);
    int cardCount;
    switch (selectedLevel) {
      case 4:
        cardCount = cardTitlesIntermediateLevelOne.length;
        break;
      case 5:
        cardCount = cardTitlesIntermediateLevelTwo.length;
        break;
      case 2:
        cardCount = cardTitlesBeginnerLevelOne.length;
        break;
      case 3:
        cardCount = cardTitlesBeginnerLevelTwo.length;
        break;
      default:
        cardCount = cardTitlesElementaryLevel.length;
    }
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
        return cardTitlesBeginnerLevelOne[index];
      case 3:
        return cardTitlesBeginnerLevelTwo[index];
      case 4:
        return cardTitlesIntermediateLevelOne[index];
      case 5:
        return cardTitlesIntermediateLevelTwo[index];
      default:
        return cardTitlesElementaryLevel[index];
    }
  }

  // favorites and myCards bloc

  Future<void> _onLoadCards(
      LoadCardsEvent event, Emitter<VocabularyState> emit) async {
    emit(VocabularyLoading());
    try {
      final cards = await HiveStorageService.getAllCards();
      emit(CardsLoaded(cards));
    } catch (e) {
      emit(VocabularyError('Ошибка загрузки карточек $e'));
    }
  }

  Future<void> _onAddCard(
      AddCardEvent event, Emitter<VocabularyState> emit) async {
    try {
      await HiveStorageService.addCard(event.card);
    } catch (e) {
      emit(VocabularyError('Ошибка добавления карточки $e'));
    }
  }

  Future<void> _onAddToFavorites(
      AddToFavoritesEvent event, Emitter<VocabularyState> emit) async {
    try {
      await HiveStorageService.addToFavorites(event.card);
    } catch (e) {
      emit(VocabularyError('Ошибка добавления в избранное $e'));
    }
  }

  Future<void> _onLoadFavorites(
      LoadFavoritesEvent event, Emitter<VocabularyState> emit) async {
    emit(VocabularyLoading());
    try {
      final favorites = await HiveStorageService.getFavorites();
      emit(FavoritesLoaded(favorites));
    } catch (e) {
      print('Error loading favorites: $e');
      emit(VocabularyError('Ошибка загрузки избранного $e'));
    }
  }
}
