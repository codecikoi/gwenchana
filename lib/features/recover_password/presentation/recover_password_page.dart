import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gwenchana/core/services/auth_service_impl.dart';
import 'package:gwenchana/core/helper/basic_appbar.dart';
import 'package:gwenchana/core/helper/basic_appbutton.dart';
import 'package:gwenchana/gen_l10n/app_localizations.dart';

@RoutePage()
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
      await AuthServiceImpl().resetPassword(
        _emailController.text.trim(),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Password reset email link sent! Check your inbox.'),
          backgroundColor: Colors.green,
        ));
        context.router.pushPath('/login');
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
          AppLocalizations.of(context)!.recoverPassword,
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
                labelText: AppLocalizations.of(context)!.email,
                border: OutlineInputBorder(),
                errorText: _emailController.text.isNotEmpty &&
                        !_isValidEmail(_emailController.text.trim())
                    ? AppLocalizations.of(context)!.pleaseEnterValidEmail
                    : null,
              ),
            ),
            const SizedBox(height: 40),
            BasicAppButton(
              onPressed:
                  (_isFormValid && !_isLoading) ? _handlePasswordReset : null,
              title: _isLoading
                  ? 'Sending...'
                  : AppLocalizations.of(context)!.reset,
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
