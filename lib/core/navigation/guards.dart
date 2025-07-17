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

    if (language == null) {
      if (path != '/choose-lang') {
        // yazik ne vybran go vibrat yazik

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
      router.replacePath('/skill-choosing-page');
      return;
    }
    resolver.next(true);
  }
}
