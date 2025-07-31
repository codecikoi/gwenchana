import 'package:bloc/bloc.dart';
import 'package:gwenchana/features/choose_language/presentation/bloc/app_language_event.dart';
import 'package:gwenchana/features/choose_language/presentation/bloc/app_language_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLanguageBloc extends Bloc<AppLanguageEvent, AppLanguageState> {
  AppLanguageBloc() : super(AppLanguageInitial()) {
    on<AppLanguageLoaded>(_onAppLanguageLoaded);
    on<AppLanguageSelected>(_onAppLanguageSelected);
  }

  // обработчик изменения языка
  Future<void> _onAppLanguageLoaded(
    AppLanguageLoaded event,
    Emitter<AppLanguageState> emit,
  ) async {
    try {
      // сохранение языка в локальное хранилище (SharedPreferences)
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? savedAppLanguage = prefs.getString('selected_language');

      if (savedAppLanguage != null && savedAppLanguage.isNotEmpty) {
        emit(AppLanguageSelectedState(savedAppLanguage));
      } else {
        emit(AppLanguageNotSelected());
      }
    } catch (e) {
      emit(AppLanguageNotSelected());
    }
  }

  // обработчик загрузки сохраненного языка

  Future<void> _onAppLanguageSelected(
    AppLanguageSelected event,
    Emitter<AppLanguageState> emit,
  ) async {
    try {
      // сохранение выбранного языка (SharedPreferences)
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('selected_language', event.appLanguageCode);
      // обновление локализации
      emit(AppLanguageSelectedState(event.appLanguageCode));
    } catch (e) {
      //ignore error
    }
  }
}
