const registrationService = require('../services/registration.service');
// Kiểm tra ID phải là số nguyên dương hợp lệ
const isValidId = (id) =>
    /^\d+$/.test(String(id)) &&
    Number.isSafeInteger(Number(id)) &&
    Number(id) > 0;

// 1. Đăng ký suất ăn
const createRegistration = async (req, res, next) => {
    try {
        const maCongNhan = req.user.ma_cn;
        const maNhaMay = req.user.ma_nha_may;
        const { ma_menu, loai_suat } = req.body;

        if (!maCongNhan || !maNhaMay) {
            return res.status(403).json({
                success: false,
                message: 'Tài khoản không có quyền đăng ký suất ăn'
            });
        }

        const registration = await registrationService.createRegistration(
            maCongNhan,
            maNhaMay,
            ma_menu,
            loai_suat
        );

        return res.status(201).json({
            success: true,
            message: 'Đăng ký suất ăn thành công',
            data: registration
        });
    } catch (error) {
        next(error);
    }
};

// 2. Xem danh sách đăng ký
const getRegistrations = async (req, res, next) => {
    try {
        const maCongNhan = req.user.ma_cn;

        if (!maCongNhan) {
            return res.status(403).json({
                success: false,
                message: 'Tài khoản không phải công nhân'
            });
        }

        const registrations = await registrationService.getRegistrations(
            maCongNhan
        );

        return res.status(200).json({
            success: true,
            message: 'Lấy danh sách đăng ký thành công',
            data: registrations
        });
    } catch (error) {
        next(error);
    }
};

// 3. Xem chi tiết đăng ký
const getRegistrationById = async (req, res, next) => {
    try {
        const maCongNhan = req.user.ma_cn;
        const { id } = req.params;
        if (!isValidId(id)) {
            return res.status(400).json({
                success: false,
                message: 'Mã đăng ký không hợp lệ'
            });
        }

        if (!maCongNhan) {
            return res.status(403).json({
                success: false,
                message: 'Tài khoản không phải công nhân'
            });
        }

        const registration = await registrationService.getRegistrationById(
            id,
            maCongNhan
        );

        return res.status(200).json({
            success: true,
            message: 'Lấy chi tiết đăng ký thành công',
            data: registration
        });
    } catch (error) {
        next(error);
    }
};

// 4. Hủy đăng ký
const cancelRegistration = async (req, res, next) => {
    try {
        const maCongNhan = req.user.ma_cn;
        const { id } = req.params;
        if (!isValidId(id)) {
            return res.status(400).json({
                success: false,
                message: 'Mã đăng ký không hợp lệ'
            });
        }

        if (!maCongNhan) {
            return res.status(403).json({
                success: false,
                message: 'Tài khoản không phải công nhân'
            });
        }

        const registration = await registrationService.cancelRegistration(
            id,
            maCongNhan
        );

        return res.status(200).json({
            success: true,
            message: 'Hủy đăng ký suất ăn thành công',
            data: registration
        });
    } catch (error) {
        next(error);
    }
};

module.exports = {
    createRegistration,
    getRegistrations,
    getRegistrationById,
    cancelRegistration
};