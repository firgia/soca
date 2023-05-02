package com.firgia.soca

import android.os.Bundle
import android.content.Intent
import android.util.Log
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    private val TAG = "FlutterActivity"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Logging for troubleshooting purposes
        logIntent(intent)
    }

    /**
     * For debugging Android intents
     */
    fun logIntent(intent: Intent) {
        val bundle: Bundle = intent.extras ?: return

        Log.d(TAG, "======= logIntent =========")
        Log.d(TAG, "Logging intent data start")

        bundle.keySet().forEach { key ->
            Log.d(TAG, "[$key=${bundle.get(key)}]")
        }

        Log.d(TAG, "Logging intent data complete")
    }
}
