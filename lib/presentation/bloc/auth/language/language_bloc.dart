import 'package:bloc/bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:gwenchana/presentation/bloc/auth/language/language_event.dart';
import 'package:gwenchana/presentation/bloc/auth/language/language_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  final FlutterLocalization localization;
  LanguageBloc({required this.localization}) : super(LanguageInitial()) {
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

      if (savedLanguage != null) {
        localization.translate(savedLanguage);
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
      localization.translate(event.languageCode);

      emit(LanguageSelectedState(event.languageCode));
    } catch (e) {
      print('$e.toString()');
    }
  }
}
