import 'package:flutter/material.dart';
import 'package:relationship_coach_flutter/components/rc_card.dart';
import 'package:relationship_coach_flutter/components/rc_icon_widget.dart';
import 'package:relationship_coach_flutter/enum/chat_option.dart';
import 'package:relationship_coach_flutter/enum/chat_type.dart';

class ChatOptionScreen extends StatelessWidget {
  ChatOptionScreen({super.key, required this.option});

  final ChatType option;
  final List<ChatOptionType> options = [
    .realLifeExamples,
    .steps,
    .conversationStarters,
    .coachingTips,
    .doItYourself,
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(option.title)),
      body: ListView.builder(
        itemCount: options.length,
        itemBuilder: (context, index) {
          return RCCard(
            cardWidget: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(options[index].title),
                      Text(options[index].subTitle),
                    ],
                  ),
                ),
                // RCIconWidget(iconImage: Icon(Icons.lock)),
                Image.asset(height: 40, 'lib/assets/ic_arrow_female.png'),
              ],
            ),
          );
        },
      ),
    );
  }
}
