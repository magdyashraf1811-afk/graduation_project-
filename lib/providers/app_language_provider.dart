import 'package:material_ui/material_ui.dart';

class AppLanguageProvider extends ChangeNotifier {
  //todo: data
  String appLanguage = 'en';

  String? language;

  void changeLanguage(String newLanguage) {
    if (appLanguage == newLanguage) {
      return;
    }
    appLanguage = newLanguage;
    language = appLanguage;
    notifyListeners();
  }
}
