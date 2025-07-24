import 'package:equatable/equatable.dart';

class CreateAccountState extends Equatable {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;
  final bool isValid;
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;

  const CreateAccountState({
    this.name = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.isValid = false,
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
  });

  CreateAccountState copyWith({
    String? name,
    String? email,
    String? password,
    String? confirmPassword,
    bool? isValid,
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return CreateAccountState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isValid: isValid ?? this.isValid,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  List<Object?> get props => [
        name,
        email,
        password,
        confirmPassword,
        isValid,
        isLoading,
        errorMessage,
        isSuccess,
      ];
}
