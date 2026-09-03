import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:jamendo_music_player/core/constants/api_constants.dart';
import 'package:jamendo_music_player/data/models/tracks_response.dart';

class ApiException implements Exception {
  final String message;

  const ApiException(this.message);

  @override
  String toString() => message;
}

class JamendoService {
  Future<TracksResponse> _fetchTracks(Uri uri) async {
    try {
      http.Response response = await http.get(uri);
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return TracksResponse.fromJson(jsonResponse);
      } else {
        throw ApiException('Server Error: (${response.statusCode})');
      }
    } on http.ClientException {
      throw const ApiException('No internet Connection');
    } on FormatException {
      throw const ApiException('Unexpected response from server');
    }
  }

  Future<TracksResponse> getTracks({required int limit, required int offset}) {
    return _fetchTracks(ApiConstants.getTracks(limit: limit, offset: offset));
  }

  Future<TracksResponse> searchTracks({
    required String query,
    required int limit,
    required int offset,
  }) {
    return _fetchTracks(
      ApiConstants.searchTracks(query: query, limit: limit, offset: offset),
    );
  }
}
