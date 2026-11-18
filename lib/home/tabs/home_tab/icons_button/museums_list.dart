import 'package:athaar_app/utils/app_colors.dart';
import 'package:athaar_app/utils/app_routes.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_animate/flutter_animate.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.homeRouteScreen),
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: AppColors.goldAccentColor,
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: museums.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: const Color(0xFFD4AF37),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.account_balance_outlined,
                  color: AppColors.primaryColor,
                  size: 35,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    museums[index],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ).animate(
            delay: (index * 80).milliseconds,
          )
              .fade(duration: 500.ms)
              .slideX(begin: 0.3, duration: 500.ms);
        },
      ),
    );
  }
}