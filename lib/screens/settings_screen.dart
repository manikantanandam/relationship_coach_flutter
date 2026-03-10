import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:relationship_coach_flutter/components/gender_toggle.dart';
import 'package:relationship_coach_flutter/components/rc_card.dart';
import 'package:relationship_coach_flutter/constants.dart/constants.dart';
import 'package:relationship_coach_flutter/enum/gender.dart';
import 'package:relationship_coach_flutter/enum/settings_section.dart';
import 'package:relationship_coach_flutter/providers/user_settings_provider.dart';
import 'package:flutter/foundation.dart';

class SettingsScreen extends StatelessWidget {
  final List<SettingsSection> sections = [
    .user,
    .coach,
    .legal,
    if (kDebugMode) .debug,
  ];

  SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Gender gender = Provider.of<UserSettingsProvider>(context).gender;

    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Settings'),
      //   backgroundColor: gender.color,
      //   foregroundColor: Colors.white,
      // ),
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
      case .featureFlags:
      case .admin:
        return userSettingsProvider.gender.arrowIcon;
    }
  }

  @override
  Widget build(BuildContext context) {
    Gender gender = Provider.of<UserSettingsProvider>(context).gender;

    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 40,
          alignment: .center,
          color: gender.color,
          child: Text(section.title, style: kSettingsSectionTitleTextStyle),
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
                  Expanded(
                    child: Text(item.title, style: kLabelTextStyle(context)),
                  ),
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
        return [.coach, if (kDebugMode) .admin];
      case SettingsSection.legal:
        return [.privacyPolicy, .termsAndConditions];
      case SettingsSection.debug:
        return [.featureFlags];
    }
  }
}
