# Keep line numbers for crash logs
-keepattributes SourceFile,LineNumberTable

# Keep generic type info (important for Gson)
-keepattributes Signature

# Gson
-keep class com.google.gson.** { *; }
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer
-dontwarn com.google.gson.**

# Firebase
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# Google Play Services
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**

# Flutter Local Notifications
-keep class com.dexterous.flutterlocalnotifications.** { *; }

# Video Player
-keep class io.flutter.plugins.videoplayer.** { *; }

# Image Picker
-keep class io.flutter.plugins.imagepicker.** { *; }

# File Picker
-keep class com.mr.flutter.plugin.filepicker.** { *; }

# Prevent removing model classes used in JSON parsing
-keep class your.package.name.models.** { *; }

# Suppress optional warnings
-dontwarn reactor.blockhound.integration.BlockHoundIntegration