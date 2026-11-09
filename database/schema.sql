-- =====================================================
-- DO AN INT4211
-- HE THONG DAT SUAT AN CONG NGHIEP
-- PostgreSQL / Supabase
-- =====================================================

-- =====================================================
-- 1. NHA_MAY
-- =====================================================

CREATE TABLE nha_may (
    ma_nha_may SERIAL PRIMARY KEY,
    ma_nha_may_code VARCHAR(20) NOT NULL UNIQUE,
    ten_nha_may VARCHAR(100) NOT NULL,
    dia_chi TEXT,
    so_dien_thoai VARCHAR(20)
);

-- =====================================================
-- 2. CONG_NHAN
-- =====================================================

CREATE TABLE cong_nhan (
    ma_cn SERIAL PRIMARY KEY,
    ma_nha_may INT NOT NULL,
    ma_cong_nhan VARCHAR(20) NOT NULL,
    ho_ten VARCHAR(100) NOT NULL,
    gioi_tinh VARCHAR(10),
    ngay_sinh DATE,
    bo_phan VARCHAR(100),
    ca_lam_viec VARCHAR(50),

    CONSTRAINT fk_cong_nhan_nha_may
        FOREIGN KEY (ma_nha_may)
        REFERENCES nha_may(ma_nha_may),

    CONSTRAINT uq_ma_cong_nhan
        UNIQUE (ma_nha_may, ma_cong_nhan)
);

-- =====================================================
-- 3. TAI_KHOAN
-- =====================================================

CREATE TABLE tai_khoan (
    ma_tk SERIAL PRIMARY KEY,

    ma_cn INT UNIQUE,

    ten_dang_nhap VARCHAR(50) UNIQUE,

    ma_nha_may INT,

    password_hash VARCHAR(255) NOT NULL,

    vai_tro VARCHAR(30) NOT NULL
        CHECK (
            vai_tro IN (
                'QUAN_TRI_HE_THONG',
                'QUAN_LY_NHA_MAY',
                'CONG_NHAN'
            )
        ),

    trang_thai BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT fk_tai_khoan_cong_nhan
        FOREIGN KEY (ma_cn)
        REFERENCES cong_nhan(ma_cn),

    CONSTRAINT fk_tai_khoan_nha_may
        FOREIGN KEY (ma_nha_may)
        REFERENCES nha_may(ma_nha_may),

    CONSTRAINT chk_tai_khoan_phan_quyen
        CHECK (
            (
                vai_tro = 'QUAN_TRI_HE_THONG'
                AND ma_cn IS NULL
                AND ma_nha_may IS NULL
                AND ten_dang_nhap IS NOT NULL
            )
            OR
            (
                vai_tro = 'QUAN_LY_NHA_MAY'
                AND ma_cn IS NULL
                AND ma_nha_may IS NOT NULL
                AND ten_dang_nhap IS NOT NULL
            )
            OR
            (
                vai_tro = 'CONG_NHAN'
                AND ma_cn IS NOT NULL
                AND ma_nha_may IS NULL
                AND ten_dang_nhap IS NULL
            )
        )
);

-- =====================================================
-- 4. MON_AN
-- =====================================================

CREATE TABLE mon_an (
    ma_mon SERIAL PRIMARY KEY,
    ten_mon VARCHAR(100) NOT NULL,
    mo_ta TEXT,
    gia NUMERIC(10,2) NOT NULL CHECK (gia >= 0),
    anh_url TEXT,
    nguyen_lieu TEXT,
    canh_bao_di_ung TEXT
);

-- =====================================================
-- 5. MENU
-- =====================================================

CREATE TABLE menu (
    ma_menu SERIAL PRIMARY KEY,

    ma_nha_may INT NOT NULL,

    ngay_ap_dung DATE NOT NULL,

    thoi_diem_chot TIMESTAMPTZ NOT NULL,

    ghi_chu TEXT,

    CONSTRAINT fk_menu_nha_may
        FOREIGN KEY (ma_nha_may)
        REFERENCES nha_may(ma_nha_may),

    CONSTRAINT uq_menu_nha_may_ngay
        UNIQUE (ma_nha_may, ngay_ap_dung)
);

-- =====================================================
-- 6. MENU_MON_AN
-- =====================================================

CREATE TABLE menu_mon_an (
    ma_menu INT NOT NULL,
    ma_mon INT NOT NULL,

    loai_suat VARCHAR(20) NOT NULL
        CHECK (loai_suat IN ('THUONG', 'CHAY')),

    PRIMARY KEY (
        ma_menu,
        ma_mon,
        loai_suat
    ),

    CONSTRAINT fk_mma_menu
        FOREIGN KEY (ma_menu)
        REFERENCES menu(ma_menu),

    CONSTRAINT fk_mma_mon
        FOREIGN KEY (ma_mon)
        REFERENCES mon_an(ma_mon)
);

