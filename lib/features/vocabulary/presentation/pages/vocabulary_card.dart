import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gwenchana/core/services/progress_service.dart';
import 'package:gwenchana/features/vocabulary/data/vocabulary_five_data.dart';
import 'package:gwenchana/features/vocabulary/data/vocabulary_four_data.dart';
import 'package:gwenchana/features/vocabulary/data/vocabulary_one_data.dart';
import 'package:gwenchana/features/vocabulary/data/vocabulary_three_data.dart';
import 'package:gwenchana/features/vocabulary/data/vocabulary_two_data.dart';
import 'package:gwenchana/features/vocabulary/presentation/bloc/vocabulary_bloc.dart';
import 'package:gwenchana/features/vocabulary/presentation/bloc/vocabulary_event.dart';
import 'package:gwenchana/features/vocabulary/presentation/bloc/vocabulary_state.dart';
import 'package:gwenchana/features/vocabulary/presentation/widgets/card_titles.dart';
import 'package:gwenchana/features/vocabulary/presentation/widgets/word_card_model.dart';

class VocabularyWordCard {
  final String korean;
  final String english;

  VocabularyWordCard({
    required this.korean,
    required this.english,
  });
}

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
  late List<dynamic> wordCards;
  int currentIndex = 0;
  bool showEnglish = false;
  late AnimationController _controller;
  late Animation<double> _animation;
  int currentProgress = 0;

  @override
  void initState() {
    super.initState();
    updateCardData();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 400,
      ),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    loadProgress();
  }

  void updateCardData() {
    switch (widget.selectedLevel) {
      case 2:
        wordCards = allTwoDataSets[widget.setIndex];
        break;
      case 3:
        wordCards = allThreeDataSets[widget.setIndex];
        break;
      case 4:
        wordCards = allFourDataSets[widget.setIndex];
        break;
      case 5:
        wordCards = allFiveDataSets[widget.setIndex];
      default:
        wordCards = _getLevelOneSet(widget.setIndex);
        break;
    }
  }

  @override
  void didUpdateWidget(VocabularyCardPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedLevel != widget.selectedLevel) {
      updateCardData();
      loadProgress();
      setState(() {
        showEnglish = false;
        _controller.reset();
      });
    }
  }

  List<dynamic> _getLevelOneSet(int setIndex) {
    final allSets = [
      familyCards,
      foodCards,
      colorsCards,
      numbersCards,
      bodyCards,
      weatherCards,
      transportCards,
      homeCards,
      clothingCards,
      animalCards,
      schoolCards,
      workCards,
      sportsCards,
      technologyCards,
      travelCards,
      healthCards,
      emotionsCards,
      activitiesCards,
    ];
    return allSets[setIndex];
  }

  Future<void> loadProgress() async {
    currentProgress = await ProgressService.getProgress(
      widget.setIndex,
      widget.selectedLevel,
    );
    currentIndex = (currentProgress - 1).clamp(
      0,
      wordCards.length - 1,
    );
    setState(() {});
  }

  Future<void> updateProgress() async {
    final newProgress = currentIndex + 1;
    if (newProgress > currentProgress) {
      currentProgress = newProgress;
      await ProgressService.saveProgress(
        widget.setIndex,
        currentProgress,
        widget.selectedLevel,
      );
      if (!mounted) return;
      context.read<VocabularyBloc>().add(UpdateProgressEvent());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void nextCard() {
    if (currentIndex < wordCards.length - 1) {
      setState(() {
        currentIndex++;
        showEnglish = false;
        _controller.reset();
      });
      updateProgress();
    }
  }

  void prevCard() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        showEnglish = false;
        _controller.reset();
      });
      if (currentIndex + 1 > currentProgress) {
        updateProgress();
      }
    }
  }

  void flipCard() {
    if (showEnglish) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    setState(() {
      showEnglish = !showEnglish;
    });
    updateProgress();
  }

  String getCardtitle(int index) {
    switch (widget.selectedLevel) {
      case 2:
        return cardTitlesLevel2[index];
      case 3:
        return cardTitlesLevel3[index];
      case 4:
        return cardTitlesLevel4[index];
      case 5:
        return cardTitlesLevel5[index];
      default:
        return cardTitlesLevel1[index];
    }
  }

  @override
  Widget build(BuildContext context) {
    if (wordCards.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('no data')),
        body: Center(
          child: Text('not found cards for this set'),
        ),
      );
    }

    final card = wordCards[currentIndex];
    final setTitle = getCardtitle(widget.setIndex);

    return Scaffold(
      appBar: AppBar(
        title: Text(setTitle),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () async {
              await ProgressService.resetProgress(
                widget.setIndex,
                widget.selectedLevel,
              );
              await loadProgress();
              if (!mounted) return;
              context.read<VocabularyBloc>().add(UpdateProgressEvent());
              setState(() {
                showEnglish = false;
                _controller.reset();
              });
            },
            tooltip: 'reset progress',
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
              '${currentIndex + 1} / ${wordCards.length}',
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
                              isBack ? card.english : card.korean,
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
                  onPressed: currentIndex > 0
                      ? prevCard
                      : null, // норм что нулл или сделать кнопку не кликабельной?
                ),
                BlocBuilder<VocabularyBloc, VocabularyState>(
                  builder: (context, state) {
                    List<MyCard> favorites = [];
                    if (state is FavoritesLoaded) {
                      favorites = state.favorites;
                    }

                    final card = wordCards[currentIndex];
                    final myCard = MyCard(
                      korean: card.korean,
                      translation: card.english,
                    );
                    final isFavorite = favorites.any(
                      (fav) =>
                          fav.korean == myCard.korean &&
                          fav.translation == myCard.translation,
                    );
                    return IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : null,
                      ),
                      onPressed: isFavorite
                          ? null
                          : () {
                              context
                                  .read<VocabularyBloc>()
                                  .add(AddToFavoritesEvent(myCard));
                              context
                                  .read<VocabularyBloc>()
                                  .add(LoadFavoritesEvent());
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Added to favorites')),
                              );
                            },
                      tooltip: isFavorite
                          ? 'Already in favorites'
                          : 'Add to favorites',
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: currentIndex < wordCards.length - 1
                      ? nextCard
                      : null, // норм что нулл или сделать кнопку не кликабельной?
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
