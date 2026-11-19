import 'package:material_ui/material_ui.dart';
import 'package:athaar_app/utils/app_colors.dart';

class ContinuePaymentButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;

  const ContinuePaymentButton({
    super.key,
    this.onPressed,
    this.label = 'Continue',
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.goldColor,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 5,
          shadowColor: AppColors.goldColor.withOpacity(0.4),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style:
              const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios, size: 14),
          ],
        ),
      ),
    );
  }
}
