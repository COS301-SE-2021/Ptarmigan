package com.example.ptarmigan

/*import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
}*/

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
     override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
      GeneratedPluginRegistrant.registerWith(flutterEngine);
  }
}
