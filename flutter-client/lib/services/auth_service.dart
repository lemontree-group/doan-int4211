
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/api_config.dart';

class AuthService {
  // Đăng nhập bằng tài khoản công nhân
  Future<Map<String, dynamic>> loginWorker({
    required String maCongNhan,
    required String maNhaMay,
    required String matKhau,
  }) async {
    final url = Uri.parse(
      '${ApiConfig.baseUrl}${ApiConfig.workerLogin}',
    );

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'maCongNhan': maCongNhan.trim(),
        'maNhaMay': maNhaMay.trim(),
        'matKhau': matKhau,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['success'] == true) {
      final token = data['data']['token'];
      final user = data['data']['user'];

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('token', token);
      await prefs.setString('user', jsonEncode(user));

      return user;
    }

    throw Exception(
      data['message'] ?? 'Đăng nhập thất bại. Vui lòng thử lại.',
    );
  }

  // Lấy JWT Token đã lưu
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Lấy thông tin công nhân đã lưu
  Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');

    if (userJson == null) {
      return null;
    }

    return jsonDecode(userJson) as Map<String, dynamic>;
  }

  // Đăng xuất
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('token');
    await prefs.remove('user');
  }
}