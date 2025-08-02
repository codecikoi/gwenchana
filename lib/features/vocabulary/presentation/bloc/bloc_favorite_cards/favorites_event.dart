import 'package:equatable/equatable.dart';
import 'package:gwenchana/features/vocabulary/presentation/widgets/word_card_model.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object?> get props => [];
}

class LoadFavoritesEvent extends FavoritesEvent {}

class AddToFavoritesEvent extends FavoritesEvent {
  final MyCard card;
  const AddToFavoritesEvent(this.card);
  @override
  List<Object?> get props => [card];
}

class RemoveFromFavoritesEvent extends FavoritesEvent {
  final MyCard card;
  const RemoveFromFavoritesEvent(this.card);
  @override
  List<Object?> get props => [card];
}
