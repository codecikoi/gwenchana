import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

// Вход уже существующего пользователя (почта и пароль)

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

// Регистрация нового пользователя (имя, почта и пароль)

class AuthSignUpRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;

  const AuthSignUpRequested({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [name, email, password];
}

// Вход через гугл

class AuthGoogleSignInRequested extends AuthEvent {}

// Вход через фейсбук

class AuthFacebookSignInRequested extends AuthEvent {}

// password reset event

class AuthPasswordResetRequested extends AuthEvent {
  final String email;

  const AuthPasswordResetRequested({required this.email});

  @override
  List<Object> get props => [email];
}

// Выход из аккаунта
class AuthSignOutRequested extends AuthEvent {}

// Проверка авторизации юзера

class AuthStatusChecked extends AuthEvent {}
