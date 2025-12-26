import 'package:flutter/material.dart';
import 'package:relationship_coach_flutter/components/rc_icon_widget.dart';

enum ChatType {
  hisFault,
  myFault,
  toxicChat,
  receivingTalk,
  sweetTalk,
  instagram,
  share,
}

extension HomeScreenOptionExtension on ChatType {
  String get key {
    switch (this) {
      case ChatType.hisFault:
        return 'his_fault';
      case ChatType.myFault:
        return 'my_fault';
      case ChatType.toxicChat:
        return 'toxic_chat';
      case ChatType.receivingTalk:
        return 'receiving_talk';
      case ChatType.sweetTalk:
        return 'sweet_talk';
      case ChatType.instagram:
      case ChatType.share:
        return '';
    }
  }

  String get title {
    switch (this) {
      case ChatType.hisFault:
        return 'His Fault Love Chat';
      case ChatType.myFault:
        return 'My Fault Love Chat';
      case ChatType.toxicChat:
        return 'Toxic Chat';
      case ChatType.receivingTalk:
        return 'Receiving Talk';
      case ChatType.sweetTalk:
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
      case ChatType.myFault:
        return 'lib/assets/ic_male.png';
      case ChatType.toxicChat:
        return 'lib/assets/ic_flask.png';
      case ChatType.receivingTalk:
        return 'lib/assets/ic_sms.png';
      case ChatType.sweetTalk:
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

const List<ChatType> maleHomeScreenOptions = [
  .hisFault,
  .myFault,
  .toxicChat,
  .receivingTalk,
  .sweetTalk,
  .instagram,
  .share,
];

const List<ChatType> rcHomeScreenOptions = [.instagram, .share];
