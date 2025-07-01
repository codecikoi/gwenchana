// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [AppPage]
class AppRoute extends PageRouteInfo<void> {
  const AppRoute({List<PageRouteInfo>? children})
    : super(AppRoute.name, initialChildren: children);

  static const String name = 'AppRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AppPage();
    },
  );
}

/// generated route for
/// [ChooseLangPage]
class ChooseLangRoute extends PageRouteInfo<ChooseLangRouteArgs> {
  ChooseLangRoute({
    Key? key,
    required VoidCallback onLanguageSelected,
    List<PageRouteInfo>? children,
  }) : super(
         ChooseLangRoute.name,
         args: ChooseLangRouteArgs(
           key: key,
           onLanguageSelected: onLanguageSelected,
         ),
         initialChildren: children,
       );

  static const String name = 'ChooseLangRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ChooseLangRouteArgs>();
      return ChooseLangPage(
        key: args.key,
        onLanguageSelected: args.onLanguageSelected,
      );
    },
  );
}

class ChooseLangRouteArgs {
  const ChooseLangRouteArgs({this.key, required this.onLanguageSelected});

  final Key? key;

  final VoidCallback onLanguageSelected;

  @override
  String toString() {
    return 'ChooseLangRouteArgs{key: $key, onLanguageSelected: $onLanguageSelected}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ChooseLangRouteArgs) return false;
    return key == other.key && onLanguageSelected == other.onLanguageSelected;
  }

  @override
  int get hashCode => key.hashCode ^ onLanguageSelected.hashCode;
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
      return const CreateAccountPage();
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
/// [MyApp]
class MyApp extends PageRouteInfo<void> {
  const MyApp({List<PageRouteInfo>? children})
    : super(MyApp.name, initialChildren: children);

  static const String name = 'MyApp';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MyApp();
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
/// [WritingPage]
class WritingRoute extends PageRouteInfo<void> {
  const WritingRoute({List<PageRouteInfo>? children})
    : super(WritingRoute.name, initialChildren: children);

  static const String name = 'WritingRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const WritingPage();
    },
  );
}
