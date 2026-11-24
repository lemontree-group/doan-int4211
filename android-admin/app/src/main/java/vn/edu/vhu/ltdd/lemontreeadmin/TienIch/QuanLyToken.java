package vn.edu.vhu.ltdd.lemontreeadmin.TienIch;

import android.content.Context;
import android.content.SharedPreferences;

public class QuanLyToken {
    private static final String TEN_PREF = "LemonTree_Pref";
    private static final String KHOA_TOKEN = "jwt_token";

    public static void luuToken(Context context, String token) {
        SharedPreferences pref = context.getSharedPreferences(TEN_PREF, Context.MODE_PRIVATE);
        pref.edit().putString(KHOA_TOKEN, token).apply();
    }

    public static String layToken(Context context) {
        SharedPreferences pref = context.getSharedPreferences(TEN_PREF, Context.MODE_PRIVATE);
        return pref.getString(KHOA_TOKEN, "");
    }
}