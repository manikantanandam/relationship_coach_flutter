import 'package:flutter/material.dart';

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
}
