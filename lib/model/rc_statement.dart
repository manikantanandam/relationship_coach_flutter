import 'package:flutter/material.dart';
import 'package:relationship_coach_flutter/enum/gender.dart';
import 'package:relationship_coach_flutter/model/base_fire_store_model.dart';
import 'package:relationship_coach_flutter/model/rc_statement_part.dart';

class RCStatement extends BaseFirestoreModel {
  final String speaker;
  final List<RCStatementPart> statementParts;

  RCStatement({required this.speaker, required this.statementParts});

  factory RCStatement.fromJson(Map<String, dynamic> json) {
    return RCStatement(
      speaker: json['speaker'] ?? '',
      statementParts: (json['parts'] as List)
          .map((item) => RCStatementPart.fromJson(item))
          .toList(),
    );
  }

  // Requirement: Convert object to Map for Firestore
  @override
  Map<String, dynamic> toJson() {
    return {
      'speaker': speaker,
      // Map the list of parts into JSON maps
      'statementParts': statementParts.map((part) => part.toJson()).toList(),
    };
  }

  // Requirement: Factory to create instance from Firestore data
  factory RCStatement.fromFirestore(Map<String, dynamic> json, String id) {
    return RCStatement(
      speaker: json['speaker'] ?? '',
      statementParts: (json['statementParts'] as List? ?? [])
          .map((item) => RCStatementPart.fromJson(item))
          .toList(),
    );
  }

  Widget richText(Gender gender, bool bulletPointNeeded, BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        bulletPointNeeded
            ? Padding(
                padding: const EdgeInsets.only(
                  top: 8.0,
                  right: 8.0,
                ), // Adjust alignment
                child: Container(
                  height: 8,
                  width: 8,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              )
            : const SizedBox.shrink(),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: speaker.isEmpty ? '' : '$speaker Said: ',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    height: 1.5,
                  ),
                ),
                for (var part in statementParts) part.textSpan(gender, context),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
