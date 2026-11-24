package vn.edu.vhu.ltdd.lemontreeadmin.KetNoiMang;

import java.util.List;

import retrofit2.Call;
import retrofit2.http.Body;
import retrofit2.http.GET;
import retrofit2.http.POST;
import vn.edu.vhu.ltdd.lemontreeadmin.MoHinhDuLieu.MonAn;
import vn.edu.vhu.ltdd.lemontreeadmin.MoHinhDuLieu.PhanHoiDangNhap;
import vn.edu.vhu.ltdd.lemontreeadmin.MoHinhDuLieu.YeuCauDangNhap;

public interface GiaoDienApi {

    @POST("api/v1/admin/login")
    Call<PhanHoiDangNhap> dangNhap(@Body YeuCauDangNhap yeuCau);

    @POST("api/auth/staff/login")
    Call<PhanHoiDangNhap> dangNhapStaff(@Body YeuCauDangNhap yeuCau);

    @POST("api/auth/worker/login")
    Call<PhanHoiDangNhap> dangNhapWorker(@Body YeuCauDangNhap yeuCau);

    @GET("api/menus")
    Call<List<MonAn>> layDanhSachMenus();
}