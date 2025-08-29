import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text('Privacy Policy', style: AppTextStyles.get("Title/t3"))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Privacy Policy (MVP – Pulse)', style: AppTextStyles.get("Title/t2")),
            const SizedBox(height: 8),
            Text('Effective Date: [Insert Date]', style: AppTextStyles.get("Body/p2-high")),
            const SizedBox(height: 16),
            Text(
              'Pulse Inc. (“Pulse,” “we,” “our,” or “us”) values your privacy. This Privacy Policy explains how we collect, use, and protect information when you use the Pulse mobile app (“Service”).',
              style: AppTextStyles.get("Body/p1"),
            ),
            const SizedBox(height: 20),

            const _SectionTitle('1. Information We Collect'),
            const _Bullet('Personal Information you provide: name, age, location (city/state/ZIP), phone number, email, account credentials.'),
            const _Bullet('Activity Data: votes, ratings, poll participation history.'),
            const _Bullet('Device Data: device type, operating system, IP address, crash reports, log data.'),
            const _Bullet('Location Data: general location (city/state).'),

            const _SectionTitle('2. How We Collect It'),
            const _Bullet('When you create an account or update your profile.'),
            const _Bullet('When you participate in polls or rate politicians/policies.'),
            const _Bullet('Automatically via cookies, app logs, and analytics tools.'),
            const _Bullet('From third-party services that support our app (hosting, analytics, crash reporting, push notifications).'),

            const _SectionTitle('3. How We Use Information'),
            const _Bullet('To provide and improve the Service.'),
            const _Bullet('To show aggregated approval ratings and polling results (always anonymized).'),
            const _Bullet('To keep the Service secure and prevent misuse.'),
            const _Bullet('To comply with U.S. legal obligations.'),
            const _Bullet('To communicate service updates and security alerts.'),

            const _SectionTitle('4. Sharing of Information'),
            Text('We do not sell your personal data. We only share it with:', style: AppTextStyles.get("Body/p1")),
            const SizedBox(height: 6),
            const _Bullet('Service providers (cloud hosting, analytics, crash reporting, push notifications).'),
            const _Bullet('Legal authorities if required by law.'),
            const _Bullet('Successors if Pulse is acquired or merged.'),

            const _SectionTitle('5. Data Retention & Deletion'),
            const _Bullet('We keep data as long as needed to operate the Service.'),
            const _Bullet('You can request account deletion by emailing us at privacy@pulseapp.com.'),
            const _Bullet('Aggregated, anonymized data may be kept indefinitely.'),

            const _SectionTitle('6. Your Rights'),
            const _Bullet('California (CCPA): right to request access or deletion.'),
            const _Bullet('All users may request deletion of their data.'),

            const _SectionTitle('7. Children’s Privacy'),
            const _Bullet('Pulse is not directed at children under 13. We do not knowingly collect data from them.'),

            const _SectionTitle('8. Security'),
            const _Bullet('We use reasonable safeguards to protect data, but no system is completely secure.'),

            const _SectionTitle('9. Changes'),
            const _Bullet('We may update this Privacy Policy. If major changes occur, we’ll notify you in-app or by email.'),

            const _SectionTitle('10. Contact'),
            const _Bullet('Pulse Inc.'),
            const _Bullet('Email: privacy@pulseapp.com'),
            const _Bullet('Address: [Insert Delaware address]'),

            const SizedBox(height: 24),
            Text('Terms of Service (MVP – Pulse)', style: AppTextStyles.get("Title/t2")),
            const SizedBox(height: 8),
            Text('Effective Date: [Insert Date]', style: AppTextStyles.get("Body/p2-high")),
            const SizedBox(height: 12),

            const _SectionTitle('1. Eligibility'),
            const _Bullet('You must be at least 13 years old.'),
            const _Bullet('The Service is intended for U.S. residents (initial launch in New York and California).'),

            const _SectionTitle('2. Accounts'),
            const _Bullet('Provide accurate info when signing up.'),
            const _Bullet('Do not impersonate others.'),
            const _Bullet('Keep your password secure.'),

            const _SectionTitle('3. Acceptable Use'),
            Text('You may not:', style: AppTextStyles.get("Body/p1")),
            const SizedBox(height: 6),
            const _Bullet('Use Pulse for unlawful or fraudulent purposes.'),
            const _Bullet('Harass or abuse other users.'),
            const _Bullet('Manipulate or tamper with poll results.'),
            const _Bullet('Interfere with or disrupt the Service.'),

            const _SectionTitle('4. User Content'),
            const _Bullet('You own the content you provide.'),
            const _Bullet('By submitting, you give Pulse a limited license to use and display it within the Service.'),

            const _SectionTitle('5. Polling & Voting Disclaimer'),
            const _Bullet('Pulse is not an official election platform. Results are for informational purposes only.'),

            const _SectionTitle('6. Future Paid Features'),
            const _Bullet('Pulse may introduce subscriptions or premium features later. Payment terms will be provided then.'),

            const _SectionTitle('7. Intellectual Property'),
            const _Bullet('Pulse’s trademarks, logos, and software belong to Pulse Inc. You may not copy, distribute, or reverse-engineer the Service.'),

            const _SectionTitle('8. Disclaimers'),
            const _Bullet('Pulse is provided “as is” and “as available.” We do not guarantee accuracy or uninterrupted service.'),

            const _SectionTitle('9. Limitation of Liability'),
            const _Bullet('To the fullest extent allowed by law, Pulse is not liable for indirect or consequential damages.'),
            const _Bullet('Maximum liability = any fees you paid in the last 12 months (if any).'),

            const _SectionTitle('10. Termination'),
            const _Bullet('We may suspend or terminate your account if you violate these Terms. You may stop using Pulse at any time.'),

            const _SectionTitle('11. Governing Law'),
            const _Bullet('These Terms are governed by Delaware law. [MVP: disputes in Delaware courts; arbitration may be added later].'),

            const _SectionTitle('12. Updates'),
            const _Bullet('We may update these Terms. If we make major changes, we’ll notify you in-app or by email. Continued use = acceptance of updated Terms.'),

            const SizedBox(height: 24),
            Text(
              'This version is MVP-ready:\n• Complies with COPPA (under 13), CCPA (California users), and U.S. privacy norms.\n• Keeps it simple for app store review and first users.\n• Leaves placeholders for subscriptions, GDPR, and arbitration for later growth.',
              style: AppTextStyles.get("Body/p2"),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Text(text, style: AppTextStyles.get("Title/t3")),
    );
  }
}

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 2, bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: AppTextStyles.get("Body/p1")),
          Expanded(child: Text(text, style: AppTextStyles.get("Body/p1"))),
        ],
      ),
    );
  }
}
