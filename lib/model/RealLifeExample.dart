import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:relationship_coach_flutter/enum/gender.dart';

class RealLifeExample {
  final int id;
  final String title;
  final String scenario;
  final List<DialogueEntry> dialogue;

  RealLifeExample({
    required this.id,
    required this.title,
    required this.scenario,
    required this.dialogue,
  });

  static List<RealLifeExample> fromList(List<dynamic> jsonList) {
    return jsonList.map((item) => RealLifeExample.fromJson(item)).toList();
  }

  // Factory to create an instance from JSON map
  factory RealLifeExample.fromJson(Map<String, dynamic> json) {
    return RealLifeExample(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      scenario: json['scenario'] ?? '',
      dialogue: (json['dialogue'] as List)
          .map((item) => DialogueEntry.fromJson(item))
          .toList(),
    );
  }
}

class DialogueEntry {
  final String speaker;
  final List<DialoguePart> parts;

  DialogueEntry({required this.speaker, required this.parts});

  factory DialogueEntry.fromJson(Map<String, dynamic> json) {
    return DialogueEntry(
      speaker: json['speaker'] ?? '',
      parts: (json['parts'] as List)
          .map((item) => DialoguePart.fromJson(item))
          .toList(),
    );
  }

  RichText get richText {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$speaker Said: ',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          for (var part in parts)
            TextSpan(
              text: part.formattedString,
              style: TextStyle(
                color: part.color(Gender.male),
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }
}

class DialoguePart {
  final String type; // "text" or "metadata"
  final String content;

  DialoguePart({required this.type, required this.content});

  factory DialoguePart.fromJson(Map<String, dynamic> json) {
    return DialoguePart(
      type: json['type'] ?? 'text',
      content: json['content'] ?? '',
    );
  }

  Color color(Gender gender) {
    if (type == 'text') {
      return Colors.black;
    } else {
      return gender.color;
    }
  }

  String get formattedString {
    if (type == 'text') {
      return content;
    } else {
      return '($content)';
    }
  }
}
