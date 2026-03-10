import 'package:flutter/foundation.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class AppLogger {
  // Use this for tracking steps (e.g., "User tapped monthly subscription")
  static void logInfo(String message) {
    FirebaseCrashlytics.instance.log(message);

    if (kDebugMode) {
      print('🔵 INFO: $message');
    } else {
      // This leaves a breadcrumb, but DOES NOT send to Firebase immediately
      FirebaseCrashlytics.instance.log(message);
    }
  }

  // Use this when something actually fails (e.g., "Product not found")
  // This forces Firebase to upload the report + all previous logInfo breadcrumbs
  static void logError(
    String message, [
    dynamic error,
    StackTrace? stackTrace,
  ]) {
    if (kDebugMode) {
      print('🔴 ERROR: $message \n ${error ?? ""}');
    } else {
      FirebaseCrashlytics.instance.recordError(
        error ?? Exception(message),
        stackTrace,
        reason: message,
        fatal:
            false, // Mark false so it shows up as a "Non-Fatal" in your dashboard
      );
    }
  }
}
