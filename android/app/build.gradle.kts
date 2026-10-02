import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("com.google.gms.google-services")   // ✅ Firebase
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

/* =====================================================
   ✅ Load keystore properties (for release signing)
   ===================================================== */

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")

if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.wecare.healthcare"

    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    /* =====================================================
       ✅ Java 11 + Desugaring (IMPORTANT for notifications)
       ===================================================== */
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    /* =====================================================
       ✅ Default Config
       ===================================================== */
    defaultConfig {
        applicationId = "com.wecare.newapp"

        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion

        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    /* =====================================================
       ✅ Signing Configs
       ===================================================== */
    signingConfigs {

        // debug (default)
        getByName("debug")

        // release
        if (keystorePropertiesFile.exists()) {
            create("release") {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
            }
        }
    }

    /* =====================================================
       ✅ Build Types
       ===================================================== */
    buildTypes {

        getByName("debug")

        getByName("release") {
            if (keystorePropertiesFile.exists()) {
                signingConfig = signingConfigs.getByName("release")
            } else {
                signingConfig = signingConfigs.getByName("debug")
            }

            isMinifyEnabled = false
            isShrinkResources = false
            isDebuggable = false
        }
    }

    /* =====================================================
       ✅ Fix common AndroidX conflicts
       ===================================================== */
    configurations.all {
        resolutionStrategy {
            force("androidx.core:core:1.13.1")
            force("androidx.core:core-ktx:1.13.1")
        }
    }
}

flutter {
    source = "../.."
}

/* =====================================================
   ✅ Dependencies
   ===================================================== */
dependencies {

    // Required for Java 8+ APIs (notifications etc)
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
}
