const express = require('express');
const router = express.Router();

const registrationController = require('../controllers/registration.controller');

const {
    authenticateToken,
    authorizeRoles
} = require('../middleware/auth.middleware');

// Tất cả API chỉ dành cho công nhân đã đăng nhập
router.use(authenticateToken);
router.use(authorizeRoles('CONG_NHAN'));

// Đăng ký suất ăn
router.post('/', registrationController.createRegistration);

// Xem danh sách đăng ký
router.get('/', registrationController.getRegistrations);

// Xem chi tiết đăng ký
router.get('/:id', registrationController.getRegistrationById);

// Hủy đăng ký
router.delete('/:id', registrationController.cancelRegistration);

module.exports = router;