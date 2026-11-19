const db = require('../config/db');

// Lấy thực đơn theo nhà máy và khoảng ngày
const getMenusByFactory = async (maNhaMay, tuNgay = null, denNgay = null) => {
    const sql = `
        SELECT
            mn.ma_menu,
            mn.ma_nha_may,
            nm.ma_nha_may_code,
            nm.ten_nha_may,
            TO_CHAR(mn.ngay_ap_dung, 'YYYY-MM-DD') AS ngay_ap_dung,
            mn.thoi_diem_chot,
            mn.ghi_chu,
            mma.loai_suat,
            ma.ma_mon,
            ma.ten_mon,
            ma.mo_ta,
            ma.gia,
            ma.anh_url,
            ma.nguyen_lieu,
            ma.canh_bao_di_ung
        FROM public.menu mn
        JOIN public.nha_may nm
            ON mn.ma_nha_may = nm.ma_nha_may
        JOIN public.menu_mon_an mma
            ON mn.ma_menu = mma.ma_menu
        JOIN public.mon_an ma
            ON mma.ma_mon = ma.ma_mon
        WHERE mn.ma_nha_may = $1
          AND ($2::date IS NULL OR mn.ngay_ap_dung >= $2::date)
          AND ($3::date IS NULL OR mn.ngay_ap_dung <= $3::date)
        ORDER BY
            mn.ngay_ap_dung,
            mma.loai_suat,
            ma.ten_mon;
    `;

    const result = await db.query(sql, [
        maNhaMay,
        tuNgay,
        denNgay
    ]);

    return result.rows;
};

module.exports = {
    getMenusByFactory
};