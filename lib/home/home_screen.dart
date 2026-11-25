import 'dart:ui';
import 'package:athaar_app/home/tabs/home_tab/home_tab.dart';
import 'package:athaar_app/home/tabs/home_tab/horas_bottom_bar.dart';
import 'package:athaar_app/home/tabs/horus_tab/horus_tab.dart';
import 'package:athaar_app/home/tabs/profile_tab/profile_tab.dart';
import 'package:athaar_app/home/tabs/tickets_tab/tickets_tab.dart';
import 'package:material_ui/material_ui.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  bool showBar = true;

  void hide() {
    if (!showBar) return;

    setState(() {
      showBar = false;
    });
  }

  void show() {
    if (showBar) return;

    setState(() {
      showBar = true;
    });
  }

  late final List<Widget> tabsList = [
    HomeTab(
      onScrollDown: hide,
      onScrollUp: show,
    ),
    TicketsTab(),
    const HorusTab(),
    const ProfileTab(),
  ];

  Widget buildEventsButton() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 25,
          sigmaY: 25,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(22),
            onTap: () {
              // Events navigation
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFc49a4a),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: const Color(0xFFD8B56B).withOpacity(0.65),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFD8B56B).withOpacity(0.16),
                    blurRadius: 22,
                    spreadRadius: 1,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.calendar_month_rounded,
                    color: Color(0xFF15191c),
                    size: 27,
                  ),
                  SizedBox(height: 3),
                  Text(
                    'EVENTS',
                    style: TextStyle(
                      color: Color(0xFF15191c),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,

      body: IndexedStack(
        index: selectedIndex,
        children: tabsList,
      ),

      bottomNavigationBar: AnimatedSlide(
        offset: showBar ? Offset.zero : const Offset(0, 1),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,

        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 2),

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                if (selectedIndex == 0)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        right: 8,
                        bottom: 2,
                      ),
                      child: buildEventsButton(),
                    ),
                  ),

                Transform.translate(
                  offset: const Offset(0, 20),
                  child: HorusBottomNavBar(
                    selectedIndex: selectedIndex,
                    onItemSelected: (index) {
                      setState(() {
                        selectedIndex = index;
                        showBar = true;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
