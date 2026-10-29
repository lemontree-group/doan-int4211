package vn.edu.vhu.ltdd.lemontreeadmin.MoHinhDuLieu;

import com.google.gson.annotations.SerializedName;

public class PhanHoiDangNhap {
    @SerializedName("success")
    private boolean success;

    @SerializedName("message")
    private String message;

    @SerializedName("token")
    private String token;

    public boolean isSuccess() {
        return success;
    }

    public String getMessage() {
        return message;
    }

    public String getToken() {
        return token;
    }
}