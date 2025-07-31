import 'package:gwenchana/core/data/datasource/beginner_level_one_datasource.dart';
import 'package:gwenchana/core/data/datasource/beginner_level_two_datasouce.dart';
import 'package:gwenchana/core/data/datasource/elementary_datasource.dart';
import 'package:gwenchana/core/data/datasource/intermediate_level_one_datasource.dart';
import 'package:gwenchana/core/data/datasource/intermediate_level_two_datasource.dart';
import 'package:gwenchana/core/data/extensions/words_data_raw_extensions.dart';
import 'package:gwenchana/core/data/models/words_data_raw.dart';
import 'package:gwenchana/core/domain/models/book.dart';
import 'package:gwenchana/core/domain/models/level.dart';
import '../models/words_data.dart';

abstract class BookDataSource {
  String get title;
  List<String> get lessonTitles;
  List<List<WordsDataRaw>> get lessons;
}

class ElementaryDataSourceAdapter implements BookDataSource {
  final ElementaryDataSource _dataSource = ElementaryDataSource();

  @override
  String get title => _dataSource.title;

  @override
  List<String> get lessonTitles => _dataSource.lessonTitles;

  @override
  List<List<WordsDataRaw>> get lessons => _dataSource.lessons;
}

class BeginnerLevelOneDataSourceAdapter implements BookDataSource {
  final BeginnerLevelOneDataSource _dataSource = BeginnerLevelOneDataSource();

  @override
  String get title => _dataSource.title;

  @override
  List<String> get lessonTitles => _dataSource.lessonTitles;

  @override
  List<List<WordsDataRaw>> get lessons => _dataSource.lessons;
}

class BeginnerLevelTwoDataSourceAdapter implements BookDataSource {
  final BeginnerLevelTwoDataSource _dataSource = BeginnerLevelTwoDataSource();

  @override
  String get title => _dataSource.title;

  @override
  List<String> get lessonTitles => _dataSource.lessonTitles;

  @override
  List<List<WordsDataRaw>> get lessons => _dataSource.lessons;
}

class IntermediateLevelOneDataSourceAdapter implements BookDataSource {
  final IntermediateLevelOneDatasource _dataSource =
      IntermediateLevelOneDatasource();

  @override
  String get title => _dataSource.title;

  @override
  List<String> get lessonTitles => _dataSource.lessonTitles;

  @override
  List<List<WordsDataRaw>> get lessons => _dataSource.lessons;
}

class IntermediateLevelTwoDataSourceAdapter implements BookDataSource {
  final IntermediateLevelTwoDatasource _dataSource =
      IntermediateLevelTwoDatasource();

  @override
  String get title => _dataSource.title;

  @override
  List<String> get lessonTitles => _dataSource.lessonTitles;

  @override
  List<List<WordsDataRaw>> get lessons => _dataSource.lessons;
}

class BookRepository {
  final Map<Level, BookDataSource> _dataSource;

  BookRepository({
    BookDataSource? beginnerLevelOne,
    BookDataSource? beginnerLevelTwo,
    BookDataSource? elementaryLevel,
    BookDataSource? intermediateLevelOne,
    BookDataSource? intermediateLevelTwo,
  }) : _dataSource = {
          Level.elementary: elementaryLevel ?? ElementaryDataSourceAdapter(),
          Level.beginnerLevelOne:
              beginnerLevelOne ?? BeginnerLevelOneDataSourceAdapter(),
          Level.beginnerLevelTwo:
              beginnerLevelTwo ?? BeginnerLevelTwoDataSourceAdapter(),
          Level.intermediateLevelOne:
              intermediateLevelOne ?? IntermediateLevelOneDataSourceAdapter(),
          Level.intermediateLevelTwo:
              intermediateLevelTwo ?? IntermediateLevelTwoDataSourceAdapter(),
        };

  BookDataSource _getDataSource(Level level) {
    final dataSource = _dataSource[level];
    if (dataSource == null) {
      throw ArgumentError('DataSource not found for level: $level');
    }
    return dataSource;
  }

  void _validateLessonIndex(BookDataSource dataSource, int lessonIndex) {
    if (lessonIndex < 0 || lessonIndex >= dataSource.lessonTitles.length) {
      throw ArgumentError('Invalid lesson index: $lessonIndex');
    }
  }

  List<WordsData> _convertWords(List<WordsDataRaw> wordsRaw) {
    return wordsRaw.map((e) => e.toWordsData()).toList();
  }

  String getBookTitle(Level level) {
    return _getDataSource(level).title;
  }

  List<String> getAllBookTitles() {
    return [
      getBookTitle(Level.elementary),
      getBookTitle(Level.beginnerLevelOne),
      getBookTitle(Level.beginnerLevelTwo),
      getBookTitle(Level.intermediateLevelOne),
      getBookTitle(Level.intermediateLevelTwo),
    ];
  }

  Lesson? getLesson({
    required Level level,
    required int lessonIndex,
  }) {
    try {
      final dataSource = _getDataSource(level);
      _validateLessonIndex(dataSource, lessonIndex);

      return Lesson(
        title: dataSource.lessonTitles[lessonIndex],
        words: _convertWords(dataSource.lessons[lessonIndex]),
      );
    } catch (e) {
      print('getlesson ${e.toString()}');
      return null;
    }
  }

  List<Lesson>? getAllLessons({
    required Level level,
  }) {
    try {
      final dataSource = _getDataSource(level);
      final lessons = <Lesson>[];

      for (int lessonIndex = 0;
          lessonIndex < dataSource.lessonTitles.length;
          ++lessonIndex) {
        final lesson = Lesson(
          title: dataSource.lessonTitles[lessonIndex],
          words: _convertWords(dataSource.lessons[lessonIndex]),
        );
        lessons.add(lesson);
      }

      return lessons;
    } catch (e) {
      print('getlesson ${e.toString()}');
      return null;
    }
  }

  List<Map<String, String>> getWordsForWritingSkill({
    required Level level,
    required int lessonIndex,
  }) {
    try {
      final dataSource = _getDataSource(level);
      _validateLessonIndex(dataSource, lessonIndex);

      return dataSource.lessons[lessonIndex].map((data) {
        return {'korean': data.korean, 'english': data.english};
      }).toList();
    } catch (e) {
      print('error getting words for writing ${e.toString()}');
      return [];
    }
  }

  List<String> getLessonTitlesForLevel(Level level) {
    try {
      final dataSource = _getDataSource(level);
      return dataSource.lessonTitles;
    } catch (e) {
      print('getting titles for lesson error ${e.toString()}');
      return [];
    }
  }
}
