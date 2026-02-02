import 'package:flutter/material.dart';
import 'package:relationship_coach_flutter/enum/gender.dart';

TextStyle kLabelTextStyle(BuildContext context) => TextStyle(
  // This automatically switches between dark and light shades
  color: Theme.of(context).colorScheme.onSurface,
  fontSize: 16,
  fontWeight: FontWeight.w500,
);

TextStyle kSettingsSectionTitleTextStyle = TextStyle(
  // This automatically switches between dark and light shades
  color: Colors.white,
  fontSize: 16,
  fontWeight: FontWeight.w500,
);

TextStyle kTitleTextStyle(Gender gender) => TextStyle(
  // This automatically switches between dark and light shades
  color: gender.color,
  fontSize: 24,
);

TextStyle kSubTitleTextStyle(BuildContext context) => TextStyle(
  // This automatically switches between dark and light shades
  color: Theme.of(context).colorScheme.onSurface,
  fontSize: 14,
  // fontWeight: FontWeight.w500,
);
