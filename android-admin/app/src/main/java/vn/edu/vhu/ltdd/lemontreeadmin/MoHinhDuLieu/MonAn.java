package vn.edu.vhu.ltdd.lemontreeadmin.MoHinhDuLieu;

import com.google.gson.annotations.SerializedName;

public class MonAn {
    @SerializedName("ma_mon")
    public int maMon;

    @SerializedName("ten_mon")
    public String tenMon;

    @SerializedName("mo_ta")
    public String moTa;

    @SerializedName("gia")
    public double gia;

    @SerializedName("anh_url")
    public String anhUrl;

    @SerializedName("nguyen_lieu")
    public String nguyenLieu;

    @SerializedName("canh_bao_di_ung")
    public String canhBaoDiUng;
}