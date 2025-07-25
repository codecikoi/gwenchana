import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gwenchana/core/helper/basic_appbutton.dart';
import 'package:gwenchana/core/helper/card_colors.dart';
import 'package:gwenchana/core/navigation/app_router.dart';
import 'package:gwenchana/features/vocabulary/presentation/bloc/vocabulary_bloc.dart';
import 'package:gwenchana/features/vocabulary/presentation/bloc/vocabulary_event.dart';
import 'package:gwenchana/features/vocabulary/presentation/bloc/vocabulary_state.dart';
import 'package:gwenchana/features/vocabulary/presentation/widgets/add_card_dialog.dart';
import 'package:gwenchana/l10n/gen_l10n/app_localizations.dart';

@RoutePage()
class VocabularyPage extends StatefulWidget {
  const VocabularyPage({super.key});

  @override
  State<VocabularyPage> createState() => _VocabularyPageState();
}

class _VocabularyPageState extends State<VocabularyPage> {
  final List<String> levelNames = [
    '기조', // elementary
    '초급 1', // beginner I
    '초급 2', // beginner II
    '중급 1', // intermediate I
    '중급 2', // intermediate II
  ];

  Color getCardColor(int index) {
    return cardColors[index % cardColors.length];
  }

  void showLevelDialog(BuildContext context, VocabularyBloc bloc) {
    levelNames;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.chooseBook),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            5,
            (i) => ListTile(
                title: Text(levelNames[i]),
                onTap: () {
                  bloc.add(ChangeLevelEvent(i + 1));
                  Navigator.of(context).pop();
                }),
          ),
        ),
      ),
    );
  }

  void navigateToVocabularyCard(BuildContext context, int cardIndex,
      int selectedLevel, VocabularyBloc bloc) async {
    await context.router.push(
      VocabularyCardRoute(setIndex: cardIndex, selectedLevel: selectedLevel),
    );
    bloc.add(LoadProgressEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VocabularyBloc, VocabularyState>(
      builder: (context, state) {
        if (state is VocabularyLoading) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Vocabulary Cards'),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (state is VocabularyError) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Error'),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
            body: Center(
              child: Text(state.message),
            ),
          );
        }
        if (state is VocabularyLoaded) {
          return Scaffold(
            appBar: AppBar(
              title: TextButton(
                child: Text(
                  state.selectedLevel > 0
                      ? levelNames[state.selectedLevel - 1]
                      : AppLocalizations.of(context)!.chooseBook,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                onPressed: () => showLevelDialog(
                  context,
                  context.read<VocabularyBloc>(),
                ),
              ),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              actions: [
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => AddCardDialog(
                      bloc: context.read<VocabularyBloc>(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () {
                    context.read<VocabularyBloc>().add(
                          ResetProgressEvent(state.selectedLevel),
                        );
                  },
                ),
              ],
            ),
            body: GridView.builder(
              padding: EdgeInsets.all(6.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.0,
                crossAxisSpacing: 6.0,
                mainAxisSpacing: 6.0,
              ),
              itemCount: state.cards.length + 2,
              itemBuilder: (context, index) {
                if (index == 0) {
                  // my cards
                  return GestureDetector(
                    onTap: () => context.router.push(const MyCardsRoute()),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      color: getCardColor(index - 3),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 40,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              AppLocalizations.of(context)!.myCards,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                if (index == 1) {
                  // favorites
                  return GestureDetector(
                    onTap: () => context.router.push(
                      FavoritesCardRoute(),
                    ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      color: getCardColor(index - 7),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.favorite,
                              color: Colors.white,
                              size: 40,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              AppLocalizations.of(context)!.favorites,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                final card = state.cards[index - 2];
                return GestureDetector(
                  onTap: () => navigateToVocabularyCard(
                    context,
                    index - 2,
                    state.selectedLevel,
                    context.read<VocabularyBloc>(),
                  ),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    color: getCardColor(index - 2),
                    child: Padding(
                      padding: EdgeInsets.all(14.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            card.mainTitle,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4.0),
                          if (card.isCompleted)
                            Icon(
                              Icons.check_circle,
                              color: Colors.white,
                              size: 32.0,
                            )
                          else
                            Text(
                              '${card.progress}/${card.total}',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.white,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
        if (state is CardsLoaded) {
          context.read<VocabularyBloc>().add(LoadProgressEvent());
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (state is FavoritesLoaded) {
          context.read<VocabularyBloc>().add(LoadProgressEvent());
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Scaffold(
          body: Center(
            child: BasicAppButton(
              onPressed: () {
                context.router.push(
                  const VocabularyRoute(),
                );
                context.read<VocabularyBloc>().add(LoadProgressEvent());
              },
              title: 'Back to vocabulary',
            ),
          ),
        );
      },
    );
  }
}

class VocabularyCardData {
  final String title;
  final String mainTitle;
  final int progress;
  final int total;
  final bool isCompleted;

  VocabularyCardData({
    required this.title,
    required this.mainTitle,
    this.progress = 0,
    this.total = 26,
    this.isCompleted = false,
  });
}
