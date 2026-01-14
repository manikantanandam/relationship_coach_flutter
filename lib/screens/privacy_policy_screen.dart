import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:relationship_coach_flutter/enum/gender.dart';
import 'package:relationship_coach_flutter/providers/user_settings_provider.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Gender gender = Provider.of<UserSettingsProvider>(context).gender;

    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy'),
        backgroundColor: gender.color,
        foregroundColor: Colors.white,
      ),
    );
  }
}
