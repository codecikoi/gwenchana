import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gwenchana/bloc/auth/auth_bloc.dart';
import 'package:gwenchana/bloc/auth/auth_state.dart';
import 'package:gwenchana/bloc/auth/language/language_bloc.dart';
import 'package:gwenchana/bloc/auth/language/language_state.dart';
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
                if (languageState is LanguageNotSelected) {
                  return ChooseLangPage(
                    onLanguageSelected: () {
                      context.go('/choose-lang');
                    },
                  );
                }
                return BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, authState) {
                    if (authState is AuthAuthenticated) {
                      return LoginPage();
                    }
                    return AppPage();
                  },
                );
              },
            );
          },
        ),
        GoRoute(
          path: '/choose-lang',
          builder: (BuildContext context, GoRouterState state) {
            return ChooseLangPage(
              onLanguageSelected: () {
                context.go('/choose-lang');
              },
            );
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

        if (languageState is LanguageNotSelected &&
            location != '/choose-lang' &&
            location != '/') {
          return '/choose-lang';
        }
        if (authState is AuthAuthenticated) {
          if (location == '/login' ||
              location == '/create-account' ||
              location == '/recover-password') {
            return '/app-page';
          }
        }

        if (authState is AuthUnauthenticated && location == '/app-page') {
          return '/login';
        }
        return null;
      },
    );
  }
}
