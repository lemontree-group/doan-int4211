import 'dart:convert';

import 'package:http/http.dart' as http;

import 'auth_service.dart';
import '../utils/api_config.dart';

class MenuService {
  final AuthService _authService = AuthService();

  Future<List<Map<String, dynamic>>> getMenus({
    String? tuNgay,
    String? denNgay,
  }) async {
    final token = await _authService.getToken();

    if (token == null || token.isEmpty) {
      throw Exception('Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.');
    }

    final queryParameters = <String, String>{};

    if (tuNgay != null && tuNgay.isNotEmpty) {
      queryParameters['tuNgay'] = tuNgay;
    }

    if (denNgay != null && denNgay.isNotEmpty) {
      queryParameters['denNgay'] = denNgay;
    }

    final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.menus}').replace(
      queryParameters: queryParameters.isEmpty ? null : queryParameters,
    );

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['success'] == true) {
      final menus = data['data'] as List<dynamic>;

      return menus.map((menu) => Map<String, dynamic>.from(menu)).toList();
    }

    if (response.statusCode == 401 || response.statusCode == 403) {
      throw Exception(
        'Không có quyền truy cập thực đơn. Vui lòng đăng nhập lại.',
      );
    }

    throw Exception(data['message'] ?? 'Không thể tải danh sách thực đơn.');
  }
}
