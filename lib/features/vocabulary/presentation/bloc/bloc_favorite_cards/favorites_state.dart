import 'package:equatable/equatable.dart';
import 'package:gwenchana/features/vocabulary/presentation/widgets/word_card_model.dart';

abstract class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object?> get props => [];
}

class FavoritesLoadingState extends FavoritesState {}

class FavoritesLoadedState extends FavoritesState {
  final List<MyCard> favorites;
  const FavoritesLoadedState(this.favorites);

  @override
  List<Object?> get props => [favorites];
}

class FavoritesErrorState extends FavoritesState {
  final String message;

  const FavoritesErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
