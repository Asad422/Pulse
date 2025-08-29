import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/localization/generated/l10n.dart';
import '../../core/resources/app_icons.dart';
import '../../core/router/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/text_styles.dart';
import '../../core/widgets/app_button_widget.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              Align(alignment: Alignment.center, child: AppIcons.icLogo.svg(height: 40, width: 80)),
              const SizedBox(height: 24),
              Text(l10n.onbHeader, textAlign: TextAlign.center, style: AppTextStyles.get("Title/t2")),
              const SizedBox(height: 8),
              Text(
                l10n.onbSubtitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.get("Body/p1"),
              ),
              const SizedBox(height: 24),
              Center(child: AppIcons.icPeoples.svg(width: 256, height: 240)),
              const SizedBox(height: 24),
              Text(l10n.onbSectionTitle, textAlign: TextAlign.center, style: AppTextStyles.get("Title/t2")),
              const SizedBox(height: 8),
              Text(
                l10n.onbSectionBody,
                textAlign: TextAlign.center,
                style: AppTextStyles.get("Body/p1"),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: AppButtonWidget(
                  label: l10n.onbCtaGetStarted,
                  onPressed: () => context.go(AppPaths.login),
                  size: AppButtonWidgetSize.large,
                  intent: AppButtonWidgetIntent.primary,
                  tone: AppButtonWidgetTone.solid,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: AppButtonWidget(
                  label: l10n.onbCtaContinueGuest,
                  onPressed: () => context.go(AppPaths.home),
                  size: AppButtonWidgetSize.large,
                  intent: AppButtonWidgetIntent.primary,
                  tone: AppButtonWidgetTone.ghost,
                ),
              ),
              const Spacer(),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: AppTextStyles.get("Body/p3"),
                  children: [
                    TextSpan(text: l10n.onbTermsPrefix),
                    TextSpan(
                      text: l10n.onbTermsTerms,
                      style: AppTextStyles.get("Body/p3-bold")?.copyWith(
                        decoration: TextDecoration.underline,
                        color: AppColors.primary,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => context.push(AppPaths.userRights),
                    ),
                    const TextSpan(text: '\n'),
                    TextSpan(text: l10n.onbTermsAnd),
                    TextSpan(
                      text: l10n.onbTermsPrivacy,
                      style: AppTextStyles.get("Body/p3-bold")?.copyWith(
                        decoration: TextDecoration.underline,
                        color: AppColors.primary,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => context.push(AppPaths.policySafety),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
