import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gwenchana/core/di/locator.dart';
import 'package:gwenchana/core/domain/models/level.dart';
import 'package:gwenchana/core/domain/repository/book_repository.dart';
import 'package:gwenchana/features/vocabulary/presentation/bloc_vocabulary/vocabulary_bloc.dart';
import 'package:gwenchana/features/vocabulary/presentation/bloc_vocabulary/vocabulary_event.dart';
import 'package:gwenchana/features/vocabulary/presentation/bloc_vocabulary/vocabulary_state.dart';
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
      context.read<VocabularyBloc>().add(LoadCardDataEvent(
            setIndex: widget.setIndex,
            selectedLevel: widget.selectedLevel,
            wordCards: wordCards,
          ));
    }
  }

  void nextCard() {
    context.read<VocabularyBloc>().add(NextCardEvent(
          setIndex: widget.setIndex,
          selectedLevel: widget.selectedLevel,
        ));
  }

  void prevCard() {
    context.read<VocabularyBloc>().add(PreviousCardEvent());
  }

  void flipCard() {
    final currentState = context.read<VocabularyBloc>().state;
    if (currentState is CardDataLoadedState) {
      if (currentState.showEnglish) {
        _controller.reverse();
      } else {
        _controller.forward();
      }
      context.read<VocabularyBloc>().add(FlipCardEvent());
    }
  }

  String getCardtitle(int index) {
    final levelEnum = _intToLevel(widget.selectedLevel);
    final lessonTitles = _bookRepository.getLessonTitlesForLevel(levelEnum);
    if (index >= lessonTitles.length) return '';
    return lessonTitles[index];
  }

  Future<bool> addToFavorites(MyCard card) async {
    try {
      context.read<VocabularyBloc>().add(AddToFavoritesEvent(card));
      return true;
    } catch (e) {
      print('error adding $e');
      return false;
    }
  }

  Future<bool> removeFromFavorites(MyCard card) async {
    try {
      context.read<VocabularyBloc>().add(RemoveFromFavoritesEvent(card));
      return true;
    } catch (e) {
      print('error removing $e');
      return false;
    }
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
    return BlocBuilder<VocabularyBloc, VocabularyState>(
      builder: (context, state) {
        if (state is VocabularyLoadingState) {
          return Scaffold(
            appBar: AppBar(title: Text('Loading')),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is VocabularyErrorState) {
          return Scaffold(
            appBar: AppBar(title: Text('Error')),
            body: Center(child: Text(state.message)),
          );
        }

        if (state is CardDataLoadedState) {
          if (state.wordCards.isEmpty) {
            return Scaffold(
              appBar: AppBar(title: Text('no data')),
              body: Center(child: Text('not found cards for this set')),
            );
          }

          final card = state.wordCards[state.currentIndex];

          return Scaffold(
            appBar: AppBar(
              title: Text(state.setTitle),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              actions: [
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () {
                    context.read<VocabularyBloc>().add(ResetCardProgressEvent(
                          setIndex: widget.setIndex,
                          selectedLevel: widget.selectedLevel,
                        ));
                    _controller.reset();
                  },
                ),
              ],
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
                  child: Text(
                    '${state.currentIndex + 1} / ${state.wordCards.length}',
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
                                        ? (card['english'] ?? 'No translation')
                                        : (card['korean'] ?? 'No word'),
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
                        icon: Icon(Icons.arrow_back),
                        onPressed: state.currentIndex > 0 ? prevCard : null,
                      ),
                      Builder(
                        builder: (context) {
                          final myCard = MyCard(
                            korean: card['korean'] ?? 'No word',
                            translation: card['english'] ?? 'No translation',
                          );
                          final isFavorite = state.favorites.any(
                            (fav) =>
                                fav.korean == myCard.korean &&
                                fav.translation == myCard.translation,
                          );
                          return IconButton(
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite ? Colors.red : null,
                            ),
                            onPressed: () => isFavorite
                                ? removeFromFavorites(myCard)
                                : addToFavorites(myCard),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_forward),
                        onPressed:
                            state.currentIndex < state.wordCards.length - 1
                                ? nextCard
                                : null,
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
          body: Center(child: Text('unknow state ${state.runtimeType}')),
        );
      },
    );
  }
}
