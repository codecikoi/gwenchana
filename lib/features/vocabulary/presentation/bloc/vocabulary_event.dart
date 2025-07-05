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

class LoadCardsEvent extends VocabularyEvent {}

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
