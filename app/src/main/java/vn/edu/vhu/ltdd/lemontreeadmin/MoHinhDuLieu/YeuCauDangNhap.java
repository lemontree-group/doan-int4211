package vn.edu.vhu.ltdd.lemontreeadmin.MoHinhDuLieu;

public class YeuCauDangNhap {
    private String username;
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