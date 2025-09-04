import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/resources/app_icons.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/validators/validators.dart';
import '../../../../core/widgets/app_button_widget.dart';
import '../../../../core/widgets/login_auth_widgets/app_input.dart';
import '../../../../core/widgets/login_auth_widgets/apple_google_widget.dart';
import '../bloc/login_bloc/login_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscure = true;

  String? _emailErr, _pwdErr;
  bool _triedSubmit = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _validate() {
    // _emailErr = AppValidators.emailError(_emailCtrl.text);
    _pwdErr = _passwordCtrl.text.isEmpty ? 'Enter your password' : null;
  }

  bool get _isFormValid {
    _validate();
    return _emailErr == null && _pwdErr == null;
  }

  void _submit(BuildContext context) {
    setState(() {
      _triedSubmit = true;
      _validate();
    });
    if (!_isFormValid) return;

    context.read<LoginBloc>().add(
      LoginSubmitted(
        login: _emailCtrl.text.trim(),
        password: _passwordCtrl.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              context.go(AppPaths.home);
            } else if (state is LoginFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            final loading = state is LoginLoading;

            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.center,
                    child: AppIcons.icLogo.svg(height: 40, width: 80),
                  ),
                  const SizedBox(height: 24),
                  Text('Log in', style: AppTextStyles.get("Title/t2")),
                  const SizedBox(height: 12),

                  // Email
                  AppTextField(
                    controller: _emailCtrl,
                    label: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    errorText: _triedSubmit ? _emailErr : null,
                  ),
                  const SizedBox(height: 12),

                  // Password
                  AppTextField(
                    controller: _passwordCtrl,
                    label: 'Password',
                    obscureText: _obscure,
                    textInputAction: TextInputAction.done,
                    errorText: _triedSubmit ? _pwdErr : null,
                    suffix: IconButton(
                      onPressed: () => setState(() => _obscure = !_obscure),
                      icon: (_obscure ? AppIcons.icEyeOff : AppIcons.icEye)
                          .svg(width: 20, height: 20, color: AppColors.textSecondary),
                      splashRadius: 20,
                      padding: EdgeInsets.zero,
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      focusColor: Colors.transparent,
                    ),
                  ),

                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: AppButtonWidget(
                      label: loading ? 'Logging in…' : 'Log in',
                      onPressed: loading ? null : () => _submit(context),
                      size: AppButtonWidgetSize.large,
                      intent: AppButtonWidgetIntent.primary,
                      tone: AppButtonWidgetTone.solid,
                    ),
                  ),
                  const SizedBox(height: 16),

                  SocialProviders(
                    title: 'or continue with',
                    onGooglePressed: () => debugPrint('Google pressed'),
                    onApplePressed: () => debugPrint('Apple pressed'),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(),
                  ),
                  Row(
                    children: [
                      Text("Don’t have an account? ", style: AppTextStyles.get("Body/p1")),
                      const Spacer(),
                      TextButton(
                        onPressed: () => context.go(AppPaths.register),
                        child: Text(
                          'Sign Up',
                          style: AppTextStyles.get("Button/Medium")
                              ?.copyWith(color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(),
                  ),
                  Center(
                    child: TextButton(
                      onPressed: () => context.go(AppPaths.home),
                      child: Text(
                        'Continue as guest',
                        style: AppTextStyles.get("Button/Medium")
                            ?.copyWith(color: AppColors.primary),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      'Limited features, no voting',
                      style: AppTextStyles.get("Body/p2")
                          ?.copyWith(color: AppColors.textSecondary),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
