import 'package:flutter/material.dart';
import 'package:relationship_coach_flutter/components/local_video_player_screen.dart';
import 'package:relationship_coach_flutter/components/rc_card.dart';
import 'package:relationship_coach_flutter/enum/home_screen_option.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  final List<HomeScreenOption> options = maleHomeScreenOptions;

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
                return RCCard(
                  cardWidget: Row(
                    children: [
                      options[index].iconWiget,
                      Text(options[index].title),
                      Image.asset(
                        'lib/assets/ic_arrow_female.png',
                        width: 40,
                        height: 40,
                      ),
                    ],
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