-- =====================================================
-- 7. DANG_KY_SUAT_AN
-- =====================================================

CREATE TABLE dang_ky_suat_an (
    ma_dang_ky SERIAL PRIMARY KEY,

    ma_cn INT NOT NULL,

    ma_menu INT NOT NULL,

    loai_suat VARCHAR(20) NOT NULL
        CHECK (loai_suat IN ('THUONG', 'CHAY')),

    ma_qr VARCHAR(255) UNIQUE,

    thoi_gian_dang_ky TIMESTAMPTZ
        NOT NULL DEFAULT CURRENT_TIMESTAMP,

    thoi_gian_nhan TIMESTAMPTZ,

    trang_thai VARCHAR(20)
        NOT NULL DEFAULT 'DA_DANG_KY'
        CHECK (
            trang_thai IN (
                'DA_DANG_KY',
                'DA_HUY',
                'DA_NHAN'
            )
        ),

    CONSTRAINT uq_dang_ky
        UNIQUE (ma_cn, ma_menu),

    CONSTRAINT fk_dksa_congnhan
        FOREIGN KEY (ma_cn)
        REFERENCES cong_nhan(ma_cn),

    CONSTRAINT fk_dksa_menu
        FOREIGN KEY (ma_menu)
        REFERENCES menu(ma_menu)
);

-- =====================================================
-- 8. DANH_GIA
-- =====================================================

CREATE TABLE danh_gia (
    ma_danh_gia SERIAL PRIMARY KEY,

    ma_cn INT NOT NULL,

    ma_menu INT NOT NULL,

    diem_so INT NOT NULL
        CHECK (diem_so BETWEEN 1 AND 5),

    nhan_xet TEXT,

    ngay_danh_gia TIMESTAMPTZ
        NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uq_danh_gia_cong_nhan_menu
        UNIQUE (ma_cn, ma_menu),

    CONSTRAINT fk_danhgia_congnhan
        FOREIGN KEY (ma_cn)
        REFERENCES cong_nhan(ma_cn),

    CONSTRAINT fk_danhgia_menu
        FOREIGN KEY (ma_menu)
        REFERENCES menu(ma_menu)
);

-- =====================================================
-- 9. PHAN_ANH
-- =====================================================

CREATE TABLE phan_anh (
    ma_phan_anh SERIAL PRIMARY KEY,

    ma_cn INT NOT NULL,

    tieu_de VARCHAR(200) NOT NULL,

    noi_dung TEXT NOT NULL,

    anh_url TEXT,

    ngay_phan_anh TIMESTAMPTZ
        NOT NULL DEFAULT CURRENT_TIMESTAMP,

    trang_thai VARCHAR(30)
        NOT NULL DEFAULT 'DA_TIEP_NHAN'
        CHECK (
            trang_thai IN (
                'DA_TIEP_NHAN',
                'DANG_XU_LY',
                'DA_GIAI_QUYET'
            )
        ),

    CONSTRAINT fk_phananh_congnhan
        FOREIGN KEY (ma_cn)
        REFERENCES cong_nhan(ma_cn)
);


-- =====================================================
-- 10. DINH_MUC
-- =====================================================

CREATE TABLE dinh_muc (
    ma_mon INT NOT NULL,
    ten_nguyen_lieu VARCHAR(100) NOT NULL,
    so_luong NUMERIC(10,2) NOT NULL,
    don_vi VARCHAR(20) NOT NULL,

    PRIMARY KEY (ma_mon, ten_nguyen_lieu),

    CONSTRAINT fk_dinh_muc_mon_an
        FOREIGN KEY (ma_mon)
        REFERENCES mon_an(ma_mon)
);


-- =====================================================
-- INDEX
-- =====================================================

CREATE INDEX idx_cong_nhan_nha_may
ON cong_nhan(ma_nha_may);

CREATE INDEX idx_tai_khoan_nha_may
ON tai_khoan(ma_nha_may);

CREATE INDEX idx_tai_khoan_vai_tro
ON tai_khoan(vai_tro);

CREATE INDEX idx_menu_ngay_ap_dung
ON menu(ngay_ap_dung);

CREATE INDEX idx_dang_ky_ma_cn
ON dang_ky_suat_an(ma_cn);

CREATE INDEX idx_dang_ky_ma_menu
ON dang_ky_suat_an(ma_menu);

