import 'package:equatable/equatable.dart';

abstract class AccountSettingsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadAccountData extends AccountSettingsEvent {}

class NameChanged extends AccountSettingsEvent {
  final String name;
  NameChanged(this.name);

  @override
  List<Object?> get props => [name];
}

class UserAvatarChanged extends AccountSettingsEvent {
  final String fileName;
  UserAvatarChanged(this.fileName);

  @override
  List<Object?> get props => [fileName];
}

class NotificationsToggled extends AccountSettingsEvent {
  final bool enabled;
  NotificationsToggled(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

class ChangeLanguageRequested extends AccountSettingsEvent {
  final String languageCode;
  ChangeLanguageRequested(this.languageCode);

  @override
  List<Object?> get props => [languageCode];
}

class ChangePasswordRequested extends AccountSettingsEvent {
  final String oldPassword;
  final String newPassword;
  // final String confirmPassword;
  ChangePasswordRequested(
    this.oldPassword,
    this.newPassword,
  );

  @override
  List<Object?> get props => [oldPassword, newPassword];
}

class DeleteAccountRequested extends AccountSettingsEvent {}

class LogoutRequested extends AccountSettingsEvent {}

class OpenExternalLink extends AccountSettingsEvent {
  final String url;
  OpenExternalLink(this.url);

  @override
  List<Object?> get props => [url];
}
