import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/app_theme_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_image.dart';
import '../../utils/app_routes.dart';
import '../../utils/app_style.dart';
import 'custom_elevated_button.dart';
import 'list_view_widget.dart';

class ScrollWidget extends StatelessWidget {
  const ScrollWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var themeProvider = Provider.of<AppThemeProvider>(context);
    final gold = themeProvider.isDarkMode()
        ? AppColors.gold
        : AppColors.darkGold;

    return SliverToBoxAdapter(
      child: Column(
        spacing: height * 0.02,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: width * 0.04,
            children: [
              Expanded(
                child: CustomElevatedButton(
                  borderSideColor: gold.withOpacity(
                    themeProvider.isDarkMode() ? 0.90 : 0.80,
                  ),
                  backgroundColor: themeProvider.isDarkMode()
                      ? AppColors.darkColor
                      : AppColors.whiteColor,
                  onPressed: () {
                    // todo go to museums list
                    Navigator.pushReplacementNamed(
                        context, AppRoutes.museumsScreen);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: height * 0.005,
                    children: [
                      Icon(Icons.account_balance_outlined,
                        color: AppColors.primaryColor, size: 35,),
                      Text(
                        AppLocalizations.of(context)!.museums,
                        style: themeProvider.isDarkMode()
                            ? AppStyle.bold16bgWhite
                            : AppStyle.bold16lightGray,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: CustomElevatedButton(
                  borderSideColor: gold.withOpacity(
                    themeProvider.isDarkMode() ? 0.90 : 0.80,
                  ),
                  backgroundColor: themeProvider.isDarkMode()
                      ? AppColors.darkColor
                      : AppColors.whiteColor,
                  onPressed: () {
                    // todo go to Artifacts liat
                    Navigator.pushReplacementNamed(
                        context, AppRoutes.artifactsScreen);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,

                    spacing: height * 0.005,
                    children: [
                      Icon(Icons.auto_awesome, color: AppColors.primaryColor,
                        size: 35,),
                      Text(
                        AppLocalizations.of(context)!.artifacts,
                        style: themeProvider.isDarkMode()
                            ? AppStyle.bold16bgWhite
                            : AppStyle.bold16lightGray,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: CustomElevatedButton(
                  borderSideColor: gold.withOpacity(
                    themeProvider.isDarkMode() ? 0.90 : 0.80,
                  ),
                  backgroundColor: themeProvider.isDarkMode()
                      ? AppColors.darkColor
                      : AppColors.whiteColor,
                  onPressed: () {
                    // todo go to nearby list
                    Navigator.pushReplacementNamed(
                        context, AppRoutes.nearbyScreen);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,

                    spacing: height * 0.005,
                    children: [
                      Icon(Icons.location_on_outlined,
                        color: AppColors.primaryColor, size: 35,),
                      Text(
                        AppLocalizations.of(context)!.nearby,
                        style: themeProvider.isDarkMode()
                            ? AppStyle.bold16bgWhite
                            : AppStyle.bold16lightGray,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: CustomElevatedButton(
                  borderSideColor: gold.withOpacity(
                    themeProvider.isDarkMode() ? 0.90 : 0.80,
                  ),
                  backgroundColor: themeProvider.isDarkMode()
                      ? AppColors.darkColor
                      : AppColors.whiteColor,
                  onPressed: () {
                    // todo go to events list
                    Navigator.pushReplacementNamed(
                        context, AppRoutes.eventsScreen);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: height * 0.005,
                    children: [
                      Icon(Icons.event_note, color: AppColors.primaryColor,
                        size: 35,),
                      Text(
                        AppLocalizations.of(context)!.events,
                        style: themeProvider.isDarkMode()
                            ? AppStyle.bold16bgWhite
                            : AppStyle.bold16lightGray,
                      ),
                    ],
                  ),
                ),
              ),


            ],
          ),
          Row(
            spacing: width * 0.01,
            children: [
              Icon(
                Icons.account_balance_outlined, color: AppColors.primaryColor,
                size: 25,),
              Text(
                AppLocalizations.of(context)!.feature_museums,
                style: themeProvider.isDarkMode()
                    ? AppStyle.bold18White
                    : AppStyle.bold18Black,
              ),
            ],
          ),
          ListViewWidget(
            size: 30,
            style: AppStyle.bold16White,
            icon: Icons.arrow_circle_right_outlined,
            height: 171,
            itemWidth: 320,
            images: [ AppImage.grandMuseumImage,
              AppImage.graecoRomanMuseumImage,
              AppImage.islamicArtMuseumImage,
            ],
            titles: [ AppLocalizations.of(context)!.grand_egyption_museum,
              AppLocalizations.of(context)!.graeco_roman_museum,
              AppLocalizations.of(context)!.islamic_arts_museum,
            ],
          ),
          Row(
            spacing: width * 0.01,
            children: [
              Icon(Icons.location_on_outlined, color: AppColors.primaryColor,
                size: 25,),
              Text(
                AppLocalizations.of(context)!.near,
                style: themeProvider.isDarkMode()
                    ? AppStyle.bold18White
                    : AppStyle.bold18Black,
              ),
            ],
          ),
          InkWell(
            onTap: () {
              Navigator.pushReplacementNamed(
                context,
                AppRoutes.museumsDetailsScreen,
              );
            },
            child: ListViewWidget(
              size: 20,
              icon: Icons.location_on_outlined,
              style: AppStyle.bold14White,
              height: 120,
              itemWidth: 200,
              images: [ AppImage.grandMuseumImage,
                AppImage.graecoRomanMuseumImage,
                AppImage.islamicArtMuseumImage,
              ],
              titles: [ AppLocalizations.of(context)!.grand_egyption_museum,
                AppLocalizations.of(context)!.graeco_roman_museum,
                AppLocalizations.of(context)!.islamic_arts_museum,
              ],
            ),
          ),
          Row(
            spacing: width * 0.01,
            children: [
              Icon(
                Icons.account_balance_outlined, color: AppColors.primaryColor,
                size: 25,),
              Text(
                AppLocalizations.of(context)!.feature_museums,
                style: themeProvider.isDarkMode()
                    ? AppStyle.bold18White
                    : AppStyle.bold18Black,
              ),
            ],
          ),
          ListViewWidget(
            size: 30,
            style: AppStyle.bold16White,
            icon: Icons.arrow_circle_right_outlined,
            height: 171,
            itemWidth: 320,
            images: [ AppImage.grandMuseumImage,
              AppImage.graecoRomanMuseumImage,
              AppImage.islamicArtMuseumImage,
            ],
            titles: [ AppLocalizations.of(context)!.grand_egyption_museum,
              AppLocalizations.of(context)!.graeco_roman_museum,
              AppLocalizations.of(context)!.islamic_arts_museum,
            ],
          ),  Row(
            spacing: width * 0.01,
            children: [
              Icon(
                Icons.account_balance_outlined, color: AppColors.primaryColor,
                size: 25,),
              Text(
                AppLocalizations.of(context)!.feature_museums,
                style: themeProvider.isDarkMode()
                    ? AppStyle.bold18White
                    : AppStyle.bold18Black,
              ),
            ],
          ),
          ListViewWidget(
            size: 30,
            style: AppStyle.bold16White,
            icon: Icons.arrow_circle_right_outlined,
            height: 171,
            itemWidth: 320,
            images: [ AppImage.grandMuseumImage,
              AppImage.graecoRomanMuseumImage,
              AppImage.islamicArtMuseumImage,
            ],
            titles: [ AppLocalizations.of(context)!.grand_egyption_museum,
              AppLocalizations.of(context)!.graeco_roman_museum,
              AppLocalizations.of(context)!.islamic_arts_museum,
            ],
          ),  Row(
            spacing: width * 0.01,
            children: [
              Icon(
                Icons.account_balance_outlined, color: AppColors.primaryColor,
                size: 25,),
              Text(
                AppLocalizations.of(context)!.feature_museums,
                style: themeProvider.isDarkMode()
                    ? AppStyle.bold18White
                    : AppStyle.bold18Black,
              ),
            ],
          ),
          ListViewWidget(
            size: 30,
            style: AppStyle.bold16White,
            icon: Icons.arrow_circle_right_outlined,
            height: 171,
            itemWidth: 320,
            images: [ AppImage.grandMuseumImage,
              AppImage.graecoRomanMuseumImage,
              AppImage.islamicArtMuseumImage,
            ],
            titles: [ AppLocalizations.of(context)!.grand_egyption_museum,
              AppLocalizations.of(context)!.graeco_roman_museum,
              AppLocalizations.of(context)!.islamic_arts_museum,
            ],
          ),
        ],
      ),
    )

    ;
  }
}
