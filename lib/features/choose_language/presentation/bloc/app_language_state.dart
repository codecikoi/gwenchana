import 'package:equatable/equatable.dart';

abstract class AppLanguageState extends Equatable {
  const AppLanguageState();

  @override
  List<Object?> get props => [];
}

class AppLanguageInitial extends AppLanguageState {}

class AppLanguageNotSelected extends AppLanguageState {}

class AppLanguageSelectedState extends AppLanguageState {
  final String appLanguageCode;

  const AppLanguageSelectedState(this.appLanguageCode);

  @override
  List<Object> get props => [appLanguageCode];
}
