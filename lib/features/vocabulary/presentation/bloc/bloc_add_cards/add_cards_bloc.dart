import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gwenchana/features/vocabulary/presentation/bloc/bloc_add_cards/add_cards_event.dart';
import 'package:gwenchana/features/vocabulary/presentation/bloc/bloc_add_cards/add_cards_state.dart';
import 'package:gwenchana/features/vocabulary/presentation/widgets/word_card_model.dart';

class AddCardsBloc extends Bloc<AddCardsEvent, AddCardsState> {
  AddCardsBloc() : super(AddCardsLoadingState()) {
    on<LoadMyCardsEvent>(_onGetMyCard);
    on<AddNewCardEvent>(_onAddCard);
    on<DeleteCardEvent>(_onDeleteCard);
    on<ToggleViewModeEvent>(_onToggleViewMode);
    on<NextCardEvent>(_onNextCard);
    on<PreviousCardEvent>(_onPreviousCard);
    on<FlipCardEvent>(_onFlipCard);
  }

  Future<void> _onGetMyCard(
    LoadMyCardsEvent event,
    Emitter<AddCardsState> emit,
  ) async {
    emit(AddCardsLoadingState());
    try {
      final cards = await HiveStorageService.getAllCards();
      if (cards.isEmpty) {
        emit(MyCardsEmptyState());
      } else {
        emit(MyCardsLoadedState(cards: cards));
      }
    } catch (e) {
      emit(AddCardsErrorState('error loading mycards $e'));
    }
  }

  Future<void> _onAddCard(
    AddNewCardEvent event,
    Emitter<AddCardsState> emit,
  ) async {
    try {
      await HiveStorageService.addCard(event.card);
      add(LoadMyCardsEvent());
    } catch (e) {
      emit(AddCardsErrorState('error adding card $e'));
    }
  }

  Future<void> _onDeleteCard(
    DeleteCardEvent event,
    Emitter<AddCardsState> emit,
  ) async {
    try {
      final allCards = await HiveStorageService.getAllCards();
      final index = allCards.indexWhere(
        (c) =>
            c.korean == event.card.korean &&
            c.translation == event.card.translation,
      );
      if (index != -1) {
        await HiveStorageService.deleteCard(index);
      }
      add(LoadMyCardsEvent());
    } catch (e) {
      emit(AddCardsErrorState('error deleting card $e'));
    }
  }

  Future<void> _onToggleViewMode(
    ToggleViewModeEvent event,
    Emitter<AddCardsState> emit,
  ) async {
    final currentState = state;
    if (currentState is MyCardsLoadedState) {
      final newViewMode = currentState.viewMode == ViewMode.cards
          ? ViewMode.list
          : ViewMode.cards;
      emit(MyCardsLoadedState(
        cards: currentState.cards,
        currentIndex: currentState.currentIndex,
        showTranslation: false,
        viewMode: newViewMode,
      ));
    }
  }

  Future<void> _onNextCard(
    NextCardEvent event,
    Emitter<AddCardsState> emit,
  ) async {
    final currentState = state;
    if (currentState is MyCardsLoadedState) {
      if (currentState.currentIndex < currentState.cards.length - 1) {
        emit(MyCardsLoadedState(
          cards: currentState.cards,
          currentIndex: currentState.currentIndex + 1,
          showTranslation: false,
          viewMode: currentState.viewMode,
        ));
      }
    }
  }

  Future<void> _onPreviousCard(
    PreviousCardEvent event,
    Emitter<AddCardsState> emit,
  ) async {
    final currentState = state;
    if (currentState is MyCardsLoadedState) {
      if (currentState.currentIndex > 0) {
        emit(MyCardsLoadedState(
          cards: currentState.cards,
          currentIndex: currentState.currentIndex - 1,
          showTranslation: false,
          viewMode: currentState.viewMode,
        ));
      }
    }
  }

  Future<void> _onFlipCard(
    FlipCardEvent event,
    Emitter<AddCardsState> emit,
  ) async {
    final currentState = state;
    if (currentState is MyCardsLoadedState) {
      emit(MyCardsLoadedState(
        cards: currentState.cards,
        currentIndex: currentState.currentIndex,
        showTranslation: !currentState.showTranslation,
        viewMode: currentState.viewMode,
      ));
    }
  }
}
