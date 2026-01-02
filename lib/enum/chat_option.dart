import 'package:flutter/material.dart';
import 'package:relationship_coach_flutter/enum/chat_type.dart';
import 'package:relationship_coach_flutter/enum/gender.dart';
import 'package:relationship_coach_flutter/screens/coaching_tips_screen.dart';
import 'package:relationship_coach_flutter/screens/conversation_starters_screen.dart';
import 'package:relationship_coach_flutter/screens/real_life_examples_screen.dart';
import 'package:relationship_coach_flutter/screens/steps_screen.dart';

enum ChatOptionType {
  realLifeExamples,
  steps,
  conversationStarters,
  coachingTips,
  doItYourself,
}

extension ChatOptionTypeExtention on ChatOptionType {
  String get title {
    switch (this) {
      case ChatOptionType.realLifeExamples:
        return 'Real Life Examples';
      case ChatOptionType.steps:
        return 'Steps';
      case ChatOptionType.conversationStarters:
        return 'Conversation Starters';
      case ChatOptionType.coachingTips:
        return 'Coaching Tips';
      case ChatOptionType.doItYourself:
        return 'Do It Yourself';
    }
  }

  String get subTitle {
    switch (this) {
      case ChatOptionType.realLifeExamples:
        return 'Real life examples you can use.';
      case ChatOptionType.steps:
        return 'The siz steps you can follow.';
      case ChatOptionType.conversationStarters:
        return 'More examples of each step.';
      case ChatOptionType.coachingTips:
        return 'Helpful tips from the expert';
      case ChatOptionType.doItYourself:
        return 'Practice the steps yourself!';
    }
  }

  Widget chatDetailsScreen(ChatType type, Gender gender) {
    switch (this) {
      case ChatOptionType.realLifeExamples:
        return RealLifeExamplesScreen(option: type, gender: gender);
      case ChatOptionType.steps:
        return StepsScreen(option: type, gender: gender);
      case ChatOptionType.conversationStarters:
        return ConversationStartersScreen(option: type, gender: gender);
      case ChatOptionType.coachingTips:
        return CoachingTipsScreen(option: type, gender: gender);
      case ChatOptionType.doItYourself:
        return Text('DIY');
    }
  }
}
