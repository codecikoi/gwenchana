import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class VocabularyCard {
  final String korean;
  final String english;

  VocabularyCard({required this.korean, required this.english});
}

class VocabularyPage extends StatefulWidget {
  const VocabularyPage({super.key});

  @override
  State<VocabularyPage> createState() => _VocabularyPageState();
}

class _VocabularyPageState extends State<VocabularyPage>
    with SingleTickerProviderStateMixin {
  List<VocabularyCard> cards = [
    VocabularyCard(korean: '안녕하세요', english: 'Hello'),
    VocabularyCard(korean: '이름', english: 'Name'),
    VocabularyCard(korean: '직업', english: 'Job/Occupation'),
    VocabularyCard(korean: '국적', english: 'Nationality'),
    VocabularyCard(korean: '어느', english: 'Which'),
    VocabularyCard(korean: '나라', english: 'Country'),
    VocabularyCard(korean: '시원', english: 'Cool/Refreshing'),
    VocabularyCard(korean: '한국', english: 'Korea'),
    VocabularyCard(korean: '미국', english: 'America/USA'),
    VocabularyCard(korean: '중국', english: 'China'),
    VocabularyCard(korean: '일본', english: 'Japan'),
    VocabularyCard(korean: '학교에서', english: 'At school'),
    VocabularyCard(korean: '선생님', english: 'Teacher'),
    VocabularyCard(korean: '회사원', english: 'Office worker'),
    VocabularyCard(korean: '영어 강사', english: 'English instructor'),
    VocabularyCard(korean: '의사', english: 'Doctor'),
    VocabularyCard(korean: '브라질', english: 'Brazil'),
    VocabularyCard(korean: '뉴욕', english: 'New York'),
    VocabularyCard(korean: '영어', english: 'English'),
    VocabularyCard(korean: '한국어', english: 'Korean'),
  ];
  int currentIndex = 0;
  bool showEnglish = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void nextCard() {
    setState(() {
      if (currentIndex < cards.length - 1) {
        currentIndex++;
        showEnglish = false;
        _controller.reset();
      }
    });
  }

  void prevCard() {
    setState(() {
      if (currentIndex > 0) {
        currentIndex--;
        showEnglish = false;
        _controller.reset();
      }
    });
  }

  void addCard(String korean, String english) {
    setState(() {
      cards.add(VocabularyCard(korean: korean, english: english));
    });
  }

  void showAddCardDialog() {
    String korean = '';
    String english = '';
    String? errorText;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Добавить карточку'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Корейское слово'),
                onChanged: (value) {
                  korean = value;
                  setState(() => errorText = null);
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Перевод (англ.)'),
                onChanged: (value) {
                  english = value;
                  setState(() => errorText = null);
                },
              ),
              if (errorText != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    errorText!,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final koreanReg =
                    RegExp(r'^[\uac00-\ud7af\u1100-\u11ff\u3130-\u318f ]+$');
                final englishReg = RegExp(r'^[A-Za-z ]+$');
                if (korean.isEmpty || english.isEmpty) {
                  setState(() => errorText = 'Поля не должны быть пустыми');
                  return;
                }
                if (!koreanReg.hasMatch(korean)) {
                  setState(() => errorText =
                      'Корейское слово должно содержать только корейские символы');
                  return;
                }
                if (!englishReg.hasMatch(english)) {
                  setState(() =>
                      errorText = 'Перевод должен быть на английском языке');
                  return;
                }
                addCard(korean, english);
                Navigator.of(context).pop();
              },
              child: Text('Добавить'),
            ),
          ],
        ),
      ),
    );
  }

  void flipCard() {
    if (showEnglish) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    setState(() {
      showEnglish = !showEnglish;
    });
  }

  @override
  Widget build(BuildContext context) {
    final card = cards[currentIndex];
    return Scaffold(
      appBar: AppBar(
        title: Text('Карточки'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => context.go('/app-page'),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: showAddCardDialog,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4.0),
          child: LinearProgressIndicator(
            value: (currentIndex + 1) / cards.length,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${currentIndex + 1} / ${cards.length}',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 20),
          GestureDetector(
            onTap: flipCard,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                final isUnder = (_animation.value > 0.5);
                final displayText = isUnder ? card.english : card.korean;
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(3.1416 * _animation.value),
                  child: isUnder
                      ? Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()..rotateY(3.1416),
                          child: Container(
                            width: 300,
                            height: 200,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(blurRadius: 8, color: Colors.black12)
                              ],
                            ),
                            child: Text(
                              displayText,
                              style: TextStyle(fontSize: 32),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : Container(
                          width: 300,
                          height: 200,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(blurRadius: 8, color: Colors.black12)
                            ],
                          ),
                          child: Text(
                            displayText,
                            style: TextStyle(fontSize: 32),
                            textAlign: TextAlign.center,
                          ),
                        ),
                );
              },
            ),
          ),
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                iconSize: 40,
                onPressed: prevCard,
              ),
              SizedBox(width: 60),
              IconButton(
                icon: Icon(Icons.arrow_forward),
                iconSize: 40,
                onPressed: nextCard,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
