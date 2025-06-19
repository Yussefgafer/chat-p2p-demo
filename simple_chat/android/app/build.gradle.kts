plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.chatp2p.demo"
    compileSdk = 34

    // Disable NDK completely
    ndkVersion = null

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.chatp2p.demo"
        minSdk = 21
        targetSdk = 34
        versionCode = 1
        versionName = "1.0.0"
        multiDexEnabled = false

        // Optimize for GitHub Actions
        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"

        // Disable NDK completely to avoid build issues
        ndk {
            abiFilters.clear()
        }

        // Disable native builds
        externalNativeBuild {
            cmake {
                arguments.clear()
            }
        }
    }

    buildTypes {
        debug {
            isDebuggable = true
            isMinifyEnabled = false
            applicationIdSuffix = ".debug"
        }
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = false
            isShrinkResources = false
            isDebuggable = false
        }
    }

    packagingOptions {
        resources {
            excludes += "/META-INF/{AL2.0,LGPL2.1}"
        }
    }

    // Disable NDK builds completely
    androidComponents {
        beforeVariants { variantBuilder ->
            variantBuilder.enableAndroidTest = false
        }
    }
}

flutter {
    source = "../.."
}
