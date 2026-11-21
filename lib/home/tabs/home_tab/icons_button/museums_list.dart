
import 'package:athaar_app/home/tabs/home_tab/icons_button/musuem_details.dart';
import 'package:athaar_app/utils/app_colors.dart';
import 'package:athaar_app/utils/app_image.dart';
import 'package:athaar_app/utils/app_routes.dart';
import 'package:material_ui/material_ui.dart';
import 'package:animations/animations.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shimmer/shimmer.dart';

class MuseumsList extends StatelessWidget {
  const MuseumsList({super.key});

  final List<String> museums = const [
    'The Grand Egyptian Museum',
    'Egyptian Museum',
    'National Museum of Egyptian Civilization',
    'Luxor Museum',
    'Karnak Open Air Museum',
    'Nubian Museum',
    'Islamic Art Museum',
    'Coptic Museum',
    'Museum of Islamic Ceramics',
    'Alexandria National Museum',
    'Abdeen Palace Museum',
    'Royal Jewelry Museum',
    'Greco-Roman Museum',
    'Kom Ombo Museum',
    'Aswan Museum',
    'Mummification Museum',
    'Imhotep Museum',
    'Tanta Museum',
    'Matrouh Archaeological Museum',
    'El Alamein Military Museum',
  ];

  final List<String> museumImages = const [
    AppImage.grandMuseumImage,
    AppImage.grandMuseumImage,
    AppImage.grandMuseumImage,
    AppImage.grandMuseumImage,
    AppImage.grandMuseumImage,
    AppImage.grandMuseumImage,
    AppImage.grandMuseumImage,
    AppImage.grandMuseumImage,
    AppImage.grandMuseumImage,
    AppImage.grandMuseumImage,
    AppImage.grandMuseumImage,
    AppImage.grandMuseumImage,
    AppImage.grandMuseumImage,
    AppImage.grandMuseumImage,
    AppImage.grandMuseumImage,
    AppImage.grandMuseumImage,
    AppImage.grandMuseumImage,
    AppImage.grandMuseumImage,
    AppImage.grandMuseumImage,
    AppImage.grandMuseumImage,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacementNamed(
              context,
              AppRoutes.homeRouteScreen,
            );
          },
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: AppColors.goldAccentColor,
          ),
        ),
      ),

      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 20),
        itemCount: museums.length,

        itemBuilder: (context, index) {
          final museumTitle = museums[index];
          final museumImage = museumImages[index];

          return Padding(
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 18,
            ),
            child: Center(
              child: OpenContainer(
                transitionDuration: const Duration(
                  milliseconds: 700,
                ),
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
                    title: museumTitle,
                    image: museumImage,
                  );
                },

                closedBuilder: (context, openContainer) {
                  return SizedBox(
                    width: 380,
                    height: 181,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFFD4AF37),
                          width: 1.2,
                        ),
                      ),

                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [

                            // Real Image Loading + Shimmer
                            Image.asset(
                              museumImage,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,

                              frameBuilder: (
                                  context,
                                  child,
                                  frame,
                                  wasSynchronouslyLoaded,
                                  ) {
                                if (wasSynchronouslyLoaded ||
                                    frame != null) {
                                  return child;
                                }

                                return Shimmer.fromColors(
                                  baseColor: const Color(0xFF252525),
                                  highlightColor: const Color(0xFF555555),
                                  period: const Duration(
                                    milliseconds: 1200,
                                  ),
                                  child: Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    color: Colors.white,
                                  ),
                                );
                              },

                              errorBuilder: (
                                  context,
                                  error,
                                  stackTrace,
                                  ) {
                                return Container(
                                  color: const Color(0xFF252525),
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.museum_outlined,
                                    color: Color(0xFFD4AF37),
                                    size: 45,
                                  ),
                                );
                              },
                            ),

                            // Dark Gradient
                            DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.85),
                                  ],
                                ),
                              ),
                            ),

                            // Museum Name
                            Positioned(
                              left: 18,
                              right: 18,
                              bottom: 18,
                              child: Text(
                                museumTitle,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ).animate(
            delay: (index * 80).milliseconds,
          )
              .fade(duration: 500.ms)
              .slideX(
            begin: 0.3,
            duration: 500.ms,
          );
        },
      ),
    );
  }
}
