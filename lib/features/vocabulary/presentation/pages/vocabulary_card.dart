import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gwenchana/core/di/locator.dart';
import 'package:gwenchana/core/domain/models/level.dart';
import 'package:gwenchana/core/domain/repository/book_repository.dart';
import 'package:gwenchana/features/vocabulary/presentation/bloc/bloc_favorite_cards/favorites_bloc.dart';
import 'package:gwenchana/features/vocabulary/presentation/bloc/bloc_favorite_cards/favorites_event.dart';
import 'package:gwenchana/features/vocabulary/presentation/bloc/bloc_favorite_cards/favorites_state.dart';
import 'package:gwenchana/features/vocabulary/presentation/bloc/bloc_vocabulary/vocabulary_bloc.dart';
import 'package:gwenchana/features/vocabulary/presentation/bloc/bloc_vocabulary/vocabulary_event.dart'
    as vocab;
import 'package:gwenchana/features/vocabulary/presentation/bloc/bloc_vocabulary/vocabulary_state.dart'
    as vocab;
import 'package:gwenchana/features/vocabulary/presentation/widgets/word_card_model.dart';

@RoutePage()
class VocabularyCardPage extends StatefulWidget {
  final int setIndex;
  final int selectedLevel;

  const VocabularyCardPage({
    super.key,
    @PathParam('setIndex') this.setIndex = 0,
    this.selectedLevel = 1,
  });

  @override
  State<VocabularyCardPage> createState() => _VocabularyCardPageState();
}

class _VocabularyCardPageState extends State<VocabularyCardPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  final BookRepository _bookRepository = locator<BookRepository>();
  final Map<int, MyCard> _cardCache = {};

  MyCard _getCachedCard(
    int index,
    String korean,
    String english,
  ) {
    return _cardCache.putIfAbsent(
        index,
        () => MyCard(
              korean: korean,
              translation: english,
            ));
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _loadCardData();
  }

  @override
  void didUpdateWidget(VocabularyCardPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedLevel != widget.selectedLevel) {
      _loadCardData();
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _loadCardData() {
    final levelEnum = _intToLevel(widget.selectedLevel);
    final lesson = _bookRepository.getLesson(
      level: levelEnum,
      lessonIndex: widget.setIndex,
    );
    if (lesson != null) {
      final wordCards = lesson.words
          .map((word) => {
                'korean': word.korean,
                'english': word.english,
              })
          .toList();
      context.read<VocabularyBloc>().add(vocab.LoadCardDataEvent(
            setIndex: widget.setIndex,
            selectedLevel: widget.selectedLevel,
            wordCards: wordCards,
          ));
    }
  }

  void nextCard() {
    context.read<VocabularyBloc>().add(vocab.NextCardEvent(
          setIndex: widget.setIndex,
          selectedLevel: widget.selectedLevel,
        ));
  }

  void prevCard() {
    context.read<VocabularyBloc>().add(vocab.PreviousCardEvent());
  }

  void flipCard() {
    final bloc = context.read<VocabularyBloc>();
    final state = bloc.state;

    if (state is vocab.CardDataLoadedState) {
      if (state.showTranslation) {
        _controller.reverse();
      } else {
        _controller.forward();
      }
      bloc.add(vocab.FlipCardEvent());
    }
  }

  void resetProgress() {
    context.read<VocabularyBloc>().add(vocab.ResetCardProgressEvent(
        setIndex: widget.setIndex, selectedLevel: widget.selectedLevel));
  }

  void addToFavorites(MyCard card) async {
    context.read<FavoritesBloc>().add(AddToFavoritesEvent(card));
  }

  void removeFromFavorites(MyCard card) async {
    context.read<FavoritesBloc>().add(RemoveFromFavoritesEvent(card));
  }

  Level _intToLevel(int levelIndex) {
    switch (levelIndex) {
      case 1:
        return Level.elementary;
      case 2:
        return Level.beginnerLevelOne;
      case 3:
        return Level.beginnerLevelTwo;
      case 4:
        return Level.intermediateLevelOne;
      case 5:
        return Level.intermediateLevelTwo;
      default:
        throw ArgumentError('Invalid level index: $levelIndex');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VocabularyBloc, vocab.VocabularyState>(
      builder: (context, vocabularyState) {
        if (vocabularyState is vocab.VocabularyLoadingState) {
          return Scaffold(
            appBar: AppBar(title: Text('Loading')),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (vocabularyState is vocab.VocabularyErrorState) {
          return Scaffold(
            appBar: AppBar(title: Text('Error')),
            body: Center(child: Text(vocabularyState.message)),
          );
        }

        if (vocabularyState is vocab.CardDataLoadedState) {
          final currentCard =
              vocabularyState.wordCards[vocabularyState.currentIndex];
          final cachedCard = _getCachedCard(
            vocabularyState.currentIndex,
            currentCard['korean']!,
            currentCard['english']!,
          );

          return Scaffold(
            appBar: AppBar(
              title: Text(vocabularyState.setTitle),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              actions: [
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: resetProgress,
                ),
              ],
            ),
            body: Column(
              children: [
                // TODO: temporary indicator need?
                LinearProgressIndicator(
                  value: (vocabularyState.currentIndex + 1) /
                      vocabularyState.wordCards.length,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
                  child: Text(
                    '${vocabularyState.currentIndex + 1} / ${vocabularyState.wordCards.length}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 18),
                Expanded(
                  child: GestureDetector(
                    onTap: flipCard,
                    child: AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          final isBack = _animation.value > 0.5;
                          return Transform(
                            transform: Matrix4.identity()
                              ..setEntry(3, 2, 0.001)
                              ..rotateY(3.14159 * _animation.value),
                            alignment: Alignment.center,
                            child: Card(
                              margin: EdgeInsets.all(16.0),
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(16.0),
                                child: Transform(
                                  alignment: Alignment.center,
                                  transform: Matrix4.rotationY(
                                    isBack ? 3.14159 : 0.0,
                                  ),
                                  child: Text(
                                    isBack
                                        ? cachedCard.translation
                                        : cachedCard.korean,
                                    style: TextStyle(fontSize: 32.0),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed:
                            vocabularyState.currentIndex > 0 ? prevCard : null,
                        icon: Icon(Icons.arrow_back),
                      ),
                      BlocBuilder<FavoritesBloc, FavoritesState>(
                        builder: (context, favoritesState) {
                          final isFavorite = favoritesState
                                  is FavoritesLoadedState &&
                              favoritesState.favorites.any((fav) =>
                                  fav.korean == cachedCard.korean &&
                                  fav.translation == cachedCard.translation);

                          return IconButton(
                            onPressed: () {
                              if (isFavorite) {
                                removeFromFavorites(cachedCard);
                              } else {
                                addToFavorites(cachedCard);
                              }
                            },
                            // onPressed: () async {
                            //   if (isFavorite) {
                            //     await removeFromFavorites(myCard);
                            //   } else {
                            //     await addToFavorites(myCard);
                            //   }
                            // },
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite ? Colors.red : null,
                            ),
                          );
                        },
                      ),
                      IconButton(
                        onPressed: vocabularyState.currentIndex <
                                vocabularyState.wordCards.length - 1
                            ? nextCard
                            : null,
                        icon: Icon(Icons.arrow_forward),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(title: Text('unknow state')),
          body: Center(child: Text('state ${vocabularyState.runtimeType}')),

          // body: Center(child: Text('unknow state ${state.runtimeType}')),
        );
      },
    );
  }
}
