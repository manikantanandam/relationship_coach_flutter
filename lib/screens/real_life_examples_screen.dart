import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:relationship_coach_flutter/enum/chat_type.dart';
import 'package:relationship_coach_flutter/enum/gender.dart';
import 'package:relationship_coach_flutter/model/RealLifeExample.dart';
import 'package:relationship_coach_flutter/providers/user_settings_provider.dart';
import 'package:relationship_coach_flutter/utils/json_utils.dart';

class RealLifeExamplesScreen extends StatefulWidget {
  const RealLifeExamplesScreen({
    super.key,
    required this.option,
    required this.gender,
  });
  final ChatType option;
  final Gender gender;

  @override
  State<RealLifeExamplesScreen> createState() => _RealLifeExamplesScreenState();
}

class _RealLifeExamplesScreenState extends State<RealLifeExamplesScreen> {
  List<RealLifeExample> _examples = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // 2. Added setState to trigger a UI refresh
  Future<void> _loadData() async {
    try {
      var json = await JSONUtils.loadJsonData(
        'lib/resources/${widget.option.key}.json',
      );
      var realLifeExamplesJSON = json[widget.gender.name]['real_life_examples'];
      var objects = RealLifeExample.fromList(realLifeExamplesJSON);

      setState(() {
        _examples = objects;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error loading data: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Real Life Examples')),
      // 3. Handle the loading state so the user sees progress
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _examples.length, // Don't forget the itemCount!
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: RealLifeExampleWidget(example: _examples[index]),
                );
              },
            ),
    );
  }
}

class RealLifeExampleWidget extends StatelessWidget {
  const RealLifeExampleWidget({super.key, required this.example});

  final RealLifeExample example;

  @override
  Widget build(BuildContext context) {
    Gender gender = Provider.of<UserSettingsProvider>(context).gender;

    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          example.title,
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: .bold,
          ),
        ),
        Text(
          example.scenario,
          style: TextStyle(color: gender.color, fontWeight: .bold, height: 3),
        ),
        for (var dialog in example.dialogue) dialog.richText,
      ],
    );
  }
}
