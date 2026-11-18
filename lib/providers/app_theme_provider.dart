
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppThemeProvider extends ChangeNotifier {
  ThemeMode appTheme = ThemeMode.light;

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDarkMode') ?? false;

    appTheme = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  Future<void> changeThemeLanguage(ThemeMode newTheme) async {
    if (appTheme == newTheme) return;

    appTheme = newTheme;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(
      'isDarkMode',
      newTheme == ThemeMode.dark,
    );
  }

  bool isDarkMode() => appTheme == ThemeMode.dark;

  Future<void> toggleTheme() async {
    final newTheme = isDarkMode()
        ? ThemeMode.light
        : ThemeMode.dark;

    await changeThemeLanguage(newTheme);
  }
}
