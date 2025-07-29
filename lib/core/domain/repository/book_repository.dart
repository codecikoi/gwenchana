import 'package:gwenchana/core/data/datasource/elementary_datasource.dart';
import 'package:gwenchana/core/data/extensions/words_data_raw_extensions.dart';
import 'package:gwenchana/core/domain/models/book.dart';
import 'package:gwenchana/core/domain/models/level.dart';

class BookRepository {
  final ElementaryDataSource elementaryDataSource;

  BookRepository({
    required this.elementaryDataSource,
  });

  String getBookTitle(Level level) {
    switch (level) {
      case Level.elementary:
        return elementaryDataSource.title;
      case Level.beginnerLevelOne:
      case Level.beginnerLevelTwo:
      case Level.intermediateLevelOne:
      case Level.intermediateLevelTwo:
        return '';
    }
  }

  Lesson? getLesson({
    required Level level,
    required int lessonIndex,
  }) {
    try {
      switch (level) {
        case Level.elementary:
          return Lesson(
            title: elementaryDataSource.titles[lessonIndex],
            words: elementaryDataSource.lessons[lessonIndex]
                .map((e) => e.toWordsData())
                .toList(),
          );
        case Level.beginnerLevelOne:
        case Level.beginnerLevelTwo:
        case Level.intermediateLevelOne:
        case Level.intermediateLevelTwo:
          return null;
      }
    } catch (e) {
      return null;
    }
  }

  List<Lesson>? getLessons({
    required Level level,
    required int lessonIndex,
  }) {
    try {
      switch (level) {
        case Level.elementary:
          // final lessons = <Lesson>[];
          // for (int i = 0; i < elementaryDataSource.lessons.length; ++i) {
          //   final lesson = Lesson(
          //     title: elementaryDataSource.titles[i],
          //     words: elementaryDataSource.lessons[i]
          //         .map((e) => e.toWordsData())
          //         .toList(),
          //   );
          //   lessons.add(lesson);
          // }
          // return lessons;
          elementaryDataSource.lessons.indexed.map((pair) {
            return Lesson(
              title: elementaryDataSource.titles[pair.$1],
              words: pair.$2.map((e) => e.toWordsData()).toList(),
            );
          });

        case Level.beginnerLevelOne:
        case Level.beginnerLevelTwo:
        case Level.intermediateLevelOne:
        case Level.intermediateLevelTwo:
          return null;
      }
    } catch (e) {
      return null;
    }
  }
}
