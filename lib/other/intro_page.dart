// import 'package:flutter/material.dart';
// import 'package:gwenchana/presentation/pages/choose_lang_page.dart';

// class IntroPage extends StatefulWidget {
//   const IntroPage({super.key});

//   @override
//   State<IntroPage> createState() => _IntroPageState();
// }

// class _IntroPageState extends State<IntroPage> {
//   @override
//   void initState() {
//     super.initState();
//     redirect();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Text('SOON HERE WILL BE LOGO'),
//       ),
//     );
//   }

//   Future<void> redirect() async {
//     await Future.delayed(const Duration(seconds: 2));
//     if (mounted) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (BuildContext context) =>
//               ChooseLangPage(onLanguageSelected: () {}),
//         ),
//       );
//     }
//   }
// }
