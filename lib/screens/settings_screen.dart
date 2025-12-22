import 'package:flutter/material.dart';
import 'package:relationship_coach_flutter/components/rc_card.dart';

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
        for (var item in section.items) RCCard(cardWidget: Text(item.name)),
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
}
