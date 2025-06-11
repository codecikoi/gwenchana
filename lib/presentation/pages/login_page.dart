import 'package:flutter/material.dart';
import 'package:gwenchana/common/helpers/app_colors.dart';
import 'package:gwenchana/presentation/widgets/basic_appbar.dart';
import 'package:gwenchana/presentation/widgets/basic_appbutton.dart';
import 'package:gwenchana/core/auth_service.dart';
import 'package:gwenchana/presentation/pages/app_page.dart';
import 'package:gwenchana/presentation/pages/recovery_password_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => RecoveryPasswordPage(),
                    ),
                  );
                },
                child: Text(
                  'Forgot password?',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.enableButton),
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
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AppPage(),
                  ),
                );
              },
              title: ('Log in'),
            ),
            const SizedBox(height: 12),
            BasicAppButton(
              onPressed: () => AuthService().signInWithGoogle(),
              title: 'Google Sign In',
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
