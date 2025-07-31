import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gwenchana/core/services/auth_service_impl.dart';
import 'package:gwenchana/core/services/preferences_service.dart';
import 'package:gwenchana/features/account_settings/presentation/bloc/account_settings_event.dart';
import 'package:gwenchana/features/account_settings/presentation/bloc/account_settings_state.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountSettingsBloc
    extends Bloc<AccountSettingsEvent, AccountSettingsState> {
  final AuthServiceImpl authService;
  final PreferencesService preferencesService;

  AccountSettingsBloc({
    required this.authService,
    required this.preferencesService,
  }) : super(const AccountSettingsState()) {
    on<LoadAccountData>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      final name = await preferencesService.getUserName();
      final language = await preferencesService.getLanguage();
      final avatarFile = await preferencesService.getAvatarFile() ?? '27-c.png';
      emit(state.copyWith(
        name: name ?? '',
        languageCode: language ?? 'en',
        isLoading: false,
        avatarFile: avatarFile,
      ));
    });

    on<NameChanged>((event, emit) async {
      emit(state.copyWith(name: event.name, isSuccess: false));
      await preferencesService.setUserName(event.name);
      final user = authService.currentUser;
      if (user != null) {
        await user.updateDisplayName(event.name);
      }
      emit(state.copyWith(isSuccess: true));
    });

    on<NotificationsToggled>((event, emit) async {
      emit(state.copyWith(
          notificationsEnabled: event.enabled, isSuccess: false));
      emit(state.copyWith(isSuccess: true));
    });

    on<ChangeLanguageRequested>((event, emit) async {
      emit(state.copyWith(languageCode: event.languageCode, isSuccess: false));
      await preferencesService.setLanguage(event.languageCode);
      emit(state.copyWith(isSuccess: true));
    });

// TODO: need?

    // on<ChangePasswordRequested>((event, emit) async {
    //   emit(state.copyWith(
    //       isLoading: true, errorMessage: null, isSuccess: false));
    //   try {
    //     final user = authService.currentUser;
    //     if (user == null) throw 'User not found';
    //     final card = EmailAuthProvider.credential(
    //       email: user.email!,
    //       password: event.oldPassword,
    //     );
    //     await user.reauthenticateWithCredential(card);
    //     await user.updatePassword(event.newPassword);
    //     emit(state.copyWith(isLoading: false, isSuccess: true));
    //   } catch (e) {
    //     emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    //   }
    // });

    on<DeleteAccountRequested>((event, emit) async {
      emit(state.copyWith(isLoading: true, errorMessage: null));
      try {
        final user = authService.currentUser;
        if (user != null) {
          await user.delete();
          await preferencesService.clearAuthToken();
          emit(state.copyWith(isLoading: false, isAccountDeleted: true));
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'requires-recent-login') {
          emit(state.copyWith(
            isLoading: false,
            errorMessage: 'requires-recent-login',
          ));
        } else {
          emit(state.copyWith(isLoading: false, errorMessage: e.message));
        }
      } catch (e) {
        emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
      }
    });

    on<ReauthenticateandDelete>((event, emit) async {
      emit(state.copyWith(isLoading: false, errorMessage: null));
      try {
        final user = authService.currentUser;
        if (user == null || user.email == null)
          throw Exception('user not found');
        final cred = EmailAuthProvider.credential(
          email: user.email!,
          password: event.password,
        );
        await user.reauthenticateWithCredential(cred);
        await user.delete();
        await preferencesService.clearAuthToken();
        emit(state.copyWith(isLoading: false, isAccountDeleted: true));
      } on FirebaseAuthException catch (e) {
        emit(state.copyWith(isLoading: false, errorMessage: e.message));
      } catch (e) {
        emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
      }
    });

    on<LogoutRequested>((event, emit) async {
      await authService.signOut();
      await preferencesService.clearAuthToken();
      emit(state.copyWith(isLoggedOut: true));
    });

    on<OpenExternalLink>((event, emit) async {
      final url = Uri.parse(event.url);
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        emit(state.copyWith(errorMessage: "Link not foud"));
      }
    });

    on<UserAvatarChanged>((event, emit) async {
      await preferencesService.setAvatarFile(event.fileName);
      emit(state.copyWith(avatarFile: event.fileName));
    });
  }
}
