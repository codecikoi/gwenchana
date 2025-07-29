import 'package:gwenchana/core/shared/lesson_titles.dart';
import 'package:gwenchana/core/shared_data/level_beginner_one_words_data.dart';
import 'package:gwenchana/core/shared_data/level_beginner_two_words_data.dart';
import 'package:gwenchana/core/shared_data/level_elementary_words_data.dart';
import 'package:gwenchana/core/shared_data/level_intermediate_one_words_data.dart';
import 'package:gwenchana/core/shared_data/level_intermediate_two_words_data.dart';

class GetWordsFromDataService {
  static List<Map<String, String>> getWordsForWriting(int level, int setIndex) {
    switch (level) {
      case 0:
        return getElementaryLessonDataSet(setIndex + 1).map((data) {
          return {'korean': data.korean, 'english': data.english};
        }).toList();

      case 1:
        return getBeginnerOneLessonDataSet(setIndex + 1).map((data) {
          return {'korean': data.korean, 'english': data.english};
        }).toList();

      case 2:
        return getBeginnerTwoLessonDataSet(setIndex + 1).map((data) {
          return {'korean': data.korean, 'english': data.english};
        }).toList();

      case 3:
        return getIntermediateOneLessonDataSet(setIndex + 1).map((data) {
          return {'korean': data.korean, 'english': data.english};
        }).toList();

      case 4:
        return getIntermediateTwoLessonDataSet(setIndex + 1).map((data) {
          return {'korean': data.korean, 'english': data.english};
        }).toList();
      default:
        return [];
    }
  }

  static List<String> getCardTitlesForLevel(int level) {
    switch (level) {
      case 0:
        return lessonTitlesElementaryLevel;
      case 1:
        return lessonTitlesBeginnerLevelOne;
      case 2:
        return lessonTitlesBeginnerLevelTwo;
      case 3:
        return lessonTitlesIntermediateLevelOne;
      case 4:
        return lessonTitlesIntermediateLevelTwo;
      default:
        return [];
    }
  }
}
