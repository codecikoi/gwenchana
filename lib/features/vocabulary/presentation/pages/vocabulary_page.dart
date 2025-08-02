import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gwenchana/core/di/locator.dart';
import 'package:gwenchana/core/domain/repository/book_repository.dart';
import 'package:gwenchana/core/helper/app_colors.dart';
import 'package:gwenchana/core/helper/card_colors.dart';
import 'package:gwenchana/core/navigation/app_router.dart';
import 'package:gwenchana/features/vocabulary/presentation/bloc/bloc_add_cards/add_cards_bloc.dart';
import 'package:gwenchana/features/vocabulary/presentation/bloc/bloc_vocabulary/vocabulary_bloc.dart';
import 'package:gwenchana/features/vocabulary/presentation/bloc/bloc_vocabulary/vocabulary_event.dart';
import 'package:gwenchana/features/vocabulary/presentation/bloc/bloc_vocabulary/vocabulary_state.dart';
import 'package:gwenchana/features/vocabulary/presentation/widgets/add_card_dialog.dart';
import 'package:gwenchana/l10n/gen_l10n/app_localizations.dart';

@RoutePage()
class VocabularyPage extends StatefulWidget {
  const VocabularyPage({super.key});

  @override
  State<VocabularyPage> createState() => _VocabularyPageState();
}

class _VocabularyPageState extends State<VocabularyPage> {
  final BookRepository _bookRepository = locator<BookRepository>();
  List<String> get levelNames => _bookRepository.getAllBookTitles();

  Color getCardColor(int index) {
    return cardColors[index % cardColors.length];
  }

  void showLevelDialog(BuildContext context, VocabularyBloc bloc,
      int selectedLevel, List<String> levelNames) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        title: Row(
          children: [
            Icon(
              Icons.menu_book,
              color: AppColors.mainColor,
              size: 20,
            ),
            const SizedBox(width: 6),
            Text(
              AppLocalizations.of(context)!.chooseBook,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            levelNames.length,
            (i) => Container(
              margin: const EdgeInsets.only(bottom: 4),
              decoration: BoxDecoration(
                color: selectedLevel == i + 1
                    ? AppColors.secondaryColor.withAlpha(40)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: selectedLevel == i + 1
                    ? Border.all(color: AppColors.mainColor)
                    : Border.all(color: Colors.grey.shade400),
              ),
              child: ListTile(
                  dense: true,
                  title: Text(
                    levelNames[i],
                    style: TextStyle(
                      fontWeight: selectedLevel == i + 1
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: selectedLevel == i + 1
                          ? AppColors.mainColor
                          : AppColors.black,
                      fontSize: 12,
                    ),
                  ),
                  trailing: selectedLevel == i + 1
                      ? Icon(
                          Icons.check_circle,
                          color: AppColors.mainColor,
                          size: 20,
                        )
                      : null,
                  onTap: () {
                    bloc.add(ChangeLevelEvent(i + 1));
                    Navigator.of(context).pop();
                  }),
            ),
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

  // @override
  // void initState() {
  //   super.initState();
  //   context.read<VocabularyBloc>().add(LoadProgressEvent());
  // }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VocabularyBloc, VocabularyState>(
      builder: (context, state) {
        if (state is VocabularyLoadingState) {
          print('Debug: Handling VocabularyLoadingState');

          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (state is VocabularyErrorState) {
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
        if (state is VocabularyLoadedState) {
          print('Debug: Handling VocabularyLoadedState');

          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Container(
                decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                    width: 1,
                    color: AppColors.mainColor,
                  )),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => showLevelDialog(
                      context,
                      context.read<VocabularyBloc>(),
                      state.selectedLevel,
                      levelNames,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 6.0,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            (state.selectedLevel > 0 &&
                                    state.selectedLevel <= levelNames.length)
                                ? levelNames[state.selectedLevel - 1]
                                : AppLocalizations.of(context)!.chooseBook,
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.black87,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
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
                      addCardsBloc: context.read<AddCardsBloc>(),
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
                      elevation: 4,
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
                      FavoriteCardsRoute(),
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

        // return const SizedBox.shrink();

        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
            // child: Text('What is state ${state.runtimeType}'),
            // TODO: CIrcular indicator is OK?
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
    required this.total,
    this.progress = 0,
    this.isCompleted = false,
  });
}
