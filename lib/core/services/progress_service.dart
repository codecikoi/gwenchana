import 'package:gwenchana/core/di/locator.dart';
import 'package:gwenchana/core/domain/repository/book_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/models/level.dart';

class ProgressService {
  static const String _progressPrefix = 'vocabulary_progress';
  static const String _completedPrefix = 'vocabulary_completed';
  static const String _selectedLevel = 'selected_level';

  static final BookRepository _bookRepository = locator<BookRepository>();

  // saveProgress

  static Future<void> saveProgress(
      int setIndex, int progress, int level, int total) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '${_progressPrefix}level${level}_set$setIndex';
    await prefs.setInt(key, progress);

    // for completed sets

    if (progress >= total) {
      final completedKey = '${_completedPrefix}level${level}_set$setIndex';
      await prefs.setBool(completedKey, true);
    } else {
      final completedKey = '${_completedPrefix}level${level}_set$setIndex';
      await prefs.setBool(completedKey, false);
    }
  }

  // loadProgress (для конкретного набора слов и уровня)

  static Future<int> getProgress(int setIndex, int level) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '${_progressPrefix}level${level}_set$setIndex';
    return prefs.getInt(key) ?? 0;
  }

  // loadCompleted (для конкретного набора слов и уровня)

  static Future<bool> isCompleted(int setIndex, int level) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '${_completedPrefix}level${level}_set$setIndex';
    return prefs.getBool(key) ?? false;
  }

  // getting all progress for a specific level

  static int getSetCountForLevel(int level) {
    // final levelEnum = _intToLevel(level);
    final levelEnum = Level.values[level - 1];

    final lessonTitles = _bookRepository.getLessonTitlesForLevel(levelEnum);
    return lessonTitles.length;
  }

  static int getTotalCardsForLevel(int level) {
    final levelEnum = Level.values[level - 1];
    final lessons = _bookRepository.getAllLessons(level: levelEnum);
    if (lessons == null) return 0;
    return lessons.fold(0, (sum, lesson) => sum + lesson.words.length);
  }

  // static Level _intToLevel(int levelIndex) {
  //   switch (levelIndex) {
  //     case 1:
  //       return Level.elementary;
  //     case 2:
  //       return Level.beginnerLevelOne;
  //     case 3:
  //       return Level.beginnerLevelTwo;
  //     case 4:
  //       return Level.intermediateLevelOne;
  //     case 5:
  //       return Level.intermediateLevelTwo;
  //     default:
  //       throw ArgumentError('Invalid level index: $levelIndex');
  //   }
  // }

  static Future<List<int>> getAllProgress(int level) async {
    List<int> progressList = [];
    final setCount = getSetCountForLevel(level);
    for (int i = 0; i < setCount; i++) {
      progressList.add(await getProgress(i, level));
    }
    return progressList;
  }

  // getting all completed sets for a specific level

  static Future<List<bool>> getAllCompleted(int level) async {
    List<bool> completedList = [];
    final setCount = getSetCountForLevel(level);
    for (int i = 0; i < setCount; i++) {
      completedList.add(await isCompleted(i, level));
    }
    return completedList;
  }

  // reset progress for a specific set and level

  static Future<void> resetProgress(int setIndex, int level) async {
    final prefs = await SharedPreferences.getInstance();
    final progressKey = '${_progressPrefix}level${level}_set$setIndex';
    final completedKey = '${_completedPrefix}level${level}_set$setIndex';
    await prefs.remove(progressKey);
    await prefs.remove(completedKey);
  }

  // reset all progress for a specific level

  static Future<void> resetAllProgress(int level) async {
    final prefs = await SharedPreferences.getInstance();
    final setCount = getSetCountForLevel(level);
    for (int i = 0; i < setCount; i++) {
      final progressKey = '${_progressPrefix}level${level}_set$i';
      final completedKey = '${_completedPrefix}level${level}_set$i';
      await prefs.remove(progressKey);
      await prefs.remove(completedKey);
    }
  }
  // reset all progress for all levels

  static Future<void> resetAllProgressAllLevels() async {
    for (int level = 1; level <= 5; level++) {
      await resetAllProgress(level);
    }
  }

  // save selected level

  static Future<void> saveSelectedLevel(int level) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_selectedLevel, level);
  }

  // load selected level

  static Future<int> getSelectedLevel() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_selectedLevel) ?? 1;
  }

  // getting all levels progress (for stats)

  static Future<Map<String, dynamic>> getOverallProgress() async {
    Map<String, dynamic> overallProgress = {};

    for (int level = 1; level <= 5; level++) {
      final progress = await getAllProgress(level);
      final completed = await getAllCompleted(level);

      final totalCards = getTotalCardsForLevel(level);
      final completedCards = progress.fold(0, (sum, p) => sum + p);
      final completedSets = completed.where((c) => c).length;

      overallProgress['level$level'] = {
        'totalCards': totalCards,
        'completedCards': completedCards,
        'completedSets': completedSets,
        'progressPercentage':
            totalCards > 0 ? (completedCards / totalCards * 100).round() : 0,
      };
    }
    return overallProgress;
  }
}
