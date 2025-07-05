import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gwenchana/features/vocabulary/presentation/bloc/vocabulary_bloc.dart';
import 'package:gwenchana/features/vocabulary/presentation/bloc/vocabulary_event.dart';
import 'package:gwenchana/features/vocabulary/presentation/bloc/vocabulary_state.dart';

class FavoriteDialog extends StatelessWidget {
  final VocabularyBloc bloc;
  const FavoriteDialog({
    super.key,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    bloc.add(LoadFavoritesEvent());
    return BlocBuilder<VocabularyBloc, VocabularyState>(
      builder: (context, state) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.favorite, color: Colors.red),
              SizedBox(width: 8),
              Text('Favorites'),
            ],
          ),
          content: Container(
            width: double.maxFinite,
            height: 400,
            child: _buildContent(state),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            )
          ],
        );
      },
    );
  }

  Widget _buildContent(VocabularyState state) {
    if (state is VocabularyLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    if (state is VocabularyError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error,
              color: Colors.red,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(state.message),
          ],
        ),
      );
    }
    if (state is FavoritesLoaded) {
      if (state.favorites.isEmpty) {
        return Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(
              Icons.favorite_border,
              color: Colors.grey,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Нет избранных карточек',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ]),
        );
      }
      return ListView.builder(
        itemCount: state.favorites.length,
        itemBuilder: (context, index) {
          final card = state.favorites[index];
          return Card(
            margin: EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 8,
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.red.shade100,
                child: Icon(Icons.favorite, color: Colors.red, size: 20),
              ),
              title: Text(
                card.korean,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(card.translation),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('Функция удаления будет добавлена позже лол'),
                    ),
                  );
                },
              ),
            ),
          );
        },
      );
    }
    return Center(child: CircularProgressIndicator());
  }
}
