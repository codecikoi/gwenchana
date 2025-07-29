import 'package:gwenchana/core/shared_data/level_beginner_one_words_data.dart';
import 'package:gwenchana/core/shared_data/level_beginner_two_words_data.dart';
import 'package:gwenchana/core/shared_data/level_elementary_words_data.dart';
import 'package:gwenchana/core/shared_data/level_intermediate_one_words_data.dart';
import 'package:gwenchana/core/shared_data/level_intermediate_two_words_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gwenchana/core/shared/lesson_titles.dart';

class ProgressService {
  static const String _progressPrefix = 'vocabulary_progress';
  static const String _completedPrefix = 'vocabulary_completed';
  static const String _selectedLevel = 'selected_level';

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
    switch (level) {
      case 1:
        return lessonTitlesElementaryLevel.length;
      case 2:
        return lessonTitlesBeginnerLevelOne.length;
      case 3:
        return lessonTitlesBeginnerLevelTwo.length;
      case 4:
        return lessonTitlesIntermediateLevelOne.length;
      case 5:
        return lessonTitlesIntermediateLevelTwo.length;
      default:
        return 0;
    }
  }

  static int getTotalCardsForLevel(int level) {
    switch (level) {
      case 1:
        return allElementaryLevelDataSets.fold(
            0, (sum, set) => sum + set.length);
      case 2:
        return allBeginnerLevelOneDataSets.fold(
            0, (sum, set) => sum + set.length);
      case 3:
        return allBeginnerLevelTwoDataSets.fold(
            0, (sum, set) => sum + set.length);
      case 4:
        return allIntermediateLevelOneDataSets.fold(
            0, (sum, set) => sum + set.length);
      case 5:
        return allIntermediateLevelTwoDataSets.fold(
            0, (sum, set) => sum + set.length);
      default:
        return 0;
    }
  }

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
