import 'package:gwenchana/core/data/models/words_data_raw.dart';

class ElementaryDataSource {
  final List<List<WordsDataRaw>> lessons = [
    _elementaryLesson1,
    _elementaryLesson2,
    _elementaryLesson3,
    _elementaryLesson4,
  ];

  final String title = '기조';

  final List<String> lessonTitles = [
    '한글의 기초',
    '모음과 자음 I',
    '모음과 자음 II',
    '받침과 유용한 표현',
  ];

  // Set 1:
  static final List<WordsDataRaw> _elementaryLesson1 = [
    WordsDataRaw(korean: '가족', english: 'Family'),
    WordsDataRaw(korean: '부모님', english: 'Parents'),
    WordsDataRaw(korean: '아버지', english: 'Father'),
    WordsDataRaw(korean: '어머니', english: 'Mother'),
    WordsDataRaw(korean: '아들', english: 'Son'),
    WordsDataRaw(korean: '딸', english: 'Daughter'),
    WordsDataRaw(korean: '형', english: 'Older brother (for males)'),
    WordsDataRaw(korean: '누나', english: 'Older sister (for males)'),
    WordsDataRaw(korean: '오빠', english: 'Older brother (for females)'),
    WordsDataRaw(korean: '언니', english: 'Older sister (for females)'),
    WordsDataRaw(korean: '동생', english: 'Younger sibling'),
    WordsDataRaw(korean: '할아버지', english: 'Grandfather'),
    WordsDataRaw(korean: '할머니', english: 'Grandmother'),
    WordsDataRaw(korean: '삼촌', english: 'Uncle'),
    WordsDataRaw(korean: '사촌', english: 'Cousin'),
    WordsDataRaw(korean: '남편', english: 'Husband'),
    WordsDataRaw(korean: '아내', english: 'Wife'),
    WordsDataRaw(korean: '친구', english: 'Friend'),
    WordsDataRaw(korean: '애인', english: 'Lover/Boyfriend/Girlfriend'),
    WordsDataRaw(korean: '아기', english: 'Baby'),
    WordsDataRaw(korean: '어른', english: 'Adult'),
    WordsDataRaw(korean: '아이', english: 'Child'),
    WordsDataRaw(korean: '이웃', english: 'Neighbor'),
    WordsDataRaw(korean: '가정', english: 'Household'),
  ];

