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
}
