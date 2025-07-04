import 'package:bloc/bloc.dart';
import 'package:gwenchana/features/choose_language/presentation/bloc/language_event.dart';
import 'package:gwenchana/features/choose_language/presentation/bloc/language_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(LanguageInitial()) {
    on<LanguageLoaded>(_onLanguageLoaded);
    on<LanguageSelected>(_onLanguageSelected);
  }

  // обработчик изменения языка
  Future<void> _onLanguageLoaded(
    LanguageLoaded event,
    Emitter<LanguageState> emit,
  ) async {
    try {
      // сохранение языка в локальное хранилище (SharedPreferences)
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? savedLanguage = prefs.getString('selected_language');

      if (savedLanguage != null && savedLanguage.isNotEmpty) {
        emit(LanguageSelectedState(savedLanguage));
      } else {
        emit(LanguageNotSelected());
      }
    } catch (e) {
      emit(LanguageNotSelected());
    }
  }

  // обработчик загрузки сохраненного языка

  Future<void> _onLanguageSelected(
    LanguageSelected event,
    Emitter<LanguageState> emit,
  ) async {
    try {
      // сохранение выбранного языка (SharedPreferences)
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('selected_language', event.languageCode);
      // обновление локализации
      emit(LanguageSelectedState(event.languageCode));
    } catch (e) {
      //ignore error
    }
  }
}
