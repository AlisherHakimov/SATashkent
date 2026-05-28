import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/constants/colors.dart';

enum LegalType { privacyPolicy, termsOfService }

class LegalScreen extends StatelessWidget {
  final LegalType type;
  const LegalScreen({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final isPrivacy = type == LegalType.privacyPolicy;
    return Scaffold(
      backgroundColor: AppColors.bgSecondary,
      appBar: AppBar(
        title: Text(isPrivacy ? 'Privacy Policy' : 'Terms of Service'),
        leading: IconButton(
          icon: const Icon(PhosphorIconsRegular.arrowLeft),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: isPrivacy ? _privacySections : _termsSections,
        ),
      ),
    );
  }
}

const _privacySections = [
  _LegalSection(
    title: 'Privacy Policy',
    date: 'Effective date: January 1, 2025',
    body:
        'SATashkent ("we", "our", or "us") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, and safeguard your personal information when you use the SATashkent mobile application.',
  ),
  _LegalSection(
    title: '1. Information We Collect',
    body: 'We collect the following types of information:\n\n'
        '• Account information: name, phone number, and email address provided during registration.\n\n'
        '• Usage data: quiz results, test scores, practice history, and learning progress.\n\n'
        '• Device information: device type, operating system, and app version for technical support.\n\n'
        '• Analytics: anonymised usage statistics to improve the app experience.',
  ),
  _LegalSection(
    title: '2. How We Use Your Information',
    body: 'We use your information to:\n\n'
        '• Provide and personalise the learning experience.\n'
        '• Track your SAT preparation progress and scores.\n'
        '• Send reminders and competition notifications (if enabled).\n'
        '• Improve our content and fix technical issues.\n'
        '• Comply with legal obligations.',
  ),
  _LegalSection(
    title: '3. Data Sharing',
    body:
        'We do not sell or rent your personal data to third parties. We may share data with trusted service providers (e.g., cloud hosting) solely to operate the app. All providers are bound by confidentiality agreements.',
  ),
  _LegalSection(
    title: '4. Data Security',
    body:
        'We use industry-standard encryption and secure storage practices to protect your data. However, no method of transmission over the internet is 100% secure.',
  ),
  _LegalSection(
    title: '5. Your Rights',
    body: 'You have the right to:\n\n'
        '• Access the personal data we hold about you.\n'
        '• Request correction or deletion of your data.\n'
        '• Withdraw consent for notifications at any time via Settings.\n\n'
        'To exercise these rights, contact us at support@satashkent.uz.',
  ),
  _LegalSection(
    title: '6. Children\'s Privacy',
    body:
        'Our app is designed for students aged 14 and above. We do not knowingly collect data from children under 13 without parental consent.',
  ),
  _LegalSection(
    title: '7. Changes to This Policy',
    body:
        'We may update this Privacy Policy from time to time. We will notify you of significant changes via the app or email. Continued use of the app after changes constitutes your acceptance.',
  ),
  _LegalSection(
    title: '8. Contact',
    body:
        'If you have questions about this Privacy Policy, please contact us:\n\nEmail: support@satashkent.uz\nTelegram: @satashkent_support',
  ),
];

const _termsSections = [
  _LegalSection(
    title: 'Terms of Service',
    date: 'Effective date: January 1, 2025',
    body:
        'By downloading or using the SATashkent application, you agree to these Terms of Service. Please read them carefully.',
  ),
  _LegalSection(
    title: '1. Use of the App',
    body:
        'SATashkent provides SAT preparation tools including practice questions, mock tests, competitions, and learning resources. The app is intended for personal, non-commercial educational use only.',
  ),
  _LegalSection(
    title: '2. Account',
    body:
        'You must create an account to use most features. You are responsible for keeping your login credentials secure. You must not share your account with others.',
  ),
  _LegalSection(
    title: '3. Content',
    body:
        'All questions, explanations, and learning content are the intellectual property of SATashkent. You may not copy, distribute, or reproduce any content without written permission.',
  ),
  _LegalSection(
    title: '4. Competitions',
    body:
        'Competition rules are posted within each competition. SATashkent reserves the right to disqualify users found cheating or exploiting technical vulnerabilities. Prize decisions are final.',
  ),
  _LegalSection(
    title: '5. Acceptable Use',
    body: 'You agree not to:\n\n'
        '• Use the app for any unlawful purpose.\n'
        '• Attempt to hack, reverse-engineer, or disrupt the service.\n'
        '• Create multiple accounts to gain unfair advantages.\n'
        '• Upload harmful or offensive content.',
  ),
  _LegalSection(
    title: '6. Subscriptions & Payments',
    body:
        'Some features may require a paid subscription. Subscriptions auto-renew unless cancelled at least 24 hours before the renewal date. Refunds are subject to app store policies.',
  ),
  _LegalSection(
    title: '7. Limitation of Liability',
    body:
        'SATashkent is provided "as is" without warranties of any kind. We are not liable for any inaccuracies in content or any losses arising from your use of the app.',
  ),
  _LegalSection(
    title: '8. Termination',
    body:
        'We reserve the right to suspend or terminate accounts that violate these Terms without prior notice.',
  ),
  _LegalSection(
    title: '9. Changes to Terms',
    body:
        'We may update these Terms at any time. Continued use of the app after changes means you accept the new Terms.',
  ),
  _LegalSection(
    title: '10. Contact',
    body:
        'Questions about these Terms? Contact us:\n\nEmail: support@satashkent.uz\nTelegram: @satashkent_support',
  ),
];

class _LegalSection extends StatelessWidget {
  final String title;
  final String body;
  final String? date;
  const _LegalSection({required this.title, required this.body, this.date});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          if (date != null) ...[
            const SizedBox(height: 4),
            Text(date!, style: const TextStyle(fontSize: 12, color: AppColors.textTertiary)),
          ],
          const SizedBox(height: 8),
          Text(body,
              style: const TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.6)),
        ],
      ),
    );
  }
}