CREATE INDEX idx_phan_anh_ma_cn
ON phan_anh(ma_cn);

-- =====================================================
-- DU LIEU MAU
-- =====================================================

INSERT INTO nha_may
(ma_nha_may_code, ten_nha_may, dia_chi, so_dien_thoai)
VALUES
('NM001','Nhà máy Bình Dương','Bình Dương','0901234567'),
('NM002','Nhà máy Đồng Nai','Đồng Nai','0902345678');

INSERT INTO cong_nhan
(ma_nha_may, ma_cong_nhan, ho_ten, gioi_tinh, ngay_sinh, bo_phan, ca_lam_viec)
VALUES
(1,'CN001','Nguyễn Văn A','Nam','1995-05-12','Sản Xuất','Ca Sáng'),
(1,'CN002','Trần Thị B','Nữ','1998-10-21','Đóng Gói','Ca Chiều'),
(2,'CN003','Lê Văn C','Nam','1997-02-01','Kho','Ca Tối');

INSERT INTO tai_khoan
(ma_cn, ten_dang_nhap, ma_nha_may, password_hash, vai_tro, trang_thai)
VALUES
(NULL,'admin',NULL,'admin_hash','QUAN_TRI_HE_THONG',TRUE),
(NULL,'manager_bd',1,'manager_bd_hash','QUAN_LY_NHA_MAY',TRUE),
(NULL,'manager_dn',2,'manager_dn_hash','QUAN_LY_NHA_MAY',TRUE),
(1,NULL,NULL,'cn001_hash','CONG_NHAN',TRUE),
(2,NULL,NULL,'cn002_hash','CONG_NHAN',TRUE),
(3,NULL,NULL,'cn003_hash','CONG_NHAN',TRUE);

INSERT INTO mon_an
(ten_mon, mo_ta, gia, anh_url, nguyen_lieu, canh_bao_di_ung)
VALUES
('Cơm Gà Chiên','Cơm gà chiên giòn',30000,'https://food.com/comga.jpg','Gà, Cơm, Dầu ăn',NULL),
('Cá Kho Tộ','Cá kho truyền thống',32000,'https://food.com/cakho.jpg','Cá, Nước mắm','Cá'),
('Đậu Hũ Kho','Suất ăn chay',25000,'https://food.com/dauhu.jpg','Đậu hũ, Nấm','Đậu nành'),
('Rau Củ Luộc','Rau củ theo mùa',22000,'https://food.com/raucu.jpg','Rau xanh',NULL);

INSERT INTO menu
(ma_nha_may, ngay_ap_dung, thoi_diem_chot, ghi_chu)
VALUES
(1,'2026-12-10','2026-12-09 17:00:00+07','Menu ngày 10/12'),
(2,'2026-12-10','2026-12-09 17:00:00+07','Menu ngày 10/12');

INSERT INTO menu_mon_an
(ma_menu, ma_mon, loai_suat)
VALUES
(1,1,'THUONG'),
(1,2,'THUONG'),
(1,3,'CHAY'),
(2,2,'THUONG'),
(2,4,'CHAY');

INSERT INTO dang_ky_suat_an
(ma_cn, ma_menu, loai_suat, ma_qr, thoi_gian_dang_ky, thoi_gian_nhan, trang_thai)
VALUES
(1,1,'THUONG','QR_CN001_001',CURRENT_TIMESTAMP,NULL,'DA_DANG_KY'),
(2,1,'CHAY','QR_CN002_001',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'DA_NHAN'),
(3,2,'THUONG','QR_CN003_001',CURRENT_TIMESTAMP,NULL,'DA_HUY');

INSERT INTO danh_gia
(ma_cn, ma_menu, diem_so, nhan_xet)
VALUES
(2,1,4,'Khá hài lòng');

INSERT INTO phan_anh
(ma_cn, tieu_de, noi_dung, anh_url, trang_thai)
VALUES
(1,'Món ăn hơi mặn','Canh hôm nay hơi mặn','https://food.com/phananh1.jpg','DA_TIEP_NHAN'),
(2,'Cơm nguội','Cơm phát không còn nóng','https://food.com/phananh2.jpg','DANG_XU_LY');

INSERT INTO dinh_muc
(ma_mon, ten_nguyen_lieu, so_luong, don_vi)
VALUES
(1,'Gạo',0.20,'Kg'),
(1,'Gà',0.15,'Kg'),
(1,'Dầu ăn',0.02,'Lít'),

(2,'Cá',0.18,'Kg'),
(2,'Nước mắm',0.01,'Lít'),

(3,'Đậu hũ',0.20,'Kg'),
(3,'Nấm',0.05,'Kg');