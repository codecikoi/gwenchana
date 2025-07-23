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
    on<Submitted>((event, emit) async {
      if (!state.isValid) return;
      emit(state.copyWith(isLoading: true, errorMessage: null));
      try {
        final userCredential = await authService.signUpWithEmailPassword(
          state.email.trim(),
          state.password,
        );
        if (userCredential != null && userCredential.user != null) {
          await userCredential.user!.updateDisplayName(state.name.trim());
          await preferencesService.setUserName(state.name.trim());
          emit(state.copyWith(isLoading: false, errorMessage: null));
          // Навигацию делаем через BlocListener в UI
        }
      } catch (e) {
        emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
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
