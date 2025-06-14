import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:gwenchana/common/helpers/app_colors.dart';
import 'package:gwenchana/localization/app_localization.dart';
import 'package:gwenchana/presentation/widgets/basic_appbar.dart';
import 'package:gwenchana/presentation/widgets/basic_appbutton.dart';
import 'package:gwenchana/core/auth_service.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  // контроллеры для текстовых полей

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final AuthService _authService = AuthService();

  // переменная для проверки валидности формы
  bool _isFormValid = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // инициализация контроллеров
    _nameController.addListener(_validateForm);
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
    _confirmPasswordController.addListener(_validateForm);
  }

  @override
  void dispose() {
    // освобождение ресурсов контроллеров
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _isFormValid = _nameController.text.trim().isNotEmpty &&
          _emailController.text.trim().isNotEmpty &&
          _passwordController.text.trim().isNotEmpty &&
          _confirmPasswordController.text.trim().isNotEmpty &&
          _isValidEmail(_emailController.text.trim()) &&
          _passwordController.text == _confirmPasswordController.text;
    });
  }

  Future<void> _handleCreateAccount() async {
    if (!_isFormValid) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final userCredential = await _authService.signUpWithEmailPassword(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (userCredential != null && userCredential.user != null) {
        // save user data to firestore

        await userCredential.user!
            .updateDisplayName(_nameController.text.trim());
        if (mounted) {
          context.go('/app-page');
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // валидация почты
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // void _handleLogin() {
  //   if (_isFormValid) {
  //     context.go('/app-page');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        title: Text(
          AppLocale.createAccount.getString(context),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 14.0,
          vertical: 10.0,
        ),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: AppLocale.name.getString(context),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: AppLocale.email.getString(context),
                border: OutlineInputBorder(),
                errorText: _emailController.text.isNotEmpty &&
                        !_isValidEmail(_emailController.text.trim())
                    ? AppLocale.pleaseEnterValidEmail.getString(context)
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: AppLocale.password.getString(context),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: AppLocale.confirmPassword.getString(context),
                border: OutlineInputBorder(),
                errorText: _confirmPasswordController.text.isNotEmpty &&
                        _passwordController.text !=
                            _confirmPasswordController.text
                    ? AppLocale.passwordsNotMatch.getString(context)
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.check_box, color: Colors.teal),
                SizedBox(width: 4),
                Expanded(
                  child: Text(
                    AppLocale.termsAndConditions.getString(context),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            BasicAppButton(
              onPressed: _isFormValid ? _handleCreateAccount : null,
              title: _isLoading
                  ? 'Creating account ...'
                  : AppLocale.createAccount.getString(context),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: AppColors.black,
                    thickness: 1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                  ),
                  child: Text(
                    AppLocale.signInWith.getString(context),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black,
                    ),
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: AppColors.black,
                    thickness: 1,
                  ),
                ),
              ],
            ),

            // google sign in button

            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => AuthService().signInWithGoogle(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: Image.asset(
                      'assets/logo/google_logo.png',
                      width: 28,
                      height: 28,
                    ),
                    label: Text(
                      'Google',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: Image.asset(
                      'assets/logo/facebook_logo.png',
                      width: 28,
                      height: 28,
                    ),
                    label: Text(
                      'Facebook',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  AppLocale.doHaveAccount.getString(context),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextButton(
                  onPressed: () => context.go('/login'),
                  child: Text(
                    AppLocale.signIn.getString(context),
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.enableButton),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
