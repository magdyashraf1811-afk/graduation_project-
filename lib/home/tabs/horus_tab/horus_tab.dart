import 'package:material_ui/material_ui.dart';
import 'package:athaar_app/home/tabs/tickets_tab/scan_artifact_screen.dart';

class HorusTab extends StatelessWidget {
  const HorusTab({super.key});

  @override
  Widget build(BuildContext context) {
    // التاب مش بيتفتح غير لو عند المستخدم تذكرة Self-Guided ( HomeScreen)
    return const ScanArtifactScreen(showBack: false);
  }
}
