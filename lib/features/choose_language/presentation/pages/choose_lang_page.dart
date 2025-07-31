import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gwenchana/features/choose_language/presentation/bloc/language_bloc.dart';
import 'package:gwenchana/features/choose_language/presentation/bloc/language_state.dart';
import 'package:gwenchana/core/helper/basic_appbutton.dart';
import 'package:gwenchana/features/choose_language/presentation/bloc/language_event.dart';
import 'package:gwenchana/l10n/gen_l10n/app_localizations.dart';

import '../../../../core/domain/repository/config_repository.dart';

@RoutePage()
class ChooseLangPage extends StatefulWidget {
  const ChooseLangPage({super.key});

  @override
  State<ChooseLangPage> createState() => _ChooseLangPageState();
}

class _ChooseLangPageState extends State<ChooseLangPage> {
  String selectedLanguage = '';

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
                        itemCount: languagesList.length,
                        itemBuilder: (context, index) {
                          final language = languagesList[index];
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
