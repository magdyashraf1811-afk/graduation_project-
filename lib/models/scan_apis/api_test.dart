import 'api_service.dart';

Future<void> testApi() async {
  final api = ApiService();

  try {
    final health = await api.checkHealth();
    print('Health: ${health.data}');

    final artifacts = await api.getArtifacts();
    print('Artifacts: ${artifacts.data}');
  } catch (e) {
    print('API Error: $e');
  }
}
