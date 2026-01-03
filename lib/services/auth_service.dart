import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class AuthService {
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await ApiService.post('/auth/login', {
      'email': email,
      'password': password,
    });

    final token = response['token'];
    final user = response['user'];

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('user_id', user['id'].toString());
    await prefs.setString('user_name', user['name']);
    await prefs.setString('user_email', user['email']);
    if (user['profile_picture'] != null) {
      await prefs.setString('profile_picture', user['profile_picture']);
    }

    return user;
  }

  static Future<void> register(String name, String username, String email, String password) async {
    await ApiService.post('/auth/register', {
      'name': name,
      'username': username,
      'email': email,
      'password': password,
    });
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('token');
  }

  static Future<Map<String, String>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString('user_name') ?? '',
      'email': prefs.getString('user_email') ?? '',
      'username': prefs.getString('username') ?? '',
      'profile_picture_path': prefs.getString('profile_picture') ?? '', // Return stored path or empty
    };
  }

  static Future<void> updateProfile(String name, String username, String email) async {
    // 1. Call API
    await ApiService.put('/auth/update-profile', {
      'name': name,
      'username': username,
      'email': email,
    });

    // 2. Update Local Storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
    await prefs.setString('username', username);
    await prefs.setString('user_email', email);
  }

  static Future<void> updateProfilePicture(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_picture', path);
  }

  static Future<void> removeProfilePicture() async {
     final prefs = await SharedPreferences.getInstance();
     await prefs.remove('profile_picture');
  }
}
