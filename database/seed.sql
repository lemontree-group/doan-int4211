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