import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gwenchana/presentation/bloc/auth/auth_event.dart';
import 'package:gwenchana/presentation/bloc/auth/auth_state.dart';
import 'package:gwenchana/core/services/auth_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;
  late StreamSubscription<User?> _authSubscription;

  AuthBloc({required AuthService authService})
      : _authService = authService,
        super(AuthInitial()) {
    print('AuthBloc: Инициализируем...');
    // подписываемся на изменения состояния авторизации

    _authSubscription = _authService.authStateChanges.listen((user) {
      print('AuthBloc: Auth state changed, user = ${user?.email ?? 'null'}');
      if (user != null) {
        // user авторизован => обновляение состояния
        add(AuthStatusChecked());
      } else {
        add(AuthStatusChecked());
      }
    });
    // обработчики событий

    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthSignUpRequested>(_onSignUpRequested);
    on<AuthGoogleSignInRequested>(_onGoogleSignInRequested);
    on<AuthFacebookSignInRequested>(_onFacebookSignInRequested);
    on<AuthPasswordResetRequested>(_onPasswordResetRequested);
    on<AuthSignOutRequested>(_onSignOutRequested);
    on<AuthStatusChecked>(_onAuthStatusChecked);
  }
// обработка входа с почтой и паролем (существующий юзер)
  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final userCredential = await _authService.signInWithEmailPassword(
        event.email,
        event.password,
      );

      if (userCredential?.user != null) {
        emit(AuthAuthenticated(user: userCredential!.user!));
      } else {
        emit(const AuthError(message: 'Login failed'));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  // обработка регистрации с почтой и паролем (новый юзер)

  Future<void> _onSignUpRequested(
    AuthSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final userCredential = await _authService.signUpWithEmailPassword(
        event.email,
        event.password,
      );
      if (userCredential?.user != null) {
        // обновляем имя пользователя

        await userCredential!.user!.updateDisplayName(event.name);
        emit(AuthAuthenticated(user: userCredential.user!));
      } else {
        emit(const AuthError(message: 'Sign up failed'));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  // обработка входа через Google

  Future<void> _onGoogleSignInRequested(
    AuthGoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final userCredential = await _authService.signInWithGoogle();
      if (userCredential?.user != null) {
        emit(AuthAuthenticated(user: userCredential!.user!));
      } else {
        emit(const AuthError(message: 'Google sign in failed'));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  // обработка входа через Facebook

  Future<void> _onFacebookSignInRequested(
    AuthFacebookSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final userCredential = await _authService.signInWithFacebook();

      if (userCredential?.user != null) {
        emit(AuthAuthenticated(user: userCredential!.user!));
      } else {
        emit(const AuthError(message: 'Facebook sign in failed'));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  // обработка сброса пароля

  Future<void> _onPasswordResetRequested(
    AuthPasswordResetRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authService.resetPassword(event.email);
      emit(AuthResetPasswordSent(email: event.email));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  // обработка выхода из аккаунта

  Future<void> _onSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authService.signOut();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  // обработка проверки статуса авторизации

  void _onAuthStatusChecked(
    AuthStatusChecked event,
    Emitter<AuthState> emit,
  ) {
    print('AuthBloc: Проверяем статус авторизации...');
    final currentUser = _authService.currentUser;
    if (currentUser != null) {
      print('AuthBloc: Пользователь авторизован: ${currentUser.email}');
      emit(AuthAuthenticated(user: currentUser));
    } else {
      print('AuthBloc: Пользователь не авторизован');
      emit(AuthUnauthenticated());
    }
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }
}
