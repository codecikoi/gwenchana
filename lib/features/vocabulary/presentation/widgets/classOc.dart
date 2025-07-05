
  // void addCard(String korean, String english) {
  //   setState(() {
  //     cards.add(VocabularyCard(korean: korean, english: english));
  //   });
  // }

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