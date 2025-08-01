import 'package:equatable/equatable.dart';
import 'package:gwenchana/features/vocabulary/presentation/widgets/word_card_model.dart';

abstract class VocabularyEvent extends Equatable {
  const VocabularyEvent();

  @override
  List<Object?> get props => [];
}

class LoadProgressEvent extends VocabularyEvent {}

class ChangeLevelEvent extends VocabularyEvent {
  final int level;
  const ChangeLevelEvent(this.level);
  @override
  List<Object?> get props => [level];
}

class ResetProgressEvent extends VocabularyEvent {
  final int level;
  const ResetProgressEvent(this.level);
  @override
  List<Object?> get props => [level];
}

class UpdateProgressEvent extends VocabularyEvent {}

class OpenFavoritesEvent extends VocabularyEvent {}

class OpenMyCardsEvent extends VocabularyEvent {}

class LoadMyCardsEvent extends VocabularyEvent {}

class AddCardEvent extends VocabularyEvent {
  final MyCard card;

  const AddCardEvent(this.card);
  @override
  List<Object?> get props => [card];
}

class AddToFavoritesEvent extends VocabularyEvent {
  final MyCard card;
  const AddToFavoritesEvent(this.card);
  @override
  List<Object?> get props => [card];
}

class LoadFavoritesEvent extends VocabularyEvent {}

class RemoveFromFavoritesEvent extends VocabularyEvent {
  final MyCard card;
  const RemoveFromFavoritesEvent(this.card);
  @override
  List<Object?> get props => [card];
}

class LoadCardDataEvent extends VocabularyEvent {
  final int setIndex;
  final int selectedLevel;
  final List<Map<String, String>> wordCards;

  const LoadCardDataEvent({
    required this.setIndex,
    required this.selectedLevel,
    required this.wordCards,
  });

  @override
  List<Object?> get props => [
        setIndex,
        selectedLevel,
        wordCards,
      ];
}

class NextCardEvent extends VocabularyEvent {
  final int setIndex;
  final int selectedLevel;

  const NextCardEvent({
    required this.setIndex,
    required this.selectedLevel,
  });

  @override
  List<Object?> get props => [
        setIndex,
        selectedLevel,
      ];
}

class PreviousCardEvent extends VocabularyEvent {}

class FlipCardEvent extends VocabularyEvent {}

class UpdateCardProgressEvent extends VocabularyEvent {
  final int setIndex;
  final int selectedLevel;
  final int currentIndex;
  final int totalCards;

  const UpdateCardProgressEvent({
    required this.setIndex,
    required this.selectedLevel,
    required this.currentIndex,
    required this.totalCards,
  });

  @override
  List<Object?> get props => [
        setIndex,
        selectedLevel,
        currentIndex,
        totalCards,
      ];
}

class ResetCardProgressEvent extends VocabularyEvent {
  final int setIndex;
  final int selectedLevel;

  const ResetCardProgressEvent({
    required this.setIndex,
    required this.selectedLevel,
  });

  @override
  List<Object?> get props => [setIndex, selectedLevel];
}
