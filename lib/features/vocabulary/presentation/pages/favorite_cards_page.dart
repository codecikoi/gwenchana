import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gwenchana/core/helper/app_colors.dart';
import 'package:gwenchana/features/vocabulary/presentation/bloc/bloc_favorite_cards/favorites_bloc.dart';
import 'package:gwenchana/features/vocabulary/presentation/bloc/bloc_favorite_cards/favorites_event.dart';
import 'package:gwenchana/features/vocabulary/presentation/bloc/bloc_favorite_cards/favorites_state.dart';

import 'package:gwenchana/features/vocabulary/presentation/widgets/word_card_model.dart';
import 'package:auto_route/auto_route.dart';
import 'package:gwenchana/l10n/gen_l10n/app_localizations.dart';

@RoutePage()
class FavoriteCardsPage extends StatefulWidget {
  const FavoriteCardsPage({super.key});

  @override
  State<FavoriteCardsPage> createState() => _FavoriteCardsPageState();
}

class _FavoriteCardsPageState extends State<FavoriteCardsPage>
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
    context.read<FavoritesBloc>().add(LoadFavoritesEvent());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void flipCard() {
    final bloc = context.read<FavoritesBloc>();
    final state = bloc.state;

    if (state is FavoritesLoadedState) {
      if (state.showTranslation) {
        _controller.reverse();
      } else {
        _controller.forward();
      }
      bloc.add(FlipCardEvent());
    }
  }

  Widget _buildListView(List<MyCard> favorites) {
    return ListView.separated(
      itemCount: favorites.length,
      padding: const EdgeInsets.all(16.0),
      separatorBuilder: (context, index) => Divider(
        color: Colors.grey.shade300,
        thickness: 1,
        height: 1,
      ),
      itemBuilder: (context, index) {
        final card = favorites[index];

        return Dismissible(
          key: Key('${card.korean}_${card.translation}_$index'),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            context.read<FavoritesBloc>().add(
                  RemoveFromFavoritesEvent(card),
                );
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
    List<MyCard> favorites,
    int currentIndex,
    bool showTranslation,
  ) {
    if (currentIndex >= favorites.length) {
      currentIndex = favorites.length - 1;
    }
    final card = favorites[currentIndex];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 30),
        Text(
          '${currentIndex + 1} / ${favorites.length}',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
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
                        child: Text(
                          isBack ? card.translation : card.korean,
                          style: TextStyle(
                            fontSize: 42.0,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
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
                    ? () =>
                        context.read<FavoritesBloc>().add(PreviousCardEvent())
                    : null,
                icon: Icon(Icons.arrow_back),
                iconSize: 40,
              ),
              IconButton(
                onPressed: currentIndex < favorites.length - 1
                    ? () => context.read<FavoritesBloc>().add(NextCardEvent())
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
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (context, state) {
        if (state is FavoritesLoadingState) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                AppLocalizations.of(context)!.favorites,
              ),
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is FavoritesEmptyState) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                AppLocalizations.of(context)!.favorites,
              ),
              centerTitle: true,
            ),
            body: Center(
              child: Text(AppLocalizations.of(context)!.emptyFavorites),
            ),
          );
        }

        if (state is FavoritesLoadedState) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () => context.router.pop(),
                icon: Icon(
                  Icons.arrow_back,
                ),
              ),
              centerTitle: true,
              title: Text(
                AppLocalizations.of(context)!.favorites,
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    state.viewMode == ViewMode.cards ? Icons.list : Icons.style,
                  ),
                  onPressed: () => context.read<FavoritesBloc>().add(
                        ToggleViewModeEvent(),
                      ),
                ),
              ],
            ),
            body: state.viewMode == ViewMode.cards
                ? _buildCardView(
                    state.favorites,
                    state.currentIndex,
                    state.showTranslation,
                  )
                : _buildListView(state.favorites),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(
              AppLocalizations.of(context)!.favorites,
            ),
          ),
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
