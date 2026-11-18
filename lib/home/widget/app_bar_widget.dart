
import 'package:athaar_app/utils/app_colors.dart';
import 'package:athaar_app/utils/app_image.dart';
import 'package:material_ui/material_ui.dart';
import 'package:google_fonts/google_fonts.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return SliverAppBar(
      floating: true,
      snap: true,
      pinned: false,
      backgroundColor: AppColors.transparentColor,
      elevation: 0,
      toolbarHeight: 220,
      titleSpacing: 0,
      automaticallyImplyLeading: false,

      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                'ATHAR',
                maxLines: 1,
                style: GoogleFonts.cinzel(
                  fontSize: 32,
                  color: const Color(0xffd4af37),
                  fontWeight: FontWeight.bold,
                ),
              ),

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

          Stack(
            children: [
              Container(
                color: AppColors.transparentColor,
                child: Image.asset(
                  AppImage.appBarImage,
                  width: double.infinity,
                  height: 160,
                  fit: BoxFit.fill,
                ),
              ),

              Positioned(
                top: height * 0.04,
                left: width * 0.03,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello Magdy',
                      style: GoogleFonts.cinzel(
                        fontSize: 20,
                        color: const Color(0xffd4af37),
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      'Welcome To Athar',
                      style: GoogleFonts.cinzel(
                        fontSize: 20,
                        color: const Color(0xffd4af37),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
