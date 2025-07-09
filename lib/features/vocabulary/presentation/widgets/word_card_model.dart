import 'package:hive/hive.dart';
part 'word_card_model.g.dart';

@HiveType(typeId: 0)
class MyCard {
  @HiveField(0)
  final String korean;

  @HiveField(1)
  final String translation;

  @HiveField(2)
  final DateTime createdAt;

  MyCard({
    required this.korean,
    required this.translation,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() => {
        "korean": korean,
        "translation": translation,
        "createdAt": createdAt.toIso8601String(),
      };

  factory MyCard.fromMap(Map map) => MyCard(
        korean: map["korean"] ?? '',
        translation: map["translation"] ?? '',
        createdAt: map["createdAt"] != null
            ? DateTime.parse(map['createdAt'])
            : DateTime.now(),
      );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MyCard &&
          runtimeType == other.runtimeType &&
          korean == other.korean &&
          translation == other.translation;

  @override
  int get hashCode => korean.hashCode ^ translation.hashCode;
}

class HiveStorageService {
  static Future<void> initHive() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(MyCardAdapter());
    }
  }

  static Future<List<MyCard>> getAllCards() async {
    await initHive();
    final box = await Hive.openBox<MyCard>('my_cards');
    return box.values.toList();
  }

  static Future<void> addCard(MyCard card) async {
    await initHive();
    final box = await Hive.openBox<MyCard>('my_cards');
    await box.add(card);
  }

  static Future<void> deleteCard(int index) async {
    await initHive();
    final box = await Hive.openBox<MyCard>('my_cards');
    if (index >= 0 && index < box.length) {
      await box.deleteAt(index);
    }
  }

  static Future<void> deleteCardByContent(MyCard card) async {
    await initHive();
    final box = await Hive.openBox<MyCard>('my_cards');
    final cards = box.values.toList();
    for (int i = 0; i < cards.length; i++) {
      if (cards[i].korean == card.korean &&
          cards[i].translation == card.translation &&
          cards[i].createdAt == card.createdAt) {
        await box.deleteAt(i);
        break;
      }
    }
  }

  static Future<void> cleareAllCards() async {
    await initHive();
    final box = await Hive.openBox<MyCard>('my_cards');
    await box.clear();
  }

  static Future<List<MyCard>> getFavorites() async {
    await initHive();
    final box = await Hive.openBox<MyCard>('favorites');
    return box.values.toList();
  }

  static Future<void> addToFavorites(MyCard card) async {
    await initHive();
    final box = await Hive.openBox<MyCard>('favorites');

    final exists = box.values.any(
      (existing) =>
          existing.korean == card.korean &&
          existing.translation == card.translation,
    );
    if (!exists) {
      await box.add(card);
    }
  }

  static Future<void> removeFromFavorites(MyCard card) async {
    await initHive();
    final box = await Hive.openBox<MyCard>('favorites');
    final favorites = box.values.toList();

    for (int i = 0; i < favorites.length; i++) {
      if (favorites[i].korean == card.korean &&
          favorites[i].translation == card.translation) {
        await box.deleteAt(i);
        break;
      }
    }
  }

  static Future<bool> isFavorite(MyCard card) async {
    await initHive();
    final box = await Hive.openBox<MyCard>('favorites');
    return box.values.any(
      (existing) =>
          existing.korean == card.korean &&
          existing.translation == card.translation,
    );
  }

  static Future<void> clearAllFavorites() async {
    await initHive();
    final box = await Hive.openBox<MyCard>('favorites');
    await box.clear();
  }

  static Future<int> getCardsCount() async {
    await initHive();
    final box = await Hive.openBox<MyCard>('my_cards');
    return box.length;
  }

  static Future<int> getFavoritesCount() async {
    await initHive();
    final box = await Hive.openBox<MyCard>('favorites');
    return box.length;
  }
}

Future<List<MyCard>> getAllCards() => HiveStorageService.getAllCards();
Future<void> addToFavorites(MyCard card) =>
    HiveStorageService.addToFavorites(card);
Future<List<MyCard>> getFavorites() => HiveStorageService.getFavorites();
