import 'package:material_ui/material_ui.dart';
import 'package:athaar_app/utils/app_colors.dart';

class VisitHeader extends StatelessWidget {
  const VisitHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Book Your\n',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: 'Museum Visit',
                style: TextStyle(
                  color: AppColors.goldColor,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Plan your journey through Egyptian history',
          style: TextStyle(color: Colors.white70, fontSize: 13),
        ),
      ],
    );
  }
}