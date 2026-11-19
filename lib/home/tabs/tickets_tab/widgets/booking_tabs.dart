import 'package:material_ui/material_ui.dart';
import 'booking_tab_button.dart';

class BookingTabs extends StatelessWidget {
  final bool isMyBookingSelected;
  final VoidCallback? onBookNewTap;
  final VoidCallback? onMyBookingTap;

  const BookingTabs({
    super.key,
    required this.isMyBookingSelected,
    this.onBookNewTap,
    this.onMyBookingTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: BookingTabButton(
            icon: Icons.confirmation_num,
            title: 'Book a New Ticket',
            subtitle: 'Get your ticket now',
            selected: !isMyBookingSelected,
            onTap: onBookNewTap,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: BookingTabButton(
            icon: Icons.calendar_today,
            title: 'View My Booking',
            subtitle: 'Check your tickets',
            selected: isMyBookingSelected,
            onTap: onMyBookingTap,
          ),
        ),
      ],
    );
  }
}