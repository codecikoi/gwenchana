import 'package:equatable/equatable.dart';

abstract class AppLanguageEvent extends Equatable {
  const AppLanguageEvent();

  @override
  List<Object?> get props => [];
}

// событие изменения языка

class AppLanguageChanged extends AppLanguageEvent {
  final String appLanguageCode;

  const AppLanguageChanged({required this.appLanguageCode});

  @override
  List<Object> get props => [appLanguageCode];
}

// событие загрузки сохранненого языка

class AppLanguageLoaded extends AppLanguageEvent {}

class AppLanguageSelected extends AppLanguageEvent {
  final String appLanguageCode;
  const AppLanguageSelected(this.appLanguageCode);

  @override
  List<Object> get props => [appLanguageCode];
}
