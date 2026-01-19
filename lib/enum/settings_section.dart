import 'package:flutter/material.dart';
import 'package:relationship_coach_flutter/screens/about_coach_screen.dart';
import 'package:relationship_coach_flutter/screens/master_data.dart';
import 'package:relationship_coach_flutter/screens/privacy_policy_screen.dart';
import 'package:relationship_coach_flutter/screens/terms_and_conditions..dart';

enum SettingsSection { user, coach, legal }

enum SettingsSecionItem {
  gender,
  coach,
  privacyPolicy,
  termsAndConditions,
  admin,
}

extension SettingsSectionExtension on SettingsSection {
  String get title {
    switch (this) {
      case SettingsSection.user:
        return 'User Settings';
      case SettingsSection.coach:
        return 'Relationship Coach Camille';
      case SettingsSection.legal:
        return 'Legal Information';
    }
  }
}

extension SettingsSectionItemExtension on SettingsSecionItem {
  String get title {
    switch (this) {
      case SettingsSecionItem.gender:
        return 'Change Gender';
      case SettingsSecionItem.coach:
        return 'About Coach Camille';
      case SettingsSecionItem.privacyPolicy:
        return 'Privacy Policy';
      case SettingsSecionItem.termsAndConditions:
        return 'Terms and Conditions';
      case .admin:
        return 'Admin';
    }
  }

  Widget? get screen {
    switch (this) {
      case SettingsSecionItem.gender:
        return null;
      case SettingsSecionItem.coach:
        return AboutCoachScreen();
      case SettingsSecionItem.privacyPolicy:
        return PrivacyPolicyScreen();
      case SettingsSecionItem.termsAndConditions:
        return TermsAndConditionsScreen();
      case .admin:
        return MasterDataScreen();
    }
  }
}
