import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:relationship_coach_flutter/enum/gender.dart';
import 'package:relationship_coach_flutter/model/terms_and_conditions.dart';
import 'package:relationship_coach_flutter/providers/user_settings_provider.dart';
import 'package:relationship_coach_flutter/services/json_utils.dart'; // Required for rootBundle

// ================= UI SCREEN =================

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  List<TermAndCondition> _termsFuture = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Initialize the future exactly once in initState
    _loadData();
  }

  // 2. Added setState to trigger a UI refresh
  Future<void> _loadData() async {
    try {
      List<TermAndCondition> tc;
      tc = await _loadPrivacyPolicyFromJson();

      setState(() {
        debugPrint('Setting state');
        _termsFuture = tc;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error loading data: $e");
      setState(() => _isLoading = false);
    }
  }

  // Asynchronously load and parse the local JSON asset
  Future<List<TermAndCondition>> _loadPrivacyPolicyFromJson() async {
    var json = await JSONUtils.loadJsonData(
      'lib/resources/privacy_policy.json',
    );

    print(json.toString()); // Debug print to verify JSON content

    return TermAndCondition.fromList(json['privacy_policy']);
  }

  @override
  Widget build(BuildContext context) {
    Gender gender = Provider.of<UserSettingsProvider>(context).gender;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Privacy Policy"),
        backgroundColor: gender.color,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildTermsContent(_termsFuture),
              ),
            ),
    );
  }

  // Helper to build the list of text widgets from the parsed data
  List<Widget> _buildTermsContent(List<TermAndCondition> data) {
    print('Building terms content with ${data.length} sections'); // Debug print
    print(data.length);
    List<Widget> widgets = [];
    for (var term in data) {
      if (term.section.isNotEmpty) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
            child: Text(
              term.section,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                height: 1.3,
              ),
            ),
          ),
        );
      }
      for (var item in term.items) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              item,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[800],
                height: 1.5,
              ),
            ),
          ),
        );
      }
    }
    return widgets;
  }
}
