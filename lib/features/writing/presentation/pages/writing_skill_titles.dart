import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gwenchana/core/helper/app_colors.dart';
import 'package:gwenchana/core/navigation/app_router.dart';
import 'package:gwenchana/core/services/get_words_from_data.dart';
import 'package:gwenchana/core/shared/level_names.dart';
import 'package:gwenchana/features/writing/presentation/bloc/writing_skill_bloc.dart';
import 'package:gwenchana/features/writing/presentation/bloc/writing_skill_event.dart';
import 'package:gwenchana/features/writing/presentation/bloc/writing_skill_state.dart';
import 'package:gwenchana/l10n/gen_l10n/app_localizations.dart';

@RoutePage()
class WritingSkillTitlesPage extends StatelessWidget
    implements AutoRouteWrapper {
  const WritingSkillTitlesPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (_) => WritingSkillBloc()
        ..add(
          const LoadWritingLevels(),
        ),
      child: this,
    );
  }

  // void showLevelDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(8),
  //       ),
  //       title: Row(
  //         children: [
  //           Icon(
  //             Icons.menu_book,
  //             color: AppColors.enableButton,
  //             size: 20,
  //           ),
  //           const SizedBox(width: 6),
  //           Text(
  //             AppLocalizations.of(context)!.chooseBook,
  //             style: TextStyle(
  //               fontSize: 14,
  //               fontWeight: FontWeight.bold,
  //               color: AppColors.black,
  //             ),
  //           ),
  //         ],
  //       ),
  //       content: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: List.generate(
  //           5,
  //           (i) => Container(
  //             margin: const EdgeInsets.only(bottom: 4),
  //             decoration: BoxDecoration(
  //               color: selectedLevel == i
  //                   ? AppColors.disableButton.withAlpha(40)
  //                   : Colors.transparent,
  //               borderRadius: BorderRadius.circular(6),
  //               border: selectedLevel == i
  //                   ? Border.all(color: AppColors.enableButton)
  //                   : Border.all(color: Colors.grey.shade400),
  //             ),
  //             child: ListTile(
  //               dense: true,
  //               title: Text(
  //                 '${levelNames[i]}', // TODO: add localization of level
  //                 style: TextStyle(
  //                   fontWeight: selectedLevel == i
  //                       ? FontWeight.w600
  //                       : FontWeight.normal,
  //                   color: selectedLevel == i
  //                       ? AppColors.enableButton
  //                       : AppColors.black,
  //                   fontSize: 12,
  //                 ),
  //               ),
  //               trailing: selectedLevel == i
  //                   ? Icon(
  //                       Icons.check_circle,
  //                       color: AppColors.enableButton,
  //                       size: 20,
  //                     )
  //                   : null,
  //               onTap: () {
  //                 setState(() {
  //                   selectedLevel = i;
  //                 });
  //                 Navigator.of(context).pop();
  //               },
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WritingSkillBloc, WritingSkillState>(
        builder: (context, state) {
      if (state is WritingLevelsLoading) {
        return const Center(child: CircularProgressIndicator());
      }
      if (state is WritingLevelsLoaded) {
        return Scaffold(
          appBar: AppBar(
            title: DropdownButton<int>(
              value: state.selectedLevel,
              items: List.generate(
                state.levelNames.length,
                (i) => DropdownMenuItem(
                  value: i,
                  child: Text(state.levelNames[i]),
                ),
              ),
              onChanged: (level) {
                if (level != null) {
                  context
                      .read<WritingSkillBloc>()
                      .add(ChangeWritingLevel(level));
                }
              },
            ),

            // Container(
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(10),
            //     boxShadow: [
            //       BoxShadow(
            //         color: Colors.black.withAlpha(10),
            //         blurRadius: 1,
            //       ),
            //     ],
            //   ),
            //   child: Material(
            //     color: Colors.transparent,
            //     child: InkWell(
            //       borderRadius: BorderRadius.circular(16),
            //       onTap: () => showLevelDialog(context),
            //       child: Padding(
            //         padding: const EdgeInsets.symmetric(
            //             horizontal: 10.0, vertical: 6.0),
            //         child: Row(
            //           mainAxisSize: MainAxisSize.min,
            //           children: [
            //             Text(
            //               selectedLevel >= 0 &&
            //                       selectedLevel < levelNames.length
            //                   ? levelNames[selectedLevel]
            //                   : AppLocalizations.of(context)!.chooseBook,
            //               style: TextStyle(
            //                 color: Colors.black87,
            //                 fontSize: 14,
            //                 fontWeight: FontWeight.w600,
            //               ),
            //             ),
            //             const SizedBox(width: 6),
            //             Icon(
            //               Icons.keyboard_arrow_down,
            //               color: Colors.black87,
            //               size: 16,
            //             ),
            //           ],
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ),
          body: ListView.separated(
            itemCount: state.lessonTitles.length,
            padding: const EdgeInsets.all(16.0),
            separatorBuilder: (context, index) => Divider(
              color: Colors.grey.shade300,
              thickness: 1,
              height: 1,
            ),
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  state.lessonTitles[index],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text('Lesson ${index + 1}'),
                onTap: () {
                  context.read<WritingSkillBloc>().add(
                        StartWritingSkill(
                          level: state.selectedLevel,
                          setIndex: index,
                        ),
                      );
                  context.router.push(WritingSkillRoute(
                    level: state.selectedLevel,
                    setIndex: index,
                  ));
                },
              );
            },
          ),
        );
      }
      return const SizedBox.shrink();
    });
  }
}
