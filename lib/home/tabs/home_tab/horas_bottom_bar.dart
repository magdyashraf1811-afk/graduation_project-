
import 'dart:ui';

import 'package:athaar_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
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
    final themeProvider = Provider.of<AppThemeProvider>(context);
    final isDark = themeProvider.isDarkMode();

    final gold = isDark ? AppColors.gold : AppColors.darkGold;

    final inactiveColor = isDark
        ? AppColors.inactiveDark
        : AppColors.inactiveLight;

    final localization = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(35),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 22,
            sigmaY: 22,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF17212B).withOpacity(0.72)
                  : Colors.white.withOpacity(0.65),

              borderRadius: BorderRadius.circular(35),

              border: Border.all(
                color: isDark
                    ? gold.withOpacity(0.25)
                    : Colors.white.withOpacity(0.75),
                width: 1.2,
              ),

              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withOpacity(0.25)
                      : AppColors.darkGold.withOpacity(0.10),
                  blurRadius: 20,
                  spreadRadius: 1,
                  offset: const Offset(0, 6),
                ),
              ],
            ),

            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 7,
              ),
              child: Row(
                children: [
                  _buildItem(
                    index: 0,
                    label: localization.home,
                    icon: Icons.home_rounded,
                    gold: gold,
                    inactiveColor: inactiveColor,
                  ),

                  _buildItem(
                    index: 1,
                    label: localization.tickets,
                    icon: Icons.confirmation_number_rounded,
                    gold: gold,
                    inactiveColor: inactiveColor,
                  ),

                  _buildItem(
                    index: 2,
                    label: localization.horus,
                    isHorus: true,
                    gold: gold,
                    inactiveColor: inactiveColor,
                  ),

                  _buildItem(
                    index: 3,
                    label: localization.profile,
                    icon: Icons.person_rounded,
                    gold: gold,
                    inactiveColor: inactiveColor,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItem({
    required int index,
    required String label,
    required Color gold,
    required Color inactiveColor,
    IconData? icon,
    bool isHorus = false,
  }) {
    final isSelected = selectedIndex == index;
    final itemColor = isSelected ? gold : inactiveColor;

    return Expanded(
      child: GestureDetector(
        onTap: () => onItemSelected(index),
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedScale(
                scale: isSelected ? 1.08 : 1.0,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: isHorus
                      ? Image.asset(
                    'assets/icons/horus_icon.png',
                    key: const ValueKey('horus'),
                    width: 27,
                    height: 27,
                    color: itemColor,
                  )
                      : Icon(
                    icon,
                    key: ValueKey(index),
                    size: 27,
                    color: itemColor,
                  ),
                ),
              ),

              const SizedBox(height: 4),

              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected
                      ? FontWeight.w600
                      : FontWeight.w400,
                  color: itemColor,
                ),
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
