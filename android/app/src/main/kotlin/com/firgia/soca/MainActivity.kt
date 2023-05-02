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

        // Handle the intent this activity was launched with.
        intent?.handleIntent()
    }
    
    /**
     * For debugging Android intents
     */
    private fun logIntent(intent: Intent) {
        val bundle: Bundle = intent.extras ?: return

        Log.d(TAG, "======= logIntent =========")
        Log.d(TAG, "Logging intent data start")

        bundle.keySet().forEach { key ->
            Log.d(TAG, "[$key=${bundle.get(key)}]")
        }

        Log.d(TAG, "Logging intent data complete")
    }

    /**
     * Handles the action from the intent base on the type.
     *
     * @receiver the intent to handle
     */
    private fun Intent.handleIntent() {
        val callName = intent?.extras?.getString("callName")
        if(callName != null) {
            val supportedVolunteerPhrases = arrayOf("volunteer", "sukarelawan")
            val callVolunteer = supportedVolunteerPhrases.contains(callName.trim().lowercase())

            if(callVolunteer) {
                // TODO: Calling a volunteer
                Log.d(TAG, "Call a volunteer")
            }
        }
    }
}
