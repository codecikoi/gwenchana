import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gwenchana/core/helper/card_colors.dart';
import 'package:gwenchana/core/navigation/app_router.dart';
import 'package:gwenchana/features/vocabulary/presentation/bloc/vocabulary_bloc.dart';
import 'package:gwenchana/features/vocabulary/presentation/bloc/vocabulary_event.dart';
import 'package:gwenchana/features/vocabulary/presentation/bloc/vocabulary_state.dart';
import 'package:gwenchana/gen_l10n/app_localizations.dart';

@RoutePage()
class VocabularyPage extends StatelessWidget {
  const VocabularyPage({super.key});

  Color getCardColor(int index) {
    return cardColors[index % cardColors.length];
  }

  void showLevelDialog(BuildContext context, VocabularyBloc bloc) {
    final levelNames = [
      '기조', // 0
      '초급 1', // 1
      '초급 2', // 2
      '중급 1', // 3
      '중급 2', // 4
    ];

    // выбор уровня

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

  // void addCard(String korean, String english) {
  //   setState(() {
  //     cards.add(VocabularyCard(korean: korean, english: english));
  //   });
  // }

//   void showAddCardDialog() {
//     String korean = '';
//     String english = '';
//     String? errorText;
//     showDialog(
//       context: context,
//       builder: (context) => StatefulBuilder(
//         builder: (context, setState) => AlertDialog(
//           title: Text('Добавить карточку'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 decoration: InputDecoration(labelText: 'Корейское слово'),
//                 onChanged: (value) {
//                   korean = value;
//                   setState(() => errorText = null);
//                 },
//               ),
//               TextField(
//                 decoration: InputDecoration(labelText: 'Перевод (англ.)'),
//                 onChanged: (value) {
//                   english = value;
//                   setState(() => errorText = null);
//                 },
//               ),
//               if (errorText != null)
//                 Padding(
//                   padding: const EdgeInsets.only(top: 8.0),
//                   child: Text(
//                     errorText!,
//                     style: TextStyle(color: Colors.red),
//                   ),
//                 ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 final koreanReg =
//                     RegExp(r'^[\uac00-\ud7af\u1100-\u11ff\u3130-\u318f ]+$');
//                 final englishReg = RegExp(r'^[A-Za-z ]+$');
//                 if (korean.isEmpty || english.isEmpty) {
//                   setState(() => errorText = 'Поля не должны быть пустыми');
//                   return;
//                 }
//                 if (!koreanReg.hasMatch(korean)) {
//                   setState(() => errorText =
//                       'Корейское слово должно содержать только корейские символы');
//                   return;
//                 }
//                 if (!englishReg.hasMatch(english)) {
//                   setState(() =>
//                       errorText = 'Перевод должен быть на английском языке');
//                   return;
//                 }
//                 addCard(korean, english);
//                 Navigator.of(context).pop();
//               },
//               child: Text('Добавить'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VocabularyBloc, VocabularyState>(
      builder: (context, state) {
        if (state is VocabularyLoading) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Vocaabulary Cards'),
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
                  AppLocalizations.of(context)!.chooseBook,
                  style: TextStyle(
                    fontSize: 22,
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
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () {
                    context.read<VocabularyBloc>().add(
                          ResetProgressEvent(state.selectedLevel),
                        );
                  },
                  tooltip: 'Reset progress',
                ),
              ],
            ),
            body: GridView.builder(
              padding: EdgeInsets.all(16.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16.0,
                childAspectRatio: 1.0,
                crossAxisSpacing: 16.0,
              ),
              itemCount: state.cards.length,
              itemBuilder: (context, index) {
                final card = state.cards[index];
                return GestureDetector(
                  onTap: () => navigateToVocabularyCard(
                    context,
                    index,
                    state.selectedLevel,
                    context.read<VocabularyBloc>(),
                  ),
                  child: Card(
                    color: getCardColor(index),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            card.mainTitle,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8.0),
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
                                fontSize: 16.0,
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
        return Scaffold(
          appBar: AppBar(
            title: Text('Vocabulary Cardsadsad'),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
          body: Center(
            child: Text('No vocabulary data available.'),
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
