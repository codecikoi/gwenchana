import 'package:gwenchana/core/di/locator.dart';
import 'package:gwenchana/core/domain/repository/book_repository.dart';
import '../domain/models/level.dart';

class GetWordsFromDataService {
  static final BookRepository _bookRepository = locator<BookRepository>();

  static List<Map<String, String>> getWordsForWriting(
      Level level, int lessonIndex) {
    return _bookRepository.getWordsForWritingSkill(
      level: level,
      lessonIndex: lessonIndex,
    );
  }

  static List<String> getLessonTitlesForLevel(Level level) {
    return _bookRepository.getLessonTitlesForLevel(level);
  }

  static List<Map<String, String>> getWordsForWritingByInt(
      int levelIndex, int lessonIndex) {
    final level = _intToLevel(levelIndex);
    return getWordsForWriting(level, lessonIndex);
  }

  static Level _intToLevel(int levelIndex) {
    switch (levelIndex) {
      case 0:
        return Level.elementary;
      case 1:
        return Level.beginnerLevelOne;
      case 2:
        return Level.beginnerLevelTwo;
      case 3:
        return Level.intermediateLevelOne;
      case 4:
        return Level.intermediateLevelTwo;
      default:
        throw ArgumentError('invalid level index $levelIndex');
    }
  }
}

// class GetWordsFromDataService {
//   static List<Map<String, String>> getWordsForWriting(int level, int setIndex) {
//     switch (level) {
//       case 0:
//         return getElementaryLessonDataSet(setIndex + 1).map((data) {
//           return {'korean': data.korean, 'english': data.english};
//         }).toList();

//       case 1:
//         return getBeginnerOneLessonDataSet(setIndex + 1).map((data) {
//           return {'korean': data.korean, 'english': data.english};
//         }).toList();

//       case 2:
//         return getBeginnerTwoLessonDataSet(setIndex + 1).map((data) {
//           return {'korean': data.korean, 'english': data.english};
//         }).toList();

//       case 3:
//         return getIntermediateOneLessonDataSet(setIndex + 1).map((data) {
//           return {'korean': data.korean, 'english': data.english};
//         }).toList();

//       case 4:
//         return getIntermediateTwoLessonDataSet(setIndex + 1).map((data) {
//           return {'korean': data.korean, 'english': data.english};
//         }).toList();
//       default:
//         return [];
//     }
//   }

//   static List<String> getCardTitlesForLevel(int level) {
//     switch (level) {
//       case 0:
//         return lessonTitlesElementaryLevel;
//       case 1:
//         return lessonTitlesBeginnerLevelOne;
//       case 2:
//         return lessonTitlesBeginnerLevelTwo;
//       case 3:
//         return lessonTitlesIntermediateLevelOne;
//       case 4:
//         return lessonTitlesIntermediateLevelTwo;
//       default:
//         return [];
//     }
//   }
// }
