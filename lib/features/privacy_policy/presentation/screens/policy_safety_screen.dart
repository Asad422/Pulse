import 'package:flutter/material.dart';
import '../../../../core/localization/generated/l10n.dart';
import '../../../../core/theme/text_styles.dart';


class PolicySafetyScreen extends StatelessWidget {
  const PolicySafetyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text("l10n.legalPolicySafetyTitle")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.policy, size: 96),
              const SizedBox(height: 16),
              Text(
               " l10n.legalPolicySafetyTitle",
                style: AppTextStyles.get("Title/t2"),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                "l10n.legalPolicySafetyBody",
                style: AppTextStyles.get("Body/p1"),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
