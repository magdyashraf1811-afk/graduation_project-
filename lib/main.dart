import 'package:athaar_app/home/splash_screen.dart';
import 'package:athaar_app/home/tabs/home_tab/icons_button/events_list.dart';
import 'package:athaar_app/home/tabs/home_tab/icons_button/experience_near_you_screen.dart';
import 'package:athaar_app/home/tabs/home_tab/icons_button/musuem_details.dart';
import 'package:athaar_app/providers/app_theme_provider.dart';
import 'package:athaar_app/utils/app_routes.dart';
import 'package:athaar_app/utils/app_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'home/auth/login/login_screen.dart';
import 'home/auth/registration/sign_in_screen.dart';
import 'home/home_screen.dart';
import 'home/onboarding/onboarding_screen.dart';
import 'home/tabs/home_tab/icons_button/museums_list.dart';
import 'l10n/app_localizations.dart';
import 'providers/app_language_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeProvider = AppThemeProvider();
  await themeProvider.loadTheme();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AppLanguageProvider(),
        ),
        ChangeNotifierProvider.value(
          value: themeProvider,
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = context.watch<AppLanguageProvider>();
    final themeProvider = context.watch<AppThemeProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.appTheme,

      builder: (context, child) {
        return MaterialUiCompatibilityBridge(
          child: child!,
        );
      },

      home: SplashScreen(),
      initialRoute: AppRoutes.homeRouteScreen,

      routes: {
        AppRoutes.onBoardingRouteScreen: (context) => OnBoardingScreen(),
        AppRoutes.homeRouteScreen: (context) => HomeScreen(),
        AppRoutes.loginScreen: (context) => LoginScreen(),
        AppRoutes.signinScreen: (context) => SignInScreen(),
        AppRoutes.museumsScreen: (context) => MuseumsList(),
        AppRoutes.eventsScreen: (context) => EventsList(),
        AppRoutes.experienceScreen: (context) => ExperienceNearYouScreen(),
        AppRoutes.museumsDetailsScreen: (context) => MuseumDetailsScreen(
          image: 'assets/images/grand_museum.png',
          title: 'Grand Egyptian Museum',
        )
      },

      localizationsDelegates:
      AppLocalizations.localizationsDelegates,
      supportedLocales:
      AppLocalizations.supportedLocales,
      locale: Locale(languageProvider.appLanguage),
    );
  }
}
