import 'package:gwenchana/features/vocabulary/data/vocabulary_begginer_one_data.dart';
import 'package:gwenchana/features/vocabulary/data/vocabulary_beginner_two_data.dart';
import 'package:gwenchana/features/vocabulary/data/vocabulary_elementary_data.dart';
import 'package:gwenchana/features/vocabulary/data/vocabulary_intermediate_one.dart';
import 'package:gwenchana/features/vocabulary/data/vocabulary_intermediate_two.dart';

class VocabularyService {
  static List<Map<String, String>> getWordsForWriting(int level, int setIndex) {
    switch (level) {
      case 1:
        return getBeginnerOneLessonDataSet(setIndex + 1).map((data) {
          return {'korean': data.korean, 'english': data.english};
        }).toList();

      case 2:
        return getBeginnerTwoLessonDataSet(setIndex + 1).map((data) {
          return {'korean': data.korean, 'english': data.english};
        }).toList();

      case 3:
        return getElementaryLessonDataSet(setIndex + 1).map((data) {
          return {'korean': data.korean, 'english': data.english};
        }).toList();
      case 4:
        return getIntermediateOneLessonDataSet(setIndex + 1).map((data) {
          return {'korean': data.korean, 'english': data.english};
        }).toList();
      case 5:
        return getIntermediateTwoLessonDataSet(setIndex + 1).map((data) {
          return {'korean': data.korean, 'english': data.english};
        }).toList();
      default:
        return [];
    }
  }
}
