class ApiConstants {
  static const String baseUrl =
      'https://exclaim-majestic-fidgeting.ngrok-free.dev';

  static const Map<String, String> headers = {
    'ngrok-skip-browser-warning': 'true',
    'Accept': 'application/json',
  };

  static const String health = '/api/health';
  static const String artifacts = '/api/artifacts';

  static String artifactById(String id) =>
      '/api/artifacts/$id';

  static const String content = '/api/content';
  static const String predict = '/api/predict';
}