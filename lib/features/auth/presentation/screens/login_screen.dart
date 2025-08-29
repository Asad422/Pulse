import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/resources/app_icons.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/widgets/app_button_widget.dart';
import '../../../../core/widgets/login_auth_widgets/apple_google_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = AppColors.textSecondary.withOpacity(0.25);

    InputDecoration deco(String label, {Widget? suffix}) => InputDecoration(
          labelText: label,
          labelStyle: AppTextStyles.inputLabel,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          floatingLabelAlignment: FloatingLabelAlignment.start,

          filled: true,
          fillColor: Colors.white,

          // больше места сверху под лейбл
          contentPadding: const EdgeInsets.fromLTRB(16, 20, 16, 14),

          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.textSecondary.withOpacity(0.25)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),

          suffixIcon: suffix,
        );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              Align(alignment: Alignment.center, child: AppIcons.icLogo.svg(height: 40, width: 80)),
              const SizedBox(height: 24),
              Text('Log in', style: AppTextStyles.get("Title/t2")),
              const SizedBox(height: 12),
              TextField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                style: AppTextStyles.get("Input/Text"),
                decoration: deco('Email'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _passwordCtrl,
                obscureText: _obscure,
                textInputAction: TextInputAction.done,
                style: AppTextStyles.get("Input/Text"),
                decoration: deco(
                  'Password',
                  suffix: IconButton(
                    onPressed: () => setState(() => _obscure = !_obscure),
                    icon: (_obscure ? AppIcons.icEyeOff : AppIcons.icEye)
                        .svg(width: 20, height: 20, color: AppColors.textSecondary),
                    splashRadius: 20,
                    padding: EdgeInsets.zero,

                    // выключаем хайлайт/риппл
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    focusColor: Colors.transparent,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: AppButtonWidget(
                  label: 'Log in',
                  onPressed: () => context.go(AppPaths.home),
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don’t have an account? ", style: AppTextStyles.get("Body/p1")),
                  Spacer(),
                  TextButton(
                    onPressed: () => context.go(AppPaths.register),
                    child: Text(
                      'Sign Up',
                      style: AppTextStyles.get("Button/Medium")?.copyWith(color: AppColors.primary),
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
                    style: AppTextStyles.get("Button/Medium")?.copyWith(color: AppColors.primary),
                  ),
                ),
              ),
              Center(child: Text('Limited features, no voting', style: AppTextStyles.get("Body/p2"))),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _LinedText extends StatelessWidget {
  final String text;

  const _LinedText(this.text);

  @override
  Widget build(BuildContext context) {
    final style = AppTextStyles.get("Body/p3-high");
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text(text, style: style)),
        const Expanded(child: Divider()),
      ],
    );
  }
}
