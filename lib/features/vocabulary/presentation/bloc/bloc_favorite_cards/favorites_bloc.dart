import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gwenchana/features/vocabulary/presentation/bloc/bloc_favorite_cards/favorites_event.dart';
import 'package:gwenchana/features/vocabulary/presentation/bloc/bloc_favorite_cards/favorites_state.dart';
import 'package:gwenchana/features/vocabulary/presentation/widgets/word_card_model.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc() : super(FavoritesLoadingState()) {
    on<LoadFavoritesEvent>(_onLoadFavorites);
    on<AddToFavoritesEvent>(_onAddToFavorites);
    on<RemoveFromFavoritesEvent>(_onRemoveFromFavorites);
    on<ToggleViewModeEvent>(_onToggleViewMode);
    on<NextCardEvent>(_onNextCard);
    on<PreviousCardEvent>(_onPreviousCard);
    on<FlipCardEvent>(_onFlipCard);
  }

  Future<void> _onLoadFavorites(
    LoadFavoritesEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(FavoritesLoadingState());
    try {
      final favorites = await HiveStorageService.getFavorites();
      if (favorites.isEmpty) {
        emit(FavoritesEmptyState());
      } else {
        emit(FavoritesLoadedState(favorites: favorites));
      }
    } catch (e) {
      emit(FavoritesErrorState('error fav loading $e'));
    }
  }

  Future<void> _onAddToFavorites(
    AddToFavoritesEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      await HiveStorageService.addToFavorites(event.card);
      final updatedFavorites = await HiveStorageService.getFavorites();

      emit(FavoritesLoadedState(favorites: updatedFavorites));
    } catch (e) {
      emit(FavoritesErrorState('error adding to fav $e'));
    }
  }

  Future<void> _onRemoveFromFavorites(
    RemoveFromFavoritesEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      await HiveStorageService.removeFromFavorites(event.card);
      final updatedFavorites = await HiveStorageService.getFavorites();
      if (updatedFavorites.isEmpty) {
        emit(FavoritesEmptyState());
      } else {
        emit(FavoritesLoadedState(favorites: updatedFavorites));
      }
    } catch (e) {
      emit(FavoritesErrorState('Error deleting from favorites: $e'));
    }
  }

  Future<void> _onToggleViewMode(
    ToggleViewModeEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    final currentState = state;
    if (currentState is FavoritesLoadedState) {
      final newViewMode = currentState.viewMode == ViewMode.cards
          ? ViewMode.list
          : ViewMode.cards;
      emit(FavoritesLoadedState(
        favorites: currentState.favorites,
        currentIndex: currentState.currentIndex,
        showTranslation: false,
        viewMode: newViewMode,
      ));
    }
  }

  Future<void> _onNextCard(
    NextCardEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    final currentState = state;
    if (currentState is FavoritesLoadedState) {
      if (currentState.currentIndex < currentState.favorites.length - 1) {
        emit(FavoritesLoadedState(
          favorites: currentState.favorites,
          currentIndex: currentState.currentIndex + 1,
          showTranslation: false,
          viewMode: currentState.viewMode,
        ));
      }
    }
  }

  Future<void> _onPreviousCard(
    PreviousCardEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    final currentState = state;
    if (currentState is FavoritesLoadedState) {
      if (currentState.currentIndex > 0) {
        emit(FavoritesLoadedState(
          favorites: currentState.favorites,
          currentIndex: currentState.currentIndex - 1,
          showTranslation: false,
          viewMode: currentState.viewMode,
        ));
      }
    }
  }

  Future<void> _onFlipCard(
    FlipCardEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    final currentState = state;
    if (currentState is FavoritesLoadedState) {
      emit(FavoritesLoadedState(
        favorites: currentState.favorites,
        currentIndex: currentState.currentIndex,
        showTranslation: !currentState.showTranslation,
        viewMode: currentState.viewMode,
      ));
    }
  }
}
