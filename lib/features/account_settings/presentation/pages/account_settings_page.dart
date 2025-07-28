import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gwenchana/core/helper/app_colors.dart';
import 'package:gwenchana/core/helper/basic_appbutton.dart';
import 'package:gwenchana/core/navigation/app_router.dart';
import 'package:gwenchana/core/services/auth_service_impl.dart';
import 'package:gwenchana/core/services/preferences_service.dart';
import 'package:gwenchana/features/account_settings/data/avatar_files.dart';
import 'package:gwenchana/features/account_settings/presentation/bloc/account_settings_bloc.dart';
import 'package:gwenchana/features/account_settings/presentation/bloc/account_settings_event.dart';
import 'package:gwenchana/features/account_settings/presentation/bloc/account_settings_state.dart';
import 'package:gwenchana/features/choose_language/presentation/bloc/language_bloc.dart';
import 'package:gwenchana/features/choose_language/presentation/bloc/language_event.dart';
import 'package:gwenchana/l10n/gen_l10n/app_localizations.dart';
import 'package:gwenchana/core/shared/languages_list.dart';

@RoutePage()
class AccountSettingsPage extends StatelessWidget implements AutoRouteWrapper {
  const AccountSettingsPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (_) => AccountSettingsBloc(
        authService: AuthServiceImpl(),
        preferencesService: PreferencesService(),
      )..add(LoadAccountData()),
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AccountSettingsBloc, AccountSettingsState>(
      listener: (context, state) {
        if (state.errorMessage == 'requires-recent-login') {
          _showAccountDeleteDialog(context, (password) {
            context
                .read<AccountSettingsBloc>()
                .add(ReauthenticateandDelete(password));
          });
        } else if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
        }
        if (state.isLoggedOut) {
          // replace
          context.router.replaceAll([LoginRoute()]);
        }
        if (state.isAccountDeleted) {
          context.router.replaceAll([LoginRoute()]);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.accountSettings,
            style: TextStyle(
              fontSize: 20,
              letterSpacing: 1.2,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: BlocBuilder<AccountSettingsBloc, AccountSettingsState>(
                  builder: (context, state) {
                return GestureDetector(
                  onTap: () => _showAvatarPicker(context, state.avatarFile),
                  child: SizedBox(
                    width: 60,
                    height: 60,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              AssetImage('assets/avatars/${state.avatarFile}'),
                          backgroundColor: Colors.grey[300],
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.edit,
                              size: 14,
                              color: Color(0xFF667eea),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
        body: BlocBuilder<AccountSettingsBloc, AccountSettingsState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //full name
                  _accountSettingsItem(
                    icon: Icons.person,
                    title: AppLocalizations.of(context)!.name,
                    subtitle: Text(
                      state.name,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: IconButton(
                      onPressed: () => _editFullName(context, state.name),
                      icon: const Icon(
                        Icons.edit,
                        color: Color(0xFF667eea),
                      ),
                    ),
                  ),

                  // notifications
                  _accountSettingsItem(
                    icon: Icons.notifications,
                    title: AppLocalizations.of(context)!.notifications,
                    trailing: Switch(
                      activeColor: AppColors.enableButton,
                      activeTrackColor: AppColors.disableButton,
                      inactiveTrackColor: Colors.white,
                      inactiveThumbColor: AppColors.disableButton,
                      value: state.notificationsEnabled,
                      onChanged: (bool value) {
                        context.read<AccountSettingsBloc>().add(
                              NotificationsToggled(value),
                            );
                      },
                    ),
                  ),

                  //language
                  _accountSettingsItem(
                    icon: Icons.language,
                    title: AppLocalizations.of(context)!.language,
                    trailing: TextButton(
                      onPressed: () =>
                          _showLanguageDialog(context, state.languageCode),
                      child: Text(
                        languagesList.firstWhere(
                          (lang) => lang['code'] == state.languageCode,
                          orElse: () => {'name': state.languageCode},
                        )['name'],
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ),

                  // terms and privacy
                  _accountSettingsItem(
                    icon: Icons.privacy_tip,
                    title: AppLocalizations.of(context)!.terms,
                    onTap: () => context.read<AccountSettingsBloc>().add(
                          OpenExternalLink(
                              'https://www.notion.so/Gwenchana-App-Faq-23ad79fbb5ab802dbedfd165c1a40a46'),
                        ),
                  ),

                  // faq
                  _accountSettingsItem(
                      icon: Icons.help_outline,
                      title: AppLocalizations.of(context)!.faq,
                      onTap: () => context.read<AccountSettingsBloc>().add(
                            OpenExternalLink('https://notion.so/faq-link'),
                          )),

                  // contact us

                  _accountSettingsItem(
                      icon: Icons.mail,
                      title: AppLocalizations.of(context)!.contactUs,
                      onTap: () => context.read<AccountSettingsBloc>().add(
                            OpenExternalLink('mailto:wowdobryy@gmail.com'),
                          )),

                  // // change passsword
                  // _accountSettingsItem(
                  //   icon: Icons.lock_outline,
                  //   title: AppLocalizations.of(context)!.changePassword,
                  //   onTap: () => _changePassword(context),
                  // ),

                  // delete account

                  _accountSettingsItem(
                    icon: Icons.delete_outline,
                    color: AppColors.enableButton,
                    title: AppLocalizations.of(context)!.deleteAccount,
                    onTap: () => context
                        .read<AccountSettingsBloc>()
                        .add(DeleteAccountRequested()),
                  ),
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 30,
          ),
          child: BasicAppButton(
            onPressed: () => context.read<AccountSettingsBloc>().add(
                  LogoutRequested(),
                ),
            title: AppLocalizations.of(context)!.logOut,
          ),
        ),
      ),
    );
  }

  Widget _accountSettingsItem({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    Widget? subtitle,
    Widget? trailing,
    Color? color,
  }) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 4,
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: color ?? Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          leading: Icon(
            icon,
            color: color ?? Color(0xFF667eea),
          ),
          subtitle: subtitle,
          trailing: trailing,
          onTap: onTap,
        ),
        const Divider(height: 1),
      ],
    );
  }

  void _showAccountDeleteDialog(
      BuildContext context, void Function(String password) onConfirm) {
    final passwordController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          AppLocalizations.of(context)!.confirmPassword,
        ),
        content: TextField(
          controller: passwordController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.password,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppLocalizations.of(context)!.cancel,
            ),
          ),
          TextButton(
            onPressed: () {
              onConfirm(passwordController.text);
              Navigator.pop(context);
            },
            child: Text(
              'Подтвердить',
            ),
          ),
        ],
      ),
    );
  }

  void _showAvatarPicker(BuildContext context, String currentAvatar) {
    final bloc = context.read<AccountSettingsBloc>();
    showModalBottomSheet(
      context: context,
      builder: (context) => BlocProvider.value(
        value: bloc,
        child: GridView.builder(
          itemCount: avatarFiles.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemBuilder: (context, index) {
            final fileName = avatarFiles[index];
            return GestureDetector(
              onTap: () {
                bloc.add(UserAvatarChanged(fileName));
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/avatars/$fileName'),
                  radius: 30,
                  child: fileName == currentAvatar
                      ? const Icon(Icons.check, color: Colors.green)
                      : null,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _editFullName(BuildContext context, String currentName) {
    final bloc = context.read<AccountSettingsBloc>();
    final controller = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (context) => BlocProvider.value(
        value: bloc,
        child: AlertDialog(
          title: Text(
            AppLocalizations.of(context)!.editFullName,
          ),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.name,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                AppLocalizations.of(context)!.cancel,
              ),
            ),
            TextButton(
              onPressed: () {
                bloc.add(NameChanged(controller.text));
                Navigator.pop(context);
              },
              child: Text(
                AppLocalizations.of(context)!.save,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, String currentLanguage) {
    final bloc = context.read<AccountSettingsBloc>();
    showDialog(
      context: context,
      builder: (context) => BlocProvider.value(
        value: bloc,
        child: SimpleDialog(
          title: Text(AppLocalizations.of(context)!.selectLanguage),
          children: languagesList.map((lang) {
            return SimpleDialogOption(
              onPressed: () {
                bloc.add(ChangeLanguageRequested(lang['code']!));
                context.read<LanguageBloc>().add(
                      LanguageSelected(lang['code']!),
                    );
                Navigator.pop(context);
              },
              child: Text(lang['name']),
            );
          }).toList(),
        ),
      ),
    );
  }

  // void _changePassword(BuildContext context) {}
}
