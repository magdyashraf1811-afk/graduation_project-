import 'package:material_ui/material_ui.dart';
import 'package:athaar_app/utils/app_colors.dart';

class TicketInfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const TicketInfoRow({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Row(
        children: [
          Icon(icon, color: AppColors.goldColor, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}