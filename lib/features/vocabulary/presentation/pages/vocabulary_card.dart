import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gwenchana/core/services/progress_service.dart';
import 'package:gwenchana/core/shared_data/level_intermediate_two_words_data.dart';
import 'package:gwenchana/core/shared_data/level_intermediate_one_words_data.dart';
import 'package:gwenchana/core/shared_data/level_elementary_words_data.dart';
import 'package:gwenchana/core/shared_data/level_beginner_two_words_data.dart';
import 'package:gwenchana/core/shared_data/level_beginner_one_words_data.dart';
import 'package:gwenchana/features/vocabulary/presentation/bloc/vocabulary_bloc.dart';
import 'package:gwenchana/features/vocabulary/presentation/bloc/vocabulary_event.dart';
import 'package:gwenchana/core/shared/lesson_titles.dart';
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
  late List<dynamic> wordCards;
  int currentIndex = 0;
  bool showEnglish = false;
  late AnimationController _controller;
  late Animation<double> _animation;
  int currentProgress = 0;

  List<MyCard> favorites = [];

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
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    try {
      final loadedFavorites = await getFavorites();
      setState(() {
        favorites = loadedFavorites;
      });
    } catch (e) {
      print('error loading favorites $e');
    }
  }

  void updateCardData() {
    switch (widget.selectedLevel) {
      case 2:
        wordCards = allBeginnerLevelOneDataSets[widget.setIndex];
        break;
      case 3:
        wordCards = allBeginnerLevelTwoDataSets[widget.setIndex];
        break;
      case 4:
        wordCards = allIntermediateLevelOneDataSets[widget.setIndex];
        break;
      case 5:
        wordCards = allIntermediateLevelTwoDataSets[widget.setIndex];
        break;
      default:
        wordCards = allElementaryLevelDataSets[widget.setIndex];
        break;
    }
  }

  // void _startWritingPractice(BuildContext context) {
  //   context.router.push(
  //     WritingSkillRoute(
  //       level: widget.selectedLevel,
  //       setIndex: widget.setIndex,
  //     ),
  //   );
  // }

  @override
  void didUpdateWidget(VocabularyCardPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedLevel != widget.selectedLevel) {
      updateCardData();
      loadProgress();
      setState(() {
        currentIndex = 0;
        showEnglish = false;
        _controller.reset();
      });
    }
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
    currentProgress = newProgress;
    await ProgressService.saveProgress(
      widget.setIndex,
      currentProgress,
      widget.selectedLevel,
      wordCards.length,
    );
    if (!mounted) return;
    context.read<VocabularyBloc>().add(UpdateProgressEvent());
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
      updateProgress();
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
        return lessonTitlesBeginnerLevelOne[index];
      case 3:
        return lessonTitlesBeginnerLevelTwo[index];
      case 4:
        return lessonTitlesIntermediateLevelOne[index];
      case 5:
        return lessonTitlesIntermediateLevelTwo[index];
      default:
        return lessonTitlesElementaryLevel[index];
    }
  }

  Future<bool> addToFavoritesLocal(MyCard card) async {
    try {
      if (favorites.any((fav) => fav.korean == card.korean)) {
        return false;
      }
      await addToFavorites(card);
      await loadFavorites();
      return true;
    } catch (e) {
      print('error adding $e');
      return false;
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
                Builder(
                  builder: (context) {
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
                      onPressed:
                          isFavorite ? null : () => addToFavoritesLocal(myCard),
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
          ),
          // ElevatedButton(
          //   onPressed: () => _startWritingPractice(context),
          //   child: Text('practice writing'),
          // ),
        ],
      ),
    );
  }
}
