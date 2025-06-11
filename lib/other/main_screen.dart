// import 'package:flutter/material.dart';
// import 'package:flutter_localization/flutter_localization.dart';
// import 'package:gwenchana/presentation/app_localization.dart';

// class MainScreen extends StatelessWidget {
//   final VoidCallback onLanguageChange;

//   const MainScreen({super.key, required this.onLanguageChange});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(AppLocale.title.getString(context)),
//         backgroundColor: const Color(0xFF4CAF50),
//         foregroundColor: Colors.white,
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.settings),
//             onPressed: () {
//               _showLanguageChangeDialog(context);
//             },
//           ),
//         ],
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Color(0xFF4CAF50),
//               Color(0xFF66BB6A),
//             ],
//           ),
//         ),
//         child: SafeArea(
//           child: Center(
//             child: Padding(
//               padding: const EdgeInsets.all(24.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   // Иконка добро пожаловать
//                   Container(
//                     width: 120,
//                     height: 120,
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.2),
//                       shape: BoxShape.circle,
//                     ),
//                     child: const Icon(
//                       Icons.check_circle_outline,
//                       size: 80,
//                       color: Colors.white,
//                     ),
//                   ),

//                   const SizedBox(height: 32),

//                   // Заголовок
//                   Text(
//                     AppLocale.welcome.getString(context),
//                     style: const TextStyle(
//                       fontSize: 36,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),

//                   const SizedBox(height: 16),

//                   // Описание
//                   Text(
//                     AppLocale.description.getString(context),
//                     style: const TextStyle(
//                       fontSize: 18,
//                       color: Colors.white,
//                       height: 1.5,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),

//                   const SizedBox(height: 48),

//                   // Кнопка изменения языка
//                   ElevatedButton.icon(
//                     onPressed: () {
//                       onLanguageChange();
//                     },
//                     icon: const Icon(Icons.language),
//                     label: Text(AppLocale.changeLanguage.getString(context)),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.white,
//                       foregroundColor: const Color(0xFF4CAF50),
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 24, vertical: 12),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(25),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void _showLanguageChangeDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(AppLocale.settings.getString(context)),
//           content: Text(AppLocale.changeLanguage.getString(context)),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 onLanguageChange();
//               },
//               child: const Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
