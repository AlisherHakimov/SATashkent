import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Widget icon;
  final Color? color;
  final Color? bgColor;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.color,
    this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.primaryBlue;
    final bg = bgColor ?? c.withValues(alpha: 0.1);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgPrimary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
            child: IconTheme(data: IconThemeData(color: c, size: 20), child: icon),
          ),
          const SizedBox(height: 12),
          Text(value,
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
