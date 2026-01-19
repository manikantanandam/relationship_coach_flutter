import 'package:relationship_coach_flutter/enum/feature_flag_key.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class LocalFeatureFlagManager extends ChangeNotifier {
  LocalFeatureFlagManager._internal();
  static final LocalFeatureFlagManager _instance =
      LocalFeatureFlagManager._internal();
  factory LocalFeatureFlagManager() => _instance;

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Generic getter to handle Enums, Booleans, and Strings
  T getValue<T>(FeatureKey feature) {
    final storedValue = _prefs.get(feature.key);

    if (storedValue == null) return feature.defaultValue as T;

    // Handle Enum restoration from String
    if (feature.defaultValue is Enum) {
      return _getEnumFromString<T>(storedValue.toString(), feature);
    }

    return (storedValue as T);
  }

  /// Helper to convert String back to Enum
  T _getEnumFromString<T>(String name, FeatureKey feature) {
    // Access the options we stored in the enum
    final List<Enum> values = feature.options ?? [];

    return values.firstWhere(
          (e) => e.name == name,
          orElse: () => feature.defaultValue as Enum,
        )
        as T;
  }

  /// Type-safe setter
  Future<void> setValue(FeatureKey feature, Object value) async {
    if (value is bool) {
      await _prefs.setBool(feature.key, value);
    } else if (value is Enum) {
      await _prefs.setString(feature.key, value.name);
    } else {
      await _prefs.setString(feature.key, value.toString());
    }
    notifyListeners();
  }
}
