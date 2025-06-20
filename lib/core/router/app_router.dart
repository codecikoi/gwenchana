import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gwenchana/presentation/bloc/auth/auth_bloc.dart';
import 'package:gwenchana/presentation/bloc/auth/auth_state.dart';
import 'package:gwenchana/presentation/bloc/auth/language/language_bloc.dart';
import 'package:gwenchana/presentation/bloc/auth/language/language_state.dart';
import 'package:gwenchana/presentation/pages/app_page.dart';
import 'package:gwenchana/presentation/pages/choose_lang_page.dart';
import 'package:gwenchana/presentation/pages/create_account_page.dart';
import 'package:gwenchana/presentation/pages/login_page.dart';
import 'package:gwenchana/presentation/pages/recover_password_page.dart';

class AppRouter {
  static GoRouter createRouter(GlobalKey<NavigatorState> navigatorKey) {
    return GoRouter(
      navigatorKey: navigatorKey,
      initialLocation: '/',
      routes: <RouteBase>[
        GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) {
            return BlocBuilder<LanguageBloc, LanguageState>(
              builder: (context, languageState) {
                return BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, authState) {
                    print('AuthState: ${authState.runtimeType}');
                    print('LanguageState: ${languageState.runtimeType}');

                    if (authState is AuthInitial || authState is AuthLoading) {
                      return Scaffold(
                        body: Text('ebaaa'),
                      );
                    }

                    if (authState is AuthUnauthenticated &&
                        languageState is LanguageNotSelected &&
                        languageState is LanguageInitial) {
                      return ChooseLangPage(
                        onLanguageSelected: () {
                          print('🎯 Показываем ChooseLangPage');
                          context.go('/login');
                        },
                      );
                    }
                    if (authState is AuthUnauthenticated &&
                        languageState is LanguageSelectedState) {
                      print('🎯 Показываем LoginPAge');
                      return LoginPage();
                    }
                    if (authState is AuthAuthenticated &&
                        languageState is LanguageSelectedState) {
                      print('🎯 Показываем APPPAGE');
                      return AppPage();
                    }
                    print(
                        '❌ Неожиданное состояние: Auth=${authState.runtimeType}, Lang=${languageState.runtimeType}');
                    return ScaffoldMessenger(child: Text('error'));
                  },
                );
              },
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
            // apppage
          },
        ),
        GoRoute(
          path: '/create-account',
          builder: (BuildContext context, GoRouterState state) {
            return CreateAccountPage();
          },
        ),
        GoRoute(
          path: '/recover-password',
          builder: (BuildContext context, GoRouterState state) {
            return RecoverPasswordPage();
          },
        ),
      ],
      redirect: (BuildContext context, GoRouterState state) {
        final String location = state.uri.path;

        // получаем статус языка из LanguageBloc

        final languageState = context.read<LanguageBloc>().state;
        final authState = context.read<AuthBloc>().state;

        // eсли язык не выбран

        if (authState is AuthUnauthenticated &&
            languageState is LanguageNotSelected &&
            languageState is LanguageInitial &&
            location != '/') {
          return '/';
        }

        // Если язык выбран, но не авторизован — всегда на /login
        if (authState is AuthUnauthenticated &&
            languageState is LanguageSelectedState &&
            location != '/login') {
          return '/login';
        }
        // Если авторизован и язык выбран — всегда на /app-page
        if (authState is AuthAuthenticated &&
            languageState is LanguageSelectedState &&
            location != '/app-page') {
          return '/app-page';
        }
        return null;
      },
    );
  }
}
