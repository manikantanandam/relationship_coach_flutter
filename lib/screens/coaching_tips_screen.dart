import 'package:flutter/material.dart';
import 'package:relationship_coach_flutter/enum/chat_type.dart';
import 'package:relationship_coach_flutter/enum/gender.dart';
import 'package:relationship_coach_flutter/model/coaching_tips.dart';
import 'package:relationship_coach_flutter/services/ChatService.dart';

class CoachingTipsScreen extends StatefulWidget {
  const CoachingTipsScreen({
    super.key,
    required this.option,
    required this.gender,
  });

  final ChatType option;
  final Gender gender;

  @override
  State<CoachingTipsScreen> createState() => _CoachingTipsScreenState();
}

class _CoachingTipsScreenState extends State<CoachingTipsScreen> {
  bool _isLoading = true;
  CoachingTips? _coachingTips;

  Future<void> _loadData() async {
    try {
      print('getting coaching tips');
      var coachingTips = await Chatservice().getCoachingTips(
        widget.option,
        widget.gender,
      );

      setState(() {
        _coachingTips = coachingTips;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error loading data: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Real Life Examples')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : coachingTipsWidget(),
    );
  }

  Widget coachingTipsWidget() {
    if (_coachingTips == null) {
      return Text('No Steps available');
    }

    final coachingTips = _coachingTips!;

    return ListView.builder(
      itemCount: coachingTips.statements.length, // Don't forget the itemCount!
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: coachingTips.statements[index].richText(
            widget.gender,
            false,
            context,
          ),
        );
      },
    );
  }
}
