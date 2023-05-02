package com.firgia.soca

import android.content.BroadcastReceiver
import android.content.Context
import android.os.Bundle
import android.content.Intent
import android.content.IntentFilter
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.StreamHandler

class MainActivity: FlutterActivity() {
    private val ASSISTANT_CHANNEL = "com.firgia.soca/assistant"
    private val TAG = "FlutterActivity"
    private lateinit var eventChannel: EventChannel

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        eventChannel = EventChannel(flutterEngine.dartExecutor.binaryMessenger, ASSISTANT_CHANNEL)
        setStreamAssistantHandler()
    }

    private fun setStreamAssistantHandler(){
         eventChannel.setStreamHandler(object: StreamHandler{
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                val callName = intent?.extras?.getString("callName")
                if(callName != null) {
                    val supportedVolunteerPhrases = arrayOf(
                        "تطوع",
                        "volunteer",
                        "voluntario",
                        "स्वयंसेवी",
                        "sukarelawan",
                        "волонтер",
                        "志愿者"
                    )
                    val callVolunteer = supportedVolunteerPhrases.contains(callName.trim().lowercase())

                    if(callVolunteer) {
                        Log.d(TAG, "Call volunteer")
                        events?.success("call_volunteer")
                    }
                }
            }

            override fun onCancel(arguments: Any?) { }
        })
    }
}