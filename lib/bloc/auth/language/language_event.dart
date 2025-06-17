import 'package:equatable/equatable.dart';

abstract class LanguageEvent extends Equatable {
  const LanguageEvent();

  @override
  List<Object?> get props => [];
}

// событие изменения языка

class LanguageChanged extends LanguageEvent {
  final String languageCode;

  const LanguageChanged({required this.languageCode});

  @override
  List<Object> get props => [languageCode];
}

// событие загрузки сохранненого языка

class LanguageLoaded extends LanguageEvent {}

class LanguageSelected extends LanguageEvent {
  final String languageCode;
  const LanguageSelected(this.languageCode);

  @override
  List<Object> get props => [languageCode];
}
