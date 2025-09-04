import 'package:flutter/material.dart';
import '../../../../core/resources/app_icons.dart';
import '../../../../core/theme/text_styles.dart';
import '../../theme/app_colors.dart';

class SocialProviders extends StatelessWidget {
  const SocialProviders({
    super.key,
    this.title = 'or continue with',
    this.onGooglePressed,
    this.onApplePressed,
  });

  final String title;
  final VoidCallback? onGooglePressed;
  final VoidCallback? onApplePressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _LinedText(title),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: AppleGoogleWidget(
                label: 'Google',
                icon: AppIcons.icGoogle,
                onPressed: onGooglePressed ?? () => debugPrint('Google pressed'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: AppleGoogleWidget(
                label: 'Apple',
                icon: AppIcons.icApple,
                onPressed: onApplePressed ?? () => debugPrint('Apple pressed'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class AppleGoogleWidget extends StatelessWidget {
  const AppleGoogleWidget({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final SvgAsset icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final style = ButtonStyle(
      minimumSize: WidgetStateProperty.all(const Size.fromHeight(56)),
      padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 16)),
      side: WidgetStateProperty.all(BorderSide(color: Colors.grey.shade300)),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      backgroundColor: WidgetStateProperty.all(AppColors.primaryContainer),
    );

    return SizedBox(
      height: 56,
      child: OutlinedButton(
        onPressed: onPressed,
        style: style,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon.svg(width: 20, height: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.get("Body/p2")?.copyWith(color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}

class _LinedText extends StatelessWidget {
  const _LinedText(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    final style = AppTextStyles.get("Body/p3-high");
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(text, style: style),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}
