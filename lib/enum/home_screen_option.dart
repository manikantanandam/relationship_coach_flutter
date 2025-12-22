import 'package:flutter/material.dart';
import 'package:relationship_coach_flutter/components/rc_icon_widget.dart';

enum HomeScreenOption {
  hisFault,
  myFault,
  toxicChat,
  receivingTalk,
  sweetTalk,
  instagram,
  share,
}

extension HomeScreenOptionExtension on HomeScreenOption {
  String get title {
    switch (this) {
      case HomeScreenOption.hisFault:
        return 'His Fault Love Chat';
      case HomeScreenOption.myFault:
        return 'My Fault Love Chat';
      case HomeScreenOption.toxicChat:
        return 'Toxic Chat';
      case HomeScreenOption.receivingTalk:
        return 'Receiving Talk';
      case HomeScreenOption.sweetTalk:
        return 'Sweet Talk';
      case .instagram:
        return 'Instagram';
      case .share:
        return 'Share';
    }
  }

  String get icon {
    switch (this) {
      case .hisFault:
        return 'lib/assets/ic_female.png';
      case HomeScreenOption.myFault:
        return 'lib/assets/ic_male.png';
      case HomeScreenOption.toxicChat:
        return 'lib/assets/ic_flask.png';
      case HomeScreenOption.receivingTalk:
        return 'lib/assets/ic_sms.png';
      case HomeScreenOption.sweetTalk:
        return 'lib/assets/ic_gift.png';
      case .instagram:
        return 'lib/assets/ic_instagram.png';
      case .share:
        return 'lib/assets/ic_share.png';
    }
  }

  Widget get iconWiget {
    switch (this) {
      case .hisFault:
      case .myFault:
      case .toxicChat:
      case .receivingTalk:
      case .sweetTalk:
        return RCIconWidget(
          iconImage: Image.asset(icon, width: 24, height: 24),
        );
      case .instagram:
      case .share:
        return Image.asset(icon, width: 24, height: 24);
    }
  }
}

const List<HomeScreenOption> maleHomeScreenOptions = [
  .hisFault,
  .myFault,
  .toxicChat,
  .receivingTalk,
  .sweetTalk,
  .instagram,
  .share,
];

const List<HomeScreenOption> rcHomeScreenOptions = [.instagram, .share];
