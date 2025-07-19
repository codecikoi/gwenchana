import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gwenchana/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';

@RoutePage()
class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({super.key});

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  String fullName = 'Example Name';
  File? profileImage;
  bool isDarkMode = false;
  bool notificationsEnabled = true;
  String selectedLanguage = 'en';

  final Map<String, String> languages = {
    'en': 'English',
    'ru': 'Русский',
    'vi': 'Tiếng Việt',
    'ja': '日本語',
    'fr': 'Français',
    'id': 'Bahasa Indonesia',
    'zh_CN': '中文 (简体)',
    'de': 'Deutsch',
    'uz': 'O\'zbek',
  };

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
        TextEditingController(text: fullName);

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
                  fullName = fullNameController.text;
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.selectLanguage),
          content: SizedBox(
            width: double.infinity,
            child: ListView.builder(
              itemCount: languages.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                String langCode = languages.keys.elementAt(index);
                String langName = languages[langCode]!;
                return RadioListTile<String>(
                  title: Text(langName),
                  value: langCode,
                  groupValue: selectedLanguage,
                  onChanged: (String? value) {
                    setState(() {
                      selectedLanguage = value!;
                    });
                    Navigator.pop(context);
                  },
                );
              },
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
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: _changeProfilePhoto,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 20,
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
                    bottom: -2,
                    right: -2,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit,
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
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
            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                title: Text(
                  AppLocalizations.of(context)!.fullName,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  fullName,
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
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // settings section
            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  // dark mode
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 4,
                    ),
                    leading: const Icon(
                      Icons.dark_mode,
                      color: Colors.blue,
                    ),
                    title: Text(
                      AppLocalizations.of(context)!.darkMode,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Switch(
                      value: isDarkMode,
                      onChanged: (bool value) {
                        setState(() {
                          isDarkMode = value;
                        });
                      },
                    ),
                  ),
                  const Divider(height: 1),

                  // notifications
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 4,
                    ),
                    leading: const Icon(
                      Icons.notifications,
                      color: Colors.blue,
                    ),
                    title: Text(
                      AppLocalizations.of(context)!.notifications,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Switch(
                      value: notificationsEnabled,
                      onChanged: (bool value) {
                        setState(() {
                          notificationsEnabled = value;
                        });
                      },
                    ),
                  ),
                  const Divider(height: 1),

                  //language
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 4,
                    ),
                    leading: const Icon(
                      Icons.language,
                      color: Colors.blue,
                    ),
                    title: Text(
                      AppLocalizations.of(context)!.language,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: _showLanguageDialog,
                  ),
                  const Divider(height: 1),

                  // Privacy
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 4,
                    ),
                    leading: const Icon(
                      Icons.privacy_tip,
                      color: Colors.blue,
                    ),
                    title: Text(
                      AppLocalizations.of(context)!.terms,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // Navigate to NOTION (TERMS TEXT)
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('terms and privacy')),
                      );
                    },
                  ),
                  const Divider(height: 1),

                  // faq
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 4,
                    ),
                    leading: const Icon(
                      Icons.help_outline,
                      color: Colors.blue,
                    ),
                    title: Text(
                      AppLocalizations.of(context)!.faq,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // Navigate to NOTION (faq TEXT)
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('faq page')),
                      );
                    },
                  ),
                  const Divider(height: 1),

                  // contact us
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 4,
                    ),
                    leading: const Icon(
                      Icons.contact_support,
                      color: Colors.blue,
                    ),
                    title: Text(
                      AppLocalizations.of(context)!.contactUs,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // Navigate to telegram? or gmail
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('contact us')),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // account action section

            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  // change password
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 4,
                    ),
                    leading: const Icon(
                      Icons.lock_outline,
                      color: Colors.blue,
                    ),
                    title: Text(
                      AppLocalizations.of(context)!.changePassword,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: _changePassword,
                  ),
                  const Divider(height: 1),

                  // delete account
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 4,
                    ),
                    leading: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                    ),
                    title: Text(
                      AppLocalizations.of(context)!.deleteAccount,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: _deleteAccount,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // logout button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _logOut,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context)!.logOut,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

//   void _showSettingsBottomSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (context) => Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(
//             top: Radius.circular(
//               20,
//             ),
//           ),
//         ),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               SizedBox(height: 20),
//               Container(
//                 width: 40,
//                 height: 4,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[300],
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//               SizedBox(height: 20),
//               Text(
//                 AppLocalizations.of(context)!.accountSettings,
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//               ),
//               SizedBox(height: 30),
//               _buildSettingsItem(
//                 icon: Icons.language,
//                 title: 'Language',
//                 subtitle: 'English',
//                 onTap: () {
//                   Navigator.pop(context);
//                   // Логика выбора языка
//                 },
//               ),
//               _buildSettingsItem(
//                 icon: Icons.volume_up,
//                 title: 'Sound',
//                 subtitle: 'On',
//                 onTap: () {
//                   Navigator.pop(context);
//                   // Логика настройки звука
//                 },
//               ),
//               _buildSettingsItem(
//                 icon: Icons.notifications,
//                 title: 'Notifications',
//                 subtitle: 'Enabled',
//                 onTap: () {
//                   Navigator.pop(context);
//                   // Логика настройки уведомлений
//                 },
//               ),
//               _buildSettingsItem(
//                 icon: Icons.lock,
//                 title: 'Change Password',
//                 subtitle: '',
//                 onTap: () {
//                   Navigator.pop(context);
//                   // Логика смены пароля
//                 },
//               ),
//               _buildSettingsItem(
//                 icon: Icons.info_outline,
//                 title: 'About',
//                 subtitle: 'Version 1.0.0',
//                 onTap: () {
//                   Navigator.pop(context);
//                   // Логика показа информации о приложении
//                 },
//               ),
//               _buildSettingsItem(
//                 icon: Icons.logout,
//                 title: 'Logout',
//                 subtitle: '',
//                 onTap: () {
//                   Navigator.pop(context);
//                   // Логика выхода из аккаунта
//                 },
//               ),
//               SizedBox(height: 30),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSettingsItem({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required VoidCallback onTap,
//   }) {
//     return ListTile(
//       leading: Container(
//         padding: EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           color: Color(0xFF667eea).withAlpha(30),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Icon(
//           icon,
//           color: Color(0xFF667eea),
//           size: 24,
//         ),
//       ),
//       title: Text(
//         title,
//         style: TextStyle(
//           fontSize: 16,
//           fontWeight: FontWeight.w500,
//           color: Colors.black87,
//         ),
//       ),
//       subtitle: subtitle.isNotEmpty
//           ? Text(
//               subtitle,
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.grey[600],
//               ),
//             )
//           : null,
//       trailing: Icon(
//         Icons.arrow_forward_ios,
//         color: Colors.grey[400],
//         size: 16,
//       ),
//       onTap: onTap,
//     );
//   }
// }
