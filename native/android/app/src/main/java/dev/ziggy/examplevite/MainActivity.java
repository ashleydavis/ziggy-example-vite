package dev.ziggy.examplevite;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.webkit.WebView;
import dev.ziggy.nativeapp.ZiggyNativeApp;

// The Ziggy Vite example's one screen: a web view run by Ziggy's native app. What is the example's own is the name of its backend library
// and the mobile limits on the backend's threads.
public final class MainActivity extends Activity {
    private ZiggyNativeApp nativeApp;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        WebView webView = new WebView(this);
        setContentView(webView);
        nativeApp = new ZiggyNativeApp(this, webView, "ziggy_example_vite", 5, 2);
        nativeApp.start();
    }

    @Override
    protected void onResume() {
        super.onResume();
        nativeApp.onResume();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (!nativeApp.onActivityResult(requestCode, resultCode, data)) {
            super.onActivityResult(requestCode, resultCode, data);
        }
    }

    @Override
    protected void onDestroy() {
        nativeApp.destroy();
        super.onDestroy();
    }
}
