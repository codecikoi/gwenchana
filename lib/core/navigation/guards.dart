import 'package:auto_route/auto_route.dart';
import 'package:gwenchana/core/services/preferences_service.dart';

class AuthGuard extends AutoRouteGuard {
  final PreferencesService _prefs = PreferencesService();

  @override
  Future<void> onNavigation(
      NavigationResolver resolver, StackRouter router) async {
    final language = await _prefs.getLanguage();
    final token = await _prefs.getAuthToken();
    final path = resolver.route.path;

    print('Guard: language=$language, token=$token, path=$path');

    if (language == null) {
      if (path != '/choose-lang') {
        // yazik ne vybran go vibrat yazik

        print('Redirecting to choose-lang');

        print('Allowing navigation to $path');

        router.replacePath('/choose-lang');
      } else {
        resolver.next(true);
      }
      return;
    }

    if (token == null &&
        path != '/login' &&
        path != '/create-account' &&
        path != '/recover-password') {
      router.replacePath('/login');
      return;
    }

    if (token != null &&
        (path == '/login' ||
            path == '/create-account' ||
            path == '/recover-password' ||
            path == '/choose-lang')) {
      router.replacePath('/app-page');
      return;
    }
    resolver.next(true);
  }
}
