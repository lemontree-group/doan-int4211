const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const db = require('../config/db');

// Đăng nhập dành cho công nhân
const loginWorker = async ({ maCongNhan, maNhaMay, matKhau }) => {
    // 1. Kiểm tra dữ liệu đầu vào
    if (!maCongNhan || !maNhaMay || !matKhau) {
        const error = new Error('Vui lòng nhập đầy đủ thông tin đăng nhập');
        error.statusCode = 400;
        throw error;
    }

    // 2. Tìm tài khoản theo mã công nhân và mã nhà máy
    const sql = `
        SELECT
            tk.ma_tk,
            tk.password_hash,
            tk.vai_tro,
            tk.trang_thai AS tai_khoan_hoat_dong,
            cn.ma_cn,
            cn.ma_cong_nhan,
            cn.ho_ten,
            cn.ma_nha_may,
            nm.ma_nha_may_code,
            nm.ten_nha_may
        FROM tai_khoan tk
        JOIN cong_nhan cn
            ON tk.ma_cn = cn.ma_cn
        JOIN nha_may nm
            ON cn.ma_nha_may = nm.ma_nha_may
        WHERE cn.ma_cong_nhan = $1
          AND nm.ma_nha_may_code = $2
          AND tk.vai_tro = 'CONG_NHAN'
        LIMIT 1
    `;

    const { rows } = await db.query(sql, [
        maCongNhan.trim(),
        maNhaMay.trim().toUpperCase()
    ]);

    const account = rows[0];

    // 3. Kiểm tra tài khoản tồn tại và đang hoạt động
    if (
        !account || !account.tai_khoan_hoat_dong
    ) {
        const error = new Error('Thông tin đăng nhập không hợp lệ');
        error.statusCode = 401;
        throw error;
    }

    // 4. So sánh mật khẩu với mật khẩu đã mã hóa trong database
    const isPasswordValid = await bcrypt.compare(
        matKhau,
        account.password_hash
    );

    if (!isPasswordValid) {
        const error = new Error('Thông tin đăng nhập không hợp lệ');
        error.statusCode = 401;
        throw error;
    }

    // 5. Tạo JWT Token
    const token = jwt.sign(
        {
            ma_tk: account.ma_tk,
            ma_cn: account.ma_cn,
            ma_nha_may: account.ma_nha_may,
            vai_tro: account.vai_tro
        },
        process.env.JWT_SECRET,
        {
            expiresIn: process.env.JWT_EXPIRES_IN || '1d'
        }
    );

    // 6. Trả về token và thông tin công nhân
    return {
        token,
        user: {
            ma_tk: account.ma_tk,
            ma_cn: account.ma_cn,
            ma_cong_nhan: account.ma_cong_nhan,
            ho_ten: account.ho_ten,
            ma_nha_may: account.ma_nha_may,
            ma_nha_may_code: account.ma_nha_may_code,
            ten_nha_may: account.ten_nha_may,
            vai_tro: account.vai_tro
        }
    };
};

// Đăng nhập dành cho Admin và Quản lý nhà máy
const loginStaff = async ({ tenDangNhap, matKhau }) => {
    // 1. Kiểm tra dữ liệu đầu vào
    if (!tenDangNhap || !matKhau) {
        const error = new Error('Vui lòng nhập tên đăng nhập và mật khẩu');
        error.statusCode = 400;
        throw error;
    }

    // 2. Tìm tài khoản trong database
    const sql = `
        SELECT
            tk.ma_tk,
            tk.ten_dang_nhap,
            tk.password_hash,
            tk.vai_tro,
            tk.trang_thai,
            tk.ma_nha_may,
            nm.ma_nha_may_code,
            nm.ten_nha_may
        FROM tai_khoan tk
        LEFT JOIN nha_may nm
            ON tk.ma_nha_may = nm.ma_nha_may
        WHERE tk.ten_dang_nhap = $1
          AND tk.vai_tro IN (
              'QUAN_TRI_HE_THONG',
              'QUAN_LY_NHA_MAY'
          )
        LIMIT 1
    `;

    const { rows } = await db.query(sql, [
        tenDangNhap.trim()
    ]);

    const account = rows[0];

    // 3. Kiểm tra tài khoản tồn tại và đang hoạt động
    if (!account || !account.trang_thai) {
        const error = new Error('Thông tin đăng nhập không hợp lệ');
        error.statusCode = 401;
        throw error;
    }

    // 4. Kiểm tra mật khẩu
    const isPasswordValid = await bcrypt.compare(
        matKhau,
        account.password_hash
    );

    if (!isPasswordValid) {
        const error = new Error('Thông tin đăng nhập không hợp lệ');
        error.statusCode = 401;
        throw error;
    }

    // 5. Tạo JWT Token
    const token = jwt.sign(
        {
            ma_tk: account.ma_tk,
            vai_tro: account.vai_tro,
            ma_nha_may: account.ma_nha_may
        },
        process.env.JWT_SECRET,
        {
            expiresIn: process.env.JWT_EXPIRES_IN || '1d'
        }
    );

    // 6. Trả kết quả đăng nhập
    return {
        token,
        user: {
            ma_tk: account.ma_tk,
            ten_dang_nhap: account.ten_dang_nhap,
            vai_tro: account.vai_tro,
            ma_nha_may: account.ma_nha_may,
            ma_nha_may_code: account.ma_nha_may_code,
            ten_nha_may: account.ten_nha_may
        }
    };
};

module.exports = {
    loginWorker,
    loginStaff
};