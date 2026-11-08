
# HỆ THỐNG ĐẶT SUẤT ĂN CÔNG NGHIỆP

**Môn học:** INT4211  
**Đề tài:** Hệ thống đặt suất ăn công nghiệp cho khu công nghiệp

## 1. Giới thiệu

Xây dựng hệ thống hỗ trợ quản lý thực đơn, đăng ký suất ăn,
quản lý số lượng suất ăn và đánh giá chất lượng bữa ăn
trong các khu công nghiệp.

## 2. Công nghệ sử dụng

| Thành phần | Công nghệ |
|---|---|
| Android Admin | Android Studio, Java, XML |
| Flutter Client | Flutter, Dart |
| Backend | Node.js, Express |
| Cơ sở dữ liệu | PostgreSQL (Supabase) |
| Lưu trữ hình ảnh | Supabase Storage |
| Triển khai Backend | Render |
| Xác thực | JWT, bcrypt |

## 3. Cấu trúc dự án

- `android-admin/`: Ứng dụng quản trị Android.
- `flutter-client/`: Ứng dụng dành cho công nhân.
- `backend/`: REST API.
- `database/`: Cấu trúc và dữ liệu cơ sở dữ liệu.
- `phantich/`: Tài liệu phân tích, thiết kế hệ thống.

## 4. Phân công thành viên

| Thành viên | Công việc |
|---|---|
| Thành viên 1 | Phân tích, thiết kế CSDL PostgreSQL |
| Thành viên 2 | Backend Node.js, Express |
| Thành viên 3 | Android Admin Java/XML |
| Thành viên 4 | Flutter Client Dart |

## 5. Trạng thái dự án

Dự án đang trong giai đoạn khởi tạo cấu trúc và chuẩn bị
triển khai các thành phần.

## 6. Quy trình làm việc

- Mỗi thành viên phụ trách thành phần được phân công.
- Làm việc trên nhánh riêng.
- Commit và push các thay đổi lên GitHub.
- Tích hợp thông qua Pull Request.
- Không đưa thông tin bí mật trong file `.env` lên GitHub.