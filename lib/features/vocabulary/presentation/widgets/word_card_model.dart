import 'package:hive/hive.dart';
part 'word_card_model.g.dart';

@HiveType(typeId: 0)
class MyCard {
  @HiveField(0)
  final String korean;

  @HiveField(1)
  final String translation;

  // @HiveField(3)
  // final String id;

  MyCard({
    required this.korean,
    required this.translation,
    // required this.id,
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
