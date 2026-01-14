import 'package:flutter/material.dart';
import 'package:relationship_coach_flutter/components/rc_card.dart';
import 'package:relationship_coach_flutter/enum/chat_type.dart';
import 'package:relationship_coach_flutter/enum/gender.dart';
import 'package:relationship_coach_flutter/model/step.dart';
import 'package:relationship_coach_flutter/services/ChatService.dart';

class StepsScreen extends StatefulWidget {
  const StepsScreen({super.key, required this.option, required this.gender});

  final ChatType option;
  final Gender gender;

  @override
  State<StepsScreen> createState() => _StepsScreenState();
}

class _StepsScreenState extends State<StepsScreen> {
  Steps? steps;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // 2. Added setState to trigger a UI refresh
  Future<void> _loadData() async {
    try {
      var localSteps = await Chatservice().getSteps(
        widget.option,
        widget.gender,
      );
      setState(() {
        steps = localSteps;
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
      appBar: AppBar(
        title: Text('Steps'),
        backgroundColor: widget.gender.color,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: stepsWidget(),
            ),
    );
  }

  Widget stepsWidget() {
    if (steps == null) {
      return Text('No Steps available');
    }

    final currentSteps = steps!;
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(currentSteps.title),
        for (var step in currentSteps.steps)
          RCCard(
            cardWidget: Row(children: [Text('${step.id}. '), Text(step.step)]),
          ),
      ],
    );
  }
}
