import 'package:animations/animations.dart';
import 'package:athaar_app/home/tabs/home_tab/icons_button/museums_list.dart';
import 'package:athaar_app/home/tabs/home_tab/icons_button/musuem_details.dart';
import 'package:athaar_app/home/widget/custom_text_form_field.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/app_theme_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_image.dart';
import '../../utils/app_routes.dart';
import '../../utils/app_style.dart';
import 'list_view_widget.dart';

class ScrollWidget extends StatelessWidget {
  const ScrollWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final themeProvider = Provider.of<AppThemeProvider>(context);

    final isDark = themeProvider.isDarkMode();

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Column(
          spacing: height * 0.02,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextFormField(
              filled: true,
              fillColor: themeProvider.isDarkMode()
                  ? AppColors.darkColor
                  : AppColors.whiteColor,
              borderSideColor: themeProvider.isDarkMode()
                  ? AppColors.goldAccentColor
                  : AppColors.beigeColor,
              hintText: AppLocalizations.of(context)!.search,
              hintStyle: AppStyle.bold16lightGray,
              prefixIcon: Icon(
                Icons.search_outlined,
                color: AppColors.primaryColor,
              ),
            ),

            // Featured Museums
            Row(
              spacing: width * 0.01,
              children: [
                Icon(
                  Icons.account_balance_outlined,
                  color: AppColors.primaryColor,
                  size: 25,
                ),
                Text(
                  AppLocalizations.of(context)!.feature_museums,
                  style: isDark ? AppStyle.bold18White : AppStyle.bold18Black,
                ),
                Spacer(),
                TextButton(
                  onPressed: () { Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MuseumsList(),
                    ),
                  );
                  },
                  child: Text(
                    AppLocalizations.of(context)!.see_all,
                    style: AppStyle.bold14Primary,
                  ),
                ),
              ],
            ),

            OpenContainer(
              transitionDuration: const Duration(milliseconds: 700),
              transitionType: ContainerTransitionType.fade,

              closedElevation: 0,
              openElevation: 0,

              closedColor: Colors.transparent,
              openColor: Theme.of(context).scaffoldBackgroundColor,

              closedShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),

              openShape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),

              openBuilder: (context, action) {
                return MuseumDetailsScreen(
                  image: AppImage.grandMuseumImage,
                  title: AppLocalizations.of(context)!.grand_egyption_museum,
                );
              },

              closedBuilder: (context, openContainer) {
                return ListViewWidget(
                  size: 30,
                  style: AppStyle.bold16White,
                  height: 171,
                  itemWidth: 320,
                  images: [
                    AppImage.grandMuseumImage,
                    AppImage.graecoRomanMuseumImage,
                    AppImage.islamicArtMuseumImage,
                  ],
                  titles: [
                    AppLocalizations.of(context)!.grand_egyption_museum,
                    AppLocalizations.of(context)!.graeco_roman_museum,
                    AppLocalizations.of(context)!.islamic_arts_museum,
                  ],
                  onImageTap: openContainer,
                );
              },
            ),

            // Nearby Museums
            Row(
              spacing: width * 0.01,
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: AppColors.primaryColor,
                  size: 25,
                ),
                Text(
                  AppLocalizations.of(context)!.near,
                  style: isDark ? AppStyle.bold18White : AppStyle.bold18Black,
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
                images: [
                  AppImage.grandMuseumImage,
                  AppImage.graecoRomanMuseumImage,
                  AppImage.islamicArtMuseumImage,
                ],
                titles: [
                  AppLocalizations.of(context)!.grand_egyption_museum,
                  AppLocalizations.of(context)!.graeco_roman_museum,
                  AppLocalizations.of(context)!.islamic_arts_museum,
                ],
              ),
            ),

            // More Museums
            Row(
              spacing: width * 0.01,
              children: [
                Icon(
                  Icons.account_balance_outlined,
                  color: AppColors.primaryColor,
                  size: 25,
                ),
                Text(
                  AppLocalizations.of(context)!.feature_museums,
                  style: isDark ? AppStyle.bold18White : AppStyle.bold18Black,
                ),
              ],
            ),

            ListViewWidget(
              size: 30,
              style: AppStyle.bold16White,
              icon: Icons.arrow_circle_right_outlined,
              height: 171,
              itemWidth: 320,
              images: [
                AppImage.grandMuseumImage,
                AppImage.graecoRomanMuseumImage,
                AppImage.islamicArtMuseumImage,
              ],
              titles: [
                AppLocalizations.of(context)!.grand_egyption_museum,
                AppLocalizations.of(context)!.graeco_roman_museum,
                AppLocalizations.of(context)!.islamic_arts_museum,
              ],
            ),

            // Additional Museums
            Row(
              spacing: width * 0.01,
              children: [
                Icon(
                  Icons.account_balance_outlined,
                  color: AppColors.primaryColor,
                  size: 25,
                ),
                Text(
                  AppLocalizations.of(context)!.feature_museums,
                  style: isDark ? AppStyle.bold18White : AppStyle.bold18Black,
                ),
              ],
            ),

            ListViewWidget(
              size: 30,
              style: AppStyle.bold16White,
              icon: Icons.arrow_circle_right_outlined,
              height: 171,
              itemWidth: 320,
              images: [
                AppImage.grandMuseumImage,
                AppImage.graecoRomanMuseumImage,
                AppImage.islamicArtMuseumImage,
              ],
              titles: [
                AppLocalizations.of(context)!.grand_egyption_museum,
                AppLocalizations.of(context)!.graeco_roman_museum,
                AppLocalizations.of(context)!.islamic_arts_museum,
              ],
            ),

            // Additional Museums
            Row(
              spacing: width * 0.01,
              children: [
                Icon(
                  Icons.account_balance_outlined,
                  color: AppColors.primaryColor,
                  size: 25,
                ),
                Text(
                  AppLocalizations.of(context)!.feature_museums,
                  style: isDark ? AppStyle.bold18White : AppStyle.bold18Black,
                ),
              ],
            ),

            ListViewWidget(
              size: 30,
              style: AppStyle.bold16White,
              icon: Icons.arrow_circle_right_outlined,
              height: 171,
              itemWidth: 320,
              images: [
                AppImage.grandMuseumImage,
                AppImage.graecoRomanMuseumImage,
                AppImage.islamicArtMuseumImage,
              ],
              titles: [
                AppLocalizations.of(context)!.grand_egyption_museum,
                AppLocalizations.of(context)!.graeco_roman_museum,
                AppLocalizations.of(context)!.islamic_arts_museum,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
