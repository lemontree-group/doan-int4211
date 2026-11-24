package vn.edu.vhu.ltdd.lemontreeadmin.MoHinhDuLieu;

import com.google.gson.annotations.SerializedName;

public class NhaMay {
    @SerializedName("ma_nha_may")
    public int maNhaMay;

    @SerializedName("ma_nha_may_code")
    public String maNhaMayCode;

    @SerializedName("ten_nha_may")
    public String tenNhaMay;

    @SerializedName("dia_chi")
    public String diaChi;

    @SerializedName("so_dien_thoai")
    public String soDienThoai;
}