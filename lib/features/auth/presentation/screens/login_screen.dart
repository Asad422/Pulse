import 'package:flutter/gestures.dart';
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
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  bool _agree = false;
  bool _triedSubmit = false;

  String? _nameErr, _emailErr;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  void _validate() {
    _nameErr = _nameCtrl.text.trim().isEmpty ? 'Enter your name' : null;
    _emailErr = AppValidators.emailError(_emailCtrl.text.trim());
  }

  bool get _isFormValid {
    _validate();
    return _nameErr == null && _emailErr == null && _agree;
  }

  void _submit(BuildContext context) {
    setState(() {
      _triedSubmit = true;
      _validate();
    });
    if (!_isFormValid) return;

    context.read<LoginBloc>().add(
      LoginOtpRequested(
        email: _emailCtrl.text.trim(),
        login: _nameCtrl.text.trim(),
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
            if (state is LoginOtpRequestSuccess) {
              context.go(AppPaths.verifyCode, extra: {'email': _emailCtrl.text.trim()});

            } else if (state is LoginFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            } else if (state is LoginSuccess) {
              context.push(AppPaths.home);
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
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.center,
                    child: AppIcons.icLogo.svg(height: 44, width: 88),
                  ),
                  const SizedBox(height: 24),

                  Text('Join Pulse', style: AppTextStyles.get("Title/t2")),
                  const SizedBox(height: 8),
                  Text(
                    'Make your voice heard in politics. '
                        'Register to vote on policies and rate your representatives.',
                    style: AppTextStyles.get("Body/p1")
                        ?.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 20),

                  AppTextField(
                    controller: _nameCtrl,
                    label: 'Your name',
                    textInputAction: TextInputAction.next,
                    errorText: _triedSubmit ? _nameErr : null,
                  ),
                  const SizedBox(height: 12),

                  AppTextField(
                    controller: _emailCtrl,
                    label: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    errorText: _triedSubmit ? _emailErr : null,
                  ),
                  const SizedBox(height: 12),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: _agree,
                          onChanged: (v) => setState(() => _agree = v ?? false),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: AppTextStyles.get("Body/p2"),
                            children: [
                              const TextSpan(text: 'I agree to the '),
                              TextSpan(
                                text: 'Terms of Service',
                                style: AppTextStyles.get("Body/p2")
                                    ?.copyWith(color: AppColors.primary),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {},
                              ),
                              const TextSpan(text: ' and '),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: AppTextStyles.get("Body/p2")
                                    ?.copyWith(color: AppColors.primary),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {},
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_triedSubmit && !_agree)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        'You must agree to continue',
                        style: AppTextStyles.get("Caption/c1")
                            ?.copyWith(color: AppColors.error),
                      ),
                    ),

                  const SizedBox(height: 16),

                  AppButtonWidget(
                    label: loading ? 'Continuing…' : 'Continue',
                    onPressed: loading ? null : () => _submit(context),
                    size: AppButtonWidgetSize.large,
                    intent: AppButtonWidgetIntent.primary,
                    tone: AppButtonWidgetTone.solid,
                  ),

                  const SizedBox(height: 20),
                  SocialProviders(
                    title: 'or continue with',
                    onGooglePressed: () => debugPrint('Google pressed'),
                    onApplePressed: () => debugPrint('Apple pressed'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
