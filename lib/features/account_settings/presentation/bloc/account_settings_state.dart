import 'package:equatable/equatable.dart';

class AccountSettingsState extends Equatable {
  final String name;
  final bool notificationsEnabled;
  final String languageCode;
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;
  final bool isLoggedOut;
  final bool isAccountDeleted;
  final String avatarFile;

  const AccountSettingsState({
    this.name = '',
    this.notificationsEnabled = true,
    this.isLoading = false,
    this.languageCode = 'en',
    this.errorMessage,
    this.isSuccess = false,
    this.isLoggedOut = false,
    this.isAccountDeleted = false,
    this.avatarFile = '27-c.png',
  });

  AccountSettingsState copyWith({
    String? name,
    bool? notificationsEnabled,
    String? languageCode,
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
    bool? isLoggedOut,
    bool? isAccountDeleted,
    String? avatarFile,
  }) {
    return AccountSettingsState(
      name: name ?? this.name,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      languageCode: languageCode ?? this.languageCode,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
      isLoggedOut: isLoggedOut ?? this.isLoggedOut,
      isAccountDeleted: isAccountDeleted ?? this.isAccountDeleted,
      avatarFile: avatarFile ?? this.avatarFile,
    );
  }

  @override
  List<Object?> get props => [
        name,
        notificationsEnabled,
        languageCode,
        isLoading,
        errorMessage,
        isSuccess,
        isLoggedOut,
        isAccountDeleted,
        avatarFile,
      ];
}
