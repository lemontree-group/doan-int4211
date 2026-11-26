const crypto = require('crypto');
const db = require('../config/db');

const createError = (message, statusCode) => {
    const error = new Error(message);
    error.statusCode = statusCode;
    return error;
};

// 1. Đăng ký hoặc đăng ký lại suất ăn
const createRegistration = async (
    maCongNhan,
    maNhaMay,
    maMenu,
    loaiSuat
) => {
    const ids = [maCongNhan, maNhaMay, maMenu];

    const invalidId = ids.some(
        (id) =>
            id === null ||
            id === undefined ||
            String(id).trim() === '' ||
            !Number.isSafeInteger(Number(id)) ||
            Number(id) <= 0
    );

    if (invalidId) {
        throw createError('Thông tin đăng ký không hợp lệ', 400);
    }

    if (!['THUONG', 'CHAY'].includes(loaiSuat)) {
        throw createError('Loại suất ăn không hợp lệ', 400);
    }

    const client = await db.pool.connect();

    try {
        await client.query('BEGIN');

        // Khóa thực đơn để tránh xử lý đăng ký đồng thời không nhất quán
        const menuResult = await client.query(
            `SELECT ma_menu, ma_nha_may,
                    thoi_diem_chot,
                    thoi_diem_chot > CURRENT_TIMESTAMP AS con_han
             FROM menu
             WHERE ma_menu = $1
             FOR UPDATE`,
            [Number(maMenu)]
        );

        if (menuResult.rows.length === 0) {
            throw createError('Không tìm thấy thực đơn', 404);
        }

        const menu = menuResult.rows[0];

        if (Number(menu.ma_nha_may) !== Number(maNhaMay)) {
            throw createError(
                'Thực đơn không thuộc nhà máy của bạn',
                403
            );
        }

        if (!menu.con_han) {
            throw createError('Đã quá thời điểm chốt đăng ký', 400);
        }

        // Kiểm tra loại suất có trong thực đơn
        const mealResult = await client.query(
            `SELECT 1
             FROM menu_mon_an
             WHERE ma_menu = $1 AND loai_suat = $2
             LIMIT 1`,
            [Number(maMenu), loaiSuat]
        );

        if (mealResult.rows.length === 0) {
            throw createError(
                'Loại suất ăn không có trong thực đơn này',
                400
            );
        }

        // Tìm đăng ký cũ của công nhân
        const existingResult = await client.query(
            `SELECT ma_dang_ky, trang_thai
             FROM dang_ky_suat_an
             WHERE ma_cn = $1 AND ma_menu = $2
             FOR UPDATE`,
            [Number(maCongNhan), Number(maMenu)]
        );

        let result;

        if (existingResult.rows.length > 0) {
            const existing = existingResult.rows[0];

            if (existing.trang_thai === 'DA_DANG_KY') {
                throw createError(
                    'Bạn đã đăng ký thực đơn này rồi',
                    409
                );
            }

            if (existing.trang_thai === 'DA_NHAN') {
                throw createError(
                    'Bạn đã nhận suất ăn, không thể đăng ký lại',
                    409
                );
            }

            // Đăng ký lại khi bản ghi cũ đã bị hủy
            const maQr = `QR_${crypto.randomUUID()}`;

            result = await client.query(
                `UPDATE dang_ky_suat_an
                 SET loai_suat = $1,
                     ma_qr = $2,
                     thoi_gian_dang_ky = CURRENT_TIMESTAMP,
                     thoi_gian_nhan = NULL,
                     trang_thai = 'DA_DANG_KY'
                 WHERE ma_dang_ky = $3
                 RETURNING *`,
                [
                    loaiSuat,
                    maQr,
                    existing.ma_dang_ky
                ]
            );
        } else {
            const maQr = `QR_${crypto.randomUUID()}`;

            result = await client.query(
                `INSERT INTO dang_ky_suat_an
                    (ma_cn, ma_menu, loai_suat, ma_qr)
                 VALUES ($1, $2, $3, $4)
                 RETURNING *`,
                [
                    Number(maCongNhan),
                    Number(maMenu),
                    loaiSuat,
                    maQr
                ]
            );
        }

        await client.query('COMMIT');

        return result.rows[0];
    } catch (error) {
        await client.query('ROLLBACK');
        throw error;
    } finally {
        client.release();
    }
};

