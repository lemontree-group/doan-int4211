package vn.edu.vhu.ltdd.lemontreeadmin.Adapter;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import java.util.List;
import vn.edu.vhu.ltdd.lemontreeadmin.MoHinhDuLieu.NhaMay;
import vn.edu.vhu.ltdd.lemontreeadmin.R;

public class NhaMayAdapter extends RecyclerView.Adapter<NhaMayAdapter.NhaMayViewHolder> {

    private final List<NhaMay> danhSach;

    public NhaMayAdapter(List<NhaMay> danhSach) {
        this.danhSach = danhSach;
    }

    @NonNull
    @Override
    public NhaMayViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_nha_may, parent, false);
        return new NhaMayViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull NhaMayViewHolder holder, int position) {
        NhaMay nm = danhSach.get(position);
        holder.tvTenNhaMay.setText(nm.tenNhaMay);
        holder.tvMaNhaMay.setText("Mã: " + nm.maNhaMayCode);
        holder.tvDiaChi.setText("Địa chỉ: " + (nm.diaChi != null ? nm.diaChi : "Chưa cập nhật"));
        holder.tvSoDienThoai.setText("SĐT: " + (nm.soDienThoai != null ? nm.soDienThoai : "Chưa cập nhật"));
    }

    @Override
    public int getItemCount() {
        return danhSach != null ? danhSach.size() : 0;
    }

    static class NhaMayViewHolder extends RecyclerView.ViewHolder {
        TextView tvTenNhaMay, tvMaNhaMay, tvDiaChi, tvSoDienThoai;

        public NhaMayViewHolder(@NonNull View itemView) {
            super(itemView);
            tvTenNhaMay = itemView.findViewById(R.id.tvTenNhaMay);
            tvMaNhaMay = itemView.findViewById(R.id.tvMaNhaMay);
            tvDiaChi = itemView.findViewById(R.id.tvDiaChi);
            tvSoDienThoai = itemView.findViewById(R.id.tvSoDienThoai);
        }
    }
}