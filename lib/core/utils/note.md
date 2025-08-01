// this folder for theme/colors/collections/picture 


import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gwenchana/core/helper/app_colors.dart';
import 'package:gwenchana/features/vocabulary/presentation/bloc/bloc_add_cards/add_cards_bloc.dart';
import 'package:gwenchana/features/vocabulary/presentation/bloc/bloc_add_cards/add_cards_event.dart';
import 'package:gwenchana/features/vocabulary/presentation/bloc/bloc_add_cards/add_cards_state.dart';
import 'package:gwenchana/features/vocabulary/presentation/bloc/bloc_vocabulary/vocabulary_bloc.dart';
import 'package:gwenchana/features/vocabulary/presentation/widgets/add_card_dialog.dart';
import 'package:gwenchana/features/vocabulary/presentation/widgets/word_card_model.dart';
import 'package:gwenchana/l10n/gen_l10n/app_localizations.dart';

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

  // List<MyCard> myCards = [];
  // List<MyCard> favorites = [];

  // bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    // loadCardsDirectly();
    // loadFavorites();
    context.read<AddCardsBloc>().add(LoadMyCardsEvent());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Future<void> loadFavorites() async {
  //   try {
  //     final loadedFavorites = await HiveStorageService.getFavorites();
  //     setState(() {
  //       favorites = loadedFavorites;
  //     });
  //   } catch (e) {
  //     print('error loading');
  //   }
  // }

  // Future<void> loadCardsDirectly() async {
  //   try {
  //     final loadedCards = await HiveStorageService.getAllCards();
  //     setState(() {
  //       myCards = loadedCards;
  //       isLoading = false;
  //     });
  //   } catch (e) {
  //     print('error loading card $e');
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

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
        (c) => c.korean == card.korean && c.translation == card.translation,
      );
      if (index != -1) {
        await HiveStorageService.deleteCard(index);
      }

      context.read<AddCardsBloc>().add(LoadMyCardsEvent());
         
           // setState(() {
        
      //   myCards.removeWhere(
      //     (c) => c.korean == card.korean && c.translation == card.translation,
      //   );
      //   if (currentViewMode == ViewMode.cards && myCards.isNotEmpty) {
      //     if (currentIndex >= myCards.length) {
      //       currentIndex = myCards.length - 1;
      //     }
      //     showTranslation = false;
      //     _controller.reset();
      //   }
      // });


      setState(() {
        if (currentViewMode == ViewMode.cards) {
          if (currentIndex >= allCards.length - 1) {
            currentIndex = (allCards.length - 2).clamp(0, allCards.length - 1);
          }
          showTranslation = false;
          _controller.reset();
        }
      });
    } catch (e) {
      print('Error deleting card $e');
    }
  }

  // Future<void> addCardBack(MyCard card) async {
  //   try {
  //     await HiveStorageService.addCard(card);
  //     setState(() {
  //       myCards.add(card);
  //     });
  //   } catch (e) {
  //     print('error adding card back $e');
  //   }
  // }

  // Future<void> toggleFavorites(MyCard card) async {
  //   if (favorites.contains(card)) {
  //     await HiveStorageService.removeFromFavorites(card);
  //     setState(() {
  //       favorites.remove(card);
  //     });
  //   } else {
  //     await HiveStorageService.addToFavorites(card);
  //     setState(() {
  //       favorites.add(card);
  //     });
  //   }
  // }

  // void toggleViewMode() {
  //   setState(() {
  //     currentViewMode =
  //         currentViewMode == ViewMode.cards ? ViewMode.list : ViewMode.cards;
  //   });
  // }

  // void showAddCardDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AddCardDialog(
  //       bloc: context.read<VocabularyBloc>(),
  //     ),
  //   ).then((_) {
  //     loadCardsDirectly();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
      return BlocBuilder<AddCardsBloc, AddCardsState>(
        builder: (context, state) {
          if(state is AddCardsLoadingState) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                AppLocalizations.of(context)!.myCards
              ),
            ),
            body: Center(
              child: CircularProgressIndicator()
            ),
          );
        }
        
      
    if (state is AddCardsErrorState) {
      return  Scaffold(
            appBar: AppBar(
              title: Text(
                AppLocalizations.of(context)!.myCards
              ),
            ),
            body: Center(
              child: Text(state.message)
            ),
          );
    }

    if (state is MyCardsLoadedState) {
      final myCards = state.cards;
      
    if(myCards.isEmpty) {

      return Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.myCards
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () => showDialog(
                context: context, 
                builder: (context) => AddCardDialog(
                  addCardsBloc: context.read<AddCardsBloc>(),
                  ),
                  ),
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
               onPressed: () => showDialog(
                context: context, 
                builder: (context) => AddCardDialog(
                  addCardsBloc: context.read<AddCardsBloc>(),
                  ),
                  ),
                icon: Icon(
                  Icons.add,
                  size: 20,
                ),
                label: Text(AppLocalizations.of(context)!.addCard),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mainColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }


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
              currentViewMode == ViewMode.list ? Icons.view_module : Icons.view_list,
              // currentViewMode == ViewMode.cards ? Icons.list : Icons.style,
            ),
            onPressed: () {
              setState(() {
                currentViewMode = currentViewMode == ViewMode.list ? ViewMode.cards : ViewMode.list;
                currentIndex = 0;
                showTranslation = false;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () = > showDialog(
 context: context,
                    builder: (context) => AddCardDialog(
                      addCardsBloc: context.read<AddCardsBloc>(),
                    ),
            ),
          ),
        ],
      ),
      body: currentViewMode == ViewMode.list ? _buildListView(myCards) : _builCardView(myCards),
      // body: currentViewMode == ViewMode.cards
      //     ? _buildCardView(myCards)
      //     : _buildListView(myCards),
    );
  }
  return Scaffold(
      appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.myCards),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
          body: Center(
            child: CircularProgressIndicator(),
          ),
  );
  },
  );
    }

  Widget _buildListView(List<MyCard> myCards) {
    return ListView.separated(
      itemCount: myCards.length,
      padding: const EdgeInsets.all(16.0),
      separatorBuilder: (context, index) => Divider(
        color: Colors.grey.shade300,
        thickness: 1,
        height: 1,
      ),
      itemBuilder: (context, index) {
        final card = myCards[index];

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

  Widget _buildCardView(List<MyCard> myCards) {
    
    if (currentIndex >= myCards.length) {
      currentIndex = myCards.length - 1;
    }
    final currentCard = myCards[currentIndex];
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
                onPressed: () => toggleFavorites(card),
                icon: Icon(
                  favorites.contains(card)
                      ? Icons.favorite
                      : Icons.favorite_border,
                ),
                color: favorites.contains(card) ? Colors.red : null,
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
  }
