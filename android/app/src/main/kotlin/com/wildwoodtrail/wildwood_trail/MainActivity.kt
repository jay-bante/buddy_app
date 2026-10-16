package com.wildwoodtrail.wildwood_trail

import android.media.AudioAttributes
import android.media.SoundPool
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

/** Small offline bridge: asynchronous local saves and preloaded native audio. */
class MainActivity : FlutterActivity() {
    private var pool: SoundPool? = null
    private val sounds = mutableMapOf<String, Int>()
    private val loaded = mutableSetOf<Int>()

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val preferences = getSharedPreferences("wildwood_expedition", MODE_PRIVATE)
        pool = SoundPool.Builder().setMaxStreams(6).setAudioAttributes(
            AudioAttributes.Builder().setUsage(AudioAttributes.USAGE_GAME)
                .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION).build()
        ).build()
        pool?.setOnLoadCompleteListener { _, id, status -> if (status == 0) loaded.add(id) }
        for (name in listOf("encounter", "correct", "incorrect", "step")) {
            try {
                assets.openFd("flutter_assets/assets/audio/$name.wav").use {
                    sounds[name] = pool!!.load(it, 1)
                }
            } catch (_: Exception) { /* Audio failure must never interrupt play. */ }
        }
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "wildwood/native")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "load" -> result.success(preferences.getString("save_v1", null))
                    "save" -> {
                        val data = call.arguments as? String
                        if (data == null) result.error("BAD_SAVE", "Missing expedition data", null)
                        else {
                            preferences.edit().putString("save_v1", data).apply()
                            result.success(null)
                        }
                    }
                    "sound" -> {
                        sounds[call.arguments as? String]?.let { id ->
                            if (loaded.contains(id)) pool?.play(id, .6f, .6f, 1, 0, 1f)
                        }
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
    }
    override fun onPause() { pool?.autoPause(); super.onPause() }
    override fun onDestroy() { pool?.release(); pool = null; super.onDestroy() }
}
