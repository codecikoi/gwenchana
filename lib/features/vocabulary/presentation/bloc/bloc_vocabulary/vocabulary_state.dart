import 'package:equatable/equatable.dart';
import 'package:gwenchana/features/vocabulary/presentation/pages/vocabulary_page.dart';

abstract class VocabularyState extends Equatable {
  const VocabularyState();
  @override
  List<Object?> get props => [];
}

class VocabularyLoadingState extends VocabularyState {}

class VocabularyLoadedState extends VocabularyState {
  final int selectedLevel;
  final List<VocabularyCardData> cards;

  const VocabularyLoadedState({
    required this.selectedLevel,
    required this.cards,
  });

  @override
  List<Object?> get props => [selectedLevel, cards];
}

class VocabularyErrorState extends VocabularyState {
  final String message;

  const VocabularyErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

// class MyCardsLoadedState extends VocabularyState {
//   final List<MyCard> cards;
//   const MyCardsLoadedState(this.cards);

//   @override
//   List<Object?> get props => [cards];
// }

// class FavoritesLoadedState extends VocabularyState {
//   final List<MyCard> favorites;
//   const FavoritesLoadedState(this.favorites);

//   @override
//   List<Object?> get props => [favorites];
// }

class CardDataLoadedState extends VocabularyState {
  final List<Map<String, String>> wordCards;
  final int currentIndex;
  final bool showTranslation;
  final int currentProgress;
  final String setTitle;
  final int setIndex;
  final int selectedLevel;

  const CardDataLoadedState({
    required this.wordCards,
    required this.currentIndex,
    required this.showTranslation,
    required this.currentProgress,
    required this.setTitle,
    required this.setIndex,
    required this.selectedLevel,
  });

  @override
  List<Object?> get props => [
        wordCards,
        currentIndex,
        showTranslation,
        currentProgress,
        setTitle,
        setIndex,
        selectedLevel,
      ];
}

class CardProgressUpdatedState extends VocabularyState {
  final int currentIndex;
  final int currentProgress;

  const CardProgressUpdatedState({
    required this.currentIndex,
    required this.currentProgress,
  });

  @override
  List<Object?> get props => [currentIndex, currentProgress];
}
