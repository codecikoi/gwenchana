import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gwenchana/core/helper/basic_appbar.dart';
import 'package:gwenchana/features/writing/presentation/widgets/grid_painter.dart';
import 'package:gwenchana/gen_l10n/app_localizations.dart';

@RoutePage()
class WritingPage extends StatefulWidget {
  const WritingPage({super.key});

  @override
  State<WritingPage> createState() => _WritingPageState();
}

class _WritingPageState extends State<WritingPage> {
  final TextEditingController _controller = TextEditingController();

  List<Map<String, String>> words = [
    {'korean': '오이', 'english': 'Cucumber'},
    {'korean': '사과', 'english': 'Apple'},
    {'korean': '바나나', 'english': 'Banana'},
    {'korean': '토마토', 'english': 'Tomato'},
    {'korean': '당근', 'english': 'Carrot'},
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
      isCorrect = userInput.trim() == words[currentIndex]['korean'];
      showResult = true;
    });
  }

  void nextWord() {
    setState(() {
      if (currentIndex < words.length - 1) {
        currentIndex++;
        userInput = '';
        _controller.clear();
        showResult = false;
        hasStudied = false;
      }
    });
  }

  void skipWord() {
    setState(() {
      hasStudied = false;
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(height: 40),

                  // writing place
                  Text(
                    'Please write translation into korean language',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        words[currentIndex]['english']!,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                  const SizedBox(height: 60),

                  // writing area
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(0xFF3C3C3E),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey[600]!,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          // grid pattern of writing area
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: CustomPaint(
                                painter: GridPainter(),
                                child: Center(
                                  child: TextField(
                                    style: TextStyle(
                                      color: Color(0xFF00D4AA),
                                      fontSize: 48,
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

                          //action button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                onPressed: () {
                                  // Undo functionality
                                },
                                icon: Icon(
                                  Icons.undo,
                                  color: Color(0xFF00D4AA),
                                  size: 28,
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
                                  Icons.delete_outline,
                                  color: Color(0xFF00D4AA),
                                  size: 28,
                                ),
                              ),

                              //spelling
                              IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.headphones,
                                  color: Color(0xFF00D4AA),
                                  size: 28,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),
                          if (showResult)
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                isCorrect
                                    ? '정답입니다! 🎉'
                                    : '틀렸습니다. 정답: ${words[currentIndex]['korean']}',
                                style: TextStyle(
                                  color: isCorrect ? Colors.green : Colors.red,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),

                          // Study warning
                          if (!hasStudied && !showResult)
                            Text(
                              'Haizz, you haven\'t studied!',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                              ),
                            ),

                          SizedBox(height: 20),

                          // Test and Skip buttons
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: showResult
                                      ? (currentIndex < words.length - 1
                                          ? nextWord
                                          : null)
                                      : (userInput.isNotEmpty
                                          ? checkAnswer
                                          : null),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF00D4AA),
                                    foregroundColor: Colors.black,
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),
                                  child: Text(
                                    showResult
                                        ? (currentIndex < words.length - 1
                                            ? 'Next'
                                            : 'Finish')
                                        : 'Test',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 10),

                          TextButton(
                            onPressed: skipWord,
                            child: Text(
                              'Skip',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 16,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),

                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
