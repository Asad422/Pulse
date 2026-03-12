import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/resources/app_icons.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/validators/validators.dart';
import '../../../../core/widgets/app_button_widget.dart';
import '../../../../core/widgets/login_auth_widgets/app_input.dart';
import '../../../../core/widgets/login_auth_widgets/apple_google_widget.dart';
import '../widgets/age_chips.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  final _locationCtrl = TextEditingController(text: '');

  bool _obscurePwd = true;
  bool _obscureConfirm = true;
  bool _agree = false;

  int? _ageIndex;

  String? _nameErr, _emailErr, _pwdErr, _confirmErr;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

  void _recomputeErrors() {
    _nameErr = _nameCtrl.text.trim().isEmpty ? 'Enter your name' : null;
    _emailErr = AppValidators.emailError(_emailCtrl.text);
    _pwdErr = AppValidators.passwordError(_passwordCtrl.text);
    _confirmErr =
        AppValidators.confirmPasswordError(_passwordCtrl.text, _confirmCtrl.text);
  }

  bool get _isFormValid {
    _recomputeErrors();
    final hasAge = _ageIndex != null;
    final agreed = _agree;
    final noFieldErrors =
    [_nameErr, _emailErr, _pwdErr, _confirmErr].every((e) => e == null);
    return hasAge && agreed && noFieldErrors;
  }

  void _onChangedRevalidate([void Function()? extra]) {
    setState(() {
      extra?.call();
      _recomputeErrors();
    });
  }

  void _submit() {
    setState(_recomputeErrors);
    if (!_isFormValid) return;
    context.go(AppPaths.bills);
  }

  void _openLocationPicker() async {
    final result = await context.push<String>(
      AppPaths.location,
      extra: _locationCtrl.text.isEmpty ? null : _locationCtrl.text,
    );
    if (result != null && result.isNotEmpty) {
      setState(() => _locationCtrl.text = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isValid = _isFormValid;

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
              Align(
                alignment: Alignment.center,
                child: AppIcons.icLogo.svg(height: 40, width: 80),
              ),
              const SizedBox(height: 24),
              Text('Join Pulse', style: AppTextStyles.get("Title/t2")),
              const SizedBox(height: 8),
              Text(
                'Make your voice heard in politics. Register to vote on policies and rate your representatives.',
                style: AppTextStyles.get("Body/p1")
                    ?.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),

              AppTextField(
                controller: _nameCtrl,
                label: 'Your name',
                textInputAction: TextInputAction.next,
                errorText: _nameErr,
                onChanged: (_) => _onChangedRevalidate(),
              ),
              const SizedBox(height: 12),

              AppTextField(
                controller: _emailCtrl,
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                errorText: _emailErr,
                onChanged: (v) =>
                    _onChangedRevalidate(() => _emailErr = AppValidators.emailError(v)),
              ),
              const SizedBox(height: 12),

              AppTextField(
                controller: _passwordCtrl,
                label: 'Password',
                obscureText: _obscurePwd,
                textInputAction: TextInputAction.next,
                errorText: _pwdErr,
                onChanged: (v) => _onChangedRevalidate(() {
                  _pwdErr = AppValidators.passwordError(v);
                  _confirmErr =
                      AppValidators.confirmPasswordError(v, _confirmCtrl.text);
                }),
                suffix: IconButton(
                  onPressed: () => setState(() => _obscurePwd = !_obscurePwd),
                  icon: (_obscurePwd ? AppIcons.icEyeOff : AppIcons.icEye)
                      .svg(width: 20, height: 20, color: AppColors.textSecondary),
                  splashRadius: 20,
                  padding: EdgeInsets.zero,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  focusColor: Colors.transparent,
                ),
              ),
              const SizedBox(height: 12),

              AppTextField(
                controller: _confirmCtrl,
                label: 'Confirm password',
                obscureText: _obscureConfirm,
                textInputAction: TextInputAction.next,
                errorText: _confirmErr,
                onChanged: (v) => _onChangedRevalidate(() {
                  _confirmErr =
                      AppValidators.confirmPasswordError(_passwordCtrl.text, v);
                }),
                suffix: IconButton(
                  onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                  icon: (_obscureConfirm ? AppIcons.icEyeOff : AppIcons.icEye)
                      .svg(width: 20, height: 20, color: AppColors.textSecondary),
                  splashRadius: 20,
                  padding: EdgeInsets.zero,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  focusColor: Colors.transparent,
                ),
              ),
              const SizedBox(height: 12),

              TextField(
                controller: _locationCtrl,
                readOnly: true,
                showCursor: false,
                enableInteractiveSelection: false,
                onTap: _openLocationPicker,
                style: AppTextStyles.get("Input/Text"),
                decoration: AppInput.decoration(
                  'Location',
                  suffix: IconButton(
                    onPressed: _openLocationPicker,
                    icon: AppIcons.icLocation.svg(
                      width: 20,
                      height: 20,
                      color: AppColors.textSecondary,
                    ),
                    splashRadius: 20,
                    padding: EdgeInsets.zero,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    focusColor: Colors.transparent,
                  ),
                ).copyWith(
                  helperText: 'Helps us show you relevant local issues',
                  helperStyle: AppTextStyles
                      .get("Caption/c1")
                      ?.copyWith(color: AppColors.textSecondary),
                ),
              ),
              const SizedBox(height: 16),

              Text('Your Age', style: AppTextStyles.get("Label/l1")),
              const SizedBox(height: 8),
              AgeChips(
                selectedIndex: _ageIndex,
                onChanged: (i) => _onChangedRevalidate(() => _ageIndex = i),
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
                      onChanged: (v) => _onChangedRevalidate(() => _agree = v ?? false),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                      side: BorderSide(
                          color: AppColors.textSecondary.withOpacity(0.4)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: AppTextStyles
                            .get("Body/p2")
                            ?.copyWith(color: AppColors.textPrimary),
                        children: [
                          const TextSpan(text: 'I agree to the '),
                          TextSpan(
                            text: 'Safety Policy',
                            style: AppTextStyles
                                .get("Body/p2")
                                ?.copyWith(color: AppColors.primary),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => context.push(AppPaths.policySafety),
                          ),
                          const TextSpan(text: ' and '),
                          TextSpan(
                            text: 'User Rights',
                            style: AppTextStyles
                                .get("Body/p2")
                                ?.copyWith(color: AppColors.primary),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => context.push(AppPaths.userRights),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: AppButtonWidget(
                  label: 'Get Started',
                  onPressed: isValid ? _submit : null,
                  size: AppButtonWidgetSize.large,
                  intent: AppButtonWidgetIntent.primary,
                  tone: AppButtonWidgetTone.solid,
                ),
              ),

              const SizedBox(height: 24),
              SocialProviders(
                title: 'or continue with',
                onGooglePressed: () => debugPrint('Google pressed'),
                onApplePressed: () => debugPrint('Apple pressed'),
              ),

              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),

              Row(
                children: [
                  Text('Already have an account?', style: AppTextStyles.get("Body/p1")),
                  const Spacer(),
                  TextButton(
                    onPressed: () => context.go(AppPaths.login),
                    child: Text(
                      'Log in',
                      style: AppTextStyles
                          .get("Button/Medium")
                          ?.copyWith(color: AppColors.primary),
                    ),
                  ),
                ],
              ),

              const Divider(),
              const SizedBox(height: 8),

              Center(
                child: TextButton(
                  onPressed: () => context.go(AppPaths.bills),
                  child: Text(
                    'Continue as guest',
                    style: AppTextStyles
                        .get("Button/Medium")
                        ?.copyWith(color: AppColors.primary),
                  ),
                ),
              ),
              Center(
                child: Text(
                  'Limited features, no voting',
                  style: AppTextStyles
                      .get("Body/p2")
                      ?.copyWith(color: AppColors.textSecondary),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
