import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gwenchana/presentation/app_localization.dart';
import 'package:gwenchana/presentation/pages/app_page.dart';
import 'package:gwenchana/presentation/pages/choose_lang_page.dart';
import 'package:gwenchana/presentation/pages/create_account_page.dart';
import 'package:gwenchana/presentation/pages/login_page.dart';
import 'package:gwenchana/presentation/pages/recovery_password_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:go_router/go_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterLocalization.instance.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FlutterLocalization localization = FlutterLocalization.instance;
  bool _isLanguageSelected = false;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _initializeApp();
    _initializeRouter();
  }

  void _initializeRouter() {
    _router = GoRouter(
      initialLocation: '/',
      routes: <RouteBase>[
        GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) {
            return _isLanguageSelected
                ? LoginPage()
                : ChooseLangPage(
                    onLanguageSelected: _onLanguageSelected,
                  );
          },
        ),
        GoRoute(
          path: 'choose-lang',
          builder: (BuildContext context, GoRouterState state) {
            return ChooseLangPage(
              onLanguageSelected: _onLanguageSelected,
            );
          },
        ),
        GoRoute(
          path: '/login',
          builder: (BuildContext context, GoRouterState state) {
            return LoginPage();
          },
        ),
        GoRoute(
          path: '/app-page',
          builder: (BuildContext context, GoRouterState state) {
            return AppPage();
          },
        ),
        GoRoute(
          path: '/create-account',
          builder: (BuildContext context, GoRouterState state) {
            return CreateAccountPage();
          },
        ),
        GoRoute(
          path: '/recovery-password',
          builder: (BuildContext context, GoRouterState state) {
            return RecoveryPasswordPage();
          },
        ),
      ],
      redirect: (BuildContext context, GoRouterState state) {
        final String location = state.uri.path;

        // если язык не выбран

        if (!_isLanguageSelected &&
            location != '/choose-lang' &&
            location != '/') {
          return '/choose-lang';
        }

        // если язык выбран

        if (_isLanguageSelected && location == '/') {
          return '/login';
        }
        return null;
      },
    );
  }

  void _initializeApp() async {
    await configureLocalization();
    await _checkLanguageSelection();
  }

  Future<void> configureLocalization() async {
    localization.init(
      mapLocales: [
        const MapLocale('en', AppLocale.EN),
        const MapLocale('ru', AppLocale.RU),
        const MapLocale('vi', AppLocale.VI),
        const MapLocale('ja', AppLocale.JA),
        const MapLocale('fr', AppLocale.FR),
        const MapLocale('id', AppLocale.ID),
        const MapLocale('zh_CN', AppLocale.ZH_CN),
        const MapLocale('zh_TW', AppLocale.ZH_TW),
        const MapLocale('de', AppLocale.DE),
        const MapLocale('es', AppLocale.ES),
      ],
      initLanguageCode: 'en',
      // initLanguageCode: 'en', // seting default app language.
    );
    localization.onTranslatedLanguage = _onTranslatedLanguage;
  }

  void _onTranslatedLanguage(Locale? locale) {
    setState(() {});
  }

  Future<void> _checkLanguageSelection() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedLanguage = prefs.getString('select_language');
    if (savedLanguage != null) {
      setState(() {
        _isLanguageSelected = true;
      });
      localization.translate(savedLanguage);

      // обновляние состояние роутера
      _router.refresh();
    }
  }

  void _onLanguageSelected() {
    setState(() {
      _isLanguageSelected = true;
    });
    // переход на страницу логина если выбран язык
    _router.go('/login');
  }

  void _onLanguageChanged() {
    setState(() {
      _isLanguageSelected = false;
    });
    // переход на страницу выбора языка
    _router.go('/сhoose-lang');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'Gwenchana App',
      supportedLocales: localization.supportedLocales,
      localizationsDelegates: localization.localizationsDelegates,
      debugShowCheckedModeBanner: false,

      // TODO: main fontfamily SORA
    );
  }
}
