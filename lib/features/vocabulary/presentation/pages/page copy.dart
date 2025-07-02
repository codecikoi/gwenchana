// import 'package:auto_route/auto_route.dart';
// import 'package:flutter/material.dart';
// import 'package:gwenchana/features/vocabulary/data/vocabulary_data.dart';

// @RoutePage()
// class VocabularyPage extends StatefulWidget {
//   const VocabularyPage({super.key});

//   @override
//   State<VocabularyPage> createState() => _VocabularyPageState();
// }

// class _VocabularyPageState extends State<VocabularyPage>
//     with SingleTickerProviderStateMixin {
//   List<VocabularyCard> cards = List.from(vocabularyCards);

//   int currentIndex = 0;
//   bool showEnglish = false;
//   late AnimationController _controller;
//   late Animation<double> _animation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: Duration(milliseconds: 400),
//       vsync: this,
//     );
//     _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void nextCard() {
//     setState(() {
//       if (currentIndex < cards.length - 1) {
//         currentIndex++;
//         showEnglish = false;
//         _controller.reset();
//       }
//     });
//   }

//   void prevCard() {
//     setState(() {
//       if (currentIndex > 0) {
//         currentIndex--;
//         showEnglish = false;
//         _controller.reset();
//       }
//     });
//   }

//   void addCard(String korean, String english) {
//     setState(() {
//       cards.add(VocabularyCard(korean: korean, english: english));
//     });
//   }

//   void showAddCardDialog() {
//     String korean = '';
//     String english = '';
//     String? errorText;
//     showDialog(
//       context: context,
//       builder: (context) => StatefulBuilder(
//         builder: (context, setState) => AlertDialog(
//           title: Text('Добавить карточку'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 decoration: InputDecoration(labelText: 'Корейское слово'),
//                 onChanged: (value) {
//                   korean = value;
//                   setState(() => errorText = null);
//                 },
//               ),
//               TextField(
//                 decoration: InputDecoration(labelText: 'Перевод (англ.)'),
//                 onChanged: (value) {
//                   english = value;
//                   setState(() => errorText = null);
//                 },
//               ),
//               if (errorText != null)
//                 Padding(
//                   padding: const EdgeInsets.only(top: 8.0),
//                   child: Text(
//                     errorText!,
//                     style: TextStyle(color: Colors.red),
//                   ),
//                 ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 final koreanReg =
//                     RegExp(r'^[\uac00-\ud7af\u1100-\u11ff\u3130-\u318f ]+$');
//                 final englishReg = RegExp(r'^[A-Za-z ]+$');
//                 if (korean.isEmpty || english.isEmpty) {
//                   setState(() => errorText = 'Поля не должны быть пустыми');
//                   return;
//                 }
//                 if (!koreanReg.hasMatch(korean)) {
//                   setState(() => errorText =
//                       'Корейское слово должно содержать только корейские символы');
//                   return;
//                 }
//                 if (!englishReg.hasMatch(english)) {
//                   setState(() =>
//                       errorText = 'Перевод должен быть на английском языке');
//                   return;
//                 }
//                 addCard(korean, english);
//                 Navigator.of(context).pop();
//               },
//               child: Text('Добавить'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void flipCard() {
//     if (showEnglish) {
//       _controller.reverse();
//     } else {
//       _controller.forward();
//     }
//     setState(() {
//       showEnglish = !showEnglish;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final card = cards[currentIndex];
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Карточки'),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () => context.router.pushPath('/app-page'),
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.add),
//             onPressed: showAddCardDialog,
//           ),
//         ],
//         bottom: PreferredSize(
//           preferredSize: Size.fromHeight(4.0),
//           child: LinearProgressIndicator(
//             value: (currentIndex + 1) / cards.length,
//             backgroundColor: Colors.grey[300],
//             valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
//           ),
//         ),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             '${currentIndex + 1} / ${cards.length}',
//             style: TextStyle(fontSize: 18),
//           ),
//           SizedBox(height: 20),
//           GestureDetector(
//             onTap: flipCard,
//             child: AnimatedBuilder(
//               animation: _animation,
//               builder: (context, child) {
//                 final isUnder = (_animation.value > 0.5);
//                 final displayText = isUnder ? card.english : card.korean;
//                 return Transform(
//                   alignment: Alignment.center,
//                   transform: Matrix4.identity()
//                     ..setEntry(3, 2, 0.001)
//                     ..rotateY(3.1416 * _animation.value),
//                   child: isUnder
//                       ? Transform(
//                           alignment: Alignment.center,
//                           transform: Matrix4.identity()..rotateY(3.1416),
//                           child: Container(
//                             width: 300,
//                             height: 200,
//                             alignment: Alignment.center,
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(16),
//                               boxShadow: [
//                                 BoxShadow(blurRadius: 8, color: Colors.black12)
//                               ],
//                             ),
//                             child: Text(
//                               displayText,
//                               style: TextStyle(fontSize: 32),
//                               textAlign: TextAlign.center,
//                             ),
//                           ),
//                         )
//                       : Container(
//                           width: 300,
//                           height: 200,
//                           alignment: Alignment.center,
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(16),
//                             boxShadow: [
//                               BoxShadow(blurRadius: 8, color: Colors.black12)
//                             ],
//                           ),
//                           child: Text(
//                             displayText,
//                             style: TextStyle(fontSize: 32),
//                             textAlign: TextAlign.center,
//                           ),
//                         ),
//                 );
//               },
//             ),
//           ),
//           SizedBox(height: 40),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               IconButton(
//                 icon: Icon(Icons.arrow_back),
//                 iconSize: 40,
//                 onPressed: prevCard,
//               ),
//               SizedBox(width: 60),
//               IconButton(
//                 icon: Icon(Icons.arrow_forward),
//                 iconSize: 40,
//                 onPressed: nextCard,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
