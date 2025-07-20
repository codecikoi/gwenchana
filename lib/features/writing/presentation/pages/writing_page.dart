import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gwenchana/core/helper/validation_helper.dart';
import 'package:gwenchana/features/writing/presentation/widgets/grid_painter.dart';

@RoutePage()
class WritingSkillPage extends StatefulWidget {
  const WritingSkillPage({super.key});

  @override
  State<WritingSkillPage> createState() => _WritingSkillPageState();
}

class _WritingSkillPageState extends State<WritingSkillPage> {
  final TextEditingController _controller = TextEditingController();

  final List<Map<String, String>> words = [
    {'korean': '이름', 'english': 'Name'},
    {'korean': '직업', 'english': 'Occupation'},
    {'korean': '국적', 'english': 'Nationality'},
    {'korean': '어느', 'english': 'Which'},
    {'korean': '나라', 'english': 'Country'},
    {'korean': '사람', 'english': 'Person'},
    {'korean': '한국', 'english': 'Korea'},
    {'korean': '필리핀', 'english': 'Philippines'},
    {'korean': '미국', 'english': 'USA'},
    {'korean': '이집트', 'english': 'Egypt'},
    {'korean': '중국', 'english': 'China'},
    {'korean': '방글라데시', 'english': 'Bangladesh'},
    {'korean': '선생님', 'english': 'Teacher'},
    {'korean': '회사원', 'english': 'Office Worker'},
    {'korean': '영어 강사', 'english': 'English Instructor'},
    {'korean': '학생', 'english': 'Student'},
    {'korean': '공장 직원', 'english': 'Factory Worker'},
    {'korean': '판매원', 'english': 'Salesperson'},
    {'korean': '주부', 'english': 'Housewife'},
    {'korean': '초등학생', 'english': 'Elementary School Student'},
    {'korean': '뉴욕', 'english': 'New York'},
    {'korean': '영어', 'english': 'English'},
    {'korean': '한국어', 'english': 'Korean Language'},
    {'korean': '회사', 'english': 'Company'},
    {'korean': '기숙사', 'english': 'Dormitory'},
    {'korean': '책상', 'english': 'Desk'},
    {'korean': '의자', 'english': 'Chair'},
    {'korean': '침대', 'english': 'Bed'},
    {'korean': '컴퓨터', 'english': 'Computer'},
    {'korean': '휴대 전화', 'english': 'Cell phone'},
    {'korean': '시계', 'english': 'Clock/Watch'},
    {'korean': '학교', 'english': 'School'},
    {'korean': '교실', 'english': 'Classroom'},
    {'korean': '칠판', 'english': 'Blackboard'},
    {'korean': '지도', 'english': 'Map'},
    {'korean': '책', 'english': 'Book'},
    {'korean': '필통', 'english': 'Pencil case'},
    {'korean': '볼펜', 'english': 'Ballpoint pen'},
    {'korean': '화장실', 'english': 'Restroom'},
    {'korean': '수건', 'english': 'Towel'},
    {'korean': '거울', 'english': 'Mirror'},
    {'korean': '휴지', 'english': 'Tissue'},
    {'korean': '가방', 'english': 'Bag'},
    {'korean': '에어컨', 'english': 'Air conditioner'},
    {'korean': '소파', 'english': 'Sofa'},
    {'korean': '부엌', 'english': 'Kitchen'},
    {'korean': '컵', 'english': 'Cup'},
    {'korean': '냉장고', 'english': 'Refrigerator'},
    {'korean': '하지만', 'english': 'But'},
    {'korean': '옷장', 'english': 'Closet'},
    {'korean': '그리고', 'english': 'And'},
    {'korean': '싸다', 'english': 'Cheap'},
    {'korean': '비싸다', 'english': 'Expensive'},
    {'korean': '많다', 'english': 'Many'},
    {'korean': '적다', 'english': 'Few'},
    {'korean': '크다', 'english': 'Big'},
    {'korean': '작다', 'english': 'Small'},
    {'korean': '맛있다', 'english': 'Delicious'},
    {'korean': '맛없다', 'english': 'Not tasty'},
    {'korean': '쉽다', 'english': 'Easy'},
    {'korean': '어렵다', 'english': 'Difficult'},
    {'korean': '덥다', 'english': 'Hot'},
    {'korean': '재미있다', 'english': 'Interesting/Fun'},
    {'korean': '재미없다', 'english': 'Not interesting'},
    {'korean': '좋다', 'english': 'Good'},
    {'korean': '나쁘다', 'english': 'Bad'},
    {'korean': '예쁘다', 'english': 'Pretty'},
    {'korean': '바쁘다', 'english': 'Busy'},
    {'korean': '아프다', 'english': 'Sick/Hurt'},
    {'korean': '배가 고프다', 'english': 'Hungry'},
    {'korean': '고향 음식을 요리하다', 'english': 'Cook hometown food'},
    {'korean': '찬을 읽다', 'english': 'Read a book'},
    {'korean': '한국어를 공부하다', 'english': 'Study Korean'},
    {'korean': '텔레비전을 보다', 'english': 'Watch TV'},
    {'korean': '커피를 마시다', 'english': 'Drink coffee'},
    {'korean': '방을 청소하다', 'english': 'Clean the room'},
    {'korean': '밥을 먹다', 'english': 'Eat a meal'},
  ];

