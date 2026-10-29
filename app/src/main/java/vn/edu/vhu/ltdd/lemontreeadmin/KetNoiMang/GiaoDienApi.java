package vn.edu.vhu.ltdd.lemontreeadmin.KetNoiMang;

import retrofit2.Call;
import retrofit2.http.Body;
import retrofit2.http.POST;
import vn.edu.vhu.ltdd.lemontreeadmin.MoHinhDuLieu.PhanHoiDangNhap;
import vn.edu.vhu.ltdd.lemontreeadmin.MoHinhDuLieu.YeuCauDangNhap;

public interface GiaoDienApi {
    @POST("api/v1/admin/login")
    Call<PhanHoiDangNhap> dangNhap(@Body YeuCauDangNhap yeuCau);
}