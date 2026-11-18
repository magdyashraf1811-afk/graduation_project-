import 'package:material_ui/material_ui.dart';
import 'app_colors.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.beigeDesertColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.goldColor,
      brightness: Brightness.light,
    ),
    useMaterial3: true,
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.backgroundDarkColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.goldColor,
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
  );
}
