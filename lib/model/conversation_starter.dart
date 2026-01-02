import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:relationship_coach_flutter/enum/gender.dart';
import 'package:relationship_coach_flutter/model/RealLifeExample.dart';

// 3. Category grouping (e.g., "1. Admit" or "2. Body Feeling")
class ConversationStarter {
  final int stepId;
  final String title;
  final List<ConversationStarterItem> starters;

  ConversationStarter({
    required this.stepId,
    required this.title,
    required this.starters,
  });

  factory ConversationStarter.fromJson(Map<String, dynamic> json) {
    return ConversationStarter(
      stepId: json['step_id'] ?? 0,
      title: json['title'] ?? '',
      starters: (json['starters'] as List? ?? [])
          .map((item) => ConversationStarterItem.fromJson(item))
          .toList(),
    );
  }

  // Helper to parse the top-level list from your JSON file
  static List<ConversationStarter> fromList(List<dynamic> jsonList) {
    return jsonList.map((item) => ConversationStarter.fromJson(item)).toList();
  }
}

class ConversationStarterItem {
  final List<DialoguePart> parts;

  ConversationStarterItem({required this.parts});

  factory ConversationStarterItem.fromJson(Map<String, dynamic> json) {
    return ConversationStarterItem(
      parts: (json['parts'] as List? ?? [])
          .map((item) => DialoguePart.fromJson(item))
          .toList(),
    );
  }

  // Helper to parse the top-level list from your JSON file
  static List<ConversationStarter> fromList(List<dynamic> jsonList) {
    return jsonList.map((item) => ConversationStarter.fromJson(item)).toList();
  }

  RichText richText(Gender gender) {
    return RichText(
      text: TextSpan(children: [for (var part in parts) part.textSpan(gender)]),
    );
  }
}
