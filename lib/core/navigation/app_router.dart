import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gwenchana/core/navigation/guards.dart';
import 'package:gwenchana/features/account_settings/presentation/pages/account_settings_page.dart';
import 'package:gwenchana/features/skill_choosing/presentation/skill_choosing_page.dart';
import 'package:gwenchana/features/choose_language/presentation/pages/choose_lang_page.dart';
import 'package:gwenchana/features/create_account/presentation/pages/create_account_page.dart';
import 'package:gwenchana/features/authentication/presentation/pages/login_page.dart';
import 'package:gwenchana/features/reading/presentation/reading_page.dart';
import 'package:gwenchana/features/recover_password/presentation/recover_password_page.dart';
import 'package:gwenchana/features/speaking/presentation/speaking_page.dart';
import 'package:gwenchana/features/vocabulary/presentation/pages/favorites_card_page.dart';
import 'package:gwenchana/features/vocabulary/presentation/pages/my_cards_page.dart';
import 'package:gwenchana/features/vocabulary/presentation/pages/vocabulary_card.dart';
import 'package:gwenchana/features/vocabulary/presentation/pages/vocabulary_page.dart';
import 'package:gwenchana/features/writing/presentation/pages/writing_skill_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  final AuthGuard _authGuard = AuthGuard();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          initial: true,
          page: ChooseLangRoute.page,
          path: '/choose-lang',
          guards: [_authGuard],
        ),
        AutoRoute(
          page: LoginRoute.page,
          path: '/login',
          guards: [_authGuard],
        ),
        AutoRoute(
          page: CreateAccountRoute.page,
          path: '/create-account',
          guards: [_authGuard],
        ),
        AutoRoute(
          page: RecoverPasswordRoute.page,
          path: '/recover-password',
          guards: [_authGuard],
        ),
        AutoRoute(
          page: ReadingRoute.page,
          path: '/reading-page',
          guards: [_authGuard],
        ),
        AutoRoute(
          page: WritingSkillRoute.page,
          path: '/writing-skill-page',
          guards: [_authGuard],
        ),
        AutoRoute(
          page: VocabularyRoute.page,
          path: '/vocabulary-page',
          guards: [_authGuard],
        ),
        AutoRoute(
          page: VocabularyCardRoute.page,
          path: '/vocabulary-card/:setIndex',
          guards: [_authGuard],
        ),
        AutoRoute(
          page: SpeakingRoute.page,
          path: '/speaking-page',
          guards: [_authGuard],
        ),
        AutoRoute(
          page: FavoritesCardRoute.page,
          path: '/favorites-page',
          guards: [_authGuard],
        ),
        AutoRoute(
          page: MyCardsRoute.page,
          path: '/my-cards-page',
          guards: [_authGuard],
        ),
        AutoRoute(
          page: SkillChoosingRoute.page,
          path: '/skill-choosing-page',
          guards: [_authGuard],
        ),
        AutoRoute(
          page: AccountSettingsRoute.page,
          path: '/account-settings-page',
          guards: [_authGuard],
        ),
        RedirectRoute(path: '/', redirectTo: '/choose-lang'),
      ];
}
