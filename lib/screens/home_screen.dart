import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:relationship_coach_flutter/components/local_video_player_screen.dart';
import 'package:relationship_coach_flutter/components/rc_card.dart';
import 'package:relationship_coach_flutter/enum/chat_type.dart';
import 'package:relationship_coach_flutter/enum/gender.dart';
import 'package:relationship_coach_flutter/providers/user_settings_provider.dart';
import 'package:relationship_coach_flutter/screens/chat_options_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  // final List<ChatType> options = maleHomeScreenOptions;

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

  Future<void> openInstagram(String username) async {
    // 1. The Native App URL Scheme
    final Uri appUrl = Uri.parse("instagram://user?username=$username");

    // 2. The Web Browser Fallback
    final Uri webUrl = Uri.parse("https://www.instagram.com/$username");

    try {
      // Attempt to launch the app
      if (await canLaunchUrl(appUrl)) {
        await launchUrl(appUrl, mode: LaunchMode.externalApplication);
      } else {
        // If app isn't installed, launch in browser
        await launchUrl(webUrl, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      // Handle error (e.g., invalid URL)
      print("Could not launch Instagram: $e");
    }
  }

  void shareApp(BuildContext context) {
    SharePlus.instance.share(
      ShareParams(text: 'check out my website https://example.com'),
    );
  }

  @override
  Widget build(BuildContext context) {
    Gender gender = Provider.of<UserSettingsProvider>(context).gender;
    return Scaffold(
      body: Column(
        children: [
          LocalVideoPlayerScreen(height: 300),
          Expanded(
            child: ListView.builder(
              itemCount: gender.homeScreenOpions.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    final option = gender.homeScreenOpions[index];
                    switch (option) {
                      case ChatType.hisFault:
                      case ChatType.myFault:
                      case ChatType.toxicChat:
                      case ChatType.receivingTalk:
                      case ChatType.sweetTalk:
                      case ChatType.givingTalk:
                      case ChatType.herFault:
                        goToChatOptionsScreen(option, context);
                      case ChatType.instagram:
                        openInstagram('relationshipcoachcamille');
                      case ChatType.share:
                        shareApp(context);
                    }
                  },
                  child: RCCard(
                    cardWidget: Row(
                      children: [
                        gender.homeScreenOpions[index].iconWiget(gender),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(gender.homeScreenOpions[index].title),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: gender.arrowIcon,
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
