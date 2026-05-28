import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/di/di_container.dart';
import '../../../../core/mock/mock_user.dart';
import '../../../../core/router/app_router.dart';
import '../../../../features/app/bloc/app_cubit.dart';
import '../../../../features/app/bloc/theme_cubit.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _dailyReminder = true;

  @override
  Widget build(BuildContext context) {
    const user = MockUser.currentUser;

    return Scaffold(
      backgroundColor: AppColors.bgSecondary,
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(PhosphorIconsRegular.arrowLeft),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _SectionTitle('Account'),
          _SettingsCard(children: [
            _InfoRow(
              icon: PhosphorIconsRegular.user,
              label: 'Name',
              value: user.fullName,
            ),
            const Divider(height: 1, indent: 56),
            _InfoRow(
              icon: PhosphorIconsRegular.phone,
              label: 'Phone',
              value: user.phone,
            ),
          ]),

          const SizedBox(height: 20),

          const _SectionTitle('Appearance'),
          BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, themeState) {
              final isDark = themeState.themeMode == ThemeMode.dark;
              return _SettingsCard(children: [
                _SwitchRow(
                  icon: isDark ? PhosphorIconsRegular.moon : PhosphorIconsRegular.sun,
                  label: 'Dark Mode',
                  subtitle: isDark ? 'Currently using dark theme' : 'Currently using light theme',
                  value: isDark,
                  onChanged: (v) =>
                      context.read<ThemeCubit>().setTheme(v ? ThemeMode.dark : ThemeMode.light),
                ),
              ]);
            },
          ),

          const SizedBox(height: 20),

          const _SectionTitle('Notifications'),
          _SettingsCard(children: [
            _SwitchRow(
              icon: PhosphorIconsRegular.bell,
              label: 'Push Notifications',
              subtitle: 'Competitions, streaks, reminders',
              value: _pushNotifications,
              onChanged: (v) => setState(() => _pushNotifications = v),
            ),
            const Divider(height: 1, indent: 56),
            _SwitchRow(
              icon: PhosphorIconsRegular.clock,
              label: 'Daily Reminder',
              subtitle: 'Remind me to practice every day',
              value: _dailyReminder,
              onChanged: (v) => setState(() => _dailyReminder = v),
            ),
          ]),

          const SizedBox(height: 20),

          const _SectionTitle('About'),
          _SettingsCard(children: [
            _TapRow(
              icon: PhosphorIconsRegular.info,
              label: 'App Version',
              trailing: const Text(
                '1.0.0',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              onTap: () {},
            ),
            const Divider(height: 1, indent: 56),
            _TapRow(
              icon: PhosphorIconsRegular.shieldCheck,
              label: 'Privacy Policy',
              onTap: () => context.push(Routes.privacyPolicy),
            ),
            const Divider(height: 1, indent: 56),
            _TapRow(
              icon: PhosphorIconsRegular.fileText,
              label: 'Terms of Service',
              onTap: () => context.push(Routes.termsOfService),
            ),
          ]),

          const SizedBox(height: 20),

          _SettingsCard(children: [
            _TapRow(
              icon: PhosphorIconsRegular.signOut,
              label: 'Log Out',
              labelColor: AppColors.error,
              iconColor: AppColors.error,
              onTap: () => _showLogoutDialog(context),
            ),
          ]),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out of your account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await sl<AppCubit>().logout();
              sl<AppRouter>().router.go(Routes.login);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.textTertiary,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgPrimary,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(children: children),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(children: [
        Icon(icon, size: 22, color: AppColors.primaryBlue),
        const SizedBox(width: 14),
        Text(label,
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
        const Spacer(),
        Text(value, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
      ]),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _SwitchRow({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(children: [
        Icon(icon, size: 22, color: AppColors.primaryBlue),
        const SizedBox(width: 14),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
            Text(subtitle,
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          ]),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: AppColors.primary,
          activeTrackColor: AppColors.primaryLight,
        ),
      ]),
    );
  }
}

class _TapRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? labelColor;
  final Color? iconColor;
  final Widget? trailing;
  final VoidCallback onTap;
  const _TapRow({
    required this.icon,
    required this.label,
    this.labelColor,
    this.iconColor,
    this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(children: [
          Icon(icon, size: 22, color: iconColor ?? AppColors.primaryBlue),
          const SizedBox(width: 14),
          Expanded(
            child: Text(label,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: labelColor ?? AppColors.textPrimary)),
          ),
          trailing ??
              const Icon(PhosphorIconsRegular.caretRight,
                  size: 16, color: AppColors.textTertiary),
        ]),
      ),
    );
  }
}
