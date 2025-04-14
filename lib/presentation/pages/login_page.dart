import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gwenchana/common/helpers/app_colors.dart';
import 'package:gwenchana/common/widgets/basic_appbar.dart';
import 'package:gwenchana/common/widgets/basic_appbutton.dart';
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
        title: Text('Log in'.tr()),
      ),
      body: Column(
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
            'Welcome to Gwenchana'.tr(),
            style: TextStyle(
              fontSize: 20,
              color: AppColors.appBar,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(height: 10),
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
                'Forgot password?'.tr(),
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.enableButton),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_box, color: Colors.teal),
              SizedBox(width: 10),
              Text(
                  ' By signing in to Gwenchana, you agree \n to our Terms of Service and Privacy Policy',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.appBar)),
            ],
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: BasicAppButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AppPage(),
                  ),
                );
              },
              title: ('Log in'.tr()),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: BasicAppButton(
              onPressed: () => AuthService().signInWithGoogle(),
              title: 'Google Sign In',
            ),
          ),
          const SizedBox(height: 20),

          // TODO: facebook log in

          // BasicAppButton(
          //   onPressed: () => AuthService().signInWithFacebook(),
          //   title: 'Facebook Sign In',
          // )
        ],
      ),
    );
  }
}
