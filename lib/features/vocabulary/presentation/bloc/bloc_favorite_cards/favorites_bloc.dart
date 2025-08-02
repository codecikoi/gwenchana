import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gwenchana/features/vocabulary/presentation/bloc/bloc_favorite_cards/favorites_event.dart';
import 'package:gwenchana/features/vocabulary/presentation/bloc/bloc_favorite_cards/favorites_state.dart';
import 'package:gwenchana/features/vocabulary/presentation/widgets/word_card_model.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc() : super(FavoritesLoadingState()) {
    on<LoadFavoritesEvent>(_onLoadFavorites);
    on<AddToFavoritesEvent>(_onAddToFavorites);
    on<RemoveFromFavoritesEvent>(_onRemoveFromFavorites);
  }

  Future<void> _onLoadFavorites(
    LoadFavoritesEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(FavoritesLoadingState());
    try {
      final favorites = await HiveStorageService.getFavorites();
      emit(FavoritesLoadedState(favorites));
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

      emit(FavoritesLoadedState(updatedFavorites));
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

      emit(FavoritesLoadedState(updatedFavorites));
    } catch (e) {
      emit(FavoritesErrorState('Error deleting from favorites: $e'));
    }
  }
}
