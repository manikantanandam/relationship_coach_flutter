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

  Widget get richText {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 8.0,
            right: 8.0,
          ), // Adjust alignment
          child: Container(
            height: 8,
            width: 8,
            decoration: BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
          ),
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$speaker Said: ',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    height: 1.5,
                  ),
                ),
                for (var part in parts) part.textSpan,
              ],
            ),
          ),
        ),
      ],
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

  TextSpan get textSpan {
    return TextSpan(
      text: formattedString,
      style: TextStyle(
        color: color(Gender.male),
        fontWeight: FontWeight.bold,
        height: 1.5,
      ),
    );
  }
}
