import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:relationship_coach_flutter/enum/gender.dart';
import 'package:relationship_coach_flutter/model/about_coach.dart';
import 'package:relationship_coach_flutter/providers/user_settings_provider.dart';
import 'package:relationship_coach_flutter/utils/json_utils.dart';

class AboutCoachScreen extends StatefulWidget {
  const AboutCoachScreen({super.key});

  @override
  State<AboutCoachScreen> createState() => _AboutCoachScreenState();
}

class _AboutCoachScreenState extends State<AboutCoachScreen> {
  late AboutCoach aboutCoach;
  bool _isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _loadData();
  }

  Future<void> _loadData() async {
    try {
      var json = await JSONUtils.loadJsonData('lib/resources/about_coach.json');

      setState(() {
        aboutCoach = AboutCoach.fromJson(json);
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error loading data: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    Gender gender = Provider.of<UserSettingsProvider>(context).gender;

    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(title: Text('About Coach')),
            body: ListView.builder(
              itemCount:
                  aboutCoach.statements.length, // Don't forget the itemCount!
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: aboutCoach.statements[index].richText(gender, false),
                );
              },
            ),
          );
  }
}
