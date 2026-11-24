package vn.edu.vhu.ltdd.lemontreeadmin.Adapter;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import java.util.List;
import vn.edu.vhu.ltdd.lemontreeadmin.MoHinhDuLieu.MonAn;

import vn.edu.vhu.ltdd.lemontreeadmin.R;

public class MonAnAdapter extends RecyclerView.Adapter<MonAnAdapter.MonAnViewHolder> {

    private final List<MonAn> danhSach;

    public MonAnAdapter(List<MonAn> danhSach) {
        this.danhSach = danhSach;
    }

    @NonNull
    @Override
    public MonAnViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_mon_an, parent, false);
        return new MonAnViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull MonAnViewHolder holder, int position) {
        MonAn mon = danhSach.get(position);
        holder.tvTenMon.setText(mon.tenMon);
        holder.tvGiaMon.setText("Giá: " + String.format("%,.0f", mon.gia) + " đ");
        holder.tvMoTaMon.setText("Mô tả: " + (mon.moTa != null ? mon.moTa : "Không có"));
        holder.tvNguyenLieuMon.setText("Nguyên liệu: " + (mon.nguyenLieu != null ? mon.nguyenLieu : "Chưa cập nhật"));
        holder.tvDiUngMon.setText("Cảnh báo dị ứng: " + (mon.canhBaoDiUng != null && !mon.canhBaoDiUng.isEmpty() ? mon.canhBaoDiUng : "Không có"));
    }

    @Override
    public int getItemCount() {
        return danhSach != null ? danhSach.size() : 0;
    }

    static class MonAnViewHolder extends RecyclerView.ViewHolder {
        TextView tvTenMon, tvGiaMon, tvMoTaMon, tvNguyenLieuMon, tvDiUngMon;

        public MonAnViewHolder(@NonNull View itemView) {
            super(itemView);
            tvTenMon = itemView.findViewById(R.id.tvTenMon);
            tvGiaMon = itemView.findViewById(R.id.tvGiaMon);
            tvMoTaMon = itemView.findViewById(R.id.tvMoTaMon);
            tvNguyenLieuMon = itemView.findViewById(R.id.tvNguyenLieuMon);
            tvDiUngMon = itemView.findViewById(R.id.tvDiUngMon);
        }
    }
}