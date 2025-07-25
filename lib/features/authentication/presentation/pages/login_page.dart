import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gwenchana/core/helper/app_colors.dart';
import 'package:gwenchana/core/helper/validation_helper.dart';
import 'package:gwenchana/core/navigation/app_router.dart';
import 'package:gwenchana/core/services/preferences_service.dart';
import 'package:gwenchana/core/helper/basic_appbutton.dart';
import 'package:gwenchana/core/services/auth_service_impl.dart';
import 'package:gwenchana/l10n/gen_l10n/app_localizations.dart';

@RoutePage()
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // контроллеры для текстовых полей

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthServiceImpl _authService = AuthServiceImpl();
  final PreferencesService _preferencesService = PreferencesService();

  // переменная для проверки валидности формы
  bool _isLoading = false;
  bool _isFormValid = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    // инициализация контроллеров
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  @override
  void dispose() {
    // освобождение ресурсов контроллеров
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _isFormValid = ValidationHelper.isValidLoginForm(
        _emailController.text,
        _passwordController.text,
      );
      _errorMessage = null;
    });
  }

  Future<void> _handleLogin() async {
    if (!_isFormValid) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final userCredential = await _authService.signInWithEmailPassword(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (userCredential != null && userCredential.user != null) {
        await _preferencesService.saveToken(userCredential.user!.uid);
        if (mounted) {
          context.router.replace(const SkillChoosingRoute());
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.login,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 14.0,
            vertical: 10.0,
          ),
          child: Column(
            children: [
              const SizedBox(height: 40),
              ClipOval(
                child: SizedBox(
                  width: 160,
                  height: 160,
                  child: Image.asset('assets/logo/main_logo_r.png'),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '${AppLocalizations.of(context)!.welcomeTo} Gwenchana',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.email,
                  border: OutlineInputBorder(),
                  errorText: _emailController.text.isNotEmpty
                      ? _emailController.validateEmail(context)
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.password,
                  border: OutlineInputBorder(),
                  errorText: _passwordController.text.isNotEmpty
                      ? _passwordController.validatePassword(context)
                      : null,
                ),
              ),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: TextButton(
                  onPressed: () => context.router.pushPath('/recover-password'),
                  child: Text(
                    AppLocalizations.of(context)!.forgotPassword,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.enableButton,
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Icon(Icons.check_box, color: Colors.teal),
                  SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.termsAndConditions,
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
                onPressed: _isFormValid ? _handleLogin : null,
                title: _isLoading
                    ? 'signing in...'
                    : AppLocalizations.of(context)!.login,
              ),
              const SizedBox(height: 10),

              // sign in with google and facebook

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
                      AppLocalizations.of(context)!.signInWith,
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
                      onPressed: () => AuthServiceImpl().signInWithGoogle(),
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
                      onPressed: () async {
                        try {
                          final result =
                              await AuthServiceImpl().signInWithFacebook();
                          if (!mounted) return;
                          if (result != null) {
                            context.router.pushPath('/skill-choosing-page');
                          }
                        } catch (e) {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('fb login failed button: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
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
                    AppLocalizations.of(context)!.dontHaveAccount,
                    maxLines: 3,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.router.pushPath('/create-account'),
                    child: Text(
                      AppLocalizations.of(context)!.createAccount,
                      maxLines: 3,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.enableButton),
                    ),
                  ),
                ],
              ),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
