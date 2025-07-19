import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gwenchana/features/choose_language/presentation/bloc/language_bloc.dart';
import 'package:gwenchana/features/choose_language/presentation/bloc/language_state.dart';
import 'package:gwenchana/core/helper/basic_appbutton.dart';
import 'package:gwenchana/features/choose_language/presentation/bloc/language_event.dart';
import 'package:gwenchana/gen_l10n/app_localizations.dart';

@RoutePage()
class ChooseLangPage extends StatefulWidget {
  const ChooseLangPage({super.key});

  @override
  State<ChooseLangPage> createState() => _ChooseLangPageState();
}

class _ChooseLangPageState extends State<ChooseLangPage> {
  String selectedLanguage = '';

  final List<Map<String, dynamic>> languages = [
    {'name': 'English', 'flag': 'assets/flags/us.png', 'code': 'en'},
    {'name': 'Uzbek', 'flag': 'assets/flags/uz.png', 'code': 'uz'},
    {'name': 'Tiếng Việt', 'flag': 'assets/flags/vn.png', 'code': 'vi'},
    {'name': 'Русский', 'flag': 'assets/flags/ru.png', 'code': 'ru'},
    {'name': 'ไทย', 'flag': 'assets/flags/th.png', 'code': 'th'},
    {'name': 'Filipino', 'flag': 'assets/flags/fr.png', 'code': 'fil'},
    {'name': '简体中文', 'flag': 'assets/flags/cn.png', 'code': 'zh_CN'},
  ];

  void _selectLanguage(String languageCode) {
    setState(() {
      selectedLanguage = languageCode;
    });
    // отправляем событие в LanguageBloc
  }

  void _confirmLanguageSelection() {
    if (selectedLanguage.isNotEmpty) {
      context.read<LanguageBloc>().add(LanguageSelected(selectedLanguage));
      context.router.replacePath('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, state) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF667eea),
                  Color(0xFF764ba2),
                ],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14.0,
                  vertical: 10.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Заголовок
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        AppLocalizations.of(context)!.chooseLanguage,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Список языков
                    Expanded(
                      child: ListView.builder(
                        itemCount: languages.length,
                        itemBuilder: (context, index) {
                          final language = languages[index];
                          final isSelected =
                              selectedLanguage == language['code'];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 5),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => _selectLanguage(language['code']),
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isSelected
                                          ? const Color(0xFF4CAF50)
                                          : Colors.grey[300]!,
                                      width: isSelected ? 2 : 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withAlpha(30),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundImage:
                                            AssetImage(language['flag']),
                                        radius: 16,
                                      ),
                                      const SizedBox(width: 16),
                                      // Название языка
                                      Expanded(
                                        child: Text(
                                          language['name'],
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color: isSelected
                                                ? const Color(0xFF4CAF50)
                                                : Colors.white,
                                          ),
                                        ),
                                      ),
                                      // Индикатор выбора
                                      Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: isSelected
                                                ? const Color(0xFF4CAF50)
                                                : Colors.grey[400]!,
                                            width: 2,
                                          ),
                                          color: isSelected
                                              ? const Color(0xFF4CAF50)
                                              : Colors.transparent,
                                        ),
                                        child: isSelected
                                            ? const Icon(
                                                Icons.check,
                                                size: 14,
                                                color: Colors.white,
                                              )
                                            : null,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Кнопка "Далее"
                    BasicAppButton(
                      onPressed: selectedLanguage.isNotEmpty
                          ? () => _confirmLanguageSelection()
                          : null,
                      title: AppLocalizations.of(context)!.next,
                      elevation: selectedLanguage.isNotEmpty ? 2 : 0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
