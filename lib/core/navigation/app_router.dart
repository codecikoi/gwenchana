import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gwenchana/core/navigation/guards.dart';
import 'package:gwenchana/features/app_page/presentation/app_page.dart';
import 'package:gwenchana/features/choose_language/presentation/pages/choose_lang_page.dart';
import 'package:gwenchana/features/create_account/presentation/create_account_page.dart';
import 'package:gwenchana/features/authentication/presentation/pages/login_page.dart';
import 'package:gwenchana/features/reading/presentation/reading_page.dart';
import 'package:gwenchana/features/recover_password/presentation/recover_password_page.dart';
import 'package:gwenchana/features/speaking/presentation/speaking_page.dart';
import 'package:gwenchana/features/vocabulary/presentation/pages/vocabulary_page.dart';
import 'package:gwenchana/features/writing/presentation/writing_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  final AuthGuard _authGuard = AuthGuard();

  // @override
  // RouteType get defaulRouteType => RouteType.material();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(
            page: ChooseLangRoute.page,
            path: '/choose-lang',
            guards: [_authGuard]),
        AutoRoute(page: LoginRoute.page, path: '/login', guards: [_authGuard]),
        AutoRoute(
            page: CreateAccountRoute.page,
            path: '/create-account',
            guards: [_authGuard]),
        AutoRoute(
            page: RecoverPasswordRoute.page,
            path: '/recover-password',
            guards: [_authGuard]),
        AutoRoute(page: AppRoute.page, path: '/app-page', guards: [_authGuard]),
        AutoRoute(
            page: ReadingRoute.page,
            path: '/reading-page',
            guards: [_authGuard]),
        AutoRoute(
            page: WritingRoute.page,
            path: '/writing-page',
            guards: [_authGuard]),
        AutoRoute(
            page: VocabularyRoute.page,
            path: '/vocabulary-page',
            guards: [_authGuard]),
        AutoRoute(
            page: SpeakingRoute.page,
            path: '/speaking-page',
            guards: [_authGuard]),
        RedirectRoute(path: '/', redirectTo: '/choose-lang'),
      ];
}
