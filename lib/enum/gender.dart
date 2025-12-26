import 'package:flutter/material.dart';
import 'package:relationship_coach_flutter/enum/chat_type.dart';

// Use an enum for type safety instead of raw strings
enum Gender { male, female }

extension GenderExtension on Gender {
  Image get arrowIcon {
    String icon;
    switch (this) {
      case .male:
        icon = 'lib/assets/ic_arrow_male.png';
      // Image.asset();
      case .female:
        icon = 'lib/assets/ic_arrow_female.png';
    }

    return Image.asset(height: 40, icon);
  }

  Color get color {
    switch (this) {
      case .female:
        return Color(0xfffd4269);
      case .male:
        return Color(0xff1a60e3);
    }
  }

  List<ChatType> get homeScreenOpions {
    switch (this) {
      case Gender.male:
        return maleHomeScreenOptions;
      case Gender.female:
        return femaleHomeScreenOption;
    }
  }
}
