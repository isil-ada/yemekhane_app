import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:5000/api'; // Adjust for emulator if needed (10.0.2.2 for Android)

  // Helper to get headers with token
  static Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<dynamic> get(String endpoint) async {
    final headers = await _getHeaders();
    final response = await http.get(Uri.parse('$baseUrl$endpoint'), headers: headers);
    return _handleResponse(response);
  }

  static Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: jsonEncode(data),
    );
    return _handleResponse(response);
  }

  static Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: jsonEncode(data),
    );
    return _handleResponse(response);
  }

  static Future<dynamic> delete(String endpoint) async {
    final headers = await _getHeaders();
    final response = await http.delete(Uri.parse('$baseUrl$endpoint'), headers: headers);
    return _handleResponse(response);
  }

  static dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    } else {
      // Throw error with message from server if available
      String message = 'Bir hata oluştu';
      try {
        final body = jsonDecode(response.body);
        if (body['message'] != null) message = body['message'];
      } catch (_) {}
      throw Exception(message);
    }
  }

  static Future<String?> uploadProfilePicture(String filePath) async {
    final uri = Uri.parse('$baseUrl/upload-profile-picture');
    final request = http.MultipartRequest('POST', uri);
    
    // Add headers (Auth)
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    final mimeType = lookupMimeType(filePath);
    MediaType? mediaType;
    if (mimeType != null) {
      final split = mimeType.split('/');
      mediaType = MediaType(split[0], split[1]);
    }

    request.files.add(await http.MultipartFile.fromPath(
      'profile_image', 
      filePath,
      contentType: mediaType,
    ));

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data['profile_picture_path']; // Return the relative path
      } else {
        print('Upload failed: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Upload error: $e');
      return null;
    }
  }
}
