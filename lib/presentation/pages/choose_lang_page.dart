import 'package:flutter/material.dart';
import 'package:gwenchana/common/widgets/basic_appbutton.dart';
import 'package:gwenchana/common/widgets/basic_appbar.dart';
import 'package:gwenchana/presentation/pages/login_page.dart';
import 'package:easy_localization/easy_localization.dart';

class ChooseLangPage extends StatefulWidget {
  const ChooseLangPage({super.key});

  @override
  State<ChooseLangPage> createState() => _ChooseLangPageState();
}

class _ChooseLangPageState extends State<ChooseLangPage> {
  String selectedLanguage = '';
  final List<Map<String, dynamic>> languages = [
    {'name': 'Русский', 'flag': 'assets/flags/ru.png', 'code': 'ru'},
    {'name': 'English', 'flag': 'assets/flags/us.png', 'code': 'en'},
    //   {'name': 'Tiếng Việt', 'flag': 'assets/flags/vn.png', 'code': 'vi'},
    //   {'name': '日本語', 'flag': 'assets/flags/jp.png', 'code': 'ja'},
    //   {'name': 'Français', 'flag': 'assets/flags/fr.png', 'code': 'fr'},
    //   {'name': 'Bahasa Indo', 'flag': 'assets/flags/id.png', 'code': 'id'},
    //   {'name': '简体中文', 'flag': 'assets/flags/cn.png', 'code': 'zh_CN'},
    //   {'name': '繁體中文', 'flag': 'assets/flags/tw.png', 'code': 'zh_TW'},
    //   {'name': 'Deutsch', 'flag': 'assets/flags/de.png', 'code': 'de'},
  ];

  void _changeLanguage(String languageCode) {
    context.setLocale(Locale(languageCode));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        title: Text('Choose Your Language'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemCount: languages.length,
              itemBuilder: (context, index) {
                final language = languages[index];
                final isSelected =
                    language['code'] == context.locale.languageCode;
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(language['flag']),
                    radius: 16,
                  ),
                  title: Text(
                    language['name'],
                    style: TextStyle(
                      fontSize: 16,
                      color: isSelected ? Colors.teal : Colors.black87,
                    ),
                  ),
                  trailing: Container(
                    height: 24,
                    width: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? Colors.teal : Colors.grey,
                        width: 2,
                      ),
                      color: isSelected ? Colors.teal : Colors.white,
                    ),
                    child: isSelected
                        ? Icon(
                            Icons.check,
                            size: 16,
                            color: Colors.white,
                          )
                        : null,
                  ),
                  onTap: () {
                    setState(() {
                      selectedLanguage = language['name'];
                      _changeLanguage(language['code']);
                    });
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 40.0,
              vertical: 20,
            ),
            child: BasicAppButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (BuildContext context) => const LoginPage(),
                  ),
                );
              },
              title: 'Next',
              isEnabled: selectedLanguage.isNotEmpty,
            ),
          ),
        ],
      ),
    );
  }
}
