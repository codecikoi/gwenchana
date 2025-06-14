import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:gwenchana/localization/app_localization.dart';
import 'package:gwenchana/presentation/widgets/basic_appbutton.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChooseLangPage extends StatefulWidget {
  final VoidCallback onLanguageSelected;

  const ChooseLangPage({super.key, required this.onLanguageSelected});

  @override
  State<ChooseLangPage> createState() => _ChooseLangPageState();
}

class _ChooseLangPageState extends State<ChooseLangPage> {
  String selectedLanguage = '';

  final FlutterLocalization localization = FlutterLocalization.instance;

  final List<Map<String, dynamic>> languages = [
    {'name': 'Русский', 'flag': 'assets/flags/ru.png', 'code': 'ru'},
    {'name': 'English', 'flag': 'assets/flags/us.png', 'code': 'en'},
    {'name': 'Tiếng Việt', 'flag': 'assets/flags/vn.png', 'code': 'vi'},
    {'name': '日本語', 'flag': 'assets/flags/jp.png', 'code': 'ja'},
    {'name': 'Français', 'flag': 'assets/flags/fr.png', 'code': 'fr'},
    {'name': 'Bahasa Indo', 'flag': 'assets/flags/id.png', 'code': 'id'},
    {'name': '简体中文', 'flag': 'assets/flags/cn.png', 'code': 'zh_CN'},
    {'name': 'Deutsch', 'flag': 'assets/flags/de.png', 'code': 'de'},
  ];

  void _selectLanguage(String languageCode) async {
    setState(() {
      selectedLanguage = languageCode;
    });
    // сохраняем выбранный язык в SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_language', languageCode);

    // обновляем локализацию приложения
    localization.translate(languageCode);
  }

  void _navigateToNextScreen() {
    if (selectedLanguage.isNotEmpty) {
      widget.onLanguageSelected();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                  AppLocale.chooseLanguage.getString(context),
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
                    final isSelected = selectedLanguage == language['code'];
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
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF4CAF50)
                                    : Colors.grey[300]!,
                                width: isSelected ? 2 : 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                // Флаг
                                // доработать этот пакет позже
                                // ClipRRect(
                                //   borderRadius: BorderRadius.circular(7),
                                //   child: CountryFlag.fromCountryCode(
                                //     language['code'],
                                //     width: 16,
                                //     height: 16,
                                //     shape: const RoundedRectangle(8.0),
                                //   ),
                                // ),
                                CircleAvatar(
                                  backgroundImage: AssetImage(language['flag']),
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
                                          : Colors.black87,
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
                    ? () => _navigateToNextScreen()
                    : null,
                title: AppLocale.next.getString(context),
                elevation: selectedLanguage.isNotEmpty ? 2 : 0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
