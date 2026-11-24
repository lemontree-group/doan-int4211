package vn.edu.vhu.ltdd.lemontreeadmin.GiaoDienNguoiDung;

import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.util.Log;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;
import vn.edu.vhu.ltdd.lemontreeadmin.KetNoiMang.CauHinhApiClient;
import vn.edu.vhu.ltdd.lemontreeadmin.KetNoiMang.GiaoDienApi;
import vn.edu.vhu.ltdd.lemontreeadmin.MainActivity;
import vn.edu.vhu.ltdd.lemontreeadmin.MoHinhDuLieu.PhanHoiDangNhap;
import vn.edu.vhu.ltdd.lemontreeadmin.MoHinhDuLieu.YeuCauDangNhap;
import vn.edu.vhu.ltdd.lemontreeadmin.R;

public class LoginActivity extends AppCompatActivity {

    private static final String TAG = "LOGIN_DEBUG";
    private static final String PREF_NAME = "LoginPrefs";

    private EditText edtUsername, edtPassword;
    private CheckBox chkRemember;
    private Button btnLogin;

    private SharedPreferences sharedPreferences;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);

        edtUsername = findViewById(R.id.edtUsername);
        edtPassword = findViewById(R.id.edtPassword);
        chkRemember = findViewById(R.id.chkRemember);
        btnLogin = findViewById(R.id.btnLogin);

        sharedPreferences = getSharedPreferences(PREF_NAME, MODE_PRIVATE);
        loadSavedCredentials();

        btnLogin.setOnClickListener(v -> {
            final String username = edtUsername.getText().toString().trim();
            final String password = edtPassword.getText().toString().trim();

            if (username.isEmpty() || password.isEmpty()) {
                Toast.makeText(LoginActivity.this, "Vui lòng nhập đầy đủ tài khoản và mật khẩu", Toast.LENGTH_SHORT).show();
                return;
            }

            btnLogin.setEnabled(false);
            YeuCauDangNhap yeuCau = new YeuCauDangNhap(username, password);

            CauHinhApiClient.getClient()
                    .create(GiaoDienApi.class)
                    .dangNhapStaff(yeuCau)
                    .enqueue(new Callback<PhanHoiDangNhap>() {
                        @Override
                        public void onResponse(Call<PhanHoiDangNhap> call, Response<PhanHoiDangNhap> response) {
                            btnLogin.setEnabled(true);

                            PhanHoiDangNhap body = response.body();
                            if (response.isSuccessful() && body != null && body.isSuccess()) {
                                saveCredentials(username, password, chkRemember.isChecked());

                                String msg = (body.getMessage() != null && !body.getMessage().isEmpty())
                                        ? body.getMessage()
                                        : "Đăng nhập thành công!";
                                Toast.makeText(LoginActivity.this, msg, Toast.LENGTH_SHORT).show();

                                Intent intent = new Intent(LoginActivity.this, MainActivity.class);
                                startActivity(intent);
                                finish();
                            } else {
                                String rawError = "";
                                try {
                                    if (response.errorBody() != null) {
                                        rawError = response.errorBody().string();
                                    }
                                } catch (Exception e) {
                                    rawError = e.getMessage() != null ? e.getMessage() : "Không đọc được errorBody";
                                }

                                Log.e(TAG, "HTTP " + response.code() + " | errorBody: " + rawError);

                                String errMsg;
                                if (body != null && body.getMessage() != null && !body.getMessage().isEmpty()) {
                                    errMsg = body.getMessage();
                                } else if (!rawError.isEmpty()) {
                                    errMsg = "Lỗi " + response.code() + ": " + rawError;
                                } else {
                                    errMsg = "Sai tài khoản hoặc mật khẩu! (Mã: " + response.code() + ")";
                                }

                                Toast.makeText(LoginActivity.this, errMsg, Toast.LENGTH_SHORT).show();
                            }
                        }

                        @Override
                        public void onFailure(Call<PhanHoiDangNhap> call, Throwable t) {
                            btnLogin.setEnabled(true);
                            String failMsg = t.getMessage() != null ? t.getMessage() : "Lỗi không xác định";
                            Log.e(TAG, "onFailure: " + failMsg, t);
                            Toast.makeText(LoginActivity.this, "Lỗi kết nối máy chủ: " + failMsg, Toast.LENGTH_SHORT).show();
                        }
                    });
        });
    }

    private void saveCredentials(String username, String password, boolean isRemember) {
        SharedPreferences.Editor editor = sharedPreferences.edit();
        if (isRemember) {
            editor.putString("username", username);
            editor.putString("password", password);
            editor.putBoolean("remember", true);
        } else {
            editor.clear();
        }
        editor.apply();
    }

    private void loadSavedCredentials() {
        boolean isRemember = sharedPreferences.getBoolean("remember", false);
        if (isRemember) {
            String savedUser = sharedPreferences.getString("username", "");
            String savedPass = sharedPreferences.getString("password", "");

            edtUsername.setText(savedUser);
            edtPassword.setText(savedPass);
            chkRemember.setChecked(true);
        }
    }
}