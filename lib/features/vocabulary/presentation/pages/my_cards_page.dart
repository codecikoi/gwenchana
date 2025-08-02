import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gwenchana/core/helper/app_colors.dart';
import 'package:gwenchana/features/vocabulary/presentation/bloc/bloc_add_cards/add_cards_bloc.dart';
import 'package:gwenchana/features/vocabulary/presentation/bloc/bloc_add_cards/add_cards_event.dart'
    as add_cards;
import 'package:gwenchana/features/vocabulary/presentation/bloc/bloc_add_cards/add_cards_state.dart'
    as add_cards;
import 'package:gwenchana/features/vocabulary/presentation/bloc/bloc_favorite_cards/favorites_bloc.dart';
import 'package:gwenchana/features/vocabulary/presentation/bloc/bloc_favorite_cards/favorites_event.dart'
    as favs;
import 'package:gwenchana/features/vocabulary/presentation/bloc/bloc_favorite_cards/favorites_state.dart'
    as favs;
import 'package:gwenchana/features/vocabulary/presentation/widgets/add_card_dialog.dart';
import 'package:gwenchana/features/vocabulary/presentation/widgets/word_card_model.dart';
import 'package:gwenchana/l10n/gen_l10n/app_localizations.dart';

@RoutePage()
class MyCardsPage extends StatefulWidget {
  const MyCardsPage({super.key});

  @override
  State<MyCardsPage> createState() => _MyCardsPageState();
}

class _MyCardsPageState extends State<MyCardsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);

    context.read<AddCardsBloc>().add(add_cards.LoadMyCardsEvent());
    context.read<FavoritesBloc>().add(favs.LoadFavoritesEvent());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void flipCard() {
    final bloc = context.read<AddCardsBloc>();
    final state = bloc.state;
    if (state is add_cards.MyCardsLoadedState) {
      if (state.showTranslation) {
        _controller.reverse();
      } else {
        _controller.forward();
      }
      bloc.add(add_cards.FlipCardEvent());
    }
  }

  void showAddCardDialog() {
    showDialog(
      context: context,
      builder: (context) => AddCardDialog(
        addCardsBloc: context.read<AddCardsBloc>(),
      ),
    ).then((_) {
      if (mounted) {
        context.read<AddCardsBloc>().add(add_cards.LoadMyCardsEvent());
      }
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

        // TODO: swipe to right add to fav ?

        return Dismissible(
          key: Key('${card.korean}_${card.translation}_$index'),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            context.read<AddCardsBloc>().add(add_cards.DeleteCardEvent(card));
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

  Widget _buildCardView(
    List<MyCard> cards,
    int currentIndex,
    bool showTranslation,
    List<MyCard> favorites,
  ) {
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
                      color: AppColors.secondaryColor,
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
                onPressed: currentIndex > 0
                    ? () => context
                        .read<AddCardsBloc>()
                        .add(add_cards.PreviousCardEvent())
                    : null,
                icon: Icon(Icons.arrow_back),
                iconSize: 40,
              ),
              BlocBuilder<FavoritesBloc, favs.FavoritesState>(
                  builder: (context, favoritesState) {
                final isFavorite = favoritesState is favs.FavoritesLoadedState
                    ? favoritesState.favorites.contains(card)
                    : false;
                return IconButton(
                  onPressed: () {
                    if (isFavorite) {
                      context
                          .read<FavoritesBloc>()
                          .add(favs.RemoveFromFavoritesEvent(card));
                    } else {
                      context
                          .read<FavoritesBloc>()
                          .add(favs.AddToFavoritesEvent(card));
                    }
                  },
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                  ),
                  color: isFavorite ? Colors.red : null,
                  iconSize: 32,
                );
              }),
              IconButton(
                onPressed: currentIndex < cards.length - 1
                    ? () => context
                        .read<AddCardsBloc>()
                        .add(add_cards.NextCardEvent())
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
    return BlocBuilder<AddCardsBloc, add_cards.AddCardsState>(
      builder: (context, addCardsState) {
        return BlocBuilder<FavoritesBloc, favs.FavoritesState>(
          builder: (context, favoritesState) {
            if (addCardsState is add_cards.AddCardsLoadingState) {
              return Scaffold(
                appBar: AppBar(
                  title: Text(AppLocalizations.of(context)!.myCards),
                ),
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            // Show empty state
            if (addCardsState is add_cards.MyCardsEmptyState) {
              return Scaffold(
                appBar: AppBar(
                  title: Text(AppLocalizations.of(context)!.myCards),
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
                          backgroundColor: AppColors.mainColor,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (addCardsState is add_cards.AddCardsErrorState) {
              return Scaffold(
                body: Center(
                  child: Text(addCardsState.message),
                ),
              );
            }

            if (addCardsState is add_cards.MyCardsLoadedState) {
              final favorites = favoritesState is favs.FavoritesLoadedState
                  ? favoritesState.favorites
                  : <MyCard>[];

              // Show cards content
              return Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                    onPressed: () => context.router.pop(),
                    icon: Icon(Icons.arrow_back),
                  ),
                  title: Text(
                    AppLocalizations.of(context)!.myCards,
                  ),
                  centerTitle: true,
                  actions: [
                    IconButton(
                      icon: Icon(
                        addCardsState.viewMode == add_cards.ViewMode.cards
                            ? Icons.list
                            : Icons.style,
                      ),
                      onPressed: () => context
                          .read<AddCardsBloc>()
                          .add(add_cards.ToggleViewModeEvent()),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: showAddCardDialog,
                    ),
                  ],
                ),
                body: addCardsState.viewMode == add_cards.ViewMode.cards
                    ? _buildCardView(
                        addCardsState.cards,
                        addCardsState.currentIndex,
                        addCardsState.showTranslation,
                        favorites,
                      )
                    : _buildListView(addCardsState.cards),
              );
            }
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        );
      },
    );
  }
}
