import 'package:flutter/material.dart';
import 'package:gwenchana/features/vocabulary/presentation/widgets/word_card_model.dart';
import 'package:auto_route/auto_route.dart';
import 'package:gwenchana/gen_l10n/app_localizations.dart';

enum ViewMode { list, cards }

@RoutePage()
class FavoritesCardPage extends StatefulWidget {
  const FavoritesCardPage({super.key});

  @override
  State<FavoritesCardPage> createState() => _FavoritesCardPageState();
}

class _FavoritesCardPageState extends State<FavoritesCardPage>
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  bool showTranslation = false;

  ViewMode currentViewMode = ViewMode.list;
  late AnimationController _controller;
  late Animation<double> _animation;

  List<MyCard> favorites = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    loadFavoritesDirectly();
  }

  Future<void> loadFavoritesDirectly() async {
    try {
      final loadedFavorites = await HiveStorageService.getFavorites();
      setState(() {
        favorites = loadedFavorites;
        isLoading = false;
      });
    } catch (e) {
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

  Future<void> removeFromFavorites(MyCard card, {String? source}) async {
    try {
      await HiveStorageService.removeFromFavorites(card);

      setState(() {
        favorites.removeWhere(
          (fav) =>
              fav.korean == card.korean && fav.translation == card.translation,
        );
        if (currentViewMode == ViewMode.list && favorites.isNotEmpty) {
          if (currentIndex >= favorites.length) {
            currentIndex = favorites.length - 1;
          }
          showTranslation = false;
          _controller.reset();
        }
      });
    } catch (e) {
      print('error from favorites $e');
    }
  }

  void toggleViewMode() {
    setState(() {
      currentViewMode =
          currentViewMode == ViewMode.list ? ViewMode.cards : ViewMode.list;
    });
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
            removeFromFavorites(card, source: 'swipe');
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

  Widget _buildCardView(List<MyCard> favorites) {
    if (currentIndex >= favorites.length) {
      currentIndex = favorites.length - 1;
    }
    final card = favorites[currentIndex];
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        Text(
          '${currentIndex + 1} / ${favorites.length}',
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
                    currentIndex > 0 ? () => prevCard(favorites.length) : null,
                icon: Icon(Icons.arrow_back),
                iconSize: 40,
              ),
              IconButton(
                onPressed: currentIndex < favorites.length - 1
                    ? () => nextCard(favorites.length)
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
    if (isLoading) {
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

    if (favorites.isEmpty) {
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.router.pop(),
          icon: Icon(
            Icons.arrow_back,
            color: Colors.red,
          ),
        ),
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.favorites,
        ),
        actions: [
          IconButton(
            icon: Icon(
              currentViewMode == ViewMode.cards ? Icons.list : Icons.style,
            ),
            onPressed: toggleViewMode,
          ),
        ],
      ),
      body: currentViewMode == ViewMode.cards
          ? _buildCardView(favorites)
          : _buildListView(favorites),
    );
  }
}
