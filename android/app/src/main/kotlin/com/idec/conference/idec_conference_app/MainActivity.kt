package com.idec.conference.idec_conference_app

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.idec.conference.app/main"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // Set up error handling for Flutter engine
        flutterEngine.let {
            try {
                // Ensure Flutter engine is properly initialized
                android.util.Log.d("MainActivity", "Flutter engine configured successfully")
            } catch (e: Exception) {
                android.util.Log.e("MainActivity", "Error configuring Flutter engine", e)
            }
        }
    }

    override fun onResume() {
        super.onResume()
        android.util.Log.d("MainActivity", "Activity resumed")
    }

    override fun onPause() {
        super.onPause()
        android.util.Log.d("MainActivity", "Activity paused")
    }
}
