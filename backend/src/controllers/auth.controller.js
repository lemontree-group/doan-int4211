const authService = require('../services/auth.service');

// Xử lý yêu cầu đăng nhập công nhân
const loginWorker = async (req, res, next) => {
    try {
        // Nhận thông tin đăng nhập từ ứng dụng Flutter
        const { maCongNhan, maNhaMay, matKhau } = req.body;

        // Gọi dịch vụ xác thực tài khoản
        const result = await authService.loginWorker({
            maCongNhan,
            maNhaMay,
            matKhau
        });

        // Trả kết quả đăng nhập thành công
        return res.status(200).json({
            success: true,
            message: 'Đăng nhập thành công',
            data: result
        });
    } catch (error) {
        next(error);
    }
};

// Xử lý đăng nhập Admin và Quản lý
const loginStaff = async (req, res, next) => {
    try {
        const { tenDangNhap, matKhau } = req.body;

        const result = await authService.loginStaff({
            tenDangNhap,
            matKhau
        });

        return res.status(200).json({
            success: true,
            message: 'Đăng nhập thành công',
            data: result
        });
    } catch (error) {
        next(error);
    }
};

module.exports = {
    loginWorker,
    loginStaff
};