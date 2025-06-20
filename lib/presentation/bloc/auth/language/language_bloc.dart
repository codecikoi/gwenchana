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
      print('📱 LanguageBloc: Загружаем сохраненный язык...');
      // сохранение языка в локальное хранилище (SharedPreferences)
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? savedLanguage = prefs.getString('selected_language');

      print('📱 LanguageBloc: Сохраненный язык = $savedLanguage');

      if (savedLanguage != null && savedLanguage.isNotEmpty) {
        localization.translate(savedLanguage);
        print(
            '📱 LanguageBloc: Язык найден, переключаемся на LanguageSelectedState($savedLanguage)');
        emit(LanguageSelectedState(savedLanguage));
      } else {
        print(
            '📱 LanguageBloc: Язык не найден, переключаемся на LanguageNotSelected');
        emit(LanguageNotSelected());
      }
    } catch (e) {
      print('❌ LanguageBloc: Ошибка при загрузке языка: $e');
      emit(LanguageNotSelected());
    }
  }

  // обработчик загрузки сохраненного языка

  Future<void> _onLanguageSelected(
    LanguageSelected event,
    Emitter<LanguageState> emit,
  ) async {
    try {
      print('📱 LanguageBloc: Выбран язык ${event.languageCode}');
      // сохранение выбранного языка (SharedPreferences)

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('selected_language', event.languageCode);
      // обновление локализации
      localization.translate(event.languageCode);
      print(
          '📱 LanguageBloc: Язык сохранен и применен, переключаемся на LanguageSelectedState');
      emit(LanguageSelectedState(event.languageCode));
    } catch (e) {
      print('$e.toString()');
    }
  }
}
