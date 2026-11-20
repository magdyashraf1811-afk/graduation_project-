
import 'package:athaar_app/utils/app_colors.dart';
import 'package:material_ui/material_ui.dart';

class CustomTextFormField extends StatelessWidget {
  final Color? borderSideColor;
  final Color? fillColor;
  final bool? filled;

  final String? hintText;
  final TextStyle? hintStyle;
  final String? labelText;
  final TextStyle? labelStyle;

  final Widget? prefixIcon;
  final Widget? suffixIcon;

  final int? maxLines;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const CustomTextFormField({
    super.key,
    this.suffixIcon,
    this.prefixIcon,
    this.borderSideColor,
    this.maxLines,
    this.fillColor,
    this.filled,
    this.hintStyle,
    this.hintText,
    this.labelStyle,
    this.labelText,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      maxLines: obscureText ? 1 : (maxLines ?? 1),
      decoration: InputDecoration(
        enabledBorder: builtDecorationBorder(
          borderColor: borderSideColor ?? AppColors.transparentColor,
        ),
        focusedBorder: builtDecorationBorder(
          borderColor: borderSideColor ?? AppColors.transparentColor,
        ),
        errorBorder: builtDecorationBorder(
          borderColor: AppColors.redColor,
        ),
        focusedErrorBorder: builtDecorationBorder(
          borderColor: AppColors.redColor,
        ),
        fillColor: fillColor,
        filled: filled,
        hintText: hintText,
        hintStyle: hintStyle,
        labelText: labelText,
        labelStyle: labelStyle,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );
  }

  OutlineInputBorder builtDecorationBorder({
    required Color borderColor,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(
        width: 2,
        color: borderColor,
      ),
    );
  }
}
