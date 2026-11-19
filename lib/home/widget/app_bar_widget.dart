
import 'package:athaar_app/home/widget/custom_text_form_field.dart';
import 'package:athaar_app/l10n/app_localizations.dart';
import 'package:athaar_app/providers/app_theme_provider.dart';
import 'package:athaar_app/utils/app_colors.dart';
import 'package:athaar_app/utils/app_image.dart';
import 'package:athaar_app/utils/app_style.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var themeProvider = Provider.of<AppThemeProvider>(context);

    return SliverAppBar(
      floating: true,
      snap: true,
      pinned: false,
      backgroundColor: AppColors.transparentColor,
      toolbarHeight: 220
      ,
      automaticallyImplyLeading: false,

      title: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: height*0.05,
        children: [
          Row(
            children: [
              Image.asset(AppImage.logoAthar,width: 100,height: 100,),
              const Spacer(),

              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.notifications_outlined,
                  color: AppColors.primaryColor,
                  size: 28,
                ),
              ),

              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.person_3_outlined,
                  color: AppColors.primaryColor,
                  size: 28,
                ),
              ),
            ],
          ),
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


        ],
      ),
    );
  }
}
