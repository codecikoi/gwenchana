import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gwenchana/features/vocabulary/presentation/bloc/vocabulary_bloc.dart';
import 'package:gwenchana/features/vocabulary/presentation/bloc/vocabulary_event.dart';
import 'package:gwenchana/features/vocabulary/presentation/bloc/vocabulary_state.dart';
import 'package:gwenchana/features/vocabulary/presentation/widgets/add_card_dialog.dart';
import 'package:gwenchana/gen_l10n/app_localizations.dart';

class MyCardsDialog extends StatelessWidget {
  final VocabularyBloc bloc;
  const MyCardsDialog({
    super.key,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    bloc.add(LoadCardsEvent());
    return BlocBuilder<VocabularyBloc, VocabularyState>(
      builder: (context, state) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.list, color: Colors.blue),
              SizedBox(width: 8),
              Text('My cards'),
            ],
          ),
          content: Container(
            width: double.maxFinite,
            height: 400,
            child: _buildContent(state, context),
          ),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildContent(VocabularyState state, BuildContext context) {
    if (state is VocabularyLoading) {
      return Center(child: CircularProgressIndicator());
    }
    if (state is VocabularyError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(state.message),
          ],
        ),
      );
    }
    if (state is CardsLoaded) {
      if (state.cards.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.list, color: Colors.grey, size: 48),
              const SizedBox(height: 16),
              Text(
                'Нет пользовательских карточек',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  _showAddCardDialog(context);
                },
                icon: Icon(Icons.add),
                label: Text(AppLocalizations.of(context)!.addCard),
              ),
            ],
          ),
        );
      }
      return ListView.builder(
        itemCount: state.cards.length,
        itemBuilder: (context, index) {
          final card = state.cards[index];
          return Card(
            margin: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 8,
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue.shade100,
                child: Icon(
                  Icons.list,
                  color: Colors.blue,
                  size: 20,
                ),
              ),
              title: Text(
                card.korean,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(card.translation),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      bloc.add(AddToFavoritesEvent(card));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Добавлено в избранное'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.favorite_border,
                      color: Colors.red,
                    ),
                    tooltip: 'Добавить в избранное',
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      // TODO: Добавить удаление карточки
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text('функция удаления будет доабвлено позже'),
                        ),
                      );
                    },
                    tooltip: 'удалить карточку',
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
    return Center(child: CircularProgressIndicator());
  }

  void _showAddCardDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddCardDialog(bloc: bloc),
    );
  }
}
