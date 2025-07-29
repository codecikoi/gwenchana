import 'package:gwenchana/core/domain/models/words_data.dart';

class Book {
  final String title;
  final List<Lesson> lessons;

  Book({
    required this.title,
    required this.lessons,
  });
}

class Lesson {
  final String title;

  final List<WordsData> words;

  Lesson({
    required this.title,
    required this.words,
  });
}
