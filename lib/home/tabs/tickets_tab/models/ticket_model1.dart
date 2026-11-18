import 'ticket_type.dart';

class TicketModel {
  final String museumName;
  final String date;
  final String time;
  final String language;
  final String visitorType;
  final String imageAsset;
  final String bookingRef;
  final TicketType type;

  const TicketModel({
    required this.museumName,
    required this.date,
    required this.time,
    required this.language,
    required this.visitorType,
    required this.imageAsset,
    required this.bookingRef,
    this.type = TicketType.regular,
  });
}
