import 'package:flutter/material.dart';
import 'package:athaar_app/utils/app_colors.dart';

class OutlinedPillButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const OutlinedPillButton({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.fieldBgColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.goldBorderColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.goldColor, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}