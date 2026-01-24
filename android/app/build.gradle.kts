plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

android {
    namespace = "com.sml.nammadaiva_dashboard"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    defaultConfig {
        applicationId = "com.sml.nammadaiva_dashboard"
        minSdk = 24
        targetSdk = 35
        versionCode = 1
        versionName = "1.0.0"

        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
    }

    signingConfigs {
        create("release") {
            storeFile = file("/Users/smlmacmini1/Documents/git/nammaDaivaDashboard/nd-admin-app/android/upload_keystore.jks")
            storePassword = "nammadaiva123"
            keyAlias = "nammadaiva"
            keyPassword = "nammadaiva123"
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release") // ✅ FIXED
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true // ✅ REQUIRED
    }

    kotlinOptions {
        jvmTarget = "11"
    }
}

dependencies {
coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}

flutter {
    source = "../.."
}
