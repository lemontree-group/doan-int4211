package vn.edu.vhu.ltdd.lemontreeadmin.GiaoDienNguoiDung;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import vn.edu.vhu.ltdd.lemontreeadmin.R;
import vn.edu.vhu.ltdd.lemontreeadmin.MoHinhDuLieu.PhanHoiDangNhap;
import vn.edu.vhu.ltdd.lemontreeadmin.MoHinhDuLieu.YeuCauDangNhap;
import vn.edu.vhu.ltdd.lemontreeadmin.KetNoiMang.CauHinhApiClient;
import vn.edu.vhu.ltdd.lemontreeadmin.KetNoiMang.GiaoDienApi;

public class LoginActivity extends AppCompatActivity {

    private EditText edtUsername, edtPassword;
    private Button btnLogin;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);

        edtUsername = findViewById(R.id.edtUsername);
        edtPassword = findViewById(R.id.edtPassword);
        btnLogin = findViewById(R.id.btnLogin);
        btnLogin.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String user = edtUsername.getText().toString().trim();
                String pass = edtPassword.getText().toString().trim();

                if (user.isEmpty() || pass.isEmpty()) {
                    Toast.makeText(LoginActivity.this, "Vui lòng nhập đầy đủ thông tin!", Toast.LENGTH_SHORT).show();
                    return;
                }

                // Tạo đối tượng chứa thông tin đăng nhập
                YeuCauDangNhap yeuCau = new YeuCauDangNhap(user, pass);

                // Gọi API thông qua Retrofit Client đã cấu hình
                GiaoDienApi apiService = CauHinhApiClient.getClient().create(GiaoDienApi.class);
                apiService.dangNhap(yeuCau).enqueue(new retrofit2.Callback<PhanHoiDangNhap>() {
                    @Override
                    public void onResponse(retrofit2.Call<PhanHoiDangNhap> call, retrofit2.Response<PhanHoiDangNhap> response) {
                        if (response.isSuccessful() && response.body() != null) {
                            PhanHoiDangNhap ketQua = response.body();

                            // Lưu Token vào SharedPreferences (nếu cần quản lý phiên đăng nhập)
                            // QuanLyToken.luuToken(LoginActivity.this, ketQua.getToken());

                            Toast.makeText(LoginActivity.this, "Đăng nhập thành công!", Toast.LENGTH_SHORT).show();

                            // Chuyển sang MainActivity
                            Intent intent = new Intent(LoginActivity.this, MainActivity.class);
                            startActivity(intent);
                            finish();
                        } else {
                            Toast.makeText(LoginActivity.this, "Sai tài khoản hoặc mật khẩu!", Toast.LENGTH_SHORT).show();
                        }
                    }

                    @Override
                    public void onFailure(retrofit2.Call<PhanHoiDangNhap> call, Throwable t) {
                        Toast.makeText(LoginActivity.this, "Lỗi kết nối server: " + t.getMessage(), Toast.LENGTH_LONG).show();
                    }
                });
            }
        });
    }
}