import 'package:material_ui/material_ui.dart';
import 'package:athaar_app/utils/app_colors.dart';

class CaptureButton extends StatelessWidget {
  final VoidCallback? onTap;

  const CaptureButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 84,
        height: 84,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.goldColor, width: 2),
        ),
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.gold, AppColors.darkGold],
            ),
          ),
          child: const Icon(Icons.crop_free, color: Colors.black54, size: 32),
        ),
      ),
    );
  }
}