import 'package:equatable/equatable.dart';
import 'package:gwenchana/features/vocabulary/presentation/pages/vocabulary_page.dart';
import 'package:gwenchana/features/vocabulary/presentation/widgets/word_card_model.dart';

abstract class VocabularyState extends Equatable {
  const VocabularyState();
  @override
  List<Object?> get props => [];
}

class VocabularyLoading extends VocabularyState {}

class VocabularyLoaded extends VocabularyState {
  final int selectedLevel;
  final List<VocabularyCardData> cards;
  final bool isLoading;

  const VocabularyLoaded({
    required this.selectedLevel,
    required this.cards,
    this.isLoading = false,
  });

  @override
  List<Object?> get props => [selectedLevel, cards, isLoading];
}

class VocabularyError extends VocabularyState {
  final String message;

  const VocabularyError(this.message);

  @override
  List<Object?> get props => [message];
}

class CardsLoaded extends VocabularyState {
  final List<MyCard> cards;
  const CardsLoaded(this.cards);

  @override
  List<Object?> get props => [cards];
}

class FavoritesLoaded extends VocabularyState {
  final List<MyCard> favorites;
  const FavoritesLoaded(this.favorites);

  @override
  List<Object?> get props => [favorites];
}
