# Mantener nombres de clases y métodos para Firebase
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# Mantener las anotaciones de Firebase
-keepattributes *Annotation*

# Mantener la serialización/deserialización de Gson
-keep class com.google.gson.** { *; }
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# Si estás utilizando Retrofit para llamadas de red
-keepattributes Signature
-keepattributes *Annotation*
-keep class com.squareup.okhttp.** { *; }
-keep class retrofit.** { *; }

# Mantener nombres para clases y métodos relacionados con Flutter
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.embedding.** { *; }
