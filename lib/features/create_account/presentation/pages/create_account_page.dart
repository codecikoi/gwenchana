import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gwenchana/core/helper/app_colors.dart';
import 'package:gwenchana/core/helper/basic_appbar.dart';
import 'package:gwenchana/core/helper/basic_appbutton.dart';
import 'package:gwenchana/core/helper/validation_helper.dart';
import 'package:gwenchana/core/services/auth_service_impl.dart';
import 'package:gwenchana/core/services/preferences_service.dart';
import 'package:gwenchana/features/create_account/presentation/bloc/create_account_bloc.dart';
import 'package:gwenchana/features/create_account/presentation/bloc/create_account_event.dart';
import 'package:gwenchana/features/create_account/presentation/bloc/create_account_state.dart';
import 'package:gwenchana/l10n/gen_l10n/app_localizations.dart';

//TODO: validation to fix
@RoutePage()
class CreateAccountPage extends StatelessWidget implements AutoRouteWrapper {
  const CreateAccountPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (_) => CreateAccountBloc(
        authService: AuthServiceImpl(),
        preferencesService: PreferencesService(),
      ),
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateAccountBloc, CreateAccountState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
        }
        if (state.isSuccess) {
          context.router.pushPath('/skill-choosing-page');
        }
      },
      child: BlocBuilder<CreateAccountBloc, CreateAccountState>(
        builder: (context, state) {
          return Scaffold(
            appBar: BasicAppBar(
              title: Text(
                AppLocalizations.of(context)!.createAccount,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14.0,
                  vertical: 10.0,
                ),
                child: Column(
                  children: [
                    TextField(
                      onChanged: (value) =>
                          context.read<CreateAccountBloc>().add(
                                NameChanged(value),
                              ),
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.name,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      onChanged: (value) =>
                          context.read<CreateAccountBloc>().add(
                                EmailChanged(value),
                              ),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.email,
                        border: OutlineInputBorder(),
                        errorText: state.email.isNotEmpty &&
                                !ValidationHelper.isValidEmail(state.email)
                            ? AppLocalizations.of(context)!
                                .pleaseEnterValidEmail
                            : null,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      onChanged: (value) =>
                          context.read<CreateAccountBloc>().add(
                                PasswordChanged(value),
                              ),
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.password,
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      onChanged: (value) =>
                          context.read<CreateAccountBloc>().add(
                                ConfirmPasswordChanged(value),
                              ),
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText:
                            AppLocalizations.of(context)!.confirmPassword,
                        border: OutlineInputBorder(),
                        errorText: state.confirmPassword.isNotEmpty &&
                                state.password != state.confirmPassword
                            ? AppLocalizations.of(context)!.passwordsNotMatch
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
                      onPressed: state.isValid && !state.isLoading
                          ? () => context.read<CreateAccountBloc>().add(
                                Submitted(),
                              )
                          : null,
                      title: state.isLoading
                          ? 'Creating account ...'
                          : AppLocalizations.of(context)!.createAccount,
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
                            onPressed: () =>
                                AuthServiceImpl().signInWithGoogle(),
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
                          AppLocalizations.of(context)!.doHaveAccount,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextButton(
                          onPressed: () => context.router.pushPath('/login'),
                          child: Text(
                            AppLocalizations.of(context)!.signIn,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppColors.mainColor),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
