import 'dart:convert';
import 'package:athaar_app/models/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _tokenKey = 'token';

  // LOGIN
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.login),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      Map<String, dynamic> data;

      try {
        final decoded = jsonDecode(response.body);

        if (decoded is! Map<String, dynamic>) {
          throw const FormatException();
        }

        data = decoded;
      } on FormatException {
        throw Exception(
          'Invalid response received from server.',
        );
      }

      if (response.statusCode >= 200 &&
          response.statusCode < 300) {
        final token = data['token']?.toString();

        if (token == null || token.isEmpty) {
          throw Exception(
            'Authentication token was not returned.',
          );
        }

        final prefs = await SharedPreferences.getInstance();

        await prefs.setString(_tokenKey, token);

        return data;
      }

      throw Exception(
        data['message']?.toString() ?? 'Login failed.',
      );
    } on http.ClientException {
      throw Exception('Unable to connect to the server.');
    } catch (e) {
      rethrow;
    }
  }

  // GET SAVED TOKEN
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // LOGOUT - LOCAL TOKEN CLEARING
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}
