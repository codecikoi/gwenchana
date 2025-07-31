import 'package:get_it/get_it.dart';
import 'package:gwenchana/core/domain/repository/book_repository.dart';
import 'package:gwenchana/core/services/auth_service.dart';
import 'package:gwenchana/core/services/auth_service_impl.dart';

final GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  locator.registerLazySingleton<IAuthService>(() => AuthServiceImpl());
  locator.registerLazySingleton<BookRepository>(() => BookRepository());

  // locator.registerLazySingleton<PreferencesService>(() => PreferencesService());

  // locator.registerFactory<AccountSettingsBloc>(() => AccountSettingsBloc(
  //       authService: locator<AuthServiceImpl>(),
  //       preferencesService: locator<PreferencesService>(),
  //     ));
}
