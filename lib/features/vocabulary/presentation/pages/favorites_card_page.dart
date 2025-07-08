import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gwenchana/features/vocabulary/presentation/bloc/vocabulary_bloc.dart';
import 'package:gwenchana/features/vocabulary/presentation/bloc/vocabulary_event.dart';
import 'package:gwenchana/features/vocabulary/presentation/bloc/vocabulary_state.dart';
import 'package:gwenchana/features/vocabulary/presentation/widgets/word_card_model.dart';

class FavoritesCardPage extends StatefulWidget {
  const FavoritesCardPage({super.key});

  @override
  State<FavoritesCardPage> createState() => _FavoritesCardPageState();
}

class _FavoritesCardPageState extends State<FavoritesCardPage> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<VocabularyBloc>().add(LoadFavoritesEvent());
  }

  void nextCard(int total) {
    if (currentIndex < total - 1) {
      setState(() {
        currentIndex++;
      });
    }
  }

  void prevCard(int total) {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
    }
  }

  void removeFromFavorites(BuildContext context, MyCard card, int total) {
    context.read<VocabularyBloc>().add(RemoveFromFavoritesEvent(card));
    setState(() {
      if (currentIndex >= total - 1 && currentIndex > 0) {
        currentIndex--;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Удаление из избранного'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VocabularyBloc, VocabularyState>(
      builder: (context, state) {
        if (state is VocabularyLoading) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Избранные'),
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (state is FavoritesLoaded) {
          final favorites = state.favorites;
          if (favorites.isEmpty) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Избравннные'),
              ),
              body: Center(child: Text('Нет избранных карточек')),
            );
          }
          final card = favorites[currentIndex];
          return Scaffold(
            appBar: AppBar(
              title: const Text('Избравннные'),
              actions: [
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () =>
                      removeFromFavorites(context, card, favorites.length),
                )
              ],
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${currentIndex + 1} / ${favorites.length}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 18),
                Card(
                  margin: EdgeInsets.all(16),
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          card.korean,
                          style: TextStyle(
                            fontSize: 32.0,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      iconSize: 40,
                      onPressed: () => currentIndex > 0 ? prevCard : null,
                    ),
                    SizedBox(width: 60),
                    IconButton(
                      icon: Icon(Icons.arrow_forward),
                      iconSize: 40,
                      onPressed: currentIndex < favorites.length - 1
                          ? () => nextCard(favorites.length)
                          : null,
                    ),
                  ],
                )
              ],
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text('Избраннные'),
          ),
          body: Center(
            child: Text('Произошла ошибка при загрузке избранных карточек'),
          ),
        );
      },
    );
  }
}
