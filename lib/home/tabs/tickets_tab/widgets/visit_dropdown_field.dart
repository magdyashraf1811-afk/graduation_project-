import 'package:material_ui/material_ui.dart';
import 'package:athaar_app/utils/app_colors.dart';

class VisitDropdownField extends StatelessWidget {
  final String label;
  final String placeholder;
  final IconData icon;

  const VisitDropdownField({
    super.key,
    required this.label,
    required this.placeholder,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.fieldBgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.goldColor.withOpacity(0.4),
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColors.goldColor, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  placeholder,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.goldColor,
                size: 20,
              ),
            ],
          ),
        ),
      ],
    );
  }
}