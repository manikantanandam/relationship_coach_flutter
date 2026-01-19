import 'package:flutter/material.dart';
import 'package:relationship_coach_flutter/enum/chat_type.dart';
import 'package:relationship_coach_flutter/enum/feature_flag_key.dart';
import 'package:relationship_coach_flutter/enum/gender.dart';
import 'package:relationship_coach_flutter/model/coaching_tips.dart';
import 'package:relationship_coach_flutter/screens/add_coaching_tips_screen.dart';
import 'package:relationship_coach_flutter/services/ChatService.dart';
import 'package:relationship_coach_flutter/services/firestore_chat_service.dart';
import 'package:relationship_coach_flutter/services/local_feature_flag_manager.dart';

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
      debugPrint('getting coaching tips');
      CoachingTips coachingTips;
      ChatServiceType provider = LocalFeatureFlagManager()
          .getValue<ChatServiceType>(FeatureKey.chatProvider);

      if (provider == ChatServiceType.firebase) {
        debugPrint('Getting coaching tips from firebase');
        coachingTips = await FirestoreChatService().getCoachingTips(
          widget.option,
          widget.gender,
        );
      } else {
        debugPrint('Getting coaching tips from local');
        coachingTips = await LocalChatService().getCoachingTips(
          widget.option,
          widget.gender,
        );
      }

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
      appBar: AppBar(
        title: const Text('Coaching Tips'),
        backgroundColor: widget.gender.color,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return AddCoachingTipsScreen(
                      type: widget.option,
                      gender: widget.gender,
                      coachingTips: _coachingTips,
                    );
                  },
                ),
              );
              // Reload data after returning from edit screen
              _loadData();
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
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
