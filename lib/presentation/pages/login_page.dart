import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gwenchana/common/helpers/app_colors.dart';
import 'package:gwenchana/presentation/widgets/basic_appbar.dart';
import 'package:gwenchana/presentation/widgets/basic_appbutton.dart';
import 'package:gwenchana/core/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // контроллеры для текстовых полей

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // переменная для проверки валидности формы
  bool _isFormValid = false;

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
      _isFormValid = _emailController.text.trim().isNotEmpty &&
          _passwordController.text.trim().isNotEmpty &&
          _isValidEmail(_emailController.text.trim());
    });
  }

  // валидация почты
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void _handleLogin() {
    if (_isFormValid) {
      context.go('/app-page');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        title: Text('Log in'),
      ),
      body: Padding(
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
              'Welcome to Gwenchana',
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
                labelText: 'Email',
                border: OutlineInputBorder(),
                errorText: _emailController.text.isNotEmpty &&
                        !_isValidEmail(_emailController.text.trim())
                    ? 'Please enter a valid email'
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton(
                onPressed: () => context.go('/recovery-password'),
                child: Text(
                  'Forgot password?',
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
                Text(
                    ' By signing in to Gwenchana, you agree \n to our Terms of Service and Privacy Policy',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    )),
              ],
            ),
            const SizedBox(height: 20),
            BasicAppButton(
              onPressed: _isFormValid ? _handleLogin : null,
              title: ('Log in'),
            ),
            const SizedBox(height: 12),
            BasicAppButton(
              onPressed: () => AuthService().signInWithGoogle(),
              title: 'Google Sign In',
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text(
                  'Don\'t have an account?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextButton(
                  onPressed: () => context.push('/create-account'),
                  child: Text(
                    'Create account',
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
