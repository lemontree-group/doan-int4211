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
import vn.edu.vhu.ltdd.lemontreeadmin.Adapter.MonAnAdapter;
import vn.edu.vhu.ltdd.lemontreeadmin.MoHinhDuLieu.MonAn;
import vn.edu.vhu.ltdd.lemontreeadmin.R;

public class QuanLyMonAnActivity extends AppCompatActivity {

    private RecyclerView rvMonAn;
    private ProgressBar progressBar;
    private TextView tvTrong;
    private MonAnAdapter adapter;
    private final List<MonAn> danhSachMonAn = new ArrayList<>();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_quan_ly_mon_an);

        rvMonAn = findViewById(R.id.rvMonAn);
        progressBar = findViewById(R.id.progressBarMonAn);
        tvTrong = findViewById(R.id.tvTrongMonAn);

        rvMonAn.setLayoutManager(new LinearLayoutManager(this));
        adapter = new MonAnAdapter(danhSachMonAn);
        rvMonAn.setAdapter(adapter);

        taiDuLieuMau();
    }

    private void taiDuLieuMau() {
        progressBar.setVisibility(View.VISIBLE);
        danhSachMonAn.clear();

        MonAn m1 = new MonAn();
        m1.maMon = 1;
        m1.tenMon = "Cơm Gà Chiên";
        m1.moTa = "Cơm gà chiên giòn";
        m1.gia = 30000;
        m1.nguyenLieu = "Gà, Cơm, Dầu ăn";
        m1.canhBaoDiUng = null;

        MonAn m2 = new MonAn();
        m2.maMon = 2;
        m2.tenMon = "Cá Kho Tộ";
        m2.moTa = "Cá kho truyền thống";
        m2.gia = 32000;
        m2.nguyenLieu = "Cá, Nước mắm";
        m2.canhBaoDiUng = "Cá";

        MonAn m3 = new MonAn();
        m3.maMon = 3;
        m3.tenMon = "Đậu Hũ Kho";
        m3.moTa = "Suất ăn chay";
        m3.gia = 25000;
        m3.nguyenLieu = "Đậu hũ, Nấm";
        m3.canhBaoDiUng = "Đậu nành";

        danhSachMonAn.add(m1);
        danhSachMonAn.add(m2);
        danhSachMonAn.add(m3);

        progressBar.setVisibility(View.GONE);
        adapter.notifyDataSetChanged();
        tvTrong.setVisibility(danhSachMonAn.isEmpty() ? View.VISIBLE : View.GONE);
    }
}