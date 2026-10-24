package com.zhufeng.agent.mobile

import android.content.Context
import android.content.SharedPreferences
import androidx.security.crypto.EncryptedSharedPreferences
import androidx.security.crypto.MasterKey

/**
 * 轻量配置存储（安全强化版）：
 * - serverUrl 非敏感 → 明文 "zf_mobile"
 * - authToken / zf_sessions（登录凭证+会话）→ EncryptedSharedPreferences("zf_secure")，密钥存 Android Keystore
 * - 首次运行自动迁移旧明文库中的敏感项，迁移后立即从明文库删除
 */
class Prefs(context: Context) {
    private val plain = context.getSharedPreferences("zf_mobile", Context.MODE_PRIVATE)
    private val sec: SharedPreferences = createSecure(context)

    private companion object {
        const val SEC_FILE = "zf_secure"
    }

    private fun createSecure(context: Context): SharedPreferences {
        fun build(): SharedPreferences {
            val mk = MasterKey.Builder(context)
                .setKeyScheme(MasterKey.KeyScheme.AES256_GCM)
                .build()
            return EncryptedSharedPreferences.create(
                context, SEC_FILE, mk,
                EncryptedSharedPreferences.PrefKeyEncryptionScheme.AES256_SIV,
                EncryptedSharedPreferences.PrefValueEncryptionScheme.AES256_GCM
            )
        }
        return try {
            build()
        } catch (e: Exception) {
            // Keystore 异常兜底（罕见：系统还原/密钥损坏）：删掉损坏的加密库重建，宁可重新登录也不崩
            try { context.deleteSharedPreferences(SEC_FILE) } catch (_: Exception) {}
            build()
        }
    }

    init {
        migrate()
    }

    /** 旧明文库 auth_token / zf_sessions → 加密库，成功后从明文库抹除 */
    private fun migrate() {
        try {
            val oldToken = plain.getString("auth_token", null)
            if (!oldToken.isNullOrEmpty() && sec.getString("auth_token", "").isNullOrEmpty()) {
                sec.edit().putString("auth_token", oldToken).apply()
            }
            val oldSess = plain.getString("zf_sessions", null)
            if (!oldSess.isNullOrEmpty() && sec.getString("zf_sessions", "").isNullOrEmpty()) {
                sec.edit().putString("zf_sessions", oldSess).apply()
            }
            if (oldToken != null || oldSess != null) {
                plain.edit().remove("auth_token").remove("zf_sessions").apply()
            }
        } catch (_: Exception) { }
    }

    var serverUrl: String
        get() = plain.getString("server_url", "") ?: ""
        set(value) = plain.edit().putString("server_url", value).apply()

    var authToken: String
        get() = sec.getString("auth_token", "") ?: ""
        set(value) = sec.edit().putString("auth_token", value).apply()

    /** 助手页 zf_sessions 备份（登录会话 JSON），走加密库 */
    var sessions: String
        get() = sec.getString("zf_sessions", "") ?: ""
        set(value) = sec.edit().putString("zf_sessions", value).apply()
}
