import 'package:equatable/equatable.dart';
import 'package:gwenchana/features/vocabulary/presentation/widgets/word_card_model.dart';

enum ViewMode { list, cards }

abstract class AddCardsState extends Equatable {
  const AddCardsState();

  @override
  List<Object?> get props => [];
}

class AddCardsLoadingState extends AddCardsState {}

class MyCardsEmptyState extends AddCardsState {}

class MyCardsLoadedState extends AddCardsState {
  final List<MyCard> cards;
  final int currentIndex;
  final bool showTranslation;
  final ViewMode viewMode;

  const MyCardsLoadedState({
    required this.cards,
    this.currentIndex = 0,
    this.showTranslation = false,
    this.viewMode = ViewMode.list,
  });

  @override
  List<Object?> get props => [
        cards,
        currentIndex,
        showTranslation,
        viewMode,
      ];
}

class AddCardsErrorState extends AddCardsState {
  final String message;
  const AddCardsErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
