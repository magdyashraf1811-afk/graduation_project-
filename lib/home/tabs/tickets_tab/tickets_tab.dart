import 'package:flutter/material.dart';
import 'book_your_visit_screen1.dart';

class TicketsTab extends StatefulWidget {
  const TicketsTab({super.key});

  @override
  State<TicketsTab> createState() => _TicketsTabState();
}

class _TicketsTabState extends State<TicketsTab> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return NavigatorPopHandler(
      onPop: () => _navigatorKey.currentState?.pop(),
      child: Navigator(
        key: _navigatorKey,
        onGenerateRoute: (settings) => MaterialPageRoute(
          builder: (_) => const BookYourVisitScreen1(),
        ),
      ),
    );
  }
}