const express = require('express');
const router = express.Router();

const menuController = require('../controllers/menu.controller');

const {
    authenticateToken,
    authorizeRoles
} = require('../middleware/auth.middleware');

// API lấy thực đơn dành cho công nhân đã đăng nhập
router.get(
    '/',
    authenticateToken,
    authorizeRoles('CONG_NHAN'),
    menuController.getMenus
);

module.exports = router;