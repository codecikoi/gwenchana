import 'package:equatable/equatable.dart';
import 'package:gwenchana/features/vocabulary/presentation/widgets/word_card_model.dart';

abstract class AddCardsEvent extends Equatable {
  const AddCardsEvent();

  @override
  List<Object?> get props => [];
}

class LoadMyCardsEvent extends AddCardsEvent {}

class AddNewCardEvent extends AddCardsEvent {
  final MyCard card;

  const AddNewCardEvent(this.card);
  @override
  List<Object?> get props => [card];
}

class DeleteCardEvent extends AddCardsEvent {
  final MyCard card;
  const DeleteCardEvent(this.card);

  @override
  List<Object?> get props => [card];
}

class ToggleViewModeEvent extends AddCardsEvent {}

class NextCardEvent extends AddCardsEvent {}

class PreviousCardEvent extends AddCardsEvent {}

class FlipCardEvent extends AddCardsEvent {}
