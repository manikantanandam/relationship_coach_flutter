import 'package:flutter/material.dart';
import 'package:relationship_coach_flutter/components/local_video_player_screen.dart';
import 'package:relationship_coach_flutter/components/rc_card.dart';
import 'package:relationship_coach_flutter/enum/chat_type.dart';
import 'package:relationship_coach_flutter/screens/chat_options_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  final List<ChatType> options = maleHomeScreenOptions;

  void goToChatOptionsScreen(ChatType type, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return ChatOptionScreen(option: type);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          LocalVideoPlayerScreen(height: 300),
          Expanded(
            child: ListView.builder(
              itemCount: maleHomeScreenOptions.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    final option = options[index];
                    switch (option) {
                      case ChatType.hisFault:
                      case ChatType.myFault:
                      case ChatType.toxicChat:
                      case ChatType.receivingTalk:
                      case ChatType.sweetTalk:
                        goToChatOptionsScreen(option, context);
                      case ChatType.instagram:
                        // TODO: Handle this case.
                        throw UnimplementedError();
                      case ChatType.share:
                        // TODO: Handle this case.
                        throw UnimplementedError();
                    }
                  },
                  child: RCCard(
                    cardWidget: Row(
                      children: [
                        options[index].iconWiget,
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(options[index].title),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Image.asset(
                            'lib/assets/ic_arrow_female.png',
                            width: 40,
                            height: 40,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
