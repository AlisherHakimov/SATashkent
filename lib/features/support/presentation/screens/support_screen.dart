import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/colors.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgSecondary,
      appBar: AppBar(
        title: const Text('Support'),
        leading: IconButton(
          icon: const Icon(PhosphorIconsRegular.arrowLeft),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.gradientStart, AppColors.gradientEnd],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Need help?', style: TextStyle(color: Colors.white70, fontSize: 13)),
                    SizedBox(height: 4),
                    Text('Our team is here',
                        style: TextStyle(
                            color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                    SizedBox(height: 6),
                    Text(
                      'Mon – Sat  ·  09:00 – 20:00',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16),
              _SupportIconBox(),
            ]),
          ),

          const SizedBox(height: 24),

          const _SectionTitle('Contact Us'),
          _ContactCard(
            icon: PhosphorIconsFill.telegramLogo,
            color: const Color(0xFF2AABEE),
            platform: 'Telegram',
            handle: '@satashkent_support',
            subtitle: 'Fastest response — usually within minutes',
            onTap: () =>
                _launchUrl(context, 'https://t.me/satashkent_support', '@satashkent_support'),
          ),
          const SizedBox(height: 10),
          _ContactCard(
            icon: PhosphorIconsFill.whatsappLogo,
            color: const Color(0xFF25D366),
            platform: 'WhatsApp',
            handle: '+998 90 000-00-00',
            subtitle: 'Available during working hours',
            onTap: () => _launchUrl(context, 'https://wa.me/998900000000', '+998 90 000-00-00'),
          ),
          const SizedBox(height: 10),
          _ContactCard(
            icon: PhosphorIconsFill.envelope,
            color: AppColors.primary,
            platform: 'Email',
            handle: 'support@satashkent.uz',
            subtitle: 'For detailed inquiries and documents',
            onTap: () =>
                _launchUrl(context, 'mailto:support@satashkent.uz', 'support@satashkent.uz'),
          ),

          const SizedBox(height: 24),

          const _SectionTitle('Mentor Sessions'),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.bgPrimary,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: const Column(
              children: [
                _SessionRow(
                  day: 'Monday',
                  time: '18:00 – 19:00',
                  topic: 'Math — Algebra & Functions',
                  available: true,
                ),
                Divider(height: 20),
                _SessionRow(
                  day: 'Wednesday',
                  time: '18:00 – 19:00',
                  topic: 'English — Reading Comprehension',
                  available: true,
                ),
                Divider(height: 20),
                _SessionRow(
                  day: 'Friday',
                  time: '17:00 – 18:30',
                  topic: 'Full Mock Test Review',
                  available: false,
                ),
                Divider(height: 20),
                _SessionRow(
                  day: 'Saturday',
                  time: '10:00 – 11:30',
                  topic: 'Writing & Language',
                  available: true,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          const _SectionTitle('FAQ'),
          ..._faqs.map((faq) => _FaqTile(faq: faq)),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Future<void> _launchUrl(BuildContext context, String url, String fallbackText) async {
    final messenger = ScaffoldMessenger.of(context);
    final uri = Uri.parse(url);
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched) {
      // Fallback: copy to clipboard
      await Clipboard.setData(ClipboardData(text: fallbackText));
      messenger.showSnackBar(
        SnackBar(
          content: Text('Copied: $fallbackText'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}

const _faqs = [
  (
    q: 'How is my SAT score calculated?',
    a: 'Your score is based on correctly answered questions in Math and English. Each section contributes up to 800 points for a total of 1600.',
  ),
  (
    q: 'Can I retry questions I got wrong?',
    a: 'Yes! Go to Question Bank, filter by subject or difficulty, and you can practice any question again.',
  ),
  (
    q: 'How do competitions work?',
    a: 'Competitions run for a set period. Answer questions, earn points, and climb the leaderboard. Top performers win prizes.',
  ),
  (
    q: 'How do I reset my progress?',
    a: 'Contact support via Telegram or email. Progress reset requires manual review to prevent accidental loss.',
  ),
];


class _SupportIconBox extends StatelessWidget {
  const _SupportIconBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(PhosphorIconsFill.headset, color: Colors.white, size: 32),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Text(title.toUpperCase(),
          style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.textTertiary,
              letterSpacing: 0.8)),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String platform;
  final String handle;
  final String subtitle;
  final VoidCallback onTap;
  const _ContactCard(
      {required this.icon,
      required this.color,
      required this.platform,
      required this.handle,
      required this.subtitle,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.bgPrimary,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Row(children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(platform,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              Text(handle,
                  style: TextStyle(fontSize: 13, color: color, fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
            ]),
          ),
          const Icon(PhosphorIconsRegular.copy, size: 16, color: AppColors.textTertiary),
        ]),
      ),
    );
  }
}

class _SessionRow extends StatelessWidget {
  final String day;
  final String time;
  final String topic;
  final bool available;
  const _SessionRow(
      {required this.day, required this.time, required this.topic, required this.available});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(day,
                style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            Text(time, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            const SizedBox(height: 2),
            Text(topic, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          ]),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: available ? AppColors.success.withValues(alpha: 0.1) : AppColors.errorLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            available ? 'Open' : 'Full',
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: available ? AppColors.success : AppColors.error),
          ),
        ),
      ],
    );
  }
}

class _FaqTile extends StatelessWidget {
  final ({String q, String a}) faq;
  const _FaqTile({required this.faq});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.bgPrimary,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
        title: Text(faq.q,
            style: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(faq.a,
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.5)),
        ],
      ),
    );
  }
}
