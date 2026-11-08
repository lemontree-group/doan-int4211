
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


## 4. Danh sách thành viên và phân công công việc

| STT | Họ và tên             | MSSV       | GitHub Username    | Vai trò phụ trách |
|---|-----------------------|------------|--------------------|---|
| 1 | Bùi Huỳnh Tuấn Vũ     | 241A010778 | tuanvu254254-dot   | Phân tích hệ thống, Use Case, ERD, PostgreSQL |
| 2 | Lê Huỳnh Thành Đạt    | 241A010102 | haruestia0613-sudo | Backend Node.js, Express, REST API |
| 3 | Trần Nguyễn Thanh Lộc | 241A010179 | LocTran246         | Android Admin (Java/XML) |
| 4 | Nguyễn Thị Hồng Thắm  | 241A010134 | HTham326           | Flutter Client (Flutter/Dart) |

## 5. Trạng thái dự án

Dự án đang trong giai đoạn khởi tạo cấu trúc và chuẩn bị
triển khai các thành phần.

## 6. Quy trình làm việc

- Mỗi thành viên phụ trách thành phần được phân công.
- Làm việc trên nhánh riêng.
- Commit và push các thay đổi lên GitHub.
- Tích hợp thông qua Pull Request.
- Không đưa thông tin bí mật trong file `.env` lên GitHub.