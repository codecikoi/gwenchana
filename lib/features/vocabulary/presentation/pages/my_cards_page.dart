import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gwenchana/features/vocabulary/presentation/bloc/vocabulary_bloc.dart';
import 'package:gwenchana/features/vocabulary/presentation/widgets/add_card_dialog.dart';
import 'package:gwenchana/features/vocabulary/presentation/widgets/word_card_model.dart';

enum ViewMode { cards, list }

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

  ViewMode currentViewMode = ViewMode.cards;
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

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              source == 'swipe' ? 'card deleted' : 'card deleted?',
            ),
            backgroundColor: Colors.orange,
            action: SnackBarAction(
              label: 'cancel',
              onPressed: () => addCardBack(card),
            ),
          ),
        );
      }
    } catch (e) {
      print('error deleting card $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Error deleting card'),
            backgroundColor: Colors.red,
          ),
        );
      }
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Card added to favorites'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Error adding card to favorites'),
            backgroundColor: Colors.red,
          ),
        );
      }
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
    return ListView.builder(
      itemCount: cards.length,
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, index) {
        final card = cards[index];
        return Dismissible(
          key: Key(
              '${card.korean}_${card.translation}_${card.createdAt.millisecondsSinceEpoch}'),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            deleteCard(card, source: 'swipe');
          },
          confirmDismiss: (direction) async {
            return await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Подтвердите удаление'),
                content: Text('Delete "${card.korean}" from your cards?'),
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
                Text(
                  'delete',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          child: Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            child: ExpansionTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue.shade100,
                child: Icon(
                  Icons.person,
                  color: Colors.blue,
                  size: 20,
                ),
              ),
              title: Text(
                card.korean,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('нажмите чтоб посмотреть перевод'),
                  const SizedBox(height: 4),
                  Text(
                    'Добавлено: ${_formatDate(card.createdAt)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Перевод:',
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
                      Column(
                        children: [
                          IconButton(
                            onPressed: () => addToFavorites(card),
                            icon: Icon(
                              Icons.favorite_border,
                              color: Colors.red,
                            ),
                            tooltip: 'Add to favorites',
                          ),
                          IconButton(
                            onPressed: () => deleteCard(card),
                            icon: Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                            ),
                            tooltip: 'Delete card',
                          ),
                        ],
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

  Widget _buildCardView(List<MyCard> cards) {
    if (currentIndex >= cards.length) {
      currentIndex = cards.length - 1;
    }
    final card = cards[currentIndex];
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${currentIndex + 1} / ${cards.length}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                _formatDate(card.createdAt),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
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
                    elevation: 4,
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
                    currentIndex > 0 ? () => prevCard(cards.length) : null,
                icon: Icon(Icons.arrow_back),
                iconSize: 40,
              ),
              IconButton(
                onPressed: () => addToFavorites(card),
                icon: Icon(Icons.favorite_border),
                iconSize: 32,
                tooltip: 'Add to favorites',
              ),
              IconButton(
                onPressed: flipCard,
                icon: Icon(
                  showTranslation ? Icons.flip_to_front : Icons.flip_to_back,
                ),
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    // Show loading
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Мои карточки'),
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
          title: const Text('Мои карточки'),
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
              Icon(
                Icons.person_outline,
                size: 64,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              Text(
                'Нет ваших карточек',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Создайте свои собственные карточки для изучения',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: showAddCardDialog,
                icon: Icon(Icons.add),
                label: Text('Добавить карточку'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
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
        title: Row(
          children: [
            const Text('Мои карточки'),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${myCards.length}',
                style: TextStyle(
                  color: Colors.blue.shade700,
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
              currentViewMode == ViewMode.cards ? Icons.list : Icons.style,
            ),
            onPressed: toggleViewMode,
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: showAddCardDialog,
          ),
          if (currentViewMode == ViewMode.cards)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                if (myCards.isNotEmpty) {
                  final card = myCards[currentIndex];
                  deleteCard(card);
                }
              },
            )
        ],
      ),
      body: currentViewMode == ViewMode.cards
          ? _buildCardView(myCards)
          : _buildListView(myCards),
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
          : FloatingActionButton(
              onPressed: showAddCardDialog,
              child: Icon(Icons.add),
              backgroundColor: Colors.blue,
            ),
    );
  }
}
