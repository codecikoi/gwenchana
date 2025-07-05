import 'package:hive/hive.dart';

class MyCard {
  final String korean;
  final String translation;

  MyCard({
    required this.korean,
    required this.translation,
  });

  Map<String, dynamic> toMap() => {
        "korean": korean,
        "translation": translation,
      };

  factory MyCard.fromMap(Map map) => MyCard(
        korean: map["korean"] ?? '',
        translation: map["translation"] ?? '',
      );
}

Future<List<MyCard>> getAllCards() async {
  final box = await Hive.openBox<MyCard>('my_cards');
  return box.values.toList();
}

Future<void> addToFavorites(MyCard card) async {
  final favBox = await Hive.openBox('favorites');
  await favBox.add(card.toMap());
}

Future<List<MyCard>> getFavorites() async {
  final favBox = await Hive.openBox('favorites');
  return favBox.values
      .map((e) => MyCard.fromMap(Map<String, dynamic>.from(e)))
      .toList();
}
