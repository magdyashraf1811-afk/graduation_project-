import 'package:athaar_app/home/tabs/home_tab/home_tab.dart';
import 'package:athaar_app/home/tabs/home_tab/horas_bottom_bar.dart';
import 'package:athaar_app/home/tabs/horus_tab/horus_tab.dart';
import 'package:athaar_app/home/tabs/profile_tab/profile_tab.dart';
import 'package:athaar_app/home/tabs/tickets_tab/tickets_tab.dart';
import 'package:athaar_app/providers/tickets_provider.dart';
import 'package:athaar_app/utils/app_colors.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const int _ticketsIndex = 1;
  static const int _horusIndex = 2;

  int selectedIndex = 0;

  final List<Widget> tabsList = [
    HomeTab( onScrollDown: () {},  onScrollUp: () {}, ),
    const TicketsTab(),
    const HorusTab(),
    const ProfileTab(),
  ];

  void _onItemSelected(int index) {
    // Horus مقفول لحد ما اليوزر يحجز Self-Guided
    if (index == _horusIndex && !TicketsProvider.instance.hasSelfGuidedTicket) {
      _showHorusLockedDialog();
      return;
    }
    setState(() => selectedIndex = index);
  }

  void _showHorusLockedDialog() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.fieldBgColor,
        icon: const Icon(Icons.lock_outline,
            color: AppColors.goldColor, size: 36),
        title: const Text(
          'Horus is locked',
          style: TextStyle(color: AppColors.goldColor, fontSize: 18),
        ),
        content: const Text(
          'Horus will be available once you book a Self-Guided ticket.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Not now'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              setState(() => selectedIndex = _ticketsIndex);
            },
            child: const Text('Book now'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: tabsList[selectedIndex],
      bottomNavigationBar: HorusBottomNavBar(
        selectedIndex: selectedIndex,
        onItemSelected: _onItemSelected,
      ),
    );
  }
}