import 'package:athaar_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:athaar_app/utils/app_colors.dart';

class BookingTabButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback? onTap;

  const BookingTabButton({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.fieldBgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppColors.goldBorderColor : Colors.white12,
          ),
          boxShadow: selected
              ? const [BoxShadow(color: AppColors.goldGlowColor, blurRadius: 15)]
              : null,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.goldGlowColor
                    : Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.goldColor, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 9, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}