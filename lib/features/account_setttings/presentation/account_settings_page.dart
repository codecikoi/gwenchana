import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gwenchana/core/helper/app_colors.dart';
import 'package:gwenchana/core/helper/basic_appbutton.dart';
import 'package:gwenchana/features/choose_language/presentation/bloc/language_bloc.dart';
import 'package:gwenchana/features/choose_language/presentation/bloc/language_event.dart';
import 'package:gwenchana/features/choose_language/presentation/bloc/language_state.dart';
import 'package:gwenchana/l10n/gen_l10n/app_localizations.dart';
import 'package:gwenchana/languages_list.dart';
import 'package:image_picker/image_picker.dart';

@RoutePage()
class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({super.key});

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  String userName = 'Example Name';
  File? profileImage;
  bool isDarkMode = false;
  bool notificationsEnabled = true;

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      setState(() {
        profileImage = File(image.path);
      });
    }
  }

  Future<void> _changeProfilePhoto() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: Text(AppLocalizations.of(context)!.takePhoto),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text(AppLocalizations.of(context)!.chooseFrommGallery),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              )
            ],
          ),
        );
      },
    );
  }

  void _editFullName() {
    TextEditingController fullNameController =
        TextEditingController(text: userName);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.editFullName),
          content: TextField(
            controller: fullNameController,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.enterFullName,
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  userName = fullNameController.text;
                });
                Navigator.pop(context);
              },
              child: Text(AppLocalizations.of(context)!.save),
            ),
          ],
        );
      },
    );
  }

  void _showLanguageDialog() {
    final state = context.read<LanguageBloc>().state;
    String? selectedLanguage;

    if (state is LanguageSelectedState) {
      selectedLanguage = state.languageCode;
    } else {
      selectedLanguage = '';
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.selectLanguage),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: ListView.builder(
                itemCount: languagesList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final language = languagesList[index];
                  final langName = language['name'];
                  final langCode = language['code'];
                  return RadioListTile<String>(
                    title: Text(langName),
                    value: langCode,
                    groupValue: selectedLanguage,
                    onChanged: (String? value) {
                      if (value != null) {
                        context
                            .read<LanguageBloc>()
                            .add(LanguageSelected(value));
                      }
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void _changePassword() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Change password pushed')),
    );
  }

  void _deleteAccount() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.deleteAccount),
          content: Text(AppLocalizations.of(context)!.sureDelete),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Account deletion initiated'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text(AppLocalizations.of(context)!.delete),
            ),
          ],
        );
      },
    );
  }

  void _logOut() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.logOut),
          content: Text(AppLocalizations.of(context)!.sureLogOut),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Logo out initiated'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text(AppLocalizations.of(context)!.delete),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Gwenchana',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: _changeProfilePhoto,
              child: SizedBox(
                width: 60,
                height: 60,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: profileImage != null
                          ? FileImage(profileImage!)
                          : const AssetImage('assets/logo/main_logo.png')
                              as ImageProvider,
                      backgroundColor: Colors.grey[300],
                      child: profileImage == null
                          ? const Icon(
                              Icons.person,
                              color: Colors.grey,
                            )
                          : null,
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
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //full name
            _accountSettingsItem(
              icon: Icons.person,
              title: AppLocalizations.of(context)!.fullName,
              subtitle: Text(
                userName,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing: IconButton(
                onPressed: _editFullName,
                icon: const Icon(
                  Icons.edit,
                  color: Color(0xFF667eea),
                ),
              ),
            ),

            // dark mode
            _accountSettingsItem(
              icon: Icons.dark_mode,
              title: AppLocalizations.of(context)!.darkMode,
              trailing: Switch(
                activeColor: AppColors.enableButton,
                activeTrackColor: AppColors.disableButton,
                inactiveTrackColor: Colors.white,
                inactiveThumbColor: AppColors.disableButton,
                value: isDarkMode,
                onChanged: (bool value) {
                  setState(() {
                    isDarkMode = value;
                  });
                },
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
                value: notificationsEnabled,
                onChanged: (bool value) {
                  setState(() {
                    notificationsEnabled = value;
                  });
                },
              ),
            ),

            //language
            _accountSettingsItem(
              icon: Icons.language,
              title: AppLocalizations.of(context)!.language,
              trailing: BlocBuilder<LanguageBloc, LanguageState>(
                builder: (context, state) {
                  String? selectedLanguage;
                  if (state is LanguageSelectedState) {
                    selectedLanguage = state.languageCode;
                  }
                  return TextButton(
                    onPressed: _showLanguageDialog,
                    child: Text(
                      (selectedLanguage == null || selectedLanguage.isEmpty)
                          ? AppLocalizations.of(context)!.selectLanguage
                          : languagesList.firstWhere(
                              (lang) => lang['code'] == selectedLanguage,
                              orElse: () => {'name': selectedLanguage})['name'],
                    ),
                  );
                },
              ),
            ),

            // terms and privacy
            _accountSettingsItem(
              icon: Icons.privacy_tip,
              title: AppLocalizations.of(context)!.terms,
              onTap: () {
                // Navigate to NOTION (TERMS TEXT)
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('terms and privacy')),
                );
              },
            ),

            // faq
            _accountSettingsItem(
              icon: Icons.help_outline,
              title: AppLocalizations.of(context)!.faq,
              onTap: () {
                // Navigate to NOTION (TERMS TEXT)
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('faq page')),
                );
              },
            ),

            // contact us

            _accountSettingsItem(
              icon: Icons.mail,
              title: AppLocalizations.of(context)!.contactUs,
              onTap: () {
                // Navigate to NOTION (TERMS TEXT)
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('contact us')),
                );
              },
            ),

            // change passsword
            _accountSettingsItem(
                icon: Icons.lock_outline,
                title: AppLocalizations.of(context)!.changePassword,
                onTap: _changePassword),

            // delete account

            _accountSettingsItem(
              icon: Icons.delete_outline,
              color: AppColors.enableButton,
              title: AppLocalizations.of(context)!.deleteAccount,
              onTap: _deleteAccount,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 30,
        ),
        child: BasicAppButton(
          onPressed: _logOut,
          title: AppLocalizations.of(context)!.logOut,
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
}
