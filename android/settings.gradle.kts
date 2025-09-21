pluginManagement {
    val flutterSdk = java.util.Properties().run {
        val lp = java.io.File(rootDir, "local.properties")
        if (lp.exists()) java.io.FileInputStream(lp).use { load(it) }
        getProperty("flutter.sdk") ?: throw GradleException("flutter.sdk not set in local.properties")
    }
    includeBuild("$flutterSdk/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
    // ← fige les versions compatibles
    plugins {
        id("com.android.application") version "8.4.2" apply false
        id("org.jetbrains.kotlin.android") version "1.9.24" apply false
    }
}

plugins { id("dev.flutter.flutter-plugin-loader") }

include(":app")
