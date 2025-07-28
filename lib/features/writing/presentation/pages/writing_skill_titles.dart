import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gwenchana/core/navigation/app_router.dart';
import 'package:gwenchana/core/services/get_words_from_data.dart';
import 'package:gwenchana/core/shared/level_names.dart';
import 'package:gwenchana/l10n/gen_l10n/app_localizations.dart';

@RoutePage()
class WritingSkillTitlesPage extends StatefulWidget {
  const WritingSkillTitlesPage({super.key});

  @override
  State<WritingSkillTitlesPage> createState() => _WritingSkillTitlesPageState();
}

class _WritingSkillTitlesPageState extends State<WritingSkillTitlesPage> {
  int selectedLevel = 0;

  void showLevelDialog(BuildContext context) {
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
                setState(() {
                  selectedLevel = i;
                });
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> lessonTitles =
        GetWordsFromDataService.getCardTitlesForLevel(selectedLevel);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.chooseBook),
        actions: [
          IconButton(
            onPressed: () => showLevelDialog(context),
            icon: const Icon(
              Icons.filter_list,
            ),
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: lessonTitles.length,
        padding: const EdgeInsets.all(16.0),
        separatorBuilder: (context, index) => Divider(
          color: Colors.grey.shade300,
          thickness: 1,
          height: 1,
        ),
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              lessonTitles[index],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text('Lesson ${index + 1}'),
            trailing: const Icon(Icons.arrow_back_ios),
            onTap: () {
              context.router.push(WritingSkillRoute(
                level: selectedLevel,
                setIndex: index,
              ));
              print(
                  'Выбран урок: ${lessonTitles[index]} (Уровень: $selectedLevel, Индекс: $index)');
            },
          );
        },
      ),
    );
  }
}
