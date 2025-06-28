import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

// начальное состояние (initial state)

class AuthInitial extends AuthState {}

// состояние загрузки (loading state)

class AuthLoading extends AuthState {}

// состояние успешной авторизации (authenticated state)
// user async firebase user

class AuthAuthenticated extends AuthState {
  final User user;
  const AuthAuthenticated({required this.user});

  @override
  List<Object> get props => [user];
}

// состояние неавторизованного пользователя (unauthenticated state)

class AuthUnauthenticated extends AuthState {}

// состояние ошибки (error state)

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object> get props => [message];
}

// состояние отправки письма ресет пароля (reset password)

class AuthResetPasswordSent extends AuthState {
  final String email;

  const AuthResetPasswordSent({required this.email});

  @override
  List<Object> get props => [email];
}
