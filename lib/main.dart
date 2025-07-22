import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gwenchana/core/di/locator.dart';
import 'package:gwenchana/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:gwenchana/features/authentication/presentation/bloc/auth_event.dart';
import 'package:gwenchana/features/choose_language/presentation/bloc/language_bloc.dart';
import 'package:gwenchana/features/choose_language/presentation/bloc/language_event.dart';
import 'package:gwenchana/core/navigation/app_router.dart';
import 'package:gwenchana/core/services/auth_service_impl.dart';
import 'package:gwenchana/features/choose_language/presentation/bloc/language_state.dart';
import 'package:gwenchana/features/vocabulary/presentation/bloc/vocabulary_event.dart';
import 'package:gwenchana/features/vocabulary/presentation/widgets/word_card_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'firebase_options.dart';
import 'package:gwenchana/features/vocabulary/presentation/bloc/vocabulary_bloc.dart';
import 'package:gwenchana/gen_l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Hive.initFlutter();
  await HiveStorageService.initHive();

  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(MyCardAdapter());
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final _appRouter = AppRouter();
  Locale? _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // language bloc
        BlocProvider(
          create: (context) => LanguageBloc()..add(LanguageLoaded()),
        ),
        // auth bloc
        BlocProvider(
          create: (context) => AuthBloc(
            authService: AuthServiceImpl(),
          )..add(AuthStatusChecked()),
        ),
        BlocProvider(
          create: (context) => VocabularyBloc()
            ..add(
              LoadProgressEvent(),
            ),
        ),
      ],
      child: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, languageState) {
          if (languageState is LanguageSelectedState) {
            _locale = _getLocaleFromLanguageCode(languageState.languageCode);
          }
          return MaterialApp.router(
            routerConfig: _appRouter.config(),
            title: 'Gwenchana App',
            debugShowCheckedModeBanner: false,
            locale: _locale,
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
              Locale('ko'),
              Locale('uz'),
              Locale('en'),
              Locale('vi'),
              Locale('ru'),
              Locale('th'),
              Locale('id'),
              Locale('fil'),
              Locale('uk'),
              Locale('zh'),
              Locale('es'),
              Locale('tr'),
              Locale('pt'),
            ],
            // TODO: main fontfamily SORA
          );
        },
      ),
    );
  }

  Locale _getLocaleFromLanguageCode(String languageCode) {
    switch (languageCode) {
      case 'ko':
        return Locale('ko');
      case 'uz':
        return Locale('uz');
      case 'en':
        return Locale('en');
      case 'vi':
        return Locale('vi');
      case 'ru':
        return Locale('ru');
      case 'id':
        return Locale('id');
      case 'fil':
        return Locale('fil');
      case 'uk':
        return Locale('uk');
      case 'zh_CN':
        return Locale('zh', 'CN');
      case 'es':
        return Locale('es');
      case 'tr':
        return Locale('tr');
      case 'pt':
        return Locale('pt');
      case 'th':
        return Locale('th');
      default:
        return Locale('en');
    }
  }
}
