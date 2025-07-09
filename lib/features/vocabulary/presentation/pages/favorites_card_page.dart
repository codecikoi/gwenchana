import 'package:flutter/material.dart';
import 'package:gwenchana/features/vocabulary/presentation/widgets/word_card_model.dart';
import 'package:auto_route/auto_route.dart';

enum ViewMode { cards, list }

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

  ViewMode currentViewMode = ViewMode.cards;
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
      print('error loading fav $e');
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

      // final favBox = await Hive.openBox('favorites');
      // final favoritesList = favBox.values.toList();
      // final index = favoritesList.indexWhere(
      //   (e) =>
      //       e['korean'] == card.korean && e['translation'] == card.translation,
      // );
      // if (index != -1) {
      //   await favBox.deleteAt(index);
      // }

      setState(() {
        favorites.removeWhere(
          (fav) =>
              fav.korean == card.korean && fav.translation == card.translation,
        );
        if (currentViewMode == ViewMode.cards && favorites.isNotEmpty) {
          if (currentIndex >= favorites.length) {
            currentIndex = favorites.length - 1;
          }
          showTranslation = false;
          _controller.reset();
        }
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(source == 'swipe'
                ? 'Card deleted'
                : 'Карточка удалена из избранного'),
            backgroundColor: Colors.orange,
            action: SnackBarAction(
              label: 'cancel',
              onPressed: () => addToFavoritesLocal(card),
            ),
          ),
        );
      }
    } catch (e) {
      print('error from favorites $e');
    }
  }

  Future<void> addToFavoritesLocal(MyCard card) async {
    try {
      await HiveStorageService.addToFavorites(card);
      setState(() {
        favorites.add(card);
      });
    } catch (e) {
      print('error adding to fav $e');
    }
  }

  void toggleViewMode() {
    setState(() {
      currentViewMode =
          currentViewMode == ViewMode.cards ? ViewMode.list : ViewMode.cards;
    });
  }

  Widget _buildListView(List<MyCard> favorites) {
    return ListView.builder(
      itemCount: favorites.length,
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, index) {
        final card = favorites[index];
        return Dismissible(
          key: Key('${card.korean}_${card.translation}_$index'),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            removeFromFavorites(card, source: 'swipe');
          },
          confirmDismiss: (direction) async {
            return await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('подтвердите удаления'),
                content: Text('Delete "${card.korean}" from favorites?'),
                actions: [
                  TextButton(
                    child: Text('Отмена'),
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                    child: Text('Удалить'),
                  ),
                ],
              ),
            );
          },
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20.0),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
                const SizedBox(height: 4),
                Text('delete'),
              ],
            ),
          ),
          child: Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            child: ExpansionTile(
              leading: CircleAvatar(
                backgroundColor: Colors.red.shade100,
                child: Icon(
                  Icons.favorite,
                  color: Colors.red,
                  size: 20,
                ),
              ),
              title: Text(
                card.korean,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
              subtitle: Text('нажмите чтоб посмотреть перевод'),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'перевод',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              card.translation,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.blue.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => removeFromFavorites(card),
                        icon: Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                      ),
                    ],
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
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            '${currentIndex + 1} / ${favorites.length}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 18),
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
                    margin: const EdgeInsets.all(16.0),
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
                                fontSize: 32.0,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            if (!isBack) ...[
                              const SizedBox(height: 16),
                              Text(
                                'нажмите для перевода',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ]
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
                onPressed: flipCard,
                icon: Icon(
                  showTranslation ? Icons.flip_to_front : Icons.flip_to_back,
                ),
                iconSize: 32,
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
          title: const Text('Избранные'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (favorites.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Избранные'),
        ),
        body: Center(
          child: Text('Нет избранных карточек'),
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
        title: Row(
          children: [
            const Text('Избранные'),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${favorites.length}',
                style: TextStyle(
                  color: Colors.red.shade700,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
                currentViewMode == ViewMode.cards ? Icons.list : Icons.style),
            onPressed: toggleViewMode,
          ),
          if (currentViewMode == ViewMode.cards)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                if (favorites.isNotEmpty) {
                  final card = favorites[currentIndex];
                  removeFromFavorites(card);
                }
              },
            )
        ],
      ),
      body: currentViewMode == ViewMode.cards
          ? _buildCardView(favorites)
          : _buildListView(favorites),
      floatingActionButton: currentViewMode == ViewMode.list
          ? FloatingActionButton.extended(
              onPressed: () {
                setState(() {
                  currentViewMode = ViewMode.cards;
                });
              },
              icon: Icon(Icons.style),
              label: Text('cards'),
              backgroundColor: Colors.blue,
            )
          : null,
    );
  }
}
