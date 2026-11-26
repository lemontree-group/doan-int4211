import 'package:flutter/material.dart';

import '../services/menu_service.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final MenuService _menuService = MenuService();

  List<Map<String, dynamic>> _menus = [];
  bool _isLoading = true;
  String? _error;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _loadMenus();
  }

  Future<void> _loadMenus() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final date = _selectedDate;

      final menus = await _menuService.getMenus(
        tuNgay: date == null
            ? null
            : '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
        denNgay: date == null
            ? null
            : '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
      );

      if (!mounted) return;

      setState(() {
        _menus = menus;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      helpText: 'Chọn ngày xem thực đơn',
    );

    if (pickedDate == null) return;

    setState(() {
      _selectedDate = pickedDate;
    });

    await _loadMenus();
  }

  Future<void> _clearDate() async {
    setState(() {
      _selectedDate = null;
    });

    await _loadMenus();
  }

  String _formatDate(dynamic value) {
    if (value == null) return 'Chưa cập nhật';

    final date = DateTime.tryParse(value.toString());

    if (date == null) return value.toString();

    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  String _formatPrice(dynamic value) {
    if (value == null) return 'Chưa cập nhật';

    final price = num.tryParse(value.toString());

    if (price == null) return value.toString();

    return '${price.toStringAsFixed(0)} đ';
  }

  Widget _buildMealCard(Map<String, dynamic> meal) {
    final imageUrl = meal['anh_url']?.toString() ?? '';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imageUrl.isNotEmpty)
            Image.network(
              imageUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return _buildImagePlaceholder();
              },
            )
          else
            _buildImagePlaceholder(),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal['ten_mon']?.toString() ?? 'Món ăn',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  meal['mo_ta']?.toString() ?? 'Chưa có mô tả',
                  style: TextStyle(color: Colors.grey[700], fontSize: 14),
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    const Icon(Icons.payments, color: Colors.green, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      _formatPrice(meal['gia']),
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),

                if (meal['nguyen_lieu'] != null) ...[
                  const SizedBox(height: 10),
                  _buildDetail(
                    Icons.restaurant,
                    'Nguyên liệu',
                    meal['nguyen_lieu'].toString(),
                  ),
                ],

                if (meal['canh_bao_di_ung'] != null &&
                    meal['canh_bao_di_ung'].toString().isNotEmpty) ...[
                  const SizedBox(height: 10),
                  _buildDetail(
                    Icons.warning_amber,
                    'Cảnh báo dị ứng',
                    meal['canh_bao_di_ung'].toString(),
                    color: Colors.red,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      height: 160,
      width: double.infinity,
      color: Colors.grey[200],
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.restaurant, size: 50, color: Colors.grey),
          SizedBox(height: 8),
          Text('Chưa có hình ảnh'),
        ],
      ),
    );
  }

  Widget _buildDetail(
    IconData icon,
    String title,
    String content, {
    Color? color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: color ?? Colors.blueGrey),
        const SizedBox(width: 8),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '$title: ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: content),
              ],
            ),
            style: TextStyle(fontSize: 13, color: color ?? Colors.black87),
          ),
        ),
      ],
    );
  }

  Widget _buildMealGroup(String type, List<dynamic> meals) {
    if (meals.isEmpty) {
      return const SizedBox.shrink();
    }

    final isVegetarian = type == 'CHAY';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
          child: Row(
            children: [
              Icon(
                isVegetarian ? Icons.eco : Icons.restaurant_menu,
                color: isVegetarian ? Colors.green : Colors.orange,
              ),
              const SizedBox(width: 8),
              Text(
                isVegetarian ? 'SUẤT ĂN CHAY' : 'SUẤT ĂN THƯỜNG',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: isVegetarian ? Colors.green[700] : Colors.orange[800],
                ),
              ),
            ],
          ),
        ),

        ...meals.map((meal) {
          return _buildMealCard(Map<String, dynamic>.from(meal as Map));
        }),
      ],
    );
  }

  Widget _buildMenuCard(Map<String, dynamic> menu) {
    final mealTypes = menu['cac_loai_suat'] as Map<String, dynamic>? ?? {};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          color: Colors.blue[50],
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_month, color: Colors.blue),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _formatDate(menu['ngay_ap_dung']),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Text('Nhà máy: ${menu['ten_nha_may'] ?? 'Chưa cập nhật'}'),

                if (menu['thoi_diem_chot'] != null) ...[
                  const SizedBox(height: 6),
                  Text('Thời điểm chốt: ${menu['thoi_diem_chot']}'),
                ],

                if (menu['ghi_chu'] != null &&
                    menu['ghi_chu'].toString().isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text('Ghi chú: ${menu['ghi_chu']}'),
                ],
              ],
            ),
          ),
        ),

        _buildMealGroup('THUONG', mealTypes['THUONG'] as List<dynamic>? ?? []),

        _buildMealGroup('CHAY', mealTypes['CHAY'] as List<dynamic>? ?? []),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thực đơn'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _selectDate,
            icon: const Icon(Icons.calendar_month),
            tooltip: 'Chọn ngày',
          ),
          if (_selectedDate != null)
            IconButton(
              onPressed: _isLoading ? null : _clearDate,
              icon: const Icon(Icons.filter_alt_off),
              tooltip: 'Bỏ lọc ngày',
            ),
          IconButton(
            onPressed: _isLoading ? null : _loadMenus,
            icon: const Icon(Icons.refresh),
            tooltip: 'Tải lại thực đơn',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 60,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(_error!, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _loadMenus,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Thử lại'),
                    ),
                  ],
                ),
              ),
            )
          : _menus.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.restaurant, size: 70, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'Hiện chưa có thực đơn.',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _loadMenus,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Tải lại'),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadMenus,
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: _menus.length,
                itemBuilder: (context, index) {
                  return _buildMenuCard(_menus[index]);
                },
              ),
            ),
    );
  }
}
