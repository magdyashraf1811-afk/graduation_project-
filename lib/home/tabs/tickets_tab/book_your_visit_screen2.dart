import 'package:flutter/material.dart';
import 'models/ticket_model1.dart';
import 'models/ticket_type.dart';
import 'widgets/booking_tabs.dart';
import 'widgets/continue_payment_button.dart';
import 'widgets/ticket_card.dart';
import 'widgets/visit_header.dart';
import 'scan_artifact_screen.dart';

class BookYourVisitScreen2 extends StatelessWidget {
  final TicketModel ticket;

  const BookYourVisitScreen2({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const VisitHeader(),
                const SizedBox(height: 20),
                BookingTabs(
                  isMyBookingSelected: true,
                  onBookNewTap: () => Navigator.pop(context),
                ),
                const SizedBox(height: 20),
                TicketCard(
                  ticket: ticket,
                  onViewTicket: () {},
                  onShareBooking: () {},
                ),
                if (ticket.type == TicketType.selfGuided) ...[
                  const SizedBox(height: 20),
                  ContinuePaymentButton(
                    label: 'Start Self-Guided Tour',
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                          builder: (_) => const ScanArtifactScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}