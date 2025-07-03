import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gwenchana/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:gwenchana/features/authentication/presentation/bloc/auth_event.dart';
import 'package:gwenchana/features/choose_language/presentation/bloc/language_bloc.dart';
import 'package:gwenchana/features/choose_language/presentation/bloc/language_event.dart';
import 'package:gwenchana/core/navigation/app_router.dart';
import 'package:gwenchana/core/services/auth_service.dart';
import 'package:gwenchana/features/vocabulary/presentation/bloc/vocabulary_event.dart';
import 'firebase_options.dart';
import 'package:gwenchana/features/vocabulary/presentation/bloc/vocabulary_bloc.dart';
import 'package:gwenchana/gen_l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
        // auth bloc
        BlocProvider(
          create: (context) => AuthBloc(
            authService: AuthService(),
          )..add(AuthStatusChecked()),
        ),
        // language bloc
        BlocProvider(
          create: (context) => LanguageBloc()..add(LanguageLoaded()),
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
            debugShowCheckedModeBanner: false,
            locale: _locale,
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
              Locale('en'),
              Locale('ru'),
              Locale('vi'),
              Locale('ja'),
              Locale('fr'),
              Locale('id'),
              Locale('zh'),
              Locale('de'),
              Locale('uz'),
            ],
            // TODO: main fontfamily SORA
          );
        },
      ),
    );
  }
}