  int currentIndex = 0;
  String userInput = '';
  bool showResult = false;
  bool isCorrect = false;
  bool hasStudied = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void checkAnswer() {
    setState(() {
      // Сравниваем ответы без учёта регистра и лишних пробелов
      final correct = words[currentIndex]['korean']?.trim() ?? '';
      isCorrect = userInput.trim() == correct;
      showResult = true;
      hasStudied = true; // Теперь отмечаем, что пользователь изучил слово
    });
  }

  void nextWord() {
    setState(() {
      if (currentIndex < words.length - 1) {
        currentIndex++;
        userInput = '';
        _controller.clear();
        showResult = false;
        hasStudied = false; // Сброс при переходе к новому слову
      }
    });
  }

  void previousWord() {
    setState(() {
      if (currentIndex > 0) {
        currentIndex--;
        userInput = '';
        _controller.clear();
        hasStudied = false;
        showResult = false;
      }
    });
  }

  void skipWord() {
    setState(() {
      hasStudied = false;
      showResult = false; // Сброс результата при пропуске
    });
    nextWord();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2C2C2E),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF2C2C2E),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: Text(
          '${currentIndex + 1} / ${words.length}',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // refresh progress by bloc
            },
            icon: Icon(
              Icons.refresh,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // progress indicator
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: LinearProgressIndicator(
              value: (currentIndex + 1) / words.length,
              backgroundColor: Colors.grey[700],
              valueColor: AlwaysStoppedAnimation<Color>(
                Color(0xFF00D4AA),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // writing place
                Center(
                  child: Text(
                    words[currentIndex]['english']!,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 3,
                  ),
                ),
                const SizedBox(height: 60),
                Align(
                  alignment: Alignment.topRight,
                  child: Builder(
                    builder: (context) {
                      return IconButton(
                        onPressed: () async {
                          final button =
                              context.findRenderObject() as RenderBox;
                          final overlay = Overlay.of(context)
                              .context
                              .findRenderObject() as RenderBox;
                          final position = button.localToGlobal(Offset.zero,
                              ancestor: overlay);
                          await showMenu(
                            context: context,
                            position: RelativeRect.fromLTRB(
                              position.dx,
                              position.dy + button.size.height,
                              overlay.size.width -
                                  position.dx -
                                  button.size.width,
                              overlay.size.height - position.dy,
                            ),
                            items: [
                              PopupMenuItem(
                                enabled: false,
                                child: Text(
                                  'Correct answer:\n ${words[currentIndex]['korean']}',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                            color: Colors.black87,
                            elevation: 8.0,
                          );
                        },
                        icon: Icon(
                          Icons.tips_and_updates_rounded,
                        ),
                        iconSize: 24,
                        color: Colors.orangeAccent,
                      );
                    },
                  ),
                ),

                // writing area
                Container(
                  height: 350,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xFF3C3C3E),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: Colors.grey[600]!,
                      width: 1,
                    ),
                  ),
                  child: CustomPaint(
                    painter: GridPainter(),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: TextField(
                          controller: _controller,
                          maxLength: 75,
                          maxLines: 4,
                          inputFormatters:
                              ValidationHelper.koreanInputFormatters,
                          style: TextStyle(
                            color: Color(0xFF00D4AA),
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '여기에 쓰세요',
                            hintStyle: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 28,
                            ),
                            errorText: _controller.text.isEmpty
                                ? null
                                : ValidationHelper.getKoreanError(
                                    _controller.text, context),
                          ),
                          onChanged: (value) {
                            setState(() {
                              userInput = value;
                              showResult = false;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                //spelling // TODO: spelling
                // IconButton(
                //   onPressed: () {},
                //   icon: Icon(
                //     Icons.volume_up,
                //     color: Color(0xFF00D4AA),
                //     size: 28,
                //   ),
                // ),
                //action button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: previousWord,
                      child: Text(
                        'Back',
                        style: TextStyle(
                          color: currentIndex > 1
                              ? Color(0xFF00D4AA)
                              : Colors.grey[600],
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),

                    //delete button
                    IconButton(
                      onPressed: () {
                        setState(() {
                          userInput = '';
                          _controller.clear();
                        });
                      },
                      icon: Icon(
                        Icons.delete_outline_outlined,
                        color: Color(0xFF00D4AA),
                        size: 28,
                      ),
                    ),
                    TextButton(
                      onPressed: skipWord,
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          color: currentIndex == words.length - 1
                              ? Colors.grey[600]
                              : Color(0xFF00D4AA),
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 70),
                // Test and Skip buttons
                Container(
                  width: double.infinity,
                  color: Colors.grey[700],
                  child: ElevatedButton(
                    onPressed: showResult
                        ? (currentIndex < words.length - 1 ? nextWord : null)
                        : (userInput.isNotEmpty ? checkAnswer : null),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: !showResult
                          ? (userInput.isNotEmpty ? Colors.green : Colors.grey)
                          : (isCorrect ? Colors.green : Colors.deepOrange),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Text(
                      !showResult
                          ? 'Check'
                          : (isCorrect
                              ? (currentIndex < words.length - 1
                                  ? 'Next'
                                  : 'Finish')
                              : 'Retry'),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
