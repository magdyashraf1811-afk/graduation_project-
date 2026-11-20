
import 'package:athaar_app/utils/app_colors.dart';
import 'package:material_ui/material_ui.dart';

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final Color? backgroundColor;
  final Color? borderSideColor;
  final bool isLoading;

  const CustomElevatedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.borderSideColor,
    this.backgroundColor,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor:
        backgroundColor ?? AppColors.transparentColor,
        padding: EdgeInsets.symmetric(vertical: height * 0.01),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            width: 1,
            color: borderSideColor ?? AppColors.transparentColor,
          ),
        ),
      ),
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      )
          : child,
    );
  }
}
