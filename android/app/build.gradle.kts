plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

val keystore = java.util.Properties().apply {
    val f = rootProject.file("key.properties")
    if (f.exists()) java.io.FileInputStream(f).use { load(it) }
}

android {
    namespace = "com.ilmnafi3.app"          // ← TON packageId EXACT publié
    compileSdk = flutter.compileSdkVersion

    defaultConfig {
        applicationId = "com.ilmnafi3.app"  // ← identique
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    kotlinOptions { jvmTarget = "17" }

    signingConfigs {
        create("release") {
            keyAlias = (keystore["keyAlias"] ?: "") as String
            keyPassword = (keystore["keyPassword"] ?: "") as String
            storeFile = file((keystore["storeFile"] ?: "") as String)
            storePassword = (keystore["storePassword"] ?: "") as String
        }
    }
    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

flutter { source = "../.." }
