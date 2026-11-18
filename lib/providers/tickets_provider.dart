import 'package:flutter/foundation.dart';
import 'package:athaar_app/home/tabs/tickets_tab/models/ticket_model1.dart';
import 'package:athaar_app/home/tabs/tickets_tab/models/ticket_type.dart';

class TicketsProvider extends ChangeNotifier {
  TicketsProvider._();

  static final TicketsProvider instance = TicketsProvider._();

  final List<TicketModel> _tickets = [];

  List<TicketModel> get tickets => List.unmodifiable(_tickets);

  ///لو اليوزر عنده تذكرة Self-Guide (بتفتح Horus)
  bool get hasSelfGuidedTicket =>
      _tickets.any((t) => t.type == TicketType.selfGuided);

  void addTicket(TicketModel ticket) {
    _tickets.add(ticket);
    notifyListeners();
  }
}