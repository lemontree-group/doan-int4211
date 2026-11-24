package vn.edu.vhu.ltdd.lemontreeadmin.MoHinhDuLieu;

import com.google.gson.annotations.SerializedName;

public class DuLieuChotSuat {
    @SerializedName("mon_an_id")
    private int monAnId;
    @SerializedName("ten_mon")
    private String tenMon;
    @SerializedName("tong_suat")
    private int tongSuat;
    private String loai;

    public DuLieuChotSuat(String loai) {
        this.loai = loai;
    }

    public String getTenMon() { return tenMon; }
    public int getTongSuat() { return tongSuat; }
    public String getLoai() { return loai; }
}