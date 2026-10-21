package dev.ziggy.examplevite;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.webkit.WebView;
import dev.ziggy.nativeapp.ZiggyShell;

// The Ziggy Vite example's one screen: a web view run by Ziggy's shell. What is the example's own is the name of its backend library
// and the mobile limits on the backend's threads.
public final class MainActivity extends Activity {
    private ZiggyShell shell;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        WebView webView = new WebView(this);
        setContentView(webView);
        shell = new ZiggyShell(this, webView, "ziggy_example_vite", 5, 2);
        shell.start();
    }

    @Override
    protected void onResume() {
        super.onResume();
        shell.onResume();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (!shell.onActivityResult(requestCode, resultCode, data)) {
            super.onActivityResult(requestCode, resultCode, data);
        }
    }

    @Override
    protected void onDestroy() {
        shell.destroy();
        super.onDestroy();
    }
}
