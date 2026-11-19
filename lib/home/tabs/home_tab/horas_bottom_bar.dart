
import 'dart:ui';

import 'package:athaar_app/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../../providers/app_theme_provider.dart';
import '../../../utils/app_colors.dart';

class HorusBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const HorusBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;

    final themeProvider = Provider.of<AppThemeProvider>(context);
    final bool isDark = themeProvider.isDarkMode();

    final localizations = AppLocalizations.of(context)!;

    final Color gold =
    isDark ? AppColors.gold : AppColors.darkGold;

    final Color inactiveColor =
    isDark ? AppColors.inactiveDark : AppColors.inactiveLight;

    return Padding(
      padding: EdgeInsets.only(
        left: width * 0.03,
        right: width * 0.03,
        bottom: height * 0.025,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 22,
            sigmaY: 22,
          ),
          child: Container(
            height: 82,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.white.withValues(alpha: 0.15),
            ),
            child: Row(
              children: [
                _buildItem(
                  index: 0,
                  label: localizations.home,
                  icon: Icons.home_rounded,
                  gold: gold,
                  inactiveColor: inactiveColor,
                ),
                _buildItem(
                  index: 1,
                  label: localizations.tickets,
                  icon: Icons.confirmation_number_rounded,
                  gold: gold,
                  inactiveColor: inactiveColor,
                ),
                _buildItem(
                  index: 2,
                  label: localizations.horus,
                  isHorus: true,
                  gold: gold,
                  inactiveColor: inactiveColor,
                ),
                _buildItem(
                  index: 3,
                  label: localizations.profile,
                  icon: Icons.person_rounded,
                  gold: gold,
                  inactiveColor: inactiveColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItem({
    required int index,
    required String label,
    IconData? icon,
    bool isHorus = false,
    required Color gold,
    required Color inactiveColor,
  }) {
    final bool isSelected = selectedIndex == index;
    final Color itemColor = isSelected ? gold : inactiveColor;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onItemSelected(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected
                    ? gold.withValues(alpha: 0.10)
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: isHorus
                  ? Image.asset(
                'assets/icons/horus_icon.png',
                width: 25,
                height: 25,
                color: itemColor,
                fit: BoxFit.contain,
              )
                  : Icon(
                icon,
                size: 25,
                color: itemColor,
              ),
            ),

            const SizedBox(height: 4),

            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 250),
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected
                    ? FontWeight.w700
                    : FontWeight.w500,
                color: itemColor,
              ),
              child: Text(label),
            ),

            const SizedBox(height: 5),

            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              width: isSelected ? 18 : 0,
              height: 2,
              decoration: BoxDecoration(
                color: gold,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
