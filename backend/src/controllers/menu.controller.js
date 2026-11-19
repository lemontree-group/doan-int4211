const menuService = require('../services/menu.service');

// API lấy danh sách thực đơn
const getMenus = async (req, res, next) => {
    try {
        // Lấy mã nhà máy từ JWT Token
        const maNhaMay = req.user.ma_nha_may;

        // Lấy khoảng ngày từ Query Parameters
        const { tuNgay, denNgay } = req.query;

        // Kiểm tra tài khoản có thuộc nhà máy không
        if (!maNhaMay) {
            return res.status(403).json({
                success: false,
                message: 'Tài khoản không thuộc nhà máy nào'
            });
        }

        // Gọi Service truy vấn thực đơn
        const rows = await menuService.getMenusByFactory(
            maNhaMay,
            tuNgay || null,
            denNgay || null
        );

        // Nhóm dữ liệu theo từng thực đơn
        const menusMap = new Map();

        for (const row of rows) {
            if (!menusMap.has(row.ma_menu)) {
                menusMap.set(row.ma_menu, {
                    ma_menu: row.ma_menu,
                    ma_nha_may: row.ma_nha_may,
                    ma_nha_may_code: row.ma_nha_may_code,
                    ten_nha_may: row.ten_nha_may,
                    ngay_ap_dung: row.ngay_ap_dung,
                    thoi_diem_chot: row.thoi_diem_chot,
                    ghi_chu: row.ghi_chu,
                    cac_loai_suat: {}
                });
            }

            const menu = menusMap.get(row.ma_menu);

            // Tạo nhóm CHAY hoặc THUONG
            if (!menu.cac_loai_suat[row.loai_suat]) {
                menu.cac_loai_suat[row.loai_suat] = [];
            }

            menu.cac_loai_suat[row.loai_suat].push({
                ma_mon: row.ma_mon,
                ten_mon: row.ten_mon,
                mo_ta: row.mo_ta,
                gia: row.gia,
                anh_url: row.anh_url,
                nguyen_lieu: row.nguyen_lieu,
                canh_bao_di_ung: row.canh_bao_di_ung
            });
        }

        res.status(200).json({
            success: true,
            message: 'Lấy danh sách thực đơn thành công',
            data: Array.from(menusMap.values())
        });
    } catch (error) {
        next(error);
    }
};

module.exports = {
    getMenus
};