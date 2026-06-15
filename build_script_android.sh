#!/bin/bash
APP_NAME=$1
BUNDLE_ID=$2

echo "Iniciando script de preparación del proyecto Android..."
mkdir -p workspace
unzip -q app_source.zip -d workspace/www

# Crear directorios del proyecto Android
mkdir -p android_project/app/src/main/java/com/appcompiler/web
mkdir -p android_project/app/src/main/assets/www
mkdir -p app_output

# Copiar archivos descomprimidos al directorio assets
if [ -d "workspace/www" ]; then
  cp -r workspace/www/* android_project/app/src/main/assets/www/
fi

# Crear settings.gradle
cat << EOF > android_project/settings.gradle
include ':app'
rootProject.name = "${APP_NAME}"
EOF

# Crear build.gradle del proyecto principal
cat << EOF > android_project/build.gradle
buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath 'com.android.tools.build:gradle:8.2.2'
    }
}
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}
EOF

# Crear build.gradle de la app
cat << EOF > android_project/app/build.gradle
plugins {
    id 'com.android.application'
}

android {
    namespace 'com.appcompiler.web'
    compileSdk 34

    defaultConfig {
        applicationId "${BUNDLE_ID}"
        minSdk 21
        targetSdk 34
        versionCode 1
        versionName "1.0"
    }

    buildTypes {
        release {
            minifyEnabled false
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
}
EOF

# Crear AndroidManifest.xml
cat << EOF > android_project/app/src/main/AndroidManifest.xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.INTERNET" />
    <application
        android:allowBackup="true"
        android:label="${APP_NAME}"
        android:theme="@android:style/Theme.NoTitleBar.Fullscreen">
        <activity
            android:name=".MainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
    </application>
</manifest>
EOF

# Crear MainActivity.java
cat << 'EOF' > android_project/app/src/main/java/com/appcompiler/web/MainActivity.java
package com.appcompiler.web;

import android.app.Activity;
import android.os.Bundle;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;

public class MainActivity extends Activity {
    private WebView webView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        webView = new WebView(this);
        WebSettings settings = webView.getSettings();
        settings.setJavaScriptEnabled(true);
        settings.setDomStorageEnabled(true);
        settings.setAllowFileAccess(true);
        settings.setDatabaseEnabled(true);
        settings.setLoadWithOverviewMode(true);
        settings.setUseWideViewPort(true);
        
        webView.setWebViewClient(new WebViewClient() {
            @Override
            public boolean shouldOverrideUrlLoading(WebView view, String url) {
                return false;
            }
        });

        webView.loadUrl("file:///android_asset/www/index.html");
        setContentView(webView);
    }

    @Override
    public void onBackPressed() {
        if (webView.canGoBack()) {
            webView.goBack();
        } else {
            super.onBackPressed();
        }
    }
}
EOF

# Compilar usando gradle
echo "Ejecutando gradle para construir APK..."
cd android_project
gradle assembleDebug --no-daemon

# Mover el APK final al directorio output
echo "Moviendo archivo compilado..."
cd ..
cp android_project/app/build/outputs/apk/debug/app-debug.apk app_output/${APP_NAME}.apk
echo "¡APK compilada exitosamente!"
