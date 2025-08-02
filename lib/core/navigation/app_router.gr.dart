// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [AccountSettingsPage]
class AccountSettingsRoute extends PageRouteInfo<void> {
  const AccountSettingsRoute({List<PageRouteInfo>? children})
    : super(AccountSettingsRoute.name, initialChildren: children);

  static const String name = 'AccountSettingsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return WrappedRoute(child: const AccountSettingsPage());
    },
  );
}

/// generated route for
/// [ChooseLangPage]
class ChooseLangRoute extends PageRouteInfo<void> {
  const ChooseLangRoute({List<PageRouteInfo>? children})
    : super(ChooseLangRoute.name, initialChildren: children);

  static const String name = 'ChooseLangRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ChooseLangPage();
    },
  );
}

/// generated route for
/// [CreateAccountPage]
class CreateAccountRoute extends PageRouteInfo<void> {
  const CreateAccountRoute({List<PageRouteInfo>? children})
    : super(CreateAccountRoute.name, initialChildren: children);

  static const String name = 'CreateAccountRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return WrappedRoute(child: const CreateAccountPage());
    },
  );
}

/// generated route for
/// [FavoriteCardsPage]
class FavoriteCardsRoute extends PageRouteInfo<void> {
  const FavoriteCardsRoute({List<PageRouteInfo>? children})
    : super(FavoriteCardsRoute.name, initialChildren: children);

  static const String name = 'FavoriteCardsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const FavoriteCardsPage();
    },
  );
}

/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LoginPage();
    },
  );
}

/// generated route for
/// [MyCardsPage]
class MyCardsRoute extends PageRouteInfo<void> {
  const MyCardsRoute({List<PageRouteInfo>? children})
    : super(MyCardsRoute.name, initialChildren: children);

  static const String name = 'MyCardsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MyCardsPage();
    },
  );
}

/// generated route for
/// [ReadingPage]
class ReadingRoute extends PageRouteInfo<void> {
  const ReadingRoute({List<PageRouteInfo>? children})
    : super(ReadingRoute.name, initialChildren: children);

  static const String name = 'ReadingRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ReadingPage();
    },
  );
}

/// generated route for
/// [RecoverPasswordPage]
class RecoverPasswordRoute extends PageRouteInfo<void> {
  const RecoverPasswordRoute({List<PageRouteInfo>? children})
    : super(RecoverPasswordRoute.name, initialChildren: children);

  static const String name = 'RecoverPasswordRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const RecoverPasswordPage();
    },
  );
}

/// generated route for
/// [SkillChoosingPage]
class SkillChoosingRoute extends PageRouteInfo<void> {
  const SkillChoosingRoute({List<PageRouteInfo>? children})
    : super(SkillChoosingRoute.name, initialChildren: children);

  static const String name = 'SkillChoosingRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return WrappedRoute(child: const SkillChoosingPage());
    },
  );
}

/// generated route for
/// [SpeakingPage]
class SpeakingRoute extends PageRouteInfo<void> {
  const SpeakingRoute({List<PageRouteInfo>? children})
    : super(SpeakingRoute.name, initialChildren: children);

  static const String name = 'SpeakingRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SpeakingPage();
    },
  );
}

/// generated route for
/// [VocabularyCardPage]
class VocabularyCardRoute extends PageRouteInfo<VocabularyCardRouteArgs> {
  VocabularyCardRoute({
    Key? key,
    int setIndex = 0,
    int selectedLevel = 1,
    List<PageRouteInfo>? children,
  }) : super(
         VocabularyCardRoute.name,
         args: VocabularyCardRouteArgs(
           key: key,
           setIndex: setIndex,
           selectedLevel: selectedLevel,
         ),
         rawPathParams: {'setIndex': setIndex},
         initialChildren: children,
       );

  static const String name = 'VocabularyCardRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<VocabularyCardRouteArgs>(
        orElse:
            () => VocabularyCardRouteArgs(
              setIndex: pathParams.getInt('setIndex', 0),
            ),
      );
      return VocabularyCardPage(
        key: args.key,
        setIndex: args.setIndex,
        selectedLevel: args.selectedLevel,
      );
    },
  );
}

class VocabularyCardRouteArgs {
  const VocabularyCardRouteArgs({
    this.key,
    this.setIndex = 0,
    this.selectedLevel = 1,
  });

  final Key? key;

  final int setIndex;

  final int selectedLevel;

  @override
  String toString() {
    return 'VocabularyCardRouteArgs{key: $key, setIndex: $setIndex, selectedLevel: $selectedLevel}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! VocabularyCardRouteArgs) return false;
    return key == other.key &&
        setIndex == other.setIndex &&
        selectedLevel == other.selectedLevel;
  }

  @override
  int get hashCode => key.hashCode ^ setIndex.hashCode ^ selectedLevel.hashCode;
}

/// generated route for
/// [VocabularyPage]
class VocabularyRoute extends PageRouteInfo<void> {
  const VocabularyRoute({List<PageRouteInfo>? children})
    : super(VocabularyRoute.name, initialChildren: children);

  static const String name = 'VocabularyRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const VocabularyPage();
    },
  );
}

/// generated route for
/// [WritingSkillPage]
class WritingSkillRoute extends PageRouteInfo<WritingSkillRouteArgs> {
  WritingSkillRoute({
    Key? key,
    required int level,
    required int setIndex,
    List<PageRouteInfo>? children,
  }) : super(
         WritingSkillRoute.name,
         args: WritingSkillRouteArgs(
           key: key,
           level: level,
           setIndex: setIndex,
         ),
         rawPathParams: {'level': level, 'setIndex': setIndex},
         initialChildren: children,
       );

  static const String name = 'WritingSkillRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<WritingSkillRouteArgs>(
        orElse:
            () => WritingSkillRouteArgs(
              level: pathParams.getInt('level'),
              setIndex: pathParams.getInt('setIndex'),
            ),
      );
      return WritingSkillPage(
        key: args.key,
        level: args.level,
        setIndex: args.setIndex,
      );
    },
  );
}

class WritingSkillRouteArgs {
  const WritingSkillRouteArgs({
    this.key,
    required this.level,
    required this.setIndex,
  });

  final Key? key;

  final int level;

  final int setIndex;

  @override
  String toString() {
    return 'WritingSkillRouteArgs{key: $key, level: $level, setIndex: $setIndex}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! WritingSkillRouteArgs) return false;
    return key == other.key &&
        level == other.level &&
        setIndex == other.setIndex;
  }

  @override
  int get hashCode => key.hashCode ^ level.hashCode ^ setIndex.hashCode;
}

/// generated route for
/// [WritingSkillTitlesPage]
class WritingSkillTitlesRoute
    extends PageRouteInfo<WritingSkillTitlesRouteArgs> {
  WritingSkillTitlesRoute({Key? key, List<PageRouteInfo>? children})
    : super(
        WritingSkillTitlesRoute.name,
        args: WritingSkillTitlesRouteArgs(key: key),
        initialChildren: children,
      );

  static const String name = 'WritingSkillTitlesRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<WritingSkillTitlesRouteArgs>(
        orElse: () => const WritingSkillTitlesRouteArgs(),
      );
      return WrappedRoute(child: WritingSkillTitlesPage(key: args.key));
    },
  );
}

class WritingSkillTitlesRouteArgs {
  const WritingSkillTitlesRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'WritingSkillTitlesRouteArgs{key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! WritingSkillTitlesRouteArgs) return false;
    return key == other.key;
  }

  @override
  int get hashCode => key.hashCode;
}
