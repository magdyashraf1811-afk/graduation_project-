import 'package:material_ui/material_ui.dart';
import 'package:athaar_app/utils/app_colors.dart';
import 'qr_brackets_painter.dart';

class TicketQrSection extends StatelessWidget {
  final String bookingRef; // هيتحول لـ QR حقيقي بعدين

  const TicketQrSection({super.key, required this.bookingRef});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          height: 100,
          child: CustomPaint(
            painter: QrBracketsPainter(),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                color: Colors.white,
                child: const Center(
                  // مؤقت: مكان الـ QR الحقيقي
                  child: Icon(Icons.qr_code_2, size: 64, color: Colors.black),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 18),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Booking Reference',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.verified_user_outlined,
                      color: AppColors.goldColor, size: 22),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Please show this QR code\nat the museum entrance',
                      style: TextStyle(
                        color: AppColors.lightGrayColor,
                        fontSize: 10,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}