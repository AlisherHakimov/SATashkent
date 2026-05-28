import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/constants/colors.dart';

class SearchBarWidget extends StatelessWidget {
  final String hint;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;

  const SearchBarWidget({
    super.key,
    this.hint = 'Qidirish...',
    this.onChanged,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textTertiary, fontSize: 14),
        prefixIcon: const Icon(PhosphorIconsRegular.magnifyingGlass,
            color: AppColors.textSecondary, size: 20),
        filled: true,
        fillColor: AppColors.bgTertiary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }
}
