import 'package:equatable/equatable.dart';

abstract class LanguageState extends Equatable {
  const LanguageState();

  @override
  List<Object?> get props => [];
}

class LanguageInitial extends LanguageState {}

class LanguageNotSelected extends LanguageState {}

class LanguageSelectedState extends LanguageState {
  final String languageCode;

  const LanguageSelectedState(this.languageCode);

  @override
  List<Object> get props => [languageCode];
}
