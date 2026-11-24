package vn.edu.vhu.ltdd.lemontreeadmin.KetNoiMang;

import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;

public class CauHinhApiClient {
    private static final String BASE_URL = "https://lemontree-backend.onrender.com/";
    private static Retrofit retrofit = null;

    public static Retrofit getClient() {
        if (retrofit == null) {
            retrofit = new Retrofit.Builder()
                    .baseUrl(BASE_URL)
                    .addConverterFactory(GsonConverterFactory.create())
                    .build();
        }
        return retrofit;
    }
}