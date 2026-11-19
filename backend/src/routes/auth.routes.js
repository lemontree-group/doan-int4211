const express = require('express');
const router = express.Router();

const authController = require('../controllers/auth.controller');

// Import JWT Middleware
const {
    authenticateToken,
    authorizeRoles
} = require('../middleware/auth.middleware');

// API đăng nhập công nhân
router.post('/worker/login', authController.loginWorker);

// API đăng nhập Admin và Quản lý
router.post('/staff/login', authController.loginStaff);

// API kiểm tra thông tin tài khoản đã đăng nhập
router.get('/me', authenticateToken, (req, res) => {
    res.json({
        success: true,
        message: 'Xác thực Token thành công',
        data: {
            user: req.user
        }
    });
});

// API chỉ dành cho Admin hệ thống
router.get(
    '/admin-only',
    authenticateToken,
    authorizeRoles('QUAN_TRI_HE_THONG'),
    (req, res) => {
        res.json({
            success: true,
            message: 'Bạn có quyền truy cập chức năng Admin'
        });
    }
);

module.exports = router;