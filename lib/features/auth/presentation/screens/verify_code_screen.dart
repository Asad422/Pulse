import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/widgets/app_button_widget.dart';
import '../../../../core/widgets/login_auth_widgets/app_input.dart';
import '../bloc/login_bloc/login_bloc.dart';

class VerifyCodeScreen extends StatefulWidget {
  const VerifyCodeScreen({
    super.key,
    required this.email,
  });

  final String email;

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final _codeCtrl = TextEditingController();
  String? _codeErr;
  bool _tried = false;

  @override
  void dispose() {
    _codeCtrl.dispose();
    super.dispose();
  }

  void _validate() {
    final t = _codeCtrl.text.trim();
    _codeErr = t.isEmpty
        ? 'Enter the code'
        : (t.length < 6 ? 'Code must be 6 characters' : null);
  }

  bool get _valid {
    _validate();
    return _codeErr == null;
  }

  void _submit(BuildContext context) {
    setState(() {
      _tried = true;
      _validate();
    });
    if (!_valid) return;

    context.read<LoginBloc>().add(
      LoginOtpVerified(
        email: widget.email,
        code: _codeCtrl.text.trim(),
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
              context.go(AppPaths.home); // <-- используем правильный путь
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
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                      color: AppColors.textPrimary,
                      padding: EdgeInsets.zero,
                      onPressed: () => context.pop(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Enter the code we sent to\n${widget.email}',
                    style: AppTextStyles.get("Title/t2"),
                  ),
                  const SizedBox(height: 20),
                  AppTextField(
                    controller: _codeCtrl,
                    label: 'Code',
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    errorText: _tried ? _codeErr : null,
                  ),
                  const SizedBox(height: 16),
                  AppButtonWidget(
                    label: loading ? 'Continuing…' : 'Continue',
                    onPressed: loading ? null : () => _submit(context),
                    size: AppButtonWidgetSize.large,
                    intent: AppButtonWidgetIntent.primary,
                    tone: AppButtonWidgetTone.solid,
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
