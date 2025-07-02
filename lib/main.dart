import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gwenchana/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:gwenchana/features/authentication/presentation/bloc/auth_event.dart';
import 'package:gwenchana/features/choose_language/presentation/bloc/language_bloc.dart';
import 'package:gwenchana/features/choose_language/presentation/bloc/language_event.dart';
import 'package:gwenchana/core/navigation/app_router.dart';
import 'package:gwenchana/core/services/auth_service.dart';
import 'package:gwenchana/features/localization/presentation/pages/app_localization.dart';
import 'package:gwenchana/features/vocabulary/presentation/bloc/vocabulary_event.dart';
import 'firebase_options.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:gwenchana/features/vocabulary/presentation/bloc/vocabulary_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterLocalization.instance.ensureInitialized();
  await dotenv.load(fileName: '.env');
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
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final _appRouter = AppRouter();

  @override
  void initState() {
    super.initState();
    _configureLocalization();
  }

  Future<void> _configureLocalization() async {
    try {
      localization.init(
        mapLocales: [
          const MapLocale('en', AppLocale.EN),
          const MapLocale('ru', AppLocale.RU),
          const MapLocale('vi', AppLocale.VI),
          const MapLocale('ja', AppLocale.JA),
          const MapLocale('fr', AppLocale.FR),
          const MapLocale('id', AppLocale.ID),
          const MapLocale('zh_CN', AppLocale.ZH),
          const MapLocale('de', AppLocale.DE),
        ],
        initLanguageCode: 'en',
      );
      localization.onTranslatedLanguage = _onTranslatedLanguage;
    } catch (e) {
      print('error initializing localization: $e');
    }
  }

  void _onTranslatedLanguage(Locale? locale) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print('current user: ${AuthService().currentUser}');
    return MultiBlocProvider(
      providers: [
        // auth bloc
        BlocProvider(
          create: (context) => AuthBloc(
            authService: AuthService(),
          )..add(AuthStatusChecked()),
        ),
        // language bloc
        BlocProvider(
          create: (context) => LanguageBloc(
            localization: localization,
          )..add(LanguageLoaded()),
        ),
        BlocProvider(
          create: (context) => VocabularyBloc()
            ..add(
              LoadProgressEvent(),
            ),
        ),
      ],
      child: Builder(
        builder: (context) {
          return MaterialApp.router(
            routerConfig: _appRouter.config(),
            title: 'Gwenchana App',
            supportedLocales: localization.supportedLocales,
            localizationsDelegates: localization.localizationsDelegates,
            debugShowCheckedModeBanner: false,

            // TODO: main fontfamily SORA
          );
        },
      ),
    );
  }
}
