import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://api.jamendo.com/v3.0';

  static String get clientId => dotenv.env['CLIENT_ID'] ?? '';

  static Uri getTracks({required int limit, required int offset}) {
    return Uri.parse('$baseUrl/tracks/').replace(queryParameters: {
      'client_id': clientId,
      'format': 'json',
      'limit': '$limit',
      'offset': '$offset',
    });
  }

  static Uri searchTracks({
    required String query,
    required int limit,
    required int offset,
  }) {
    return Uri.parse('$baseUrl/tracks/').replace(queryParameters: {
      'client_id': clientId,
      'format': 'json',
      'namesearch': query,
      'limit': '$limit',
      'offset': '$offset',
    });
  }
}