// 2. Xem danh sách đăng ký của công nhân
const getRegistrations = async (maCongNhan) => {
    const sql = `
        SELECT
            d.ma_dang_ky,
            d.ma_cn,
            d.ma_menu,
            d.loai_suat,
            d.ma_qr,
            d.thoi_gian_dang_ky,
            d.thoi_gian_nhan,
            d.trang_thai,
            TO_CHAR(m.ngay_ap_dung, 'YYYY-MM-DD') AS ngay_ap_dung,
            m.thoi_diem_chot,
            m.ghi_chu,
            nm.ten_nha_may
        FROM dang_ky_suat_an d
        JOIN menu m ON d.ma_menu = m.ma_menu
        JOIN nha_may nm ON m.ma_nha_may = nm.ma_nha_may
        WHERE d.ma_cn = $1
        ORDER BY m.ngay_ap_dung DESC, d.thoi_gian_dang_ky DESC
    `;

    const result = await db.query(sql, [Number(maCongNhan)]);
    return result.rows;
};

// 3. Xem chi tiết một đăng ký của công nhân
const getRegistrationById = async (maDangKy, maCongNhan) => {
    const result = await db.query(
        `SELECT
            d.*,
            TO_CHAR(m.ngay_ap_dung, 'YYYY-MM-DD') AS ngay_ap_dung,
            m.thoi_diem_chot,
            m.ghi_chu,
            nm.ten_nha_may
         FROM dang_ky_suat_an d
         JOIN menu m ON d.ma_menu = m.ma_menu
         JOIN nha_may nm ON m.ma_nha_may = nm.ma_nha_may
         WHERE d.ma_dang_ky = $1 AND d.ma_cn = $2`,
        [Number(maDangKy), Number(maCongNhan)]
    );

    if (result.rows.length === 0) {
        throw createError('Không tìm thấy đăng ký suất ăn', 404);
    }

    return result.rows[0];
};

// 4. Hủy đăng ký
const cancelRegistration = async (maDangKy, maCongNhan) => {
    const client = await db.pool.connect();

    try {
        await client.query('BEGIN');

        // Lấy mã thực đơn của đăng ký, chỉ cho phép chủ sở hữu truy cập
        const ownerResult = await client.query(
            `SELECT ma_menu
             FROM dang_ky_suat_an
             WHERE ma_dang_ky = $1 AND ma_cn = $2`,
            [Number(maDangKy), Number(maCongNhan)]
        );

        if (ownerResult.rows.length === 0) {
            throw createError('Không tìm thấy đăng ký suất ăn', 404);
        }

        // Khóa thực đơn trước để thống nhất thứ tự khóa với createRegistration
        const menuResult = await client.query(
            `SELECT ma_menu,
                    thoi_diem_chot,
                    thoi_diem_chot > CURRENT_TIMESTAMP AS con_han
             FROM menu
             WHERE ma_menu = $1
             FOR UPDATE`,
            [ownerResult.rows[0].ma_menu]
        );

        if (menuResult.rows.length === 0) {
            throw createError('Không tìm thấy thực đơn', 404);
        }

        // Sau đó mới khóa bản ghi đăng ký
        const registrationResult = await client.query(
            `SELECT ma_dang_ky, trang_thai
             FROM dang_ky_suat_an
             WHERE ma_dang_ky = $1 AND ma_cn = $2
             FOR UPDATE`,
            [Number(maDangKy), Number(maCongNhan)]
        );

        if (registrationResult.rows.length === 0) {
            throw createError('Không tìm thấy đăng ký suất ăn', 404);
        }

        const registration = {
            ...registrationResult.rows[0],
            con_han: menuResult.rows[0].con_han
        };

        if (registration.trang_thai !== 'DA_DANG_KY') {
            throw createError(
                'Chỉ có thể hủy đăng ký chưa nhận suất ăn',
                400
            );
        }

        if (!registration.con_han) {
            throw createError(
                'Đã quá thời điểm chốt, không thể hủy',
                400
            );
        }

        const result = await client.query(
            `UPDATE dang_ky_suat_an
             SET trang_thai = 'DA_HUY'
             WHERE ma_dang_ky = $1
             RETURNING *`,
            [Number(maDangKy)]
        );

        await client.query('COMMIT');

        return result.rows[0];
    } catch (error) {
        await client.query('ROLLBACK');
        throw error;
    } finally {
        client.release();
    }
};

module.exports = {
    createRegistration,
    getRegistrations,
    getRegistrationById,
    cancelRegistration
};