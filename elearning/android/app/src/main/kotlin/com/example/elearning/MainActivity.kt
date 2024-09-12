
package com.example.elearning
import android.provider.Settings 
import android.os.Bundle
import android.content.Intent 
import io.flutter.plugin.common.MethodChannel 
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.android.FlutterActivityLaunchConfigs.BackgroundMode;

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.elearning/settings"
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        window.setFlags(WindowManager.LayoutParams.FLAG_SECURE,
                        WindowManager.LayoutParams.FLAG_SECURE)

          MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL)
    .setMethodCallHandler { call, result -> 
            if (call.method == "openNotificationSettings") {
                val packageName = call.arguments<String>()
                val intent = Intent(Settings.ACTION_APP_NOTIFICATION_SETTINGS)
                    .putExtra(Settings.EXTRA_APP_PACKAGE, packageName)
                startActivity(intent)
                result.success(true)
            } else {
                result.notImplemented()
            }
        }
 }
   
}





