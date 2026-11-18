import 'package:athaar_app/home/tabs/tickets_tab/widgets/tickets_info_row.dart';
import 'package:flutter/material.dart';
import 'package:athaar_app/utils/app_colors.dart';
import '../models/ticket_model1.dart';
import '../models/ticket_model1.dart';
import 'outlined_pill_button.dart';
import 'tickets_info_row.dart';
import 'ticket_qr_section.dart';

class TicketCard extends StatelessWidget {
  final TicketModel ticket;
  final VoidCallback? onViewTicket;
  final VoidCallback? onShareBooking;

  const TicketCard({
    super.key,
    required this.ticket,
    this.onViewTicket,
    this.onShareBooking,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBgColor,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppColors.goldBorderColor, width: 1.2),
        boxShadow: const [
          BoxShadow(color: AppColors.goldGlowColor, blurRadius: 18),
        ],
      ),
      child: Column(
        children: [
          _buildTopSection(),
          const SizedBox(height: 14),
          Container(height: 1, color: AppColors.goldBorderColor),
          const SizedBox(height: 14),
          TicketQrSection(bookingRef: ticket.bookingRef),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedPillButton(
                  icon: Icons.confirmation_num_outlined,
                  label: 'View Ticket',
                  onTap: onViewTicket,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedPillButton(
                  icon: Icons.share_outlined,
                  label: 'Share Booking',
                  onTap: onShareBooking,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// الجزء اللي فوق: صورة المتحف + التفاصيل
  Widget _buildTopSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 112,
          height: 124,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.goldBorderColor, width: 1.2),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(19),
            child: Image.asset(
              ticket.imageAsset,
              fit: BoxFit.cover,
              // لو الصورة مش موجودة لسه، تظهر أيقونة بدل ما يحصل crash
              errorBuilder: (_, __, ___) => Container(
                color: const Color(0xFF1E1E1E),
                child: const Icon(Icons.museum_outlined,
                    color: AppColors.goldColor, size: 40),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ticket.museumName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TicketInfoRow(
                  icon: Icons.calendar_today_outlined, text: ticket.date),
              TicketInfoRow(icon: Icons.access_time, text: ticket.time),
              TicketInfoRow(icon: Icons.translate, text: ticket.language),
              TicketInfoRow(
                  icon: Icons.school_outlined, text: ticket.visitorType),
            ],
          ),
        ),
      ],
    );
  }
}