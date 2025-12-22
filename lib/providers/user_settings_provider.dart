import 'package:flutter/material.dart';
import 'package:relationship_coach_flutter/enum/gender.dart';

class UserSettingsProvider extends ChangeNotifier {
  Gender _gender = Gender.female;

  // Getter to access the gender
  Gender get gender => _gender;

  // Method to update gender and notify the UI
  void setGender(Gender newGender) {
    if (_gender != newGender) {
      _gender = newGender;
      notifyListeners(); // This triggers the UI rebuild
    }
  }
}
