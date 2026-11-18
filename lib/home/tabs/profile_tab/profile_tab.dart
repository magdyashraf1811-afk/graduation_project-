
import 'package:material_ui/material_ui.dart';
import 'package:athaar_app/utils/app_colors.dart';
import 'package:provider/provider.dart';

import '../../../l10n/app_localizations.dart';
import '../../../providers/app_theme_provider.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<AppThemeProvider>(context);

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final isDark = themeProvider.isDarkMode();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.04,
            vertical: height * 0.04,
          ),
          child: Column(
            spacing: 20,
            children: [
              Column(
                spacing: height * 0.02,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.04,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.transparentColor
                          : AppColors.whiteColor,
                      border: Border.all(
                        color: AppColors.whiteColor,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isDark
                              ? AppLocalizations.of(context)!.dark_mode
                              : AppLocalizations.of(context)!.light_mode,
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge,
                        ),

                        IconButton(
                          onPressed: () async {
                            await themeProvider.toggleTheme();
                          },
                          icon: Icon(
                            isDark
                                ? Icons.dark_mode_outlined
                                : Icons.light_mode_outlined,
                            color: AppColors.gold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
