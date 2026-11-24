package vn.edu.vhu.ltdd.lemontreeadmin.GiaoDienNguoiDung;

import android.os.Bundle;
import android.view.View;
import android.widget.ProgressBar;
import android.widget.TextView;
import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import java.util.ArrayList;
import java.util.List;
import vn.edu.vhu.ltdd.lemontreeadmin.Adapter.NhaMayAdapter;
import vn.edu.vhu.ltdd.lemontreeadmin.MoHinhDuLieu.NhaMay;
import vn.edu.vhu.ltdd.lemontreeadmin.R;

public class QuanLyNhaMayActivity extends AppCompatActivity {

    private RecyclerView rvNhaMay;
    private ProgressBar progressBar;
    private TextView tvTrong;
    private NhaMayAdapter adapter;
    private final List<NhaMay> danhSachNhaMay = new ArrayList<>();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_quan_ly_nha_may);

        rvNhaMay = findViewById(R.id.rvNhaMay);
        progressBar = findViewById(R.id.progressBarNhaMay);
        tvTrong = findViewById(R.id.tvTrongNhaMay);

        rvNhaMay.setLayoutManager(new LinearLayoutManager(this));
        adapter = new NhaMayAdapter(danhSachNhaMay);
        rvNhaMay.setAdapter(adapter);

        taiDuLieuMau();
    }

    private void taiDuLieuMau() {
        progressBar.setVisibility(View.VISIBLE);
        danhSachNhaMay.clear();

        NhaMay nm1 = new NhaMay();
        nm1.maNhaMay = 1;
        nm1.maNhaMayCode = "NM001";
        nm1.tenNhaMay = "Nhà máy Bình Dương";
        nm1.diaChi = "Bình Dương";
        nm1.soDienThoai = "0901234567";

        NhaMay nm2 = new NhaMay();
        nm2.maNhaMay = 2;
        nm2.maNhaMayCode = "NM002";
        nm2.tenNhaMay = "Nhà máy Đồng Nai";
        nm2.diaChi = "Đồng Nai";
        nm2.soDienThoai = "0902345678";

        danhSachNhaMay.add(nm1);
        danhSachNhaMay.add(nm2);

        progressBar.setVisibility(View.GONE);
        adapter.notifyDataSetChanged();
        tvTrong.setVisibility(danhSachNhaMay.isEmpty() ? View.VISIBLE : View.GONE);
    }
}