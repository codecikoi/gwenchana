import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gwenchana/core/helper/app_colors.dart';
import 'package:gwenchana/core/helper/basic_appbutton.dart';
import 'package:gwenchana/features/vocabulary/presentation/bloc/vocabulary_bloc.dart';
import 'package:gwenchana/features/vocabulary/presentation/widgets/add_card_dialog.dart';
import 'package:gwenchana/features/vocabulary/presentation/widgets/word_card_model.dart';
import 'package:gwenchana/gen_l10n/app_localizations.dart';

enum ViewMode { list, cards }

@RoutePage()
class MyCardsPage extends StatefulWidget {
  const MyCardsPage({super.key});

  @override
  State<MyCardsPage> createState() => _MyCardsPageState();
}

class _MyCardsPageState extends State<MyCardsPage>
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  bool showTranslation = false;

  ViewMode currentViewMode = ViewMode.list;
  late AnimationController _controller;
  late Animation<double> _animation;

  List<MyCard> myCards = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    loadCardsDirectly();
  }

  Future<void> loadCardsDirectly() async {
    try {
      final loadedCards = await HiveStorageService.getAllCards();
      setState(() {
        myCards = loadedCards;
        isLoading = false;
      });
    } catch (e) {
      print('error loading card $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void nextCard(int total) {
    if (currentIndex < total - 1) {
      setState(() {
        currentIndex++;
        showTranslation = false;
        _controller.reset();
      });
    }
  }

  void prevCard(int total) {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        showTranslation = false;
        _controller.reset();
      });
    }
  }

  void flipCard() {
    if (showTranslation) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    setState(() {
      showTranslation = !showTranslation;
    });
  }

  Future<void> deleteCard(MyCard card, {String? source}) async {
    try {
      final allCards = await HiveStorageService.getAllCards();
      final index = allCards.indexWhere(
        (c) =>
            c.korean == card.korean &&
            c.translation == card.translation &&
            c.createdAt == card.createdAt,
      );
      if (index != -1) {
        await HiveStorageService.deleteCard(index);
      }
      setState(() {
        myCards.removeWhere(
          (c) =>
              c.korean == card.korean &&
              c.translation == card.translation &&
              c.createdAt == card.createdAt,
        );
        if (currentViewMode == ViewMode.cards && myCards.isNotEmpty) {
          if (currentIndex >= myCards.length) {
            currentIndex = myCards.length - 1;
          }
          showTranslation = false;
          _controller.reset();
        }
      });
    } catch (e) {
      print('Error deleting card $e');
    }
  }

  Future<void> addCardBack(MyCard card) async {
    try {
      await HiveStorageService.addCard(card);
      setState(() {
        myCards.add(card);
      });
    } catch (e) {
      print('error adding card back $e');
    }
  }

  Future<void> addToFavorites(MyCard card) async {
    try {
      await HiveStorageService.addToFavorites(card);
    } catch (e) {
      print('error adding to favorites $e');
    }
  }

  void toggleViewMode() {
    setState(() {
      currentViewMode =
          currentViewMode == ViewMode.cards ? ViewMode.list : ViewMode.cards;
    });
  }

  void showAddCardDialog() {
    showDialog(
      context: context,
      builder: (context) => AddCardDialog(
        bloc: context.read<VocabularyBloc>(),
      ),
    ).then((_) {
      loadCardsDirectly();
    });
  }

  Widget _buildListView(List<MyCard> cards) {
    return ListView.separated(
      itemCount: cards.length,
      padding: const EdgeInsets.all(16.0),
      separatorBuilder: (context, index) => Divider(
        color: Colors.grey.shade300,
        thickness: 1,
        height: 1,
      ),
      itemBuilder: (context, index) {
        final card = cards[index];

        return Dismissible(
          key: Key('${card.korean}_${card.translation}_$index'),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            deleteCard(card, source: 'swipe');
          },
          dismissThresholds: {
            DismissDirection.endToStart: 0.6,
          },
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20.0),
            color: Colors.red,
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 10.0,
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    card.korean,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  flex: 1,
                  child: Text(
                    card.translation,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCardView(List<MyCard> cards) {
    if (currentIndex >= cards.length) {
      currentIndex = cards.length - 1;
    }
    final card = cards[currentIndex];
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        Text(
          '${currentIndex + 1} / ${cards.length}',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
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
                    margin: const EdgeInsets.only(
                      left: 20.0,
                      right: 20.0,
                      top: 20.0,
                      bottom: 150.0,
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(32.0),
                      child: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(
                          isBack ? 3.14159 : 0.0,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              isBack ? card.translation : card.korean,
                              style: TextStyle(
                                fontSize: 42.0,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed:
                    currentIndex > 0 ? () => prevCard(cards.length) : null,
                icon: Icon(Icons.arrow_back),
                iconSize: 40,
              ),
              IconButton(
                onPressed: () => addToFavorites(card),
                icon: Icon(Icons.favorite_border),
                iconSize: 32,
              ),
              IconButton(
                onPressed: currentIndex < cards.length - 1
                    ? () => nextCard(cards.length)
                    : null,
                icon: Icon(Icons.arrow_forward),
                iconSize: 40,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Show loading
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.myCards,
          ),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Show empty state
    if (myCards.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.myCards,
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: showAddCardDialog,
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                ';(',
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: showAddCardDialog,
                icon: Icon(
                  Icons.add,
                  size: 20,
                ),
                label: Text(AppLocalizations.of(context)!.addCard),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.enableButton,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Show cards content
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.router.pop(),
          icon: Icon(
            Icons.arrow_back,
            color: Colors.blue,
          ),
        ),
        title: Text(
          AppLocalizations.of(context)!.myCards,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              currentViewMode == ViewMode.cards ? Icons.list : Icons.style,
            ),
            onPressed: toggleViewMode,
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: showAddCardDialog,
          ),
        ],
      ),
      body: currentViewMode == ViewMode.cards
          ? _buildCardView(myCards)
          : _buildListView(myCards),
    );
  }
}
