
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_client/main.dart';

void main() {
  testWidgets('Hiển thị đầy đủ giao diện đăng nhập',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('ĐẶT SUẤT ĂN CÔNG NGHIỆP'), findsOneWidget);
    expect(find.text('Đăng nhập dành cho công nhân'), findsOneWidget);
    expect(find.text('Mã công nhân'), findsOneWidget);
    expect(find.text('Mã nhà máy'), findsOneWidget);
    expect(find.text('Mật khẩu'), findsOneWidget);
    expect(find.text('ĐĂNG NHẬP'), findsOneWidget);
  });

  testWidgets('Hiển thị lỗi khi bỏ trống thông tin đăng nhập',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('ĐĂNG NHẬP'));
    await tester.pump();

    expect(find.text('Vui lòng nhập mã công nhân'), findsOneWidget);
    expect(find.text('Vui lòng nhập mã nhà máy'), findsOneWidget);
    expect(find.text('Vui lòng nhập mật khẩu'), findsOneWidget);
  });
}