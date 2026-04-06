import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Change this to your server IP if running on a physical device
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  static String? _token;

  static Future<String?> get token async {
    if (_token != null) return _token;
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    return _token;
  }

  static Future<void> setToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  static Future<void> clearToken() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  static Future<Map<String, String>> _headers() async {
    final t = await token;
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (t != null) 'Authorization': 'Bearer $t',
    };
  }

  // ─── Auth ───────────────────────────────────────────────────────────

  static Future<Map<String, dynamic>> login(String email, String password) async {
    final res = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    final data = jsonDecode(res.body);
    if (res.statusCode == 200) {
      await setToken(data['token']);
    }
    return {'status': res.statusCode, 'body': data};
  }

  static Future<void> logout() async {
    try {
      await http.post(Uri.parse('$baseUrl/logout'), headers: await _headers());
    } catch (_) {}
    await clearToken();
  }

  static Future<Map<String, dynamic>?> getUser() async {
    final res = await http.get(Uri.parse('$baseUrl/user'), headers: await _headers());
    if (res.statusCode == 200) return jsonDecode(res.body);
    return null;
  }

  // ─── Generic CRUD ───────────────────────────────────────────────────

  static Future<List<dynamic>> getList(String endpoint) async {
    final res = await http.get(Uri.parse('$baseUrl/$endpoint'), headers: await _headers());
    if (res.statusCode == 200) {
      final decoded = jsonDecode(res.body);
      return decoded is List ? decoded : [];
    }
    return [];
  }

  static Future<Map<String, dynamic>?> getOne(String endpoint) async {
    final res = await http.get(Uri.parse('$baseUrl/$endpoint'), headers: await _headers());
    if (res.statusCode == 200) return jsonDecode(res.body);
    return null;
  }

  static Future<Map<String, dynamic>> create(String endpoint, Map<String, dynamic> data) async {
    final res = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: await _headers(),
      body: jsonEncode(data),
    );
    return {'status': res.statusCode, 'body': jsonDecode(res.body)};
  }

  static Future<Map<String, dynamic>> update(String endpoint, int id, Map<String, dynamic> data) async {
    final res = await http.put(
      Uri.parse('$baseUrl/$endpoint/$id'),
      headers: await _headers(),
      body: jsonEncode(data),
    );
    return {'status': res.statusCode, 'body': jsonDecode(res.body)};
  }

  static Future<bool> delete(String endpoint, int id) async {
    final res = await http.delete(
      Uri.parse('$baseUrl/$endpoint/$id'),
      headers: await _headers(),
    );
    return res.statusCode == 200;
  }

  // ─── Public Portfolio ───────────────────────────────────────────────

  static Future<Map<String, dynamic>?> getPublicPortfolio(int userId) async {
    final res = await http.get(
      Uri.parse('$baseUrl/portfolio/$userId'),
      headers: {'Accept': 'application/json'},
    );
    if (res.statusCode == 200) return jsonDecode(res.body);
    return null;
  }
}
