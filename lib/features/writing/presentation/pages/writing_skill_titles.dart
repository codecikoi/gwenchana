import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gwenchana/core/di/locator.dart';
import 'package:gwenchana/core/domain/repository/book_repository.dart';
import 'package:gwenchana/core/helper/app_colors.dart';
import 'package:gwenchana/core/navigation/app_router.dart';
import 'package:gwenchana/features/writing/presentation/bloc/writing_skill_bloc.dart';
import 'package:gwenchana/features/writing/presentation/bloc/writing_skill_event.dart';
import 'package:gwenchana/features/writing/presentation/bloc/writing_skill_state.dart';
import 'package:gwenchana/l10n/gen_l10n/app_localizations.dart';

@RoutePage()
class WritingSkillTitlesPage extends StatelessWidget
    implements AutoRouteWrapper {
  WritingSkillTitlesPage({super.key});

  final BookRepository _bookRepository = locator<BookRepository>();
  List<String> get levelNames => _bookRepository.getAllBookTitles();

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

  void showLevelDialog(
      BuildContext context, WritingLevelsLoaded state, WritingSkillBloc bloc) {
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
            5,
            (i) => Container(
              margin: const EdgeInsets.only(bottom: 4),
              decoration: BoxDecoration(
                color: state.selectedLevel == i
                    ? AppColors.secondaryColor.withAlpha(40)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: state.selectedLevel == i
                    ? Border.all(color: AppColors.mainColor)
                    : Border.all(color: Colors.grey.shade400),
              ),
              child: ListTile(
                dense: true,
                title: Text(
                  levelNames[i], // TODO: add localization of level
                  style: TextStyle(
                    fontWeight: state.selectedLevel == i
                        ? FontWeight.w600
                        : FontWeight.normal,
                    color: state.selectedLevel == i
                        ? AppColors.mainColor
                        : AppColors.black,
                    fontSize: 12,
                  ),
                ),
                trailing: state.selectedLevel == i
                    ? Icon(
                        Icons.check_circle,
                        color: AppColors.mainColor,
                        size: 20,
                      )
                    : null,
                onTap: () {
                  bloc.add(ChangeWritingLevel(i));
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

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
                      context, state, context.read<WritingSkillBloc>()),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 6.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          state.selectedLevel >= 0 &&
                                  state.selectedLevel < levelNames.length
                              ? levelNames[state.selectedLevel]
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
