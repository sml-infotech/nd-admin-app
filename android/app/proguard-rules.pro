
# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# Uncomment this to preserve the line number information for
# debugging stack traces.
# KEEP THIS UNCOMMENTED WHILE DEBUGGING!
-keepattributes SourceFile,LineNumberTable

# If you keep the line number information, uncomment this to
# hide the original source file name.
#-renamesourcefileattribute SourceFile

# Please add these rules to your existing keep rules in order to suppress warnings.
# This is generated automatically by the Android Gradle plugin.
-dontwarn proguard.annotation.Keep
-dontwarn proguard.annotation.KeepClassMembers

# --- General Application Rules ---
# Keep all classes in your main application package (broad rule)
-keep class com.sml.risen.models.** { *; }
-keep class com.example.risen.models.** { *; }

# If you have specific model packages, be more granular:
#-keep class com.sml.risen.model.** { *; }
#-keep class com.sml.risen.data.model.** { *; }
# And if your "Church" model is in such a package, make sure it's covered.

# --- Keep Room Type Converters and their anonymous inner classes (CRITICAL for your issue) ---
#-keep class com.sml.risen.database.Converters { *; }
-keep class com.sml.risen.database.Converters$* { *; }
-keep class com.example.risen.database.Converters$* { *; }

# --- Keep Gson generic type info (IMPORTANT!) ---
-keepattributes Signature
-keepattributes *Annotation* # Keep annotations if used fo\r reflection (e.g., @SerializedName)

# --- Keep Gson internal reflection ---
-keep class com.google.gson.** { *; }
-keep class com.google.gson.reflect.TypeToken
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer
-keep class * implements java.lang.reflect.Type
-keep class * implements java.lang.reflect.ParameterizedType
-keep class * implements java.lang.reflect.GenericArrayType
-keep class * implements java.lang.reflect.WildcardType
-keep class * implements java.lang.reflect.TypeVariable
-dontwarn com.google.gson.**

# --- Keep Retrofit & OkHttp ---
-keep class retrofit2.** { *; }
-keep interface retrofit2.** { *; }
-keep class retrofit2.converter.gson.** { *; }
-keep,allowobfuscation,allowshrinking interface retrofit2.Call
-keep,allowobfuscation,allowshrinking class retrofit2.Response
-keep,allowobfuscation,allowshrinking class kotlin.coroutines.Continuation
-dontwarn retrofit2.**
-dontwarn okhttp3.**
-dontwarn okio.** # Add okio if not already present

# --- Keep Room if you're using Room ---
# (You already have a rule for Converters, ensure your Room entities/DAOs are also kept if needed)
# Example for Room Entities/DAOs if they are also reflected upon directly (less common with just TypeConverters)
#-keep public class * extends androidx.room.RoomDatabase {
#    <init>();
#    @androidx.room.Database <methods>;
#}
#-keep class * extends androidx.room.RxRoom { *; }
#-keep class * extends androidx.room.RoomConverters { *; } # If you have a base class for converters
#-keep class * implements androidx.room.TypeConverter { *; } # If you had separate type converters

# Optional, if you're using kotlinx.coroutines
-keep class kotlinx.coroutines.** { *; }

# Optional, Razorpay
-keep class com.razorpay.** { *; }
-dontwarn com.razorpay.**

-keep class com.google.** { *; }
-keep interface com.google.** { *; }
-keep class com.google.android.** { *; }
-keep class com.google.android.gms.** { *; }
-keep class com.google.android.gms.auth.** { *; }
-keep class com.google.android.gms.common.** { *; }
-keep class com.google.android.gms.tasks.** { *; }

-keep class com.google.android.gms.auth.api.signin.** { *; }
-keep class com.google.android.gms.auth.api.** { *; }
-keep class com.google.android.gms.common.api.** { *; }
-keep interface com.google.android.gms.common.api.GoogleApiClient$ConnectionCallbacks { *; }
-keep interface com.google.android.gms.common.api.GoogleApiClient$OnConnectionFailedListener { *; }
-dontwarn com.google.**
# --- Suppress optional BlockHound integration (R8 warning) ---
-dontwarn reactor.blockhound.integration.BlockHoundIntegration

