const jwt = require('jsonwebtoken');

// Middleware xác thực JWT Token
const authenticateToken = (req, res, next) => {
    // Lấy Token từ Header Authorization
    const authHeader = req.headers.authorization;

    // Kiểm tra người dùng có gửi Token hay không
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
        return res.status(401).json({
            success: false,
            message: 'Vui lòng đăng nhập để tiếp tục'
        });
    }

    // Tách Token khỏi chuỗi Bearer
    const token = authHeader.split(' ')[1];

    try {
        // Xác minh Token bằng JWT_SECRET
        const decoded = jwt.verify(token, process.env.JWT_SECRET);

        // Lưu thông tin người dùng vào Request
        req.user = decoded;

        // Cho phép chuyển sang Middleware hoặc Controller tiếp theo
        next();
    } catch (error) {
        return res.status(401).json({
            success: false,
            message: 'Token không hợp lệ hoặc đã hết hạn'
        });
    }
};
// Middleware phân quyền theo vai trò
const authorizeRoles = (...allowedRoles) => {
    return (req, res, next) => {
        // Kiểm tra người dùng đã được xác thực chưa
        if (!req.user) {
            return res.status(401).json({
                success: false,
                message: 'Vui lòng đăng nhập để tiếp tục'
            });
        }

        // Kiểm tra vai trò có được phép truy cập không
        if (!allowedRoles.includes(req.user.vai_tro)) {
            return res.status(403).json({
                success: false,
                message: 'Bạn không có quyền truy cập chức năng này'
            });
        }

        next();
    };
};
module.exports = {
    authenticateToken,
    authorizeRoles
};