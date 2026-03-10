import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:relationship_coach_flutter/components/rc_card.dart';
import 'package:relationship_coach_flutter/enum/chat_type.dart';
import 'package:relationship_coach_flutter/enum/feature_flag_key.dart';
import 'package:relationship_coach_flutter/enum/gender.dart';
import 'package:relationship_coach_flutter/model/conversation_starter.dart';
import 'package:relationship_coach_flutter/screens/add_conversation_starters_screen.dart';
import 'package:relationship_coach_flutter/services/ChatService.dart';
import 'package:relationship_coach_flutter/services/firestore_chat_service.dart';
import 'package:relationship_coach_flutter/services/local_feature_flag_manager.dart';

class ConversationStartersScreen extends StatefulWidget {
  const ConversationStartersScreen({
    super.key,
    required this.option,
    required this.gender,
  });

  final ChatType option;
  final Gender gender;

  @override
  State<ConversationStartersScreen> createState() =>
      _ConversationStartersScreenState();
}

class _ConversationStartersScreenState
    extends State<ConversationStartersScreen> {
  List<ConversationStarter>? conversationStarters;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      List<ConversationStarter> loaded;
      ChatServiceType provider = LocalFeatureFlagManager()
          .getValue<ChatServiceType>(FeatureKey.chatProvider);

      if (provider == ChatServiceType.firebase) {
        debugPrint('Getting conversation starters from firebase');
        loaded = await FirestoreChatService().getConversationStarters(
          widget.option,
          widget.gender,
        );
      } else {
        debugPrint('Getting conversation starters from local');
        loaded = await LocalChatService().getConversationStarters(
          widget.option,
          widget.gender,
        );
      }

      setState(() {
        conversationStarters = loaded;
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
        title: Text('Conversation Starters'),
        backgroundColor: widget.gender.color,
        foregroundColor: Colors.white,
        actions: [
          if (kIsWeb)
            IconButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddConversationStartersScreen(
                      type: widget.option,
                      gender: widget.gender,
                    ),
                  ),
                );
                if (mounted) _loadData();
              },
              icon: const Icon(Icons.add),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : conversationStartersWidget(),
    );
  }

  Widget conversationStartersWidget() {
    if (conversationStarters == null) {
      return Text('No Steps available');
    }

    final currentConversationStarters = conversationStarters!;

    return ListView.builder(
      itemCount:
          currentConversationStarters.length, // Don't forget the itemCount!
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ConversationStarterWidget(
            starter: currentConversationStarters[index],
            gender: widget.gender,
            option: widget.option,
          ),
        );
      },
    );
  }
}

class ConversationStarterWidget extends StatelessWidget {
  const ConversationStarterWidget({
    super.key,
    required this.starter,
    required this.gender,
    required this.option,
  });
  final ConversationStarter starter;
  final Gender gender;
  final ChatType option;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                starter.title,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 22,
                  fontWeight: .bold,
                ),
              ),
            ),
            if (kIsWeb)
              IconButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddConversationStartersScreen(
                        type: option,
                        gender: gender,
                        starter: starter,
                      ),
                    ),
                  );
                  // Parent screen will reload on pop; no-op here.
                },
                icon: const Icon(Icons.edit),
              ),
          ],
        ),
        for (var starterItem in starter.statements)
          RCCard(cardWidget: starterItem.richText(gender, false, context)),
        // RichText(text: TextSpan(children: [dialog.textSpan])),
      ],
    );
  }
}
