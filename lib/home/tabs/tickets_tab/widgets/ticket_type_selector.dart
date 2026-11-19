import 'package:material_ui/material_ui.dart';
import '../models/ticket_type.dart';
import 'ticket_type_option.dart';

class TicketTypeSelector extends StatelessWidget {
  final TicketType selected;
  final ValueChanged<TicketType> onChanged;

  const TicketTypeSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choose Ticket Type',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 6),
        TicketTypeOption(
          icon: Icons.confirmation_num_outlined,
          title: 'Regular Ticket',
          subtitle: 'Enter and explore at your own pace',
          selected: selected == TicketType.regular,
          onTap: () => onChanged(TicketType.regular),
        ),
        const SizedBox(height: 10),
        TicketTypeOption(
          icon: Icons.smart_toy_outlined,
          title: 'Ticket with Robot',
          subtitle: 'A robot guide accompanies your visit',
          selected: selected == TicketType.robot,
          onTap: () => onChanged(TicketType.robot),
        ),
        const SizedBox(height: 10),
        TicketTypeOption(
          icon: Icons.document_scanner_outlined,
          title: 'Self-Guided Ticket',
          subtitle: 'Scan artifacts and learn about them',
          selected: selected == TicketType.selfGuided,
          onTap: () => onChanged(TicketType.selfGuided),
        ),
      ],
    );
  }
}