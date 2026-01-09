import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:relationship_coach_flutter/components/gender_toggle.dart';
import 'package:relationship_coach_flutter/components/rc_card.dart';
import 'package:relationship_coach_flutter/enum/gender.dart';
import 'package:relationship_coach_flutter/providers/user_settings_provider.dart';
import 'package:relationship_coach_flutter/screens/about_coach_screen.dart';
import 'package:relationship_coach_flutter/screens/privacy_policy_screen.dart';
import 'package:relationship_coach_flutter/screens/terms_and_conditions..dart';

enum SettingsSection { user, coach, legal }

enum SettingsSecionItem { gender, coach, privacyPolicy, termsAndConditions }

class SettingsScreen extends StatelessWidget {
  final List<SettingsSection> sections = [.user, .coach, .legal];

  SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings Option')),
      body: ListView.builder(
        itemCount: sections.length,
        itemBuilder: (context, index) {
          return RCSettingSection(section: sections[index]);
        },
      ),
    );
  }
}

class RCSettingSection extends StatelessWidget {
  const RCSettingSection({super.key, required this.section});
  final SettingsSection section;

  Widget rightWidget(SettingsSecionItem item, BuildContext context) {
    final userSettingsProvider = Provider.of<UserSettingsProvider>(context);

    switch (item) {
      case SettingsSecionItem.gender:
        return GenderToggle(
          selectedGender: userSettingsProvider.gender,
          onChanged: (newValue) {
            userSettingsProvider.setGender(newValue);
          },
        );
      case SettingsSecionItem.coach:
      case SettingsSecionItem.privacyPolicy:
      case SettingsSecionItem.termsAndConditions:
        return userSettingsProvider.gender.arrowIcon;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 40,
          color: Colors.red,
          child: Text(section.name),
        ),
        for (var item in section.items)
          GestureDetector(
            onTap: () {
              if (item.screen != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return item.screen!;
                    },
                  ),
                );
              }
            },
            child: RCCard(
              cardWidget: Row(
                children: [
                  Expanded(child: Text(item.name)),
                  rightWidget(item, context),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

extension SettingsSectionItemsBuild on SettingsSection {
  List<SettingsSecionItem> get items {
    switch (this) {
      case SettingsSection.user:
        return [.gender];
      case SettingsSection.coach:
        return [.coach];
      case SettingsSection.legal:
        return [.privacyPolicy, .termsAndConditions];
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
    }
  }
}
