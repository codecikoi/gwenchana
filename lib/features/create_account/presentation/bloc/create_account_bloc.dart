import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gwenchana/core/helper/validation_helper.dart';
import 'package:gwenchana/core/services/auth_service_impl.dart';
import 'package:gwenchana/core/services/preferences_service.dart';
import 'package:gwenchana/features/create_account/presentation/bloc/create_account_event.dart';
import 'package:gwenchana/features/create_account/presentation/bloc/create_account_state.dart';

class CreateAccountBloc extends Bloc<CreateAccountEvent, CreateAccountState> {
  final AuthServiceImpl authService;
  final PreferencesService preferencesService;

  CreateAccountBloc({
    required this.authService,
    required this.preferencesService,
  }) : super(const CreateAccountState()) {
    on<NameChanged>((event, emit) {
      final newState = state.copyWith(name: event.name);
      emit(_validate(newState));
    });
    on<EmailChanged>((event, emit) {
      final newstate = state.copyWith(email: event.email, isSuccess: false);
      emit(_validate(newstate));
    });
    on<PasswordChanged>((event, emit) {
      final newState =
          state.copyWith(password: event.password, isSuccess: false);
      emit(_validate(newState));
    });
    on<ConfirmPasswordChanged>((event, emit) {
      final newState = state.copyWith(
          confirmPassword: event.confirmPassword, isSuccess: false);
      emit(_validate(newState));
    });
    on<Submitted>((event, emit) async {
      if (!state.isValid) return;
      emit(state.copyWith(
          isLoading: true, errorMessage: null, isSuccess: false));
      try {
        final userCredential = await authService.signUpWithEmailPassword(
          state.email.trim(),
          state.password,
        );
        if (userCredential != null && userCredential.user != null) {
          await userCredential.user!.updateDisplayName(state.name.trim());
          await preferencesService.setUserName(state.name.trim());
          emit(state.copyWith(
            isLoading: false,
            errorMessage: null,
            isSuccess: true,
          ));
          // Навигацию делаем через BlocListener в UI
        }
      } catch (e) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: e.toString(),
          isSuccess: false,
        ));
      }
    });
  }

  CreateAccountState _validate(CreateAccountState s) {
    final isValid = s.name.trim().isNotEmpty &&
        s.email.trim().isNotEmpty &&
        s.password.trim().isNotEmpty &&
        s.confirmPassword.trim().isNotEmpty &&
        ValidationHelper.isValidEmail(s.email.trim()) &&
        s.password == s.confirmPassword;
    return s.copyWith(isValid: isValid, errorMessage: null);
  }
}
