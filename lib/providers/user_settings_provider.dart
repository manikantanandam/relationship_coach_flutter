import 'package:flutter/material.dart';
import 'package:relationship_coach_flutter/enum/gender.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSettingsProvider extends ChangeNotifier {
  Gender _gender = Gender.female;
  SharedPreferences? _prefs; // Make this nullable

  // final SharedPreferences prefs = await SharedPreferences.getInstance();

  UserSettingsProvider() {
    _initPrefs();
  }

  // Proper way to initialize async dependencies
  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();

    // Load the saved gender if it exists
    String? savedGender = _prefs?.getString('gender');
    if (savedGender != null) {
      // Convert string back to Enum
      _gender = Gender.values.firstWhere(
        (e) => e.toString() == savedGender,
        orElse: () => Gender.female,
      );
      notifyListeners();
    }
  }

  Future<void> setGender(Gender newGender) async {
    if (_gender != newGender) {
      _gender = newGender;
      notifyListeners();

      // Ensure prefs is initialized before saving
      await _prefs?.setString('gender', newGender.toString());
    }
  }

  // Getter to access the gender
  Gender get gender => _gender;
}
