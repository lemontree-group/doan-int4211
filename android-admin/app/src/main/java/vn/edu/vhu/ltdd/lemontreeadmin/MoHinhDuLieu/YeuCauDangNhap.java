package vn.edu.vhu.ltdd.lemontreeadmin.MoHinhDuLieu;

import com.google.gson.annotations.SerializedName;

public class YeuCauDangNhap {
    @SerializedName("tenDangNhap")
    private String username;

    @SerializedName("password")
    private String password;

    public YeuCauDangNhap(String username, String password) {
        this.username = username;
        this.password = password;
    }

    public String getUsername() {
        return username;
    }

    public String getPassword() {
        return password;
    }
}