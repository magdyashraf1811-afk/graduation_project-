import 'package:material_ui/material_ui.dart';
import 'package:athaar_app/providers/tickets_provider.dart';
import 'book_your_visit_screen2.dart';
import 'models/ticket_model1.dart';
import 'models/ticket_type.dart';
import 'widgets/booking_tabs.dart';
import 'widgets/continue_payment_button.dart';
import 'widgets/ticket_type_selector.dart';
import 'widgets/visit_dropdown_field.dart';
import 'widgets/visit_header.dart';

class BookYourVisitScreen1 extends StatefulWidget {
  const BookYourVisitScreen1({super.key});

  @override
  State<BookYourVisitScreen1> createState() => _BookYourVisitScreen1State();
}

class _BookYourVisitScreen1State extends State<BookYourVisitScreen1> {
  TicketType _selectedType = TicketType.regular;

  /// بيبني التذكرة (بيانات تجريبية لحد ما الـ dropdowns تشتغل)
  TicketModel _buildTicket() {
    return TicketModel(
      museumName: 'Grand Egyptian Museum',
      date: 'Nov 15,2026',
      time: '09 : 00 AM',
      language: 'English',
      visitorType: 'Student',
      imageAsset: 'assets/images/gem.jpg',
      bookingRef: 'GEM-20261115-0900-0001',
      type: _selectedType,
    );
  }

  void _openTicketScreen(TicketModel ticket) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BookYourVisitScreen2(ticket: ticket),
      ),
    );
  }

  /// Continue: نسجّل الحجز وبعدين نفتح التذكرة
  void _bookTicket() {
    final ticket = _buildTicket();
    TicketsProvider.instance.addTicket(ticket);
    _openTicketScreen(ticket);
  }

  /// View My Booking: آخر تذكرة اتحجزت (أو تجريبية لو مفيش)
  void _openMyBooking() {
    final tickets = TicketsProvider.instance.tickets;
    _openTicketScreen(tickets.isNotEmpty ? tickets.last : _buildTicket());
  }

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
                  isMyBookingSelected: false,
                  onMyBookingTap: _openMyBooking,
                ),
                const SizedBox(height: 20),
                TicketTypeSelector(
                  selected: _selectedType,
                  onChanged: (type) => setState(() => _selectedType = type),
                ),
                const SizedBox(height: 20),
                const VisitDropdownField(
                  label: 'Choose a Museum',
                  placeholder: 'Select your destination',
                  icon: Icons.account_balance,
                ),
                const SizedBox(height: 14),
                const VisitDropdownField(
                  label: 'Choose Visit Date',
                  placeholder: 'pick a day for your visit',
                  icon: Icons.date_range,
                ),
                const SizedBox(height: 14),
                const VisitDropdownField(
                  label: 'Select Time',
                  placeholder: 'Select an option',
                  icon: Icons.access_time,
                ),
                const SizedBox(height: 14),
                const VisitDropdownField(
                  label: 'Tour Language',
                  placeholder: 'Choose your tour language',
                  icon: Icons.translate,
                ),
                const SizedBox(height: 14),
                const VisitDropdownField(
                  label: 'Are you a Student',
                  placeholder: 'Select an option',
                  icon: Icons.school_outlined,
                ),
                const SizedBox(height: 24),
                ContinuePaymentButton(onPressed: _bookTicket),
              ],
            ),
          ),
        ),
      ),
    );
  }
}