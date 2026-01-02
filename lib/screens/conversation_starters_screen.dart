import 'package:flutter/material.dart';
import 'package:relationship_coach_flutter/components/rc_card.dart';
import 'package:relationship_coach_flutter/enum/chat_type.dart';
import 'package:relationship_coach_flutter/enum/gender.dart';
import 'package:relationship_coach_flutter/model/conversation_starter.dart';
import 'package:relationship_coach_flutter/services/ChatService.dart';

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
      var localConversationStarters = await Chatservice()
          .getConversationStarters(widget.option, widget.gender);

      setState(() {
        conversationStarters = localConversationStarters;
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
      appBar: AppBar(title: Text('Conversation Starters')),
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
  });
  final ConversationStarter starter;
  final Gender gender;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Row(
          children: [
            Text(
              starter.title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: .bold,
              ),
            ),
          ],
        ),
        for (var starterItem in starter.statements)
          RCCard(cardWidget: starterItem.richText(gender, false)),
        // RichText(text: TextSpan(children: [dialog.textSpan])),
      ],
    );
  }
}
