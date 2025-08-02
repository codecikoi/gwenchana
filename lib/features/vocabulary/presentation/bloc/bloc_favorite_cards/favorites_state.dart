import 'package:equatable/equatable.dart';
import 'package:gwenchana/features/vocabulary/presentation/widgets/word_card_model.dart';

enum ViewMode { list, cards }

abstract class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object?> get props => [];
}

class FavoritesLoadingState extends FavoritesState {}

class FavoritesEmptyState extends FavoritesState {}

class FavoritesLoadedState extends FavoritesState {
  final List<MyCard> favorites;
  final int currentIndex;
  final bool showTranslation;
  final ViewMode viewMode;

  const FavoritesLoadedState({
    required this.favorites,
    this.currentIndex = 0,
    this.showTranslation = false,
    this.viewMode = ViewMode.list,
  });

  @override
  List<Object?> get props => [
        favorites,
        currentIndex,
        showTranslation,
        viewMode,
      ];
}

class FavoritesErrorState extends FavoritesState {
  final String message;

  const FavoritesErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
