import 'package:equatable/equatable.dart';

abstract class CreateAccountEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class NameChanged extends CreateAccountEvent {
  final String name;
  NameChanged(this.name);

  @override
  List<Object?> get props => [name];
}

class EmailChanged extends CreateAccountEvent {
  final String email;
  EmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

class PasswordChanged extends CreateAccountEvent {
  final String password;
  PasswordChanged(this.password);

  @override
  List<Object?> get props => [password];
}

class ConfirmPasswordChanged extends CreateAccountEvent {
  final String confirmPassword;
  ConfirmPasswordChanged(this.confirmPassword);

  @override
  List<Object?> get props => [confirmPassword];
}

class Submitted extends CreateAccountEvent {}
