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

  @override
  Widget build(BuildContext context) {
    final iapProvider = Provider.of<IAPProvider>(context);
    final gender = Provider.of<UserSettingsProvider>(context).gender;

    return Scaffold(
      appBar: AppBar(title: Text(option.title)),
      body: ListView.builder(
        itemCount: options.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    final option = options[index];
                    return option.chatDetailsScreen(this.option, gender);
                  },
                ),
              );
            },
            child: RCCard(
              cardWidget: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        Text(
                          options[index].title,
                          style: kTitleTextStyle(context),
                        ),
                        Text(
                          options[index].subTitle,
                          style: kSubTitleTextStyle(context),
                        ),
                      ],
                    ),
                  ),
                  chatOptionStatusWidget(iapProvider.purchases.isEmpty, gender),
                  // RCIconWidget(iconImage: Icon(Icons.lock)),
                  // Image.asset(height: 40, 'lib/assets/ic_arrow_female.png'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
