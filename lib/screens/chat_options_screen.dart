import 'package:flutter/material.dart';
import 'package:relationship_coach_flutter/components/rc_card.dart';
import 'package:relationship_coach_flutter/components/rc_icon_widget.dart';
import 'package:relationship_coach_flutter/constants.dart/constants.dart';
import 'package:relationship_coach_flutter/enum/chat_option.dart';
import 'package:relationship_coach_flutter/enum/chat_type.dart';
import 'package:provider/provider.dart';
import 'package:relationship_coach_flutter/enum/gender.dart';
import 'package:relationship_coach_flutter/providers/iap_provider.dart';
import 'package:relationship_coach_flutter/providers/user_settings_provider.dart';
import 'package:relationship_coach_flutter/screens/purchase_wall_screen.dart';

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

  Widget chatOptionStatusWidget(bool subscribed, Gender gender) {
    if (!subscribed) {
      return RCIconWidget(iconImage: Icon(Icons.lock), gender: gender);
    } else {
      return gender.arrowIcon;
    }
  }

  void _showFullScreenModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Key for full-screen height
      useSafeArea: true, // Ensures it stays below the status bar
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: PurchaseWallScreen(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final iapProvider = Provider.of<IAPProvider>(context);
    final gender = Provider.of<UserSettingsProvider>(context).gender;

    return Scaffold(
      appBar: AppBar(
        title: Text(option.title),
        backgroundColor: gender.color,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: options.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              final subscribed = !iapProvider.purchases.isEmpty;

              // if (!subscribed) {
              //   _showFullScreenModal(context);
              //   return;
              // }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    // if (!subscribed) {
                    //   return PurchaseWallScreen();
                    // }
                    final option = options[index];
                    return option.chatDetailsScreen(this.option, gender);
                  },
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: RCCard(
                cardWidget: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: .start,
                          children: [
                            Text(
                              options[index].title,
                              style: kTitleTextStyle(gender),
                            ),
                            Text(
                              options[index].subTitle,
                              style: kSubTitleTextStyle(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                    chatOptionStatusWidget(
                      iapProvider.purchases.isEmpty,
                      gender,
                    ),
                    // RCIconWidget(iconImage: Icon(Icons.lock)),
                    // Image.asset(height: 40, 'lib/assets/ic_arrow_female.png'),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
