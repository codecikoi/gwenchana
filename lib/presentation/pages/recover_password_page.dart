import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:gwenchana/core/services/auth_service.dart';
import 'package:gwenchana/core/localization/app_localization.dart';
import 'package:gwenchana/presentation/widgets/basic_appbar.dart';
import 'package:gwenchana/presentation/widgets/basic_appbutton.dart';

class RecoverPasswordPage extends StatefulWidget {
  const RecoverPasswordPage({super.key});

  @override
  State<RecoverPasswordPage> createState() => _RecoverPasswordPageState();
}

class _RecoverPasswordPageState extends State<RecoverPasswordPage> {
  // контроллеры для текстовых полей

  final TextEditingController _emailController = TextEditingController();

  // переменная для проверки валидности формы
  bool _isFormValid = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // инициализация контроллеров
    _emailController.addListener(_validateForm);
  }

  @override
  void dispose() {
    // освобождение ресурсов контроллеров
    _emailController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _isFormValid = _emailController.text.trim().isNotEmpty &&
          _isValidEmail(_emailController.text.trim());
    });
  }

  // валидация почты
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // тут должно быть другое
  // страница воосстановления пароля

  void _handlePasswordReset() async {
    if (!_isFormValid) return;
    setState(() {
      _isLoading = true;
    });
    try {
      await AuthService().resetPassword(
        _emailController.text.trim(),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Password reset email link sent! Check your inbox.'),
          backgroundColor: Colors.green,
        ));
        context.go('/login');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        title: Text(
          AppLocale.recoverPassword.getString(context),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 14.0,
          vertical: 20.0,
        ),
        child: Column(
          children: [
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
            const SizedBox(height: 40),
            BasicAppButton(
              onPressed:
                  (_isFormValid && !_isLoading) ? _handlePasswordReset : null,
              title: _isLoading
                  ? 'Sending...'
                  : AppLocale.reset.getString(context),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