  // Set 2:
  static final List<WordsDataRaw> _elementaryLesson2 = [
    WordsDataRaw(korean: '음식', english: 'Food'),
    WordsDataRaw(korean: '밥', english: 'Rice/Meal'),
    WordsDataRaw(korean: '물', english: 'Water'),
    WordsDataRaw(korean: '김치', english: 'Kimchi'),
    WordsDataRaw(korean: '라면', english: 'Ramen'),
    WordsDataRaw(korean: '불고기', english: 'Bulgogi'),
    WordsDataRaw(korean: '비빔밥', english: 'Bibimbap'),
    WordsDataRaw(korean: '치킨', english: 'Chicken'),
    WordsDataRaw(korean: '피자', english: 'Pizza'),
    WordsDataRaw(korean: '햄버거', english: 'Hamburger'),
    WordsDataRaw(korean: '커피', english: 'Coffee'),
    WordsDataRaw(korean: '차', english: 'Tea'),
    WordsDataRaw(korean: '맥주', english: 'Beer'),
    WordsDataRaw(korean: '소주', english: 'Soju'),
    WordsDataRaw(korean: '우유', english: 'Milk'),
    WordsDataRaw(korean: '주스', english: 'Juice'),
    WordsDataRaw(korean: '과일', english: 'Fruit'),
    WordsDataRaw(korean: '사과', english: 'Apple'),
    WordsDataRaw(korean: '바나나', english: 'Banana'),
    WordsDataRaw(korean: '딸기', english: 'Strawberry'),
    WordsDataRaw(korean: '빵', english: 'Bread'),
    WordsDataRaw(korean: '케이크', english: 'Cake'),
    WordsDataRaw(korean: '아이스크림', english: 'Ice cream'),
    WordsDataRaw(korean: '계란', english: 'Egg'),
    WordsDataRaw(korean: '고기', english: 'Meat'),
    WordsDataRaw(korean: '야채', english: 'Vegetables'),
  ];

// Set 3:
  static final List<WordsDataRaw> _elementaryLesson3 = [
    WordsDataRaw(korean: '색깔', english: 'Color'),
    WordsDataRaw(korean: '빨간색', english: 'Red'),
    WordsDataRaw(korean: '파란색', english: 'Blue'),
    WordsDataRaw(korean: '노란색', english: 'Yellow'),
    WordsDataRaw(korean: '초록색', english: 'Green'),
    WordsDataRaw(korean: '보라색', english: 'Purple'),
    WordsDataRaw(korean: '주황색', english: 'Orange'),
    WordsDataRaw(korean: '분홍색', english: 'Pink'),
    WordsDataRaw(korean: '갈색', english: 'Brown'),
    WordsDataRaw(korean: '검은색', english: 'Black'),
    WordsDataRaw(korean: '흰색', english: 'White'),
    WordsDataRaw(korean: '회색', english: 'Gray'),
    WordsDataRaw(korean: '금색', english: 'Gold'),
    WordsDataRaw(korean: '은색', english: 'Silver'),
    WordsDataRaw(korean: '모양', english: 'Shape'),
    WordsDataRaw(korean: '원', english: 'Circle'),
    WordsDataRaw(korean: '사각형', english: 'Rectangle'),
    WordsDataRaw(korean: '삼각형', english: 'Triangle'),
    WordsDataRaw(korean: '정사각형', english: 'Square'),
    WordsDataRaw(korean: '별', english: 'Star'),
    WordsDataRaw(korean: '하트', english: 'Heart'),
    WordsDataRaw(korean: '선', english: 'Line'),
    WordsDataRaw(korean: '점', english: 'Dot/Point'),
    WordsDataRaw(korean: '크기', english: 'Size'),
    WordsDataRaw(korean: '큰', english: 'Big'),
    WordsDataRaw(korean: '작은', english: 'Small'),
  ];

// Set 4:
  static final List<WordsDataRaw> _elementaryLesson4 = [
    WordsDataRaw(korean: '숫자', english: 'Number'),
    WordsDataRaw(korean: '일', english: 'One'),
    WordsDataRaw(korean: '이', english: 'Two'),
    WordsDataRaw(korean: '삼', english: 'Three'),
    WordsDataRaw(korean: '사', english: 'Four'),
    WordsDataRaw(korean: '오', english: 'Five'),
    WordsDataRaw(korean: '육', english: 'Six'),
    WordsDataRaw(korean: '칠', english: 'Seven'),
    WordsDataRaw(korean: '팔', english: 'Eight'),
    WordsDataRaw(korean: '구', english: 'Nine'),
    WordsDataRaw(korean: '십', english: 'Ten'),
    WordsDataRaw(korean: '시간', english: 'Time'),
    WordsDataRaw(korean: '분', english: 'Minute'),
    WordsDataRaw(korean: '초', english: 'Second'),
    WordsDataRaw(korean: '시', english: 'Hour/O\'clock'),
    WordsDataRaw(korean: '오늘', english: 'Today'),
    WordsDataRaw(korean: '어제', english: 'Yesterday'),
    WordsDataRaw(korean: '내일', english: 'Tomorrow'),
    WordsDataRaw(korean: '지금', english: 'Now'),
    WordsDataRaw(korean: '아침', english: 'Morning'),
    WordsDataRaw(korean: '점심', english: 'Lunch/Noon'),
    WordsDataRaw(korean: '저녁', english: 'Evening/Dinner'),
    WordsDataRaw(korean: '밤', english: 'Night'),
    WordsDataRaw(korean: '주', english: 'Week'),
    WordsDataRaw(korean: '달', english: 'Month'),
    WordsDataRaw(korean: '년', english: 'Year'),
  ];
}
