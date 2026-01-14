import 'package:flutter/material.dart';
import 'package:relationship_coach_flutter/enum/gender.dart';

class RCStatementPart {
  final String type; // "text" or "metadata"
  final String content;

  RCStatementPart({required this.type, required this.content});

  factory RCStatementPart.fromJson(Map<String, dynamic> json) {
    return RCStatementPart(
      type: json['type'] ?? 'text',
      content: json['content'] ?? '',
    );
  }

  Color color(Gender gender, BuildContext context) {
    if (type == 'text') {
      return Theme.of(context).colorScheme.primary;
    } else {
      return gender.color;
    }
  }

  String get formattedString {
    if (type == 'text' || type == 'highlight') {
      return content;
    } else {
      return '($content)';
    }
  }

  TextSpan textSpan(Gender gender, BuildContext context) {
    return TextSpan(
      text: formattedString,
      style: TextStyle(
        color: color(gender, context),
        fontWeight: FontWeight.bold,
        height: 1.5,
      ),
    );
  }
}
