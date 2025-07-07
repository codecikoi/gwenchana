import 'package:get_it/get_it.dart';
import 'package:gwenchana/core/services/auth_service.dart';
import 'package:gwenchana/core/services/auth_service_impl.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<IAuthService>(() => AuthServiceImpl());
}
