# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Suppress warnings for desugaring rules that don't match
# These are common when using coreLibraryDesugaring
-dontwarn j$.util.concurrent.ConcurrentHashMap$TreeBin
-dontwarn j$.util.concurrent.ConcurrentHashMap
-dontwarn j$.util.concurrent.ConcurrentHashMap$CounterCell
-dontwarn j$.util.IntSummaryStatistics
-dontwarn j$.util.LongSummaryStatistics
-dontwarn j$.util.DoubleSummaryStatistics

# If you really want to keep these classes (when they exist)
-keepclassmembers,allowoptimization class j$.util.concurrent.ConcurrentHashMap$TreeBin {
  int lockState;
}
-keepclassmembers,allowoptimization class j$.util.concurrent.ConcurrentHashMap {
  int sizeCtl;
  int transferIndex;
  long baseCount;
  int cellsBusy;
}
-keepclassmembers,allowoptimization class j$.util.concurrent.ConcurrentHashMap$CounterCell {
  long value;
}
-keepclassmembers,allowoptimization enum * {
  public static **[] values();
  public static ** valueOf(java.lang.String);
  public static final synthetic <fields>;
}
-keepclassmembers,allowoptimization class j$.util.IntSummaryStatistics {
  long count;
  long sum;
  int min;
  int max;
}
-keepclassmembers,allowoptimization class j$.util.LongSummaryStatistics {
  long count;
  long sum;
  long min;
  long max;
}
-keepclassmembers,allowoptimization class j$.util.DoubleSummaryStatistics {
  long count;
  double sum;
  double min;
  double max;
}

# Google Play Core - Ignore missing classes for deferred components
# These classes are only needed if you're using deferred components/dynamic feature delivery
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.splitinstall.SplitInstallException
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManager
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManagerFactory
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest$Builder
-dontwarn com.google.android.play.core.splitinstall.SplitInstallSessionState
-dontwarn com.google.android.play.core.splitinstall.SplitInstallStateUpdatedListener
-dontwarn com.google.android.play.core.tasks.OnFailureListener
-dontwarn com.google.android.play.core.tasks.OnSuccessListener
-dontwarn com.google.android.play.core.tasks.Task

# Keep Flutter embedding classes
-keep class io.flutter.embedding.** { *; }

# Alternative: If you want to completely ignore these missing classes
-ignorewarnings
