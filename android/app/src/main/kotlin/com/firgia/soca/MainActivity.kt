package com.firgia.soca

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
        override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
    }

}